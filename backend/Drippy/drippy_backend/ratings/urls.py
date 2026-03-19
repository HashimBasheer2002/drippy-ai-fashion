from django.urls import path
from .views import RateDripView

urlpatterns = [
    path("rate/", RateDripView.as_view()),
]