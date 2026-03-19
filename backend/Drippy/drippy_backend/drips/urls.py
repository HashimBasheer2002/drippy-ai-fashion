from django.urls import path
from .views import UploadDripView,DripFeedView,DripDetailView

urlpatterns = [
    path("upload/", UploadDripView.as_view()),
    path("feed/", DripFeedView.as_view()),
     path("<int:pk>/", DripDetailView.as_view()),

]