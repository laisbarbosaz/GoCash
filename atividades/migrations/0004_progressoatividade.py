import django.db.models.deletion
import django.utils.timezone
from django.conf import settings
from django.db import migrations, models
from django.db.models import Min


def converter_dados(apps, schema_editor):
    Tentativa = apps.get_model('atividades', 'Tentativa')
    AtividadeAberta = apps.get_model('atividades', 'AtividadeAberta')
    ProgressoAtividade = apps.get_model('atividades', 'ProgressoAtividade')

    registrados = set()
    concluidas = (
        Tentativa.objects.order_by()
        .values('usuario_id', 'atividade_id')
        .annotate(primeiro_envio=Min('realizada_em'))
    )
    for item in concluidas:
        ProgressoAtividade.objects.create(
            usuario_id=item['usuario_id'],
            atividade_id=item['atividade_id'],
            status='concluida',
            iniciada_em=item['primeiro_envio'],
            concluida_em=item['primeiro_envio'],
        )
        registrados.add((item['usuario_id'], item['atividade_id']))

    for abertura in AtividadeAberta.objects.order_by('aberta_em'):
        chave = (abertura.usuario_id, abertura.atividade_id)
        if chave in registrados:
            continue
        ProgressoAtividade.objects.create(
            usuario_id=abertura.usuario_id,
            atividade_id=abertura.atividade_id,
            status='em_andamento',
            iniciada_em=abertura.aberta_em,
        )
        registrados.add(chave)


def liberar_para_professores(apps, schema_editor):
    ContentType = apps.get_model('contenttypes', 'ContentType')
    Permission = apps.get_model('auth', 'Permission')
    Group = apps.get_model('auth', 'Group')

    grupo = Group.objects.filter(name='Professores').first()
    if not grupo:
        return
    tipo, _ = ContentType.objects.get_or_create(app_label='atividades', model='progressoatividade')
    permissao, _ = Permission.objects.get_or_create(
        content_type=tipo,
        codename='view_progressoatividade',
        defaults={'name': 'Can view Progresso na atividade'},
    )
    grupo.permissions.add(permissao)


class Migration(migrations.Migration):

    dependencies = [
        ('atividades', '0003_limpar_aberturas_de_atividades_concluidas'),
        ('auth', '0012_alter_user_first_name_max_length'),
        ('contenttypes', '0002_remove_content_type_name'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='ProgressoAtividade',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('status', models.CharField(choices=[('em_andamento', 'Em andamento'), ('concluida', 'Concluída')], default='em_andamento', max_length=15, verbose_name='Status')),
                ('iniciada_em', models.DateTimeField(default=django.utils.timezone.now, verbose_name='Começou em')),
                ('concluida_em', models.DateTimeField(blank=True, null=True, verbose_name='Concluiu em')),
                ('atividade', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='progressos', to='atividades.atividade', verbose_name='Atividade')),
                ('usuario', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='progressos_atividades', to=settings.AUTH_USER_MODEL, verbose_name='Aluno')),
            ],
            options={
                'verbose_name': 'Progresso na atividade',
                'verbose_name_plural': 'Progresso nas atividades',
                'ordering': ['atividade__modulo__nome_modulo', 'usuario__username'],
                'constraints': [models.UniqueConstraint(fields=('usuario', 'atividade'), name='progresso_unico_por_aluno_e_atividade')],
            },
        ),
        migrations.RunPython(converter_dados, migrations.RunPython.noop),
        migrations.RunPython(liberar_para_professores, migrations.RunPython.noop),
    ]
