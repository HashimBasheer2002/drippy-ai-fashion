from django.conf import settings
from django.db import models
from .validators import validate_image_size


class Outfit(models.Model):

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="outfits"
    )

    title = models.CharField(max_length=200)
    views = models.IntegerField(default=0)
    ratings_count = models.IntegerField(default=0)
    avg_rating = models.FloatField(default=0)
    drip_score = models.FloatField(default=0)

    top_image = models.ImageField(upload_to="outfits/")
    bottom_image = models.ImageField(upload_to="outfits/")

    top_link = models.URLField(blank=True, null=True)
    bottom_link = models.URLField(blank=True, null=True)

    source = models.CharField(
        max_length=50,
        choices=[
            ("affiliate", "Affiliate"),
            ("custom", "Custom Combo")
        ],
        default="custom"
    )

    created_at = models.DateTimeField(auto_now_add=True)



from django.db import models
from django.conf import settings

from django.db import models


class StyleCategory(models.Model):

    name = models.CharField(max_length=100, unique=True)

    slug = models.SlugField(max_length=120, unique=True)

    description = models.TextField(blank=True)

    icon = models.CharField(
        max_length=100,
        blank=True,
        help_text="Optional icon name used in frontend UI"
    )

    # NEW FIELD
    image = models.ImageField(
        upload_to="style_categories/",
        blank=True,
        null=True
    )

    display_order = models.PositiveIntegerField(default=0)

    is_active = models.BooleanField(default=True)

    created_at = models.DateTimeField(auto_now_add=True)

    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["display_order", "name"]

    def __str__(self):
        return self.name

class UserStyleInterest(models.Model):

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="style_interests"
    )

    style = models.ForeignKey(
        StyleCategory,
        on_delete=models.CASCADE,
        related_name="user_style_interests"
    )

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("user", "style")

    def __str__(self):
        return f"{self.user} → {self.style}"