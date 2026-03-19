from django.db import models

# Create your models here.
from django.conf import settings
from django.db import models


class AdView(models.Model):

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE
    )

    ad_type = models.CharField(max_length=50)

    viewed_at = models.DateTimeField(auto_now_add=True)


class AffiliateClick(models.Model):

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE
    )

    product_name = models.CharField(max_length=255)

    product_url = models.URLField()

    clicked_at = models.DateTimeField(auto_now_add=True)