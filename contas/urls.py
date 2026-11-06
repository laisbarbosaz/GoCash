from django.contrib.auth import views as auth_views
from django.urls import path, reverse_lazy

from . import views

urlpatterns = [
    path('cadastro/', views.cadastro, name='cadastro'),
    path('login/', views.LoginPersonalizado.as_view(), name='login'),
    path('verificar-codigo/', views.VerificarCodigoView.as_view(), name='verificar_codigo'),
    path('reenviar-codigo/', views.reenviar_codigo, name='reenviar_codigo'),
    path("logout/", views.sair, name="logout"),
    path('termos-de-uso/', views.termos_de_uso, name='termos_de_uso'),
    path('politica-de-privacidade/', views.politica_de_privacidade, name='politica_de_privacidade'),
    path('perfil/', views.meu_perfil, name='meu_perfil'),
    path('senha/esqueci/', auth_views.PasswordResetView.as_view(
        template_name='contas/senha/esqueci.html',
        email_template_name='contas/senha/email.txt',
        subject_template_name='contas/senha/email_assunto.txt',
        success_url=reverse_lazy('senha_enviada'),
    ), name='senha_esqueci'),
    path('senha/enviada/', auth_views.PasswordResetDoneView.as_view(
        template_name='contas/senha/enviada.html',
    ), name='senha_enviada'),
    path('senha/nova/<uidb64>/<token>/', auth_views.PasswordResetConfirmView.as_view(
        template_name='contas/senha/nova.html',
        success_url=reverse_lazy('senha_redefinida'),
    ), name='senha_nova'),
    path('senha/redefinida/', auth_views.PasswordResetCompleteView.as_view(
        template_name='contas/senha/redefinida.html',
    ), name='senha_redefinida'),
]