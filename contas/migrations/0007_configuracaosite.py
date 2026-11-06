import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0006_email_unico'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='ConfiguracaoSite',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('exigir_mfa', models.BooleanField(default=True, help_text='Quando desligado, todos os usuários entram só com usuário e senha.', verbose_name='Exigir código por e-mail no login')),
                ('atualizada_em', models.DateTimeField(auto_now=True, verbose_name='Última alteração')),
                ('atualizada_por', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to=settings.AUTH_USER_MODEL, verbose_name='Alterada por')),
            ],
            options={
                'verbose_name': 'Configuração do site',
                'verbose_name_plural': 'Configurações do site',
            },
        ),
    ]
