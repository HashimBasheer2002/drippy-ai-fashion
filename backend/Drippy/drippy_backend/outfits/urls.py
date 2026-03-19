from django.urls import path
from . import views

urlpatterns = [
    path("<int:pk>/", views.OutfitDetailView.as_view()),
    path("upload/", views.UploadOutfitView.as_view(), name="upload-outfit"),
    path("feed/", views.OutfitFeedView.as_view(), name="outfit-feed"),
    path("<int:pk>/update/", views.OutfitUpdateView.as_view(), name="update-outfit"),
    path("leaderboard/week/", views.WeeklyLeaderboardView.as_view()),
    path("categories/", views.StyleCategoryListView.as_view()),
]