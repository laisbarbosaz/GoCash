from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("modulos", "0006_remover_textos_de_ajuda"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="modulo",
            name="mostrar_cotacoes",
        ),
    ]
