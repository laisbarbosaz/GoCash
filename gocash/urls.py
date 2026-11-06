from django.contrib import admin
from django.urls import path, include
from django.views.generic import RedirectView
from . import views

admin.site.site_header = "Go Cash - Painel do Administrador"
admin.site.site_title = "Go Cash Admin"
admin.site.index_title = "Painel de administração do Go Cash"

urlpatterns = [
    path('admin/login/', RedirectView.as_view(pattern_name='login', permanent=False, query_string=True)),
    path('admin/', admin.site.urls),
    path('modulos/', include('modulos.urls')),  
    path('conta/', include('contas.urls')),
    path('atividades/', include('atividades.urls')),
    path("logs/", views.logs_view, name="logs"),
    path("logs/lista/", views.logs_detalhados, name="logs_detalhados"),
    path('', include('home.urls')),
]
