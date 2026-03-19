from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from django.db.models import Avg

from .models import Rating
from .serializers import RatingSerializer
from drips.models import Drip
from drips.services import calculate_final_score


class RateDripView(generics.CreateAPIView):

    serializer_class = RatingSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):

        rating = serializer.save(user=self.request.user)
        drip = rating.drip

        # recalculate community rating
        avg_rating = drip.ratings.aggregate(avg=Avg("score"))["avg"] or 0
        rating_count = drip.ratings.count()

        drip.community_rating = avg_rating
        drip.rating_count = rating_count

        drip.save(update_fields=["community_rating", "rating_count"])

        # update ranking score
        calculate_final_score(drip)