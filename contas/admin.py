from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from .models import PerfilUsuario


class UsuarioAdminCustomizado(UserAdmin):
    list_display_links = None

    actions = None

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False


class PerfilUsuarioAdmin(admin.ModelAdmin):
    list_display = ['usuario', 'tipo_usuario', 'aceitou_termos', 'data_aceite_termos']
    
    list_display_links = None

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

admin.site.unregister(User)
admin.site.register(User, UsuarioAdminCustomizado)
admin.site.register(PerfilUsuario, PerfilUsuarioAdmin)
