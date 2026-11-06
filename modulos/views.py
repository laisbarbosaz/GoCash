from django.shortcuts import get_object_or_404, render

from home.cotacoes import buscar_cotacoes

from .models import Modulo


def listar_modulos(request):
    modulos = Modulo.objects.all().order_by('nome_modulo')
    return render(request, 'modulos/lista.html', {'modulos': modulos})


def detalhe_modulo(request, slug):
    modulo = get_object_or_404(Modulo, slug=slug)
    contexto = {'modulo': modulo}
    if modulo.mostrar_cotacoes:
        contexto['cotacoes'], contexto['erro_api'] = buscar_cotacoes()
    return render(request, 'modulos/detalhe.html', contexto)
