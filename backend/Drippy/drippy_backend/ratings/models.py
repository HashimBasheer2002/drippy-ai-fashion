from django.db import models
from django.conf import settings
from drips.models import Drip


class Rating(models.Model):

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE
    )

    drip = models.ForeignKey(
        Drip,
        on_delete=models.CASCADE,
        related_name="ratings"
    )

    score = models.IntegerField()

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("user", "drip")