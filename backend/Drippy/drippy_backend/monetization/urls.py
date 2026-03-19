from django.urls import path
from .views import AffiliateClickView

urlpatterns = [
    path("click/", AffiliateClickView.as_view()),
]