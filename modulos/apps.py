from django.apps import AppConfig


class ModulosConfig(AppConfig):
    name = 'modulos'
    verbose_name = 'Módulos'

    def ready(self):
        from . import signals  # noqa: F401
