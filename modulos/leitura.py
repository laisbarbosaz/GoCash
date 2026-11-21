from .models import ConteudoModulo, LeituraConteudo

CHAVE_SESSAO = 'conteudos_lidos'


def partes_do_modulo(modulo):
    return list(modulo.conteudos.order_by('id'))


def ids_lidos(request, partes):
    ids = [parte.id for parte in partes]
    if request.user.is_authenticated:
        return set(
            LeituraConteudo.objects.filter(usuario=request.user, conteudo_id__in=ids)
            .values_list('conteudo_id', flat=True)
        )
    return set(request.session.get(CHAVE_SESSAO, [])) & set(ids)


def marcar_como_lido(request, conteudo):
    if request.user.is_authenticated:
        LeituraConteudo.objects.get_or_create(usuario=request.user, conteudo=conteudo)
        return
    lidos = request.session.get(CHAVE_SESSAO, [])
    if conteudo.id not in lidos:
        request.session[CHAVE_SESSAO] = lidos + [conteudo.id]


def leu_tudo(usuario, modulo):
    total = modulo.conteudos.count()
    if not total:
        return True
    lidas = LeituraConteudo.objects.filter(usuario=usuario, conteudo__modulo=modulo).count()
    return lidas >= total


def primeira_parte_nao_lida(usuario, modulo):
    lidas = set(
        LeituraConteudo.objects.filter(usuario=usuario, conteudo__modulo=modulo)
        .values_list('conteudo_id', flat=True)
    )
    for numero, parte in enumerate(partes_do_modulo(modulo), start=1):
        if parte.id not in lidas:
            return numero
    return 1


def guardar_leituras_da_sessao(request, usuario):
    ids = request.session.pop(CHAVE_SESSAO, [])
    if not ids:
        return
    existentes = set(
        LeituraConteudo.objects.filter(usuario=usuario, conteudo_id__in=ids).values_list('conteudo_id', flat=True)
    )
    validos = ConteudoModulo.objects.filter(id__in=ids).exclude(id__in=existentes).values_list('id', flat=True)
    LeituraConteudo.objects.bulk_create(
        [LeituraConteudo(usuario=usuario, conteudo_id=conteudo_id) for conteudo_id in validos],
        ignore_conflicts=True,
    )
