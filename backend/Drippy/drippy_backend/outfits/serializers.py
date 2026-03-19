from rest_framework import serializers
from .models import Outfit


from rest_framework import serializers
from .models import Outfit


class OutfitSerializer(serializers.ModelSerializer):

    class Meta:
        model = Outfit
        fields = "__all__"
        read_only_fields = ["user"]


from rest_framework import serializers
from .models import StyleCategory


from rest_framework import serializers
from .models import StyleCategory


class StyleCategorySerializer(serializers.ModelSerializer):

    image = serializers.ImageField(use_url=True)

    class Meta:
        model = StyleCategory
        fields = [
            "id",
            "name",
            "slug",
            "description",
            "image"
        ]