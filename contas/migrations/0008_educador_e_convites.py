import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models

import contas.models


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0007_configuracaosite'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AlterField(
            model_name='perfilusuario',
            name='tipo_usuario',
            field=models.CharField(
                choices=[('aluno', 'Aluno'), ('educador', 'Educador'), ('administrador', 'Administrador')],
                default='aluno',
                max_length=15,
                verbose_name='Perfil',
            ),
        ),
        migrations.CreateModel(
            name='ConviteEducador',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('email', models.EmailField(max_length=254, verbose_name='E-mail do educador')),
                ('codigo', models.CharField(default=contas.models.gerar_codigo_convite, editable=False, max_length=8, unique=True, verbose_name='Código')),
                ('criado_em', models.DateTimeField(auto_now_add=True, verbose_name='Enviado em')),
                ('expira_em', models.DateTimeField(default=contas.models.validade_do_convite, editable=False, verbose_name='Vale até')),
                ('usado_em', models.DateTimeField(blank=True, editable=False, null=True, verbose_name='Usado em')),
                ('criado_por', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='convites_enviados', to=settings.AUTH_USER_MODEL, verbose_name='Enviado por')),
                ('usado_por', models.ForeignKey(blank=True, editable=False, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to=settings.AUTH_USER_MODEL, verbose_name='Conta criada')),
            ],
            options={
                'verbose_name': 'Convite de educador',
                'verbose_name_plural': 'Convites de educador',
                'ordering': ['-criado_em'],
            },
        ),
    ]
