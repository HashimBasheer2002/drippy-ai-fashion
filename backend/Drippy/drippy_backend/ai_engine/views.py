from django.shortcuts import render

# Create your views here.
from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import AIAnalysis
from .serializers import AIAnalysisSerializer


class OutfitAnalysisView(generics.RetrieveAPIView):

    serializer_class = AIAnalysisSerializer
    permission_classes = [IsAuthenticated]

    lookup_field = "outfit_id"

    def get_queryset(self):
        return AIAnalysis.objects.select_related("outfit", "user")