from .models import Tentativa

CASHS_A_CADA_10_PORCENTO = 10


def cashs_da_nota(aproveitamento):
    return (aproveitamento // 10) * CASHS_A_CADA_10_PORCENTO


def melhores_notas(usuario):
    melhores = {}
    for tentativa in Tentativa.objects.filter(usuario=usuario).only('atividade_id', 'acertos', 'total_perguntas'):
        atual = melhores.get(tentativa.atividade_id, 0)
        melhores[tentativa.atividade_id] = max(atual, tentativa.aproveitamento)
    return melhores


def saldo_de_cashs(usuario):
    return sum(cashs_da_nota(nota) for nota in melhores_notas(usuario).values())
