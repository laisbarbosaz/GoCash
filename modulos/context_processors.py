from .models import Modulo

def modulos_menu(request):
    return {
        'modulos_menu': Modulo.objects.all().order_by('nome_modulo')
    }