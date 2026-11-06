from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0010_delete_solicitacaoprofessor'),
    ]

    operations = [
        migrations.AddField(
            model_name='perfilusuario',
            name='aparecer_no_ranking',
            field=models.BooleanField(default=False, verbose_name='Aparecer no ranking'),
        ),
    ]
