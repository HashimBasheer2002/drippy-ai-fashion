from rest_framework import serializers
from .models import AffiliateClick


class AffiliateClickSerializer(serializers.ModelSerializer):

    class Meta:
        model = AffiliateClick
        fields = [
            "id",
            "user",
            "product_name",
            "product_url",
            "clicked_at",
        ]
        read_only_fields = ["user", "clicked_at"]