from django.db import migrations
from django.utils import timezone


def marcar_contas_ja_desativadas(apps, schema_editor):
    PerfilUsuario = apps.get_model('contas', 'PerfilUsuario')
    PerfilUsuario.objects.filter(usuario__is_active=False, desativada_em__isnull=True).update(
        desativada_em=timezone.now()
    )


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0014_perfilusuario_desativada_em'),
    ]

    operations = [
        migrations.RunPython(marcar_contas_ja_desativadas, migrations.RunPython.noop),
    ]
