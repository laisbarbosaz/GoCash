from django.contrib import admin
from django.urls import path, include
from django.views.generic import RedirectView
from . import views

admin.site.site_header = "Go Cash - Painel do Administrador"
admin.site.site_title = "Go Cash Admin"
admin.site.index_title = "Bem vindo ao painel administrativo do Go Cash"

urlpatterns = [
    path('admin/', admin.site.urls),
    path('modulos/', include('modulos.urls')),  
    path('conta/', include('contas.urls')),
    path("logs/", views.logs_view, name="logs"),
    path('', include('home.urls')),
]
