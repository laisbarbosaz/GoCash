from django.db import migrations


def educadores_viram_alunos(apps, schema_editor):
    User = apps.get_model('auth', 'User')
    Group = apps.get_model('auth', 'Group')
    PerfilUsuario = apps.get_model('contas', 'PerfilUsuario')

    educadores = User.objects.filter(is_staff=True, is_superuser=False)
    PerfilUsuario.objects.filter(usuario__in=educadores).update(tipo_usuario='aluno')
    PerfilUsuario.objects.filter(tipo_usuario='educador').update(tipo_usuario='aluno')
    educadores.update(is_staff=False)
    Group.objects.filter(name='Educadores').delete()


class Migration(migrations.Migration):

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
        ('contas', '0011_perfilusuario_aparecer_no_ranking'),
    ]

    operations = [
        migrations.RunPython(educadores_viram_alunos, migrations.RunPython.noop),
    ]
