from django.urls import path
from . import views

urlpatterns = [
    path("", views.listar_modulos, name="listar_modulos"),
    path("<slug:slug>/", views.detalhe_modulo, name="detalhe_modulo"),
]
