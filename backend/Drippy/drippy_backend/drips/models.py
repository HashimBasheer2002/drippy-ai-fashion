from django.db import models

# Create your models here.
from django.db import models
from django.conf import settings


from django.conf import settings
from django.db import models


class Drip(models.Model):

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="drips"
    )

    image = models.ImageField(upload_to="drips/")

    # --- AI OUTPUT ---
    ai_score = models.FloatField(default=0)
    detected_items = models.JSONField(null=True, blank=True)
    feedback = models.TextField(blank=True)

    # --- COMMUNITY (FUTURE READY) ---
    total_ratings = models.IntegerField(default=0)
    rating_sum = models.FloatField(default=0.0)
    community_score = models.FloatField(default=0.0)

    # --- FINAL SCORE ---
    final_score = models.FloatField(default=0)

    # --- STATUS (IMPORTANT FOR RELIABILITY) ---
    status = models.CharField(
        max_length=20,
        choices=[
            ("processing", "Processing"),
            ("completed", "Completed"),
            ("failed", "Failed"),
        ],
        default="processing"
    )

    # --- META ---
    views = models.IntegerField(default=0)
    is_seed = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Drip {self.id} by {self.user}"