from django.shortcuts import render, get_object_or_404
from .models import Modulo


def listar_modulos(request):
    modulos = Modulo.objects.all().order_by('nome_modulo')
    return render(request, 'modulos/lista.html', {'modulos': modulos})


def detalhe_modulo(request, slug):
    modulo = get_object_or_404(Modulo, slug=slug)
    return render(request, 'modulos/detalhe.html', {'modulo': modulo})
