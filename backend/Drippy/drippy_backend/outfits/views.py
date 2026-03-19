from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import Outfit
from .serializers import OutfitSerializer


# Upload Outfit
from ai_engine.services import analyze_outfit

from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import Outfit
from .serializers import OutfitSerializer



class UploadOutfitView(generics.CreateAPIView):

    serializer_class = OutfitSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):

        # Save outfit
        outfit = serializer.save(user=self.request.user)

        # Trigger AI analysis safely
        try:
            analyze_outfit(outfit)
        except Exception as e:
            # In production we would log this
            print(f"AI analysis failed: {e}")

from django.db.models import Avg
# Outfit Feed
class OutfitFeedView(generics.ListAPIView):

    serializer_class = OutfitSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return (
            Outfit.objects
            .select_related("user")
            .annotate(avg_rating=Avg("ratings__score"))
            .order_by("-created_at")
        )


# Update Outfit (ONLY owner can update)
class OutfitUpdateView(generics.UpdateAPIView):
    serializer_class = OutfitSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Outfit.objects.filter(user=self.request.user)
    


from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import Outfit
from .serializers import OutfitSerializer


class OutfitDetailView(generics.RetrieveAPIView):

    serializer_class = OutfitSerializer
    permission_classes = [IsAuthenticated]

    queryset = Outfit.objects.select_related("user")

    def retrieve(self, request, *args, **kwargs):

        instance = self.get_object()

        # track engagement
        instance.views += 1
        instance.save(update_fields=["views"])

        serializer = self.get_serializer(instance)

        return Response(serializer.data)
    


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from datetime import timedelta
from django.utils import timezone
from .models import Outfit
from .serializers import OutfitSerializer


class WeeklyLeaderboardView(APIView):

    permission_classes = [IsAuthenticated]

    def get(self, request):

        one_week_ago = timezone.now() - timedelta(days=7)

        outfits = (
            Outfit.objects
            .filter(created_at__gte=one_week_ago)
            .order_by("-drip_score")[:10]
        )

        serializer = OutfitSerializer(outfits, many=True)

        return Response(serializer.data)
    

from rest_framework import generics
from .models import StyleCategory
from .serializers import StyleCategorySerializer

from rest_framework import generics
from .models import StyleCategory
from .serializers import StyleCategorySerializer


class StyleCategoryListView(generics.ListAPIView):

    queryset = StyleCategory.objects.filter(is_active=True).order_by("display_order")
    serializer_class = StyleCategorySerializer