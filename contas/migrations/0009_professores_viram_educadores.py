from django.db import migrations


def professores_para_educadores(apps, schema_editor):
    PerfilUsuario = apps.get_model('contas', 'PerfilUsuario')
    Group = apps.get_model('auth', 'Group')
    SolicitacaoProfessor = apps.get_model('contas', 'SolicitacaoProfessor')
    User = apps.get_model('auth', 'User')

    PerfilUsuario.objects.filter(tipo_usuario='professor').update(tipo_usuario='educador')

    antigo = Group.objects.filter(name='Professores').first()
    if antigo:
        if Group.objects.filter(name='Educadores').exists():
            novo = Group.objects.get(name='Educadores')
            novo.permissions.add(*antigo.permissions.all())
            for usuario in antigo.user_set.all():
                usuario.groups.add(novo)
            antigo.delete()
        else:
            antigo.name = 'Educadores'
            antigo.save(update_fields=['name'])

    pendentes = SolicitacaoProfessor.objects.filter(status='pendente').values_list('usuario_id', flat=True)
    User.objects.filter(pk__in=list(pendentes)).update(is_active=True)


def educadores_para_professores(apps, schema_editor):
    PerfilUsuario = apps.get_model('contas', 'PerfilUsuario')
    Group = apps.get_model('auth', 'Group')

    PerfilUsuario.objects.filter(tipo_usuario='educador').update(tipo_usuario='professor')
    Group.objects.filter(name='Educadores').update(name='Professores')


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0008_educador_e_convites'),
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.RunPython(professores_para_educadores, educadores_para_professores),
    ]
