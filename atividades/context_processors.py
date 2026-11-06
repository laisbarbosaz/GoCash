from .cashs import saldo_de_cashs


def cashs_usuario(request):
    if request.user.is_authenticated:
        return {'cashs_usuario': saldo_de_cashs(request.user)}
    return {}
