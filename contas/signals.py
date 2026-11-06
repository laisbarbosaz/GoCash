from django.contrib.auth.models import User
from django.db.models.signals import post_migrate, post_save
from django.dispatch import receiver

from .models import PerfilUsuario
from .papeis import criar_grupo_educadores, remover_tabelas_antigas, tipo_pelas_permissoes, traduzir_permissoes


@receiver(post_save, sender=User)
def criar_ou_sincronizar_perfil(sender, instance, created, raw=False, **kwargs):
    if raw:
        return
    tipo = tipo_pelas_permissoes(instance)
    perfil, criado = PerfilUsuario.objects.get_or_create(usuario=instance, defaults={'tipo_usuario': tipo})
    if not criado and perfil.tipo_usuario != tipo:
        perfil.tipo_usuario = tipo
        perfil.save(update_fields=['tipo_usuario'])


@receiver(post_migrate)
def ajustar_permissoes(sender, **kwargs):
    criar_grupo_educadores()
    remover_tabelas_antigas()
    traduzir_permissoes()
