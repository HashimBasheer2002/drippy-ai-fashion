from rest_framework import serializers
from .models import Rating


class RatingSerializer(serializers.ModelSerializer):

    class Meta:
        model = Rating
        fields = ["id", "user", "drip", "score", "created_at"]
        read_only_fields = ["user", "created_at"]