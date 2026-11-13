from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0013_remover_convites_de_educador'),
    ]

    operations = [
        migrations.AddField(
            model_name='perfilusuario',
            name='desativada_em',
            field=models.DateTimeField(blank=True, null=True, verbose_name='Desativada em'),
        ),
    ]
