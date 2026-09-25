from django.urls import path
from django.contrib.auth.views import LogoutView
from . import views

urlpatterns = [
    path('cadastro/', views.cadastro, name='cadastro'),
    path('login/', views.LoginPersonalizado.as_view(), name='login'),
    path("logout/", views.sair, name="logout"),
    path('termos-de-uso/', views.termos_de_uso, name='termos_de_uso'),
    path('politica-de-privacidade/', views.politica_de_privacidade, name='politica_de_privacidade'),
]