"""Regras dos Cashs, a moeda de gamificação do Go Cash (RF06).

- Cada 10% de acerto em uma atividade vale 10 Cashs (ex.: 70% = 70 Cashs, 75% = 70 Cashs).
- Em cada atividade, só conta a MELHOR nota do usuário. Refazer a atividade
  não soma Cashs de novo; só aumenta o saldo se a nova nota for maior.
- O saldo é a soma dos Cashs de todas as atividades.

O saldo não é guardado em uma tabela: ele é calculado a partir das tentativas,
então nunca fica desatualizado nem "duplica" se a pessoa refizer uma atividade.
"""

from .models import Tentativa

CASHS_A_CADA_10_PORCENTO = 10


def cashs_da_nota(aproveitamento):
    """Converte o percentual de acerto em Cashs. Só conta a cada 10% completos."""
    return (aproveitamento // 10) * CASHS_A_CADA_10_PORCENTO


def melhores_notas(usuario):
    """Devolve {id_da_atividade: melhor aproveitamento} do usuário."""
    melhores = {}
    for tentativa in Tentativa.objects.filter(usuario=usuario).only('atividade_id', 'acertos', 'total_perguntas'):
        atual = melhores.get(tentativa.atividade_id, 0)
        melhores[tentativa.atividade_id] = max(atual, tentativa.aproveitamento)
    return melhores


def saldo_de_cashs(usuario):
    """Total de Cashs do usuário: soma da melhor nota de cada atividade."""
    return sum(cashs_da_nota(nota) for nota in melhores_notas(usuario).values())
