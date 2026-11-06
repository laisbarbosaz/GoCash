from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0009_professores_viram_educadores'),
    ]

    operations = [
        migrations.DeleteModel(
            name='SolicitacaoProfessor',
        ),
    ]
