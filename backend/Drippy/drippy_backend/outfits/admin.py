from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import Outfit,StyleCategory

admin.site.register(Outfit)
admin.site.register(StyleCategory)