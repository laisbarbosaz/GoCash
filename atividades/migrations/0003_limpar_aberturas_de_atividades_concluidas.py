from django.db import migrations
from django.db.models import Exists, OuterRef


def limpar_aberturas(apps, schema_editor):
    AtividadeAberta = apps.get_model('atividades', 'AtividadeAberta')
    Tentativa = apps.get_model('atividades', 'Tentativa')
    tentativas_enviadas = Tentativa.objects.filter(
        usuario_id=OuterRef('usuario_id'),
        atividade_id=OuterRef('atividade_id'),
    )
    AtividadeAberta.objects.filter(Exists(tentativas_enviadas)).delete()


class Migration(migrations.Migration):

    dependencies = [
        ('atividades', '0002_atividadeaberta'),
    ]

    operations = [
        migrations.RunPython(limpar_aberturas, migrations.RunPython.noop),
    ]
