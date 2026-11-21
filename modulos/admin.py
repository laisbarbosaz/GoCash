from django.contrib import admin
from .models import ConteudoModulo, LeituraConteudo, Modulo


@admin.register(Modulo)
class ModuloAdmin(admin.ModelAdmin):
    list_display = ('nome_modulo', 'slug')
    prepopulated_fields = {'slug': ('nome_modulo',)}


admin.site.register(ConteudoModulo)


@admin.register(LeituraConteudo)
class LeituraConteudoAdmin(admin.ModelAdmin):
    list_display = ('usuario', 'conteudo', 'lida_em')
    list_filter = ('conteudo__modulo',)
    search_fields = ('usuario__username', 'conteudo__titulo_conteudo')

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False
