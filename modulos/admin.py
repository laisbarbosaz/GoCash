from django.contrib import admin
from .models import Modulo, ConteudoModulo


@admin.register(Modulo)
class ModuloAdmin(admin.ModelAdmin):
    list_display = ('nome_modulo', 'slug')
    # Ao digitar o nome de um módulo novo, o endereço é preenchido sozinho
    prepopulated_fields = {'slug': ('nome_modulo',)}


admin.site.register(ConteudoModulo)
