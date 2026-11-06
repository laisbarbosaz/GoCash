from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='perfilusuario',
            name='tipo_usuario',
            field=models.CharField(choices=[('admin', 'Administrador'), ('aluno', 'Aluno')], default='aluno', max_length=10),
        ),
    ]
