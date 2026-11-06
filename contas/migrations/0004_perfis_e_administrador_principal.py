from django.conf import settings
from django.db import migrations, models


def classificar_usuarios_existentes(apps, schema_editor):
    User = apps.get_model('auth', 'User')
    PerfilUsuario = apps.get_model('contas', 'PerfilUsuario')
    for usuario in User.objects.all():
        if usuario.is_superuser:
            tipo = 'administrador'
        elif usuario.is_staff:
            tipo = 'professor'
        else:
            tipo = 'aluno'
        PerfilUsuario.objects.update_or_create(usuario=usuario, defaults={'tipo_usuario': tipo})


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0003_codigoverificacao'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AlterField(
            model_name='perfilusuario',
            name='tipo_usuario',
            field=models.CharField(
                choices=[('aluno', 'Aluno'), ('professor', 'Professor'), ('administrador', 'Administrador')],
                default='aluno',
                max_length=15,
                verbose_name='Perfil',
            ),
        ),
        migrations.AddField(
            model_name='perfilusuario',
            name='administrador_principal',
            field=models.BooleanField(default=False, verbose_name='Administrador principal'),
        ),
        migrations.AddConstraint(
            model_name='perfilusuario',
            constraint=models.UniqueConstraint(
                condition=models.Q(('administrador_principal', True)),
                fields=('administrador_principal',),
                name='apenas_um_administrador_principal',
            ),
        ),
        migrations.RunPython(classificar_usuarios_existentes, migrations.RunPython.noop),
    ]
