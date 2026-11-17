from datetime import timedelta

from django.contrib.auth.models import User
from django.utils import timezone

DIAS_ATE_EXCLUIR = 180


def data_da_exclusao(desativada_em):
    return desativada_em + timedelta(days=DIAS_ATE_EXCLUIR)


def excluir_contas_desativadas():
    limite = timezone.now() - timedelta(days=DIAS_ATE_EXCLUIR)
    contas = User.objects.filter(
        is_active=False,
        perfil__desativada_em__lte=limite,
        perfil__administrador_principal=False,
    )
    nomes = list(contas.values_list('username', flat=True))
    contas.delete()
    return nomes
