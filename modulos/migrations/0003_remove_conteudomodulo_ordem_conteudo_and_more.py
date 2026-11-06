from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('modulos', '0002_alter_conteudomodulo_options_alter_modulo_options'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='conteudomodulo',
            name='ordem_conteudo',
        ),
        migrations.RemoveField(
            model_name='modulo',
            name='ordem_modulo',
        ),
    ]
