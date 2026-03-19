from django.db import models

# Create your models here.
from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):

    email = models.EmailField(unique=True)
    profile_picture = models.ImageField(upload_to="profiles/", blank=True, null=True)

    is_premium = models.BooleanField(default=False)

    daily_analysis_count = models.IntegerField(default=0)

    created_at = models.DateTimeField(auto_now_add=True)


from django.conf import settings
from django.db import models
from outfits.models import StyleCategory


class UserInterest(models.Model):

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="interests"
    )

    category = models.ForeignKey(
        StyleCategory,
        on_delete=models.CASCADE,
        related_name="interested_users"
    )

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ["user", "category"]

    def __str__(self):
        return f"{self.user} → {self.category}"