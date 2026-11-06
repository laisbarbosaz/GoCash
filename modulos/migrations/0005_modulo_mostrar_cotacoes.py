from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('modulos', '0004_modulo_slug'),
    ]

    operations = [
        migrations.AddField(
            model_name='modulo',
            name='mostrar_cotacoes',
            field=models.BooleanField(default=False, help_text='Exibe no topo do módulo as cotações do dólar, do euro e do bitcoin (AwesomeAPI). A página inicial também passa a indicar este módulo.', verbose_name='Mostrar cotações do dia'),
        ),
    ]
