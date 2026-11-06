import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('modulos', '0003_remove_conteudomodulo_ordem_conteudo_and_more'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Atividade',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('titulo', models.CharField(max_length=150, verbose_name='Título')),
                ('descricao', models.TextField(blank=True, verbose_name='Descrição')),
                ('modulo', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='atividade', to='modulos.modulo', verbose_name='Módulo')),
            ],
            options={
                'verbose_name': 'Atividade',
                'verbose_name_plural': 'Atividades dos Módulos',
                'ordering': ['modulo__nome_modulo'],
            },
        ),
        migrations.CreateModel(
            name='Pergunta',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('enunciado', models.TextField(verbose_name='Enunciado')),
                ('ordem', models.PositiveIntegerField(default=1, verbose_name='Ordem')),
                ('atividade', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='perguntas', to='atividades.atividade', verbose_name='Atividade')),
            ],
            options={
                'verbose_name': 'Pergunta',
                'verbose_name_plural': 'Perguntas das Atividades',
                'ordering': ['ordem', 'id'],
            },
        ),
        migrations.CreateModel(
            name='Alternativa',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('texto', models.CharField(max_length=255, verbose_name='Texto')),
                ('correta', models.BooleanField(default=False, verbose_name='Correta')),
                ('pergunta', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='alternativas', to='atividades.pergunta', verbose_name='Pergunta')),
            ],
            options={
                'verbose_name': 'Alternativa',
                'verbose_name_plural': 'Alternativas',
                'ordering': ['id'],
            },
        ),
        migrations.CreateModel(
            name='Tentativa',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('numero', models.PositiveSmallIntegerField(verbose_name='Nº da tentativa')),
                ('acertos', models.PositiveIntegerField(verbose_name='Acertos')),
                ('total_perguntas', models.PositiveIntegerField(verbose_name='Total de perguntas')),
                ('realizada_em', models.DateTimeField(auto_now_add=True, verbose_name='Realizada em')),
                ('atividade', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='tentativas', to='atividades.atividade', verbose_name='Atividade')),
                ('usuario', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='tentativas_atividades', to=settings.AUTH_USER_MODEL, verbose_name='Usuário')),
            ],
            options={
                'verbose_name': 'Tentativa',
                'verbose_name_plural': 'Tentativas dos Usuários',
                'ordering': ['-realizada_em', '-id'],
            },
        ),
        migrations.CreateModel(
            name='Resposta',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('correta', models.BooleanField(verbose_name='Acertou?')),
                ('alternativa', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='atividades.alternativa', verbose_name='Alternativa marcada')),
                ('pergunta', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='atividades.pergunta', verbose_name='Pergunta')),
                ('tentativa', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='respostas', to='atividades.tentativa', verbose_name='Tentativa')),
            ],
            options={
                'verbose_name': 'Resposta',
                'verbose_name_plural': 'Respostas',
                'ordering': ['pergunta__ordem', 'pergunta__id'],
            },
        ),
        migrations.AddConstraint(
            model_name='tentativa',
            constraint=models.UniqueConstraint(fields=('usuario', 'atividade', 'numero'), name='tentativa_unica_por_numero'),
        ),
    ]
