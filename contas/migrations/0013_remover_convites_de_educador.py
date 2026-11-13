from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0012_educadores_viram_alunos'),
    ]

    operations = [
        migrations.DeleteModel(
            name='ConviteEducador',
        ),
        migrations.AlterField(
            model_name='perfilusuario',
            name='tipo_usuario',
            field=models.CharField(
                choices=[('aluno', 'Aluno'), ('administrador', 'Administrador')],
                default='aluno',
                max_length=15,
                verbose_name='Perfil',
            ),
        ),
    ]
