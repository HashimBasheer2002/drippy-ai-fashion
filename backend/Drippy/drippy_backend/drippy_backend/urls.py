
from django.contrib import admin
from django.urls import path,include
from django.conf import settings
from django.conf.urls.static import static
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
         path("admin/", admin.site.urls),

    path("api/accounts/", include("accounts.urls")),
    path("api/outfits/", include("outfits.urls")),
    path("api/ratings/", include("ratings.urls")),
    path("api/analysis/", include("ai_engine.urls")),
    path("api/monetization/", include("monetization.urls")),
     path("api/drips/", include("drips.urls")),
      path("api/schema/", SpectacularAPIView.as_view(), name="schema"),
    path("api/docs/", SpectacularSwaggerView.as_view(url_name="schema")),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)