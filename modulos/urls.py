from django.urls import path
from . import views

urlpatterns = [
    path("modulos/", views.listar_modulos, name="listar_modulos"),
    path("modulos/<int:modulo_id>/", views.detalhe_modulo, name="detalhe_modulo"),
]
