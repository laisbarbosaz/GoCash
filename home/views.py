import requests
from django.shortcuts import render

def pagina_inicial(request):
    moedas = "USD-BRL,EUR-BRL,BTC-BRL"
    url = f"https://economia.awesomeapi.com.br/json/last/{moedas}"

    cotacoes = []
    erro_api = False

    try:
        resposta = requests.get(url, timeout=5)
        resposta.raise_for_status()
        dados = resposta.json()

        for chave, valor in dados.items():
            cotacoes.append({
                'nome': valor['name'],
                'codigo': valor['code'],
                'valor': float(valor['bid']),
                'variacao': float(valor['pctChange']),
            })
    except requests.RequestException:
        erro_api = True

    return render(request, 'home/inicio.html', {
        'cotacoes': cotacoes,
        'erro_api': erro_api,
    })