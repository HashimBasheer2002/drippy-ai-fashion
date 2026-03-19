from django.db import models

# Create your models here.
from django.conf import settings
from django.db import models
from outfits.models import Outfit


class AIAnalysis(models.Model):

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE
    )

    outfit = models.OneToOneField(
        Outfit,
        on_delete=models.CASCADE,
        related_name="analysis"
    )

    score = models.FloatField()

    feedback = models.TextField()

    suggested_items = models.JSONField(blank=True, null=True)

    created_at = models.DateTimeField(auto_now_add=True)