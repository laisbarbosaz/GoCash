from django.conf import settings
from django.db import migrations


def verificar_emails_repetidos(apps, schema_editor):
    User = apps.get_model('auth', 'User')
    contas_por_email = {}
    for username, email in User.objects.exclude(email='').values_list('username', 'email'):
        contas_por_email.setdefault(email.lower(), []).append(username)

    repetidos = {email: nomes for email, nomes in contas_por_email.items() if len(nomes) > 1}
    if repetidos:
        detalhes = '; '.join(f"{email}: {', '.join(nomes)}" for email, nomes in sorted(repetidos.items()))
        raise RuntimeError(
            "Existem contas com o mesmo e-mail. Corrija antes de rodar o migrate de novo. " + detalhes
        )


class Migration(migrations.Migration):

    dependencies = [
        ('contas', '0005_solicitacaoprofessor'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.RunPython(verificar_emails_repetidos, migrations.RunPython.noop),
        migrations.RunSQL(
            sql="CREATE UNIQUE INDEX auth_user_email_unico ON auth_user (LOWER(email)) WHERE email <> '';",
            reverse_sql="DROP INDEX IF EXISTS auth_user_email_unico;",
        ),
    ]
