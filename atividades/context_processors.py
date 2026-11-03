from .cashs import saldo_de_cashs


def cashs_usuario(request):
    """Deixa o saldo de Cashs disponível em todas as páginas (usado no menu do base.html)."""
    if request.user.is_authenticated:
        return {'cashs_usuario': saldo_de_cashs(request.user)}
    return {}
