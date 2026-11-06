from django import forms
from django.contrib import admin, messages
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from django.core.exceptions import PermissionDenied
from django.shortcuts import redirect
from django.urls import reverse
from django.utils import timezone

from .convites import enviar_convite
from .models import ConfiguracaoSite, ConviteEducador, PerfilUsuario, nome_e_usuario
from .papeis import (
    definir_perfil,
    definir_situacao,
    eh_principal,
    pode_alterar_situacao,
    pode_definir_perfil,
)

ACOES_DO_PRINCIPAL = ('definir_como_aluno', 'definir_como_educador', 'definir_como_administrador')


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
        return 'Ativo' if obj.is_active else 'Inativo'

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

    @admin.action(description='Ativar contas selecionadas')
    def ativar_contas(self, request, queryset):
        self._executar(
            request, queryset, pode_alterar_situacao,
            lambda alvo: definir_situacao(alvo, True), 'Contas ativadas',
        )

    @admin.action(description='Desativar contas selecionadas')
    def desativar_contas(self, request, queryset):
        self._executar(
            request, queryset, pode_alterar_situacao,
            lambda alvo: definir_situacao(alvo, False), 'Contas desativadas',
        )

    @admin.action(description='Definir como Aluno')
    def definir_como_aluno(self, request, queryset):
        self._executar(
            request, queryset, pode_definir_perfil,
            lambda alvo: definir_perfil(alvo, PerfilUsuario.ALUNO), 'Agora são Alunos',
        )

    @admin.action(description='Definir como Educador')
    def definir_como_educador(self, request, queryset):
        self._executar(
            request, queryset, pode_definir_perfil,
            lambda alvo: definir_perfil(alvo, PerfilUsuario.EDUCADOR), 'Agora são Educadores',
        )

    @admin.action(description='Definir como Administrador')
    def definir_como_administrador(self, request, queryset):
        self._executar(
            request, queryset, pode_definir_perfil,
            lambda alvo: definir_perfil(alvo, PerfilUsuario.ADMINISTRADOR), 'Agora são Administradores',
        )


class PerfilUsuarioAdmin(admin.ModelAdmin):
    list_display = ['usuario', 'tipo_usuario', 'administrador_principal', 'aceitou_termos', 'data_aceite_termos']
    list_display_links = None

    def has_module_permission(self, request):
        return False

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False


class ConviteEducadorForm(forms.ModelForm):
    class Meta:
        model = ConviteEducador
        fields = ['email']

    def clean_email(self):
        email = self.cleaned_data['email'].strip()
        if User.objects.filter(email__iexact=email).exists():
            raise forms.ValidationError(
                "Já existe uma conta com este e-mail. Para torná-la educadora, "
                "o Administrador principal usa a ação \"Definir como Educador\" em Usuários."
            )
        aberto = ConviteEducador.objects.filter(
            email__iexact=email, usado_em__isnull=True, expira_em__gte=timezone.now()
        ).exists()
        if aberto:
            raise forms.ValidationError(
                "Já existe um convite válido para este e-mail. "
                "Se a pessoa não recebeu, use a ação \"Reenviar convite\" na lista."
            )
        return email


@admin.register(ConviteEducador)
class ConviteEducadorAdmin(admin.ModelAdmin):
    form = ConviteEducadorForm
    fields = ('email',)
    list_display = ('email', 'codigo', 'situacao_exibida', 'expira_em', 'criado_por', 'conta_criada', 'usado_em')
    search_fields = ('email', 'codigo')
    list_display_links = None
    actions = ['reenviar', 'cancelar']

    def get_queryset(self, request):
        return super().get_queryset(request).select_related('criado_por', 'usado_por')

    @admin.display(description='Situação')
    def situacao_exibida(self, obj):
        return obj.situacao

    @admin.display(description='Conta criada')
    def conta_criada(self, obj):
        return nome_e_usuario(obj.usado_por) if obj.usado_por else '-'

    def _e_administrador(self, request):
        return request.user.is_active and request.user.is_superuser

    def has_module_permission(self, request):
        return self._e_administrador(request)

    def has_view_permission(self, request, obj=None):
        return self._e_administrador(request)

    def has_add_permission(self, request):
        return self._e_administrador(request)

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def _link_cadastro(self, request, convite):
        return request.build_absolute_uri(f"{reverse('cadastro')}?convite={convite.codigo}")

    def _avisar_envio(self, request, convite, enviado):
        if enviado:
            self.message_user(request, f"Convite enviado para {convite.email}.", messages.SUCCESS)
        else:
            self.message_user(
                request,
                f"O convite para {convite.email} foi criado, mas o e-mail não pôde ser enviado. "
                f"Passe o código {convite.codigo} para a pessoa por outro meio.",
                messages.WARNING,
            )

    def save_model(self, request, obj, form, change):
        obj.criado_por = request.user
        super().save_model(request, obj, form, change)
        self._avisar_envio(request, obj, enviar_convite(obj, self._link_cadastro(request, obj)))

    def response_add(self, request, obj, post_url_continue=None):
        return redirect(reverse('admin:contas_conviteeducador_changelist'))

    @admin.action(description='Reenviar convite')
    def reenviar(self, request, queryset):
        ignorados = []
        for convite in queryset:
            if convite.usado_em:
                ignorados.append(convite.email)
                continue
            convite.renovar()
            self._avisar_envio(request, convite, enviar_convite(convite, self._link_cadastro(request, convite)))
        if ignorados:
            self.message_user(request, f"Convites já usados não são reenviados: {', '.join(ignorados)}.", messages.WARNING)

    @admin.action(description='Cancelar convite')
    def cancelar(self, request, queryset):
        abertos = queryset.filter(usado_em__isnull=True)
        emails = list(abertos.values_list('email', flat=True))
        abertos.delete()
        if emails:
            self.message_user(request, f"Convites cancelados: {', '.join(emails)}.", messages.SUCCESS)
        if queryset.filter(usado_em__isnull=False).exists():
            self.message_user(request, "Convites já usados ficam no histórico e não são cancelados.", messages.WARNING)


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
admin.site.register(User, UsuarioAdminCustomizado)
admin.site.register(PerfilUsuario, PerfilUsuarioAdmin)


ORDEM_DO_MENU = {
    'modulos': ['Modulo', 'ConteudoModulo'],
    'atividades': ['Atividade', 'Pergunta', 'ProgressoAtividade', 'Tentativa'],
    'contas': ['User', 'ConviteEducador', 'ConfiguracaoSite'],
    'auth': ['Group'],
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
