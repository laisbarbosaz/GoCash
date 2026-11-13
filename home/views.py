from django.shortcuts import render

from modulos.models import Modulo

from .cotacoes import buscar_cotacoes

TRILHA = [
    ('entendendo-o-seu-orcamento', 'anote o que entra e o que sai. É a base de todo o resto.'),
    ('controles-e-dividas', 'como usar o cartão sem virar dívida e o que fazer se já estiver devendo.'),
    ('primeiro-salario', 'o que vem no holerite e como separar uma parte para guardar.'),
    ('golpes-financeiros', 'como reconhecer golpe de Pix, boleto e link falso.'),
    ('juros-compostos-na-pratica', 'por que os juros fazem uma dívida crescer e um investimento render.'),
    ('investir-pela-primeira-vez', 'onde deixar o dinheiro guardado para ele render com segurança.'),
    ('economia-global', 'por que o dólar e a inflação mudam o preço das coisas.'),
]

NOMES_CURTOS = {'USD': 'Dólar', 'EUR': 'Euro', 'BTC': 'Bitcoin'}


def pagina_inicial(request):
    modulos = Modulo.objects.in_bulk([slug for slug, _ in TRILHA], field_name='slug')
    passos = [
        {'modulo': modulos[slug], 'texto': texto}
        for slug, texto in TRILHA
        if slug in modulos
    ]
    contexto = {'passos': passos}

    modulo_cotacoes = Modulo.objects.filter(mostrar_cotacoes=True).order_by('nome_modulo').first()
    if modulo_cotacoes:
        cotacoes, _ = buscar_cotacoes()
        contexto['modulo_cotacoes'] = modulo_cotacoes
        contexto['moedas'] = [
            {**cotacao, 'nome_curto': NOMES_CURTOS.get(cotacao['codigo'], cotacao['codigo'])}
            for cotacao in cotacoes
        ]
    return render(request, 'home/inicio.html', contexto)


def quem_somos(request):
    return render(request, 'home/quem_somos.html')
