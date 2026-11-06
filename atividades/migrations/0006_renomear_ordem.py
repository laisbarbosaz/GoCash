from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("atividades", "0005_delete_atividadeaberta"),
    ]

    operations = [
        migrations.AlterField(
            model_name="pergunta",
            name="ordem",
            field=models.PositiveIntegerField(
                default=1, verbose_name="Posição no quiz"
            ),
        ),
    ]
