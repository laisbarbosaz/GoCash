from django.contrib import admin
from .models import Modulo, ConteudoModulo


@admin.register(Modulo)
class ModuloAdmin(admin.ModelAdmin):
<<<<<<< HEAD
    list_display = ('nome_modulo', 'slug')
=======
    list_display = ('nome_modulo', 'slug', 'mostrar_cotacoes')
>>>>>>> 590b5c549d2da81969b5f9e3bacb31f9dc6b298f
    prepopulated_fields = {'slug': ('nome_modulo',)}


admin.site.register(ConteudoModulo)
