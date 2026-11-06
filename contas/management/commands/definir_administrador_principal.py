from django.contrib.auth.models import User
from django.core.management.base import BaseCommand, CommandError

from contas.papeis import tornar_principal


class Command(BaseCommand):
    help = 'quem é é o admin principal'

    def add_arguments(self, parser):
        parser.add_argument('username')

    def handle(self, *args, **options):
        username = options['username']
        usuario = User.objects.filter(username=username).first()
        if not usuario:
            raise CommandError(f'Usuário "{username}" não encontrado.')
        tornar_principal(usuario)
        self.stdout.write(self.style.SUCCESS(f'"{username}" agora é o administrador principal.'))
