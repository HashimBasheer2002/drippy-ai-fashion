import logging

from django.db import transaction

from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.generics import ListAPIView, RetrieveAPIView

from .models import Drip
from .serializers import DripSerializer
from .pagination import DripFeedPagination

from ai_engine.services import analyze_drip_safe
from .services import calculate_final_score


logger = logging.getLogger(__name__)


# -----------------------------
# UPLOAD DRIP
# -----------------------------
class UploadDripView(generics.CreateAPIView):

    serializer_class = DripSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        self.drip = serializer.save(
            user=self.request.user,
            status="processing"
        )

    def create(self, request, *args, **kwargs):

        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        with transaction.atomic():
            self.perform_create(serializer)

        drip = self.drip

        try:
            # -----------------------------
            # AI PROCESSING (SYNC FOR NOW)
            # -----------------------------
            analyze_drip_safe(drip)

            # Refresh from DB (important after save)
            drip.refresh_from_db()

            # -----------------------------
            # FINAL SCORE
            # -----------------------------
            calculate_final_score(drip)

            drip.status = "completed"

        except Exception as e:
            logger.error(f"[DRIP PROCESSING ERROR] {drip.id}: {str(e)}")
            drip.status = "failed"

        drip.save(update_fields=["status"])

        return Response(
            {
                "id": drip.id,
                "status": drip.status,
                "message": "Drip uploaded successfully"
            },
            status=status.HTTP_201_CREATED
        )


# -----------------------------
# FEED
# -----------------------------
class DripFeedView(ListAPIView):

    serializer_class = DripSerializer
    pagination_class = DripFeedPagination

    def get_queryset(self):
        return (
            Drip.objects
            .filter(status="completed")
            .select_related("user")
            .order_by("-final_score", "-created_at")
        )


# -----------------------------
# DRIP DETAIL
# -----------------------------
class DripDetailView(RetrieveAPIView):

    serializer_class = DripSerializer

    def get_queryset(self):
        return Drip.objects.select_related("user")

    def retrieve(self, request, *args, **kwargs):

        drip = self.get_object()

        # -----------------------------
        # STATUS HANDLING
        # -----------------------------
        if drip.status == "processing":
            return Response(
                {"detail": "Drip is still processing"},
                status=status.HTTP_202_ACCEPTED
            )

        if drip.status == "failed":
            return Response(
                {"detail": "Drip processing failed"},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

        # -----------------------------
        # VIEW TRACKING
        # -----------------------------
        drip.views += 1
        drip.save(update_fields=["views"])

        serializer = self.get_serializer(drip)
        return Response(serializer.data)