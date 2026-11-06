from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("modulos", "0005_modulo_mostrar_cotacoes"),
    ]

    operations = [
        migrations.AlterField(
            model_name="modulo",
            name="mostrar_cotacoes",
            field=models.BooleanField(
                default=False, verbose_name="Mostrar cotações do dia"
            ),
        ),
        migrations.AlterField(
            model_name="modulo",
            name="slug",
            field=models.SlugField(
                blank=True,
                max_length=110,
                null=True,
                unique=True,
                verbose_name="Endereço na URL",
            ),
        ),
    ]
