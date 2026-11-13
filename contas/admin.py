from django.contrib import admin, messages
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import Group, User
from django.core.exceptions import PermissionDenied
from django.shortcuts import redirect
from django.urls import reverse
from django.utils import timezone

from .limpeza import data_da_exclusao, excluir_contas_desativadas
from .models import ConfiguracaoSite, PerfilUsuario
from .papeis import (
    definir_perfil,
    definir_situacao,
    eh_principal,
    pode_alterar_situacao,
    pode_definir_perfil,
)

ACOES_DO_PRINCIPAL = ('definir_como_aluno', 'definir_como_administrador')


class UsuarioAdminCustomizado(UserAdmin):
    list_display = ('username', 'nome_completo', 'email', 'perfil_exibido', 'situacao', 'principal')
    list_filter = ('perfil__tipo_usuario', 'is_active')
    search_fields = ('username', 'first_name', 'last_name', 'email')
    ordering = ('username',)
    list_display_links = None
    actions = ['ativar_contas', 'desativar_contas', *ACOES_DO_PRINCIPAL]

    def get_queryset(self, request):
        return super().get_queryset(request).select_related('perfil')

    @admin.display(description='Nome', ordering='first_name')
    def nome_completo(self, obj):
        return obj.get_full_name() or '-'

    @admin.display(description='Perfil', ordering='perfil__tipo_usuario')
    def perfil_exibido(self, obj):
        perfil = getattr(obj, 'perfil', None)
        return perfil.get_tipo_usuario_display() if perfil else '-'

    @admin.display(description='Situação', ordering='is_active')
    def situacao(self, obj):
        if obj.is_active:
            return 'Ativo'
        perfil = getattr(obj, 'perfil', None)
        if perfil and perfil.desativada_em:
            exclusao = timezone.localtime(data_da_exclusao(perfil.desativada_em))
            return f"Inativo, excluído em {exclusao:%d/%m/%Y}"
        return 'Inativo'

    @admin.display(description='Principal', boolean=True)
    def principal(self, obj):
        perfil = getattr(obj, 'perfil', None)
        return bool(perfil and perfil.administrador_principal)

    def has_module_permission(self, request):
        return request.user.is_active and request.user.is_superuser

    def has_view_permission(self, request, obj=None):
        return request.user.is_active and request.user.is_superuser

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def get_actions(self, request):
        acoes = super().get_actions(request)
        if not eh_principal(request.user):
            for nome in ACOES_DO_PRINCIPAL:
                acoes.pop(nome, None)
        return acoes

    def _executar(self, request, queryset, permitido, aplicar, resultado):
        alterados = []
        ignorados = []
        for alvo in queryset:
            if permitido(request.user, alvo):
                aplicar(alvo)
                alterados.append(alvo.username)
            else:
                ignorados.append(alvo.username)

        if alterados:
            self.message_user(request, f"{resultado}: {', '.join(alterados)}.", messages.SUCCESS)
        if ignorados:
            self.message_user(
                request,
                f"Você não tem permissão para alterar: {', '.join(ignorados)}.",
                messages.WARNING,
            )
        return alterados

    @admin.action(description='Ativar contas selecionadas')
    def ativar_contas(self, request, queryset):
        self._executar(
            request, queryset, pode_alterar_situacao,
            lambda alvo: definir_situacao(alvo, True), 'Contas ativadas',
        )

    @admin.action(description='Desativar contas selecionadas')
    def desativar_contas(self, request, queryset):
        desativadas = self._executar(
            request, queryset, pode_alterar_situacao,
            lambda alvo: definir_situacao(alvo, False), 'Contas desativadas',
        )
        if not desativadas:
            return
        exclusao = timezone.localtime(data_da_exclusao(timezone.now()))
        self.message_user(
            request,
            f"Contas desativadas são excluídas em definitivo depois de 6 meses. "
            f"Se não forem reativadas, essas serão excluídas em {exclusao:%d/%m/%Y}.",
            messages.INFO,
        )

    @admin.action(description='Definir como Aluno')
    def definir_como_aluno(self, request, queryset):
        self._executar(
            request, queryset, pode_definir_perfil,
            lambda alvo: definir_perfil(alvo, PerfilUsuario.ALUNO), 'Agora são Alunos',
        )

    @admin.action(description='Definir como Administrador')
    def definir_como_administrador(self, request, queryset):
        self._executar(
            request, queryset, pode_definir_perfil,
            lambda alvo: definir_perfil(alvo, PerfilUsuario.ADMINISTRADOR), 'Agora são Administradores',
        )


@admin.register(ConfiguracaoSite)
class ConfiguracaoSiteAdmin(admin.ModelAdmin):
    fields = ('exigir_mfa', 'atualizada_em', 'atualizada_por')
    readonly_fields = ('atualizada_em', 'atualizada_por')

    def has_module_permission(self, request):
        return request.user.is_active and request.user.is_superuser

    def has_view_permission(self, request, obj=None):
        return request.user.is_active and request.user.is_superuser

    def has_change_permission(self, request, obj=None):
        return request.user.is_active and request.user.is_superuser

    def has_add_permission(self, request):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def changelist_view(self, request, extra_context=None):
        if not self.has_view_permission(request):
            raise PermissionDenied
        configuracao = ConfiguracaoSite.atual()
        return redirect(reverse('admin:contas_configuracaosite_change', args=[configuracao.pk]))

    def save_model(self, request, obj, form, change):
        obj.atualizada_por = request.user
        super().save_model(request, obj, form, change)


admin.site.unregister(User)
admin.site.unregister(Group)
admin.site.register(User, UsuarioAdminCustomizado)


ORDEM_DO_MENU = {
    'modulos': ['Modulo', 'ConteudoModulo'],
    'atividades': ['Atividade', 'Pergunta', 'ProgressoAtividade', 'Tentativa'],
    'contas': ['User', 'ConfiguracaoSite'],
}
_lista_de_apps_original = admin.site.get_app_list


def lista_de_apps_ordenada(request, app_label=None):
    apps = _lista_de_apps_original(request, app_label)
    if app_label:
        return apps

    por_label = {app['app_label']: app for app in apps}
    autenticacao = por_label.get('auth')
    contas = por_label.get('contas')
    if autenticacao and contas:
        usuarios = [modelo for modelo in autenticacao['models'] if modelo['object_name'] == 'User']
        autenticacao['models'] = [modelo for modelo in autenticacao['models'] if modelo['object_name'] != 'User']
        contas['models'] = usuarios + contas['models']

    posicoes = list(ORDEM_DO_MENU)
    for app in apps:
        ordem = ORDEM_DO_MENU.get(app['app_label'], [])
        app['models'].sort(
            key=lambda modelo: ordem.index(modelo['object_name']) if modelo['object_name'] in ordem else len(ordem)
        )
    apps = [app for app in apps if app['models']]
    apps.sort(key=lambda app: posicoes.index(app['app_label']) if app['app_label'] in posicoes else len(posicoes))
    return apps


admin.site.get_app_list = lista_de_apps_ordenada

_inicio_original = admin.site.index


def inicio_com_limpeza(request, extra_context=None):
    if request.user.is_active and request.user.is_superuser:
        excluir_contas_desativadas()
    return _inicio_original(request, extra_context)


admin.site.index = inicio_com_limpeza
