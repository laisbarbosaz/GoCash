from django.contrib.auth.models import Group, Permission
from django.contrib.contenttypes.models import ContentType
from django.utils import translation
from django.db import transaction
from django.db.models import Q

from .models import PerfilUsuario

NOME_GRUPO_EDUCADORES = 'Educadores'

PERMISSOES_EDUCADOR = [
    ('modulos', 'add_modulo'),
    ('modulos', 'change_modulo'),
    ('modulos', 'delete_modulo'),
    ('modulos', 'view_modulo'),
    ('modulos', 'add_conteudomodulo'),
    ('modulos', 'change_conteudomodulo'),
    ('modulos', 'delete_conteudomodulo'),
    ('modulos', 'view_conteudomodulo'),
    ('atividades', 'add_atividade'),
    ('atividades', 'change_atividade'),
    ('atividades', 'delete_atividade'),
    ('atividades', 'view_atividade'),
    ('atividades', 'add_pergunta'),
    ('atividades', 'change_pergunta'),
    ('atividades', 'delete_pergunta'),
    ('atividades', 'view_pergunta'),
    ('atividades', 'add_alternativa'),
    ('atividades', 'change_alternativa'),
    ('atividades', 'delete_alternativa'),
    ('atividades', 'view_alternativa'),
    ('atividades', 'view_tentativa'),
    ('atividades', 'view_progressoatividade'),
]


def criar_grupo_educadores():
    grupo = Group.objects.filter(name=NOME_GRUPO_EDUCADORES).first()
    if grupo:
        return grupo

    filtro = Q()
    for app_label, codename in PERMISSOES_EDUCADOR:
        filtro |= Q(content_type__app_label=app_label, codename=codename)
    permissoes = list(Permission.objects.filter(filtro))
    if len(permissoes) < len(PERMISSOES_EDUCADOR):
        return None

    grupo = Group.objects.create(name=NOME_GRUPO_EDUCADORES)
    grupo.permissions.set(permissoes)
    return grupo


def tipo_pelas_permissoes(usuario):
    if usuario.is_superuser:
        return PerfilUsuario.ADMINISTRADOR
    if usuario.is_staff:
        return PerfilUsuario.EDUCADOR
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


def definir_perfil(usuario, tipo):
    if eh_principal(usuario):
        raise ValueError('O perfil do Administrador principal não pode ser alterado.')

    usuario.is_superuser = tipo == PerfilUsuario.ADMINISTRADOR
    usuario.is_staff = tipo in (PerfilUsuario.EDUCADOR, PerfilUsuario.ADMINISTRADOR)
    usuario.save()

    grupo = criar_grupo_educadores()
    if grupo:
        if tipo == PerfilUsuario.EDUCADOR:
            usuario.groups.add(grupo)
        else:
            usuario.groups.remove(grupo)


@transaction.atomic
def tornar_principal(usuario):
    PerfilUsuario.objects.filter(administrador_principal=True).exclude(usuario=usuario).update(
        administrador_principal=False
    )
    usuario.is_active = True
    usuario.is_staff = True
    usuario.is_superuser = True
    usuario.save()

    grupo = Group.objects.filter(name=NOME_GRUPO_EDUCADORES).first()
    if grupo:
        usuario.groups.remove(grupo)

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
