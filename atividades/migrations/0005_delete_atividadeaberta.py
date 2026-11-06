from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('atividades', '0004_progressoatividade'),
    ]

    operations = [
        migrations.DeleteModel(
            name='AtividadeAberta',
        ),
    ]
