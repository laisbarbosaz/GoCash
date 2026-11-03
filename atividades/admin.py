from django.contrib import admin
from django.core.exceptions import ValidationError
from django.forms.models import BaseInlineFormSet

from .models import Alternativa, Atividade, AtividadeAberta, Pergunta, Tentativa


class AlternativaFormSet(BaseInlineFormSet):
    """Garante que cada pergunta tenha exatamente uma alternativa correta (RF05 - RN01)."""

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
    list_display = ('__str__', 'atividade', 'ordem', 'quantidade_alternativas')
    list_filter = ('atividade',)
    search_fields = ('enunciado',)
    inlines = [AlternativaInline]

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
    """Somente leitura: o administrador acompanha, mas não altera resultados."""

    list_display = ('usuario', 'atividade', 'numero', 'acertos', 'total_perguntas', 'aproveitamento_formatado', 'realizada_em')
    list_filter = ('atividade',)
    list_display_links = None

    @admin.display(description='Aproveitamento')
    def aproveitamento_formatado(self, obj):
        return f"{obj.aproveitamento}%"

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False


@admin.register(AtividadeAberta)
class AtividadeAbertaAdmin(admin.ModelAdmin):
    """Somente leitura: quem abriu uma atividade e ainda não enviou (para acompanhamento)."""

    list_display = ('usuario', 'atividade', 'numero', 'aberta_em')
    list_filter = ('atividade',)
    list_display_links = None

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False
