from django.shortcuts import render

# Create your views here.
from rest_framework import generics
from .models import User
from .serializers import UserRegisterSerializer


#Register

class RegisterView(generics.CreateAPIView):

    queryset = User.objects.all()
    serializer_class = UserRegisterSerializer

#login

from rest_framework_simplejwt.views import TokenObtainPairView


class LoginView(TokenObtainPairView):
    pass


#User-Interest

from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import UserInterest
from .serializers import UserInterestSerializer


class UserInterestView(generics.ListCreateAPIView):

    serializer_class = UserInterestSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return UserInterest.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)