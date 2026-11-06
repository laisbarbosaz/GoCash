from datetime import datetime

import requests
from django.core.cache import cache

MOEDAS = 'USD-BRL,EUR-BRL,BTC-BRL'
URL_API = f'https://economia.awesomeapi.com.br/json/last/{MOEDAS}'
CHAVE_CACHE = 'cotacoes_do_dia'
SEGUNDOS_EM_CACHE = 120


def _data_legivel(texto):
    try:
        return datetime.strptime(texto, '%Y-%m-%d %H:%M:%S').strftime('%d/%m/%Y às %H:%M')
    except (TypeError, ValueError):
        return ''


def buscar_cotacoes():
    cotacoes = cache.get(CHAVE_CACHE)
    if cotacoes is not None:
        return cotacoes, False

    try:
        resposta = requests.get(URL_API, timeout=5)
        resposta.raise_for_status()
        cotacoes = [
            {
                'nome': valor['name'],
                'codigo': valor['code'],
                'compra': float(valor['bid']),
                'venda': float(valor['ask']),
                'maxima': float(valor['high']),
                'minima': float(valor['low']),
                'variacao': float(valor['pctChange']),
                'atualizada': _data_legivel(valor.get('create_date', '')),
            }
            for valor in resposta.json().values()
        ]
    except (requests.RequestException, ValueError, KeyError, TypeError, AttributeError):
        return [], True

    cache.set(CHAVE_CACHE, cotacoes, SEGUNDOS_EM_CACHE)
    return cotacoes, False
