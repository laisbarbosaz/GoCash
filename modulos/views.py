from django.shortcuts import get_object_or_404, render

<<<<<<< HEAD
from home.cotacoes import SLUG_DO_MODULO, buscar_cotacoes
=======
from home.cotacoes import buscar_cotacoes
>>>>>>> 590b5c549d2da81969b5f9e3bacb31f9dc6b298f

from .models import Modulo


def listar_modulos(request):
    modulos = Modulo.objects.all().order_by('nome_modulo')
    return render(request, 'modulos/lista.html', {'modulos': modulos})


def detalhe_modulo(request, slug):
    modulo = get_object_or_404(Modulo, slug=slug)
<<<<<<< HEAD
    contexto = {'modulo': modulo, 'mostrar_cotacoes': modulo.slug == SLUG_DO_MODULO}
    if contexto['mostrar_cotacoes']:
=======
    contexto = {'modulo': modulo}
    if modulo.mostrar_cotacoes:
>>>>>>> 590b5c549d2da81969b5f9e3bacb31f9dc6b298f
        contexto['cotacoes'], contexto['erro_api'] = buscar_cotacoes()
    return render(request, 'modulos/detalhe.html', contexto)
