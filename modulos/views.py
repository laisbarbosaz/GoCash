from django.contrib import messages
from django.shortcuts import get_object_or_404, redirect, render
from django.urls import reverse

from home.cotacoes import SLUG_DO_MODULO, buscar_cotacoes

from .leitura import ids_lidos, marcar_como_lido, partes_do_modulo
from .models import Modulo


def listar_modulos(request):
    modulos = Modulo.objects.all().order_by('nome_modulo')
    return render(request, 'modulos/lista.html', {'modulos': modulos})


def _numero_da_parte(request, total):
    try:
        numero = int(request.GET.get('parte', 1))
    except (TypeError, ValueError):
        numero = 1
    return min(max(numero, 1), max(total, 1))


def _endereco_da_parte(modulo, numero):
    return f"{reverse('detalhe_modulo', args=[modulo.slug])}?parte={numero}"


def detalhe_modulo(request, slug):
    modulo = get_object_or_404(Modulo, slug=slug)
    partes = partes_do_modulo(modulo)
    total = len(partes)
    numero = _numero_da_parte(request, total)
    lidas = ids_lidos(request, partes)

    if numero > 1 and partes[numero - 2].id not in lidas:
        liberada = next(i for i, parte in enumerate(partes, start=1) if parte.id not in lidas)
        messages.info(request, "Leia as partes na ordem. Continue de onde parou.")
        return redirect(_endereco_da_parte(modulo, liberada))

    parte = partes[numero - 1] if total else None
    if parte:
        marcar_como_lido(request, parte)
        lidas.add(parte.id)

    contexto = {
        'modulo': modulo,
        'parte': parte,
        'numero': numero,
        'total': total,
        'percentual': round(numero * 100 / total) if total else 100,
        'anterior': numero - 1 if numero > 1 else None,
        'proxima': numero + 1 if numero < total else None,
        'leu_tudo': all(p.id in lidas for p in partes),
        'sumario': [
            {'numero': i, 'titulo': p.titulo_conteudo, 'lida': p.id in lidas, 'atual': i == numero}
            for i, p in enumerate(partes, start=1)
        ],
        'mostrar_cotacoes': modulo.slug == SLUG_DO_MODULO and numero == 1,
    }
    if contexto['mostrar_cotacoes']:
        contexto['cotacoes'], contexto['erro_api'] = buscar_cotacoes()
    return render(request, 'modulos/detalhe.html', contexto)
