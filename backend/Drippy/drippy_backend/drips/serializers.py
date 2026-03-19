from rest_framework import serializers
from .models import Drip


class DripSerializer(serializers.ModelSerializer):

    class Meta:
        model = Drip
        fields = "__all__"
        read_only_fields = [
            "user",
            "ai_score",
            "detected_items",
            "feedback",
            "views",
            "created_at"
        ]




