from django.contrib.auth.signals import user_logged_in
from django.dispatch import receiver

from .leitura import guardar_leituras_da_sessao


@receiver(user_logged_in)
def levar_leituras_para_a_conta(sender, request, user, **kwargs):
    if request is not None and hasattr(request, 'session'):
        guardar_leituras_da_sessao(request, user)
