from django.shortcuts import render

from modulos.models import Modulo

TRILHA = [
    ('entendendo-o-seu-orcamento', 'anote o que entra e o que sai. É a base de todo o resto.'),
    ('controles-e-dividas', 'como usar o cartão sem virar dívida e o que fazer se já estiver devendo.'),
    ('primeiro-salario', 'o que vem no holerite e como separar uma parte para guardar.'),
    ('golpes-financeiros', 'como reconhecer golpe de Pix, boleto e link falso.'),
    ('juros-compostos-na-pratica', 'por que os juros fazem uma dívida crescer e um investimento render.'),
    ('investir-pela-primeira-vez', 'onde deixar o dinheiro guardado para ele render com segurança.'),
    ('economia-global', 'por que o dólar e a inflação mudam o preço das coisas.'),
]


def pagina_inicial(request):
    modulos = Modulo.objects.in_bulk([slug for slug, _ in TRILHA], field_name='slug')
    passos = [
        {'modulo': modulos[slug], 'texto': texto}
        for slug, texto in TRILHA
        if slug in modulos
    ]
    return render(request, 'home/inicio.html', {'passos': passos})


def quem_somos(request):
    return render(request, 'home/quem_somos.html')
