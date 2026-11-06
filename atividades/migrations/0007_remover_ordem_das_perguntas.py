from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("atividades", "0006_renomear_ordem"),
    ]

    operations = [
        migrations.AlterModelOptions(
            name="pergunta",
            options={
                "ordering": ["id"],
                "verbose_name": "Pergunta",
                "verbose_name_plural": "Perguntas das Atividades",
            },
        ),
        migrations.AlterModelOptions(
            name="resposta",
            options={
                "ordering": ["pergunta__id"],
                "verbose_name": "Resposta",
                "verbose_name_plural": "Respostas",
            },
        ),
        migrations.RemoveField(
            model_name="pergunta",
            name="ordem",
        ),
    ]
