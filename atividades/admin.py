from django.contrib import admin
from django.contrib.auth.models import User
from django.core.exceptions import PermissionDenied, ValidationError
from django.forms.models import BaseInlineFormSet
from django.template.response import TemplateResponse
from django.urls import path

from contas.models import PerfilUsuario, nome_e_usuario
from modulos.models import Modulo

from .cashs import cashs_da_nota
from .models import Alternativa, Atividade, Pergunta, ProgressoAtividade, Tentativa


class AlternativaFormSet(BaseInlineFormSet):
    def clean(self):
        super().clean()
        if any(self.errors):
            return

        total = 0
        corretas = 0
        for form in self.forms:
            dados = getattr(form, 'cleaned_data', None)
            if not dados or dados.get('DELETE'):
                continue
            total += 1
            if dados.get('correta'):
                corretas += 1

        if total < 2:
            raise ValidationError('Cada pergunta deve ter pelo menos 2 alternativas.')
        if corretas != 1:
            raise ValidationError('Cada pergunta deve ter exatamente 1 alternativa correta.')


class AlternativaInline(admin.TabularInline):
    model = Alternativa
    formset = AlternativaFormSet
    extra = 4
    fields = ('texto', 'correta')


@admin.register(Pergunta)
class PerguntaAdmin(admin.ModelAdmin):
    list_display = ('__str__', 'modulo', 'quantidade_alternativas')
    list_filter = ('atividade__modulo',)
    search_fields = ('enunciado', 'atividade__modulo__nome_modulo')
    ordering = ('atividade__modulo__nome_modulo', 'id')
    sortable_by = ()
    inlines = [AlternativaInline]

    def get_queryset(self, request):
        return super().get_queryset(request).select_related('atividade__modulo')

    @admin.display(description='Módulo', ordering='atividade__modulo__nome_modulo')
    def modulo(self, obj):
        return obj.atividade.modulo.nome_modulo

    @admin.display(description='Alternativas')
    def quantidade_alternativas(self, obj):
        return obj.alternativas.count()


@admin.register(Atividade)
class AtividadeAdmin(admin.ModelAdmin):
    list_display = ('titulo', 'modulo', 'quantidade_perguntas')
    search_fields = ('titulo', 'modulo__nome_modulo')

    @admin.display(description='Perguntas')
    def quantidade_perguntas(self, obj):
        return obj.perguntas.count()


@admin.register(Tentativa)
class TentativaAdmin(admin.ModelAdmin):
    list_display = ('aluno', 'atividade', 'numero', 'acertos', 'total_perguntas', 'aproveitamento_formatado', 'realizada_em')
    list_filter = ('atividade',)
    search_fields = ('usuario__username', 'usuario__first_name', 'usuario__last_name')
    list_display_links = None

    def get_queryset(self, request):
        return super().get_queryset(request).select_related('usuario', 'atividade')

    @admin.display(description='Aluno', ordering='usuario__first_name')
    def aluno(self, obj):
        return nome_e_usuario(obj.usuario)

    @admin.display(description='Aproveitamento')
    def aproveitamento_formatado(self, obj):
        return f"{obj.aproveitamento}%"

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False


@admin.register(ProgressoAtividade)
class ProgressoAtividadeAdmin(admin.ModelAdmin):
    list_display = ('aluno', 'modulo', 'atividade', 'status', 'iniciada_em', 'concluida_em', 'tentativas', 'cashs')
    list_filter = ('status', 'atividade__modulo')
    search_fields = ('usuario__username', 'usuario__first_name', 'usuario__last_name', 'usuario__email')
    list_display_links = None

    def get_queryset(self, request):
        return super().get_queryset(request).select_related('usuario', 'atividade__modulo')

    @admin.display(description='Aluno', ordering='usuario__first_name')
    def aluno(self, obj):
        return nome_e_usuario(obj.usuario)

    @admin.display(description='Módulo', ordering='atividade__modulo__nome_modulo')
    def modulo(self, obj):
        return obj.atividade.modulo.nome_modulo

    def _tentativas_do_aluno(self, obj):
        return Tentativa.objects.filter(usuario_id=obj.usuario_id, atividade_id=obj.atividade_id)

    @admin.display(description='Tentativas')
    def tentativas(self, obj):
        return f"{self._tentativas_do_aluno(obj).count()} de {Atividade.MAX_TENTATIVAS}"

    @admin.display(description='Cashs')
    def cashs(self, obj):
        notas = [tentativa.aproveitamento for tentativa in self._tentativas_do_aluno(obj)]
        return cashs_da_nota(max(notas)) if notas else '-'

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def get_urls(self):
        return [
            path(
                'acompanhamento/',
                self.admin_site.admin_view(self.acompanhamento_view),
                name='atividades_progressoatividade_acompanhamento',
            ),
        ] + super().get_urls()

    def _resumo(self, atividade, alunos_ids):
        progressos = ProgressoAtividade.objects.filter(atividade=atividade, usuario_id__in=alunos_ids)
        resumo = {status: 0 for status in ProgressoAtividade.ROTULOS}
        for status in progressos.values_list('status', flat=True):
            resumo[status] += 1
        resumo[ProgressoAtividade.NAO_INICIADA] = len(alunos_ids) - resumo[ProgressoAtividade.CONCLUIDA] - resumo[ProgressoAtividade.EM_ANDAMENTO]
        return resumo

    def acompanhamento_view(self, request):
        if not self.has_view_permission(request):
            raise PermissionDenied

        modulos = list(
            Modulo.objects.filter(atividade__isnull=False).select_related('atividade').order_by('nome_modulo')
        )
        alunos = list(
            User.objects.filter(is_active=True, perfil__tipo_usuario=PerfilUsuario.ALUNO).order_by('first_name', 'last_name', 'username')
        )
        alunos_ids = [aluno.id for aluno in alunos]

        modulo_escolhido = next((m for m in modulos if m.slug == request.GET.get('modulo')), None)
        status_escolhido = request.GET.get('status', '')
        if status_escolhido not in ProgressoAtividade.ROTULOS:
            status_escolhido = ''

        contexto = {
            **self.admin_site.each_context(request),
            'title': 'Acompanhamento por módulo',
            'opts': self.model._meta,
            'modulos': modulos,
            'modulo_escolhido': modulo_escolhido,
            'max_tentativas': Atividade.MAX_TENTATIVAS,
            'linhas': [],
        }

        if not modulo_escolhido:
            contexto['resumo_modulos'] = [
                {'modulo': modulo, 'resumo': self._resumo(modulo.atividade, alunos_ids)}
                for modulo in modulos
            ]
            return TemplateResponse(request, 'admin/atividades/acompanhamento.html', contexto)

        atividade = modulo_escolhido.atividade
        progressos = {p.usuario_id: p for p in ProgressoAtividade.objects.filter(atividade=atividade)}
        tentativas = {}
        for tentativa in Tentativa.objects.filter(atividade=atividade):
            tentativas.setdefault(tentativa.usuario_id, []).append(tentativa)

        resumo = {status: 0 for status in ProgressoAtividade.ROTULOS}
        linhas = []
        for aluno in alunos:
            progresso = progressos.get(aluno.id)
            status = progresso.status if progresso else ProgressoAtividade.NAO_INICIADA
            resumo[status] += 1
            if status_escolhido and status != status_escolhido:
                continue
            feitas = tentativas.get(aluno.id, [])
            linhas.append({
                'aluno': aluno,
                'status': status,
                'status_exibido': ProgressoAtividade.ROTULOS[status],
                'iniciada_em': progresso.iniciada_em if progresso else None,
                'concluida_em': progresso.concluida_em if progresso else None,
                'tentativas': len(feitas),
                'cashs': cashs_da_nota(max(t.aproveitamento for t in feitas)) if feitas else None,
            })

        filtros_status = [('', 'Todos', len(alunos))] + [
            (status, rotulo, resumo[status]) for status, rotulo in ProgressoAtividade.ROTULOS.items()
        ]
        contexto.update({
            'title': f'Acompanhamento: {modulo_escolhido.nome_modulo}',
            'status_escolhido': status_escolhido,
            'filtros_status': filtros_status,
            'linhas': linhas,
            'resumo': resumo,
        })
        return TemplateResponse(request, 'admin/atividades/acompanhamento.html', contexto)
