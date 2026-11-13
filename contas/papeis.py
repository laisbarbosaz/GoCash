from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType
from django.utils import translation
from django.db import transaction
from django.utils import timezone

from .models import PerfilUsuario

def tipo_pelas_permissoes(usuario):
    if usuario.is_superuser:
        return PerfilUsuario.ADMINISTRADOR
    return PerfilUsuario.ALUNO


def eh_principal(usuario):
    if not usuario.is_authenticated or not usuario.is_superuser:
        return False
    return PerfilUsuario.objects.filter(usuario_id=usuario.pk, administrador_principal=True).exists()


def pode_alterar_situacao(quem, alvo):
    if alvo.pk == quem.pk or eh_principal(alvo):
        return False
    if eh_principal(quem):
        return True
    return quem.is_superuser and not alvo.is_superuser


def pode_definir_perfil(quem, alvo):
    return (
        eh_principal(quem)
        and alvo.pk != quem.pk
        and not eh_principal(alvo)
    )


def definir_situacao(usuario, ativo):
    usuario.is_active = ativo
    usuario.save(update_fields=['is_active'])
    PerfilUsuario.objects.filter(usuario=usuario).update(desativada_em=None if ativo else timezone.now())


def definir_perfil(usuario, tipo):
    if eh_principal(usuario):
        raise ValueError('O perfil do Administrador principal não pode ser alterado.')

    administrador = tipo == PerfilUsuario.ADMINISTRADOR
    usuario.is_superuser = administrador
    usuario.is_staff = administrador
    usuario.save()


@transaction.atomic
def tornar_principal(usuario):
    PerfilUsuario.objects.filter(administrador_principal=True).exclude(usuario=usuario).update(
        administrador_principal=False
    )
    usuario.is_active = True
    usuario.is_staff = True
    usuario.is_superuser = True
    usuario.save()

    PerfilUsuario.objects.filter(usuario=usuario).update(administrador_principal=True)


ACOES_DAS_PERMISSOES = {
    'add': 'Pode adicionar',
    'change': 'Pode alterar',
    'delete': 'Pode excluir',
    'view': 'Pode ver',
}
APPS_DO_PROJETO = ('atividades', 'contas', 'modulos', 'home')


def remover_tabelas_antigas():
    for tipo in ContentType.objects.filter(app_label__in=APPS_DO_PROJETO):
        if tipo.model_class() is None:
            tipo.delete()


def traduzir_permissoes():
    with translation.override('pt-br'):
        for permissao in Permission.objects.select_related('content_type'):
            acao = permissao.codename.split('_', 1)[0]
            modelo = permissao.content_type.model_class()
            if acao not in ACOES_DAS_PERMISSOES or modelo is None:
                continue
            nome = f"{ACOES_DAS_PERMISSOES[acao]} {modelo._meta.verbose_name}"
            if permissao.name != nome:
                permissao.name = nome
                permissao.save(update_fields=['name'])
