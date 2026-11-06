import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0004_perfis_e_administrador_principal'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='SolicitacaoProfessor',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('escola', models.CharField(max_length=150, verbose_name='Escola')),
                ('matricula', models.CharField(max_length=50, verbose_name='Matrícula')),
                ('status', models.CharField(choices=[('pendente', 'Aguardando análise'), ('aprovada', 'Aprovada')], default='pendente', max_length=10, verbose_name='Situação')),
                ('criada_em', models.DateTimeField(auto_now_add=True, verbose_name='Enviada em')),
                ('analisada_em', models.DateTimeField(blank=True, null=True, verbose_name='Analisada em')),
                ('analisada_por', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='solicitacoes_analisadas', to=settings.AUTH_USER_MODEL, verbose_name='Analisada por')),
                ('usuario', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='solicitacao_professor', to=settings.AUTH_USER_MODEL, verbose_name='Usuário')),
            ],
            options={
                'verbose_name': 'Solicitação de professor',
                'verbose_name_plural': 'Solicitações de professor',
                'ordering': ['-criada_em'],
            },
        ),
    ]
