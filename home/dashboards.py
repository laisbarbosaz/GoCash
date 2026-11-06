from collections import defaultdict

from django.contrib.auth.models import User
from django.db.models import Count
from django.utils import timezone

from atividades.cashs import cashs_da_nota, melhores_notas, saldo_de_cashs
from atividades.models import Atividade, ProgressoAtividade, Resposta, Tentativa
from contas.models import ConviteEducador, PerfilUsuario

MESES = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez']


def _atividades_disponiveis():
    atividades = (
        Atividade.objects
        .select_related('modulo')
        .prefetch_related('perguntas__alternativas')
        .order_by('modulo__nome_modulo')
    )
    return [atividade for atividade in atividades if atividade.perguntas_validas()]


def _altura(quantidade):
    return max(140, 44 * quantidade + 50)


def minhas_atividades(usuario):
    atividades = _atividades_disponiveis()
    notas = melhores_notas(usuario)
    status = dict(
        ProgressoAtividade.objects.filter(usuario=usuario).values_list('atividade_id', 'status')
    )
    tentativas = defaultdict(int)
    for atividade_id in Tentativa.objects.filter(usuario=usuario).values_list('atividade_id', flat=True):
        tentativas[atividade_id] += 1

    linhas = []
    for atividade in atividades:
        feitas = tentativas.get(atividade.id, 0)
        situacao = status.get(atividade.id, ProgressoAtividade.NAO_INICIADA)
        nota = notas.get(atividade.id)
        linhas.append({
            'atividade': atividade,
            'modulo': atividade.modulo,
            'situacao': situacao,
            'situacao_exibida': ProgressoAtividade.ROTULOS[situacao],
            'tentativas': feitas,
            'pode_tentar': feitas < Atividade.MAX_TENTATIVAS,
            'cashs': cashs_da_nota(nota) if nota is not None else 0,
        })

    erros = (
        Resposta.objects
        .filter(tentativa__usuario=usuario, correta=False, pergunta__atividade__in=atividades)
        .values('pergunta_id', 'pergunta__enunciado', 'pergunta__atividade__modulo__nome_modulo', 'pergunta__atividade__modulo__slug')
        .annotate(vezes=Count('id'))
        .order_by('-vezes', 'pergunta__atividade__modulo__nome_modulo', 'pergunta_id')[:3]
    )
    dificuldades = [
        {
            'enunciado': erro['pergunta__enunciado'],
            'modulo': erro['pergunta__atividade__modulo__nome_modulo'],
            'slug': erro['pergunta__atividade__modulo__slug'],
            'vezes': erro['vezes'],
        }
        for erro in erros
    ]

    return {
        'cashs': saldo_de_cashs(usuario),
        'concluidas': sum(1 for linha in linhas if linha['situacao'] == ProgressoAtividade.CONCLUIDA),
        'em_andamento': sum(1 for linha in linhas if linha['situacao'] == ProgressoAtividade.EM_ANDAMENTO),
        'total_atividades': len(linhas),
        'tentativas': sum(tentativas.values()),
        'linhas': linhas,
        'dificuldades': dificuldades,
        'max_tentativas': Atividade.MAX_TENTATIVAS,
    }


def _nome_publico(usuario):
    if usuario.first_name:
        inicial = f" {usuario.last_name.strip()[:1]}." if usuario.last_name.strip() else ''
        return f"{usuario.first_name.strip()}{inicial}"
    return usuario.username


def ranking(usuario=None, limite=10):
    participantes = {
        participante.pk: participante
        for participante in User.objects.filter(
            is_active=True,
            perfil__tipo_usuario=PerfilUsuario.ALUNO,
            perfil__aparecer_no_ranking=True,
        )
    }

    melhores = {}
    for usuario_id, atividade_id, acertos, total in Tentativa.objects.filter(
        usuario_id__in=participantes
    ).values_list('usuario_id', 'atividade_id', 'acertos', 'total_perguntas'):
        nota = round(acertos * 100 / total) if total else 0
        chave = (usuario_id, atividade_id)
        melhores[chave] = max(melhores.get(chave, 0), nota)

    cashs = defaultdict(int)
    for (usuario_id, _), nota in melhores.items():
        cashs[usuario_id] += cashs_da_nota(nota)

    concluidas = defaultdict(int)
    for usuario_id in ProgressoAtividade.objects.filter(
        usuario_id__in=participantes, status=ProgressoAtividade.CONCLUIDA
    ).values_list('usuario_id', flat=True):
        concluidas[usuario_id] += 1

    ordenados = sorted(
        (usuario_id for usuario_id in participantes if cashs[usuario_id] > 0),
        key=lambda usuario_id: (-cashs[usuario_id], -concluidas[usuario_id], participantes[usuario_id].username),
    )

    linhas = []
    posicao = 0
    anterior = None
    for indice, usuario_id in enumerate(ordenados, start=1):
        if cashs[usuario_id] != anterior:
            posicao = indice
            anterior = cashs[usuario_id]
        participante = participantes[usuario_id]
        linhas.append({
            'posicao': posicao,
            'nome': _nome_publico(participante),
            'usuario': participante.username,
            'cashs': cashs[usuario_id],
            'concluidas': concluidas[usuario_id],
            'eu': usuario is not None and usuario.pk == usuario_id,
        })

    minha_linha = None
    if usuario is not None and usuario.is_authenticated:
        minha_linha = next((linha for linha in linhas if linha['eu']), None)

    return {
        'linhas': linhas[:limite],
        'minha_linha': minha_linha,
        'fora_do_top': minha_linha is not None and minha_linha not in linhas[:limite],
    }


def _alunos_ativos_ids():
    return list(
        User.objects.filter(is_active=True, perfil__tipo_usuario=PerfilUsuario.ALUNO).values_list('id', flat=True)
    )


def painel_educador():
    atividades = _atividades_disponiveis()
    alunos_ids = _alunos_ativos_ids()

    status_por_atividade = defaultdict(dict)
    progressos = ProgressoAtividade.objects.filter(usuario_id__in=alunos_ids).values_list(
        'atividade_id', 'usuario_id', 'status'
    )
    for atividade_id, usuario_id, status in progressos:
        status_por_atividade[atividade_id][usuario_id] = status

    melhores = {}
    tentativas = Tentativa.objects.filter(usuario_id__in=alunos_ids).only(
        'usuario_id', 'atividade_id', 'acertos', 'total_perguntas'
    )
    for tentativa in tentativas:
        chave = (tentativa.atividade_id, tentativa.usuario_id)
        melhores[chave] = max(melhores.get(chave, 0), tentativa.aproveitamento)

    modulos = []
    for atividade in atividades:
        situacoes = status_por_atividade.get(atividade.id, {}).values()
        concluiram = sum(1 for s in situacoes if s == ProgressoAtividade.CONCLUIDA)
        em_andamento = sum(1 for s in situacoes if s == ProgressoAtividade.EM_ANDAMENTO)
        modulos.append({
            'modulo': atividade.modulo.nome_modulo,
            'concluiram': concluiram,
            'em_andamento': em_andamento,
            'nao_iniciaram': len(alunos_ids) - concluiram - em_andamento,
            'cashs': sum(cashs_da_nota(nota) for (aid, _), nota in melhores.items() if aid == atividade.id),
        })

    possiveis = len(alunos_ids) * len(atividades)
    concluidas = sum(m['concluiram'] for m in modulos)

    return {
        'alunos': len(alunos_ids),
        'atividades': len(atividades),
        'taxa_conclusao': round(concluidas * 100 / possiveis) if possiveis else None,
        'cashs_total': sum(m['cashs'] for m in modulos),
        'modulos': modulos,
        'altura_grafico': _altura(len(modulos)),
        'grafico_conclusao': {
            'rotulos': [m['modulo'] for m in modulos],
            'concluiram': [m['concluiram'] for m in modulos],
            'em_andamento': [m['em_andamento'] for m in modulos],
            'nao_iniciaram': [m['nao_iniciaram'] for m in modulos],
        },
        'grafico_cashs': {
            'rotulos': [m['modulo'] for m in modulos],
            'valores': [m['cashs'] for m in modulos],
        },
    }


def _ultimos_meses(quantidade):
    agora = timezone.localtime()
    ano, mes = agora.year, agora.month
    meses = []
    for _ in range(quantidade):
        meses.append((ano, mes))
        mes -= 1
        if mes == 0:
            mes = 12
            ano -= 1
    meses.reverse()
    inicio = agora.replace(year=meses[0][0], month=meses[0][1], day=1, hour=0, minute=0, second=0, microsecond=0)
    return meses, inicio


def painel_administrador():
    painel = painel_educador()

    meses, inicio = _ultimos_meses(6)
    cadastros = {mes: 0 for mes in meses}
    for data in User.objects.filter(date_joined__gte=inicio).values_list('date_joined', flat=True):
        local = timezone.localtime(data)
        chave = (local.year, local.month)
        if chave in cadastros:
            cadastros[chave] += 1

    painel.update({
        'educadores': User.objects.filter(is_active=True, perfil__tipo_usuario=PerfilUsuario.EDUCADOR).count(),
        'convites_pendentes': ConviteEducador.objects.filter(
            usado_em__isnull=True, expira_em__gte=timezone.now()
        ).count(),
        'contas_inativas': User.objects.filter(is_active=False).count(),
        'linhas_cadastros': [
            {'mes': f"{MESES[mes - 1]}/{str(ano)[2:]}", 'quantidade': cadastros[(ano, mes)]}
            for ano, mes in meses
        ],
    })
    painel['grafico_cadastros'] = {
        'rotulos': [linha['mes'] for linha in painel['linhas_cadastros']],
        'valores': [linha['quantidade'] for linha in painel['linhas_cadastros']],
    }
    return painel
