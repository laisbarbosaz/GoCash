from django.contrib import admin
from django.urls import path, include

from django.urls import path, include
from django.views.generic import RedirectView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('modulos/', include('modulos.urls')),
    path('', RedirectView.as_view(url='modulos/')),
]
