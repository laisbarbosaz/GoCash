from django.urls import path
from . import views

# O prefixo "modulos/" já vem do gocash/urls.py, então aqui os caminhos começam vazios.
# Resultado: /modulos/ (lista) e /modulos/controles-e-dividas/ (detalhe).
urlpatterns = [
    path("", views.listar_modulos, name="listar_modulos"),
    path("<slug:slug>/", views.detalhe_modulo, name="detalhe_modulo"),
]
