from django.core.management.base import BaseCommand

from contas.limpeza import DIAS_ATE_EXCLUIR, excluir_contas_desativadas


class Command(BaseCommand):
    help = f'Exclui as contas desativadas há mais de {DIAS_ATE_EXCLUIR} dias.'

    def handle(self, *args, **options):
        nomes = excluir_contas_desativadas()
        if nomes:
            self.stdout.write(self.style.SUCCESS(f'Contas excluídas: {", ".join(nomes)}.'))
        else:
            self.stdout.write('Nenhuma conta para excluir.')
