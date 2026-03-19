from django.shortcuts import render

# Create your views here.
from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import AffiliateClick
from .serializers import AffiliateClickSerializer


class AffiliateClickView(generics.CreateAPIView):

    serializer_class = AffiliateClickSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)