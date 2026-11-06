from functools import wraps

from django.contrib import messages
from django.contrib.auth.views import redirect_to_login
from django.db import IntegrityError, transaction
from django.shortcuts import get_object_or_404, redirect, render

from .models import Atividade, ProgressoAtividade, Resposta, Tentativa


def login_obrigatorio(view):
    @wraps(view)
    def _view(request, *args, **kwargs):
        if not request.user.is_authenticated:
            messages.info(request, "Faça login para acessar as atividades.")
            return redirect_to_login(request.get_full_path())
        return view(request, *args, **kwargs)

    return _view


@login_obrigatorio
def listar_atividades(request):
    atividades = (
        Atividade.objects
        .select_related('modulo')
        .prefetch_related('perguntas__alternativas')
    )

    tentativas_por_atividade = {}
    for tentativa in Tentativa.objects.filter(usuario=request.user):
        tentativas_por_atividade.setdefault(tentativa.atividade_id, []).append(tentativa)

    status_por_atividade = dict(
        ProgressoAtividade.objects.filter(usuario=request.user).values_list('atividade_id', 'status')
    )

    itens = []
    for atividade in atividades:
        perguntas = atividade.perguntas_validas()
        if not perguntas:
            continue

        feitas = tentativas_por_atividade.get(atividade.id, [])
        itens.append({
            'atividade': atividade,
            'qtd_perguntas': len(perguntas),
            'tentativas_feitas': len(feitas),
            'restantes': max(0, Atividade.MAX_TENTATIVAS - len(feitas)),
            'melhor_aproveitamento': max((t.aproveitamento for t in feitas), default=None),
            'ultima_tentativa': feitas[0] if feitas else None,
            'status': status_por_atividade.get(atividade.id, ProgressoAtividade.NAO_INICIADA),
        })

    return render(request, 'atividades/lista.html', {
        'itens': itens,
        'max_tentativas': Atividade.MAX_TENTATIVAS,
    })


@login_obrigatorio
def responder_atividade(request, slug):
    atividade = get_object_or_404(
        Atividade.objects.select_related('modulo').prefetch_related('perguntas__alternativas'),
        modulo__slug=slug,
    )
    perguntas = atividade.perguntas_validas()

    if not perguntas:
        messages.warning(request, "Esta atividade ainda não tem perguntas disponíveis.")
        return redirect('listar_atividades')

    tentativas_feitas = Tentativa.objects.filter(usuario=request.user, atividade=atividade).count()
    if tentativas_feitas >= Atividade.MAX_TENTATIVAS:
        messages.warning(
            request,
            f"Você já usou as {Atividade.MAX_TENTATIVAS} tentativas desta atividade.",
        )
        return redirect('listar_atividades')

    if request.method == 'POST':
        marcadas = {}
        faltando = False

        for pergunta in perguntas:
            valor = request.POST.get(f'pergunta_{pergunta.id}')
            alternativa = next((a for a in pergunta.alternativas.all() if str(a.id) == valor), None)
            pergunta.marcada_id = alternativa.id if alternativa else None
            pergunta.sem_resposta = alternativa is None
            if alternativa is None:
                faltando = True
            else:
                marcadas[pergunta.id] = alternativa

        if faltando:
            messages.error(request, "Responda todas as perguntas antes de enviar.")
        else:
            acertos = sum(1 for alternativa in marcadas.values() if alternativa.correta)
            try:
                with transaction.atomic():
                    tentativa = Tentativa.objects.create(
                        usuario=request.user,
                        atividade=atividade,
                        numero=tentativas_feitas + 1,
                        acertos=acertos,
                        total_perguntas=len(perguntas),
                    )
                    Resposta.objects.bulk_create([
                        Resposta(
                            tentativa=tentativa,
                            pergunta=pergunta,
                            alternativa=marcadas[pergunta.id],
                            correta=marcadas[pergunta.id].correta,
                        )
                        for pergunta in perguntas
                    ])
            except IntegrityError:
                messages.warning(request, "Essa tentativa já tinha sido registrada.")
                return redirect('listar_atividades')

            progresso, _ = ProgressoAtividade.objects.get_or_create(usuario=request.user, atividade=atividade)
            progresso.marcar_concluida()
            return redirect('resultado_atividade', slug=slug, numero=tentativa.numero)
    else:
        ProgressoAtividade.objects.get_or_create(usuario=request.user, atividade=atividade)

    return render(request, 'atividades/responder.html', {
        'atividade': atividade,
        'perguntas': perguntas,
        'numero_tentativa': tentativas_feitas + 1,
        'max_tentativas': Atividade.MAX_TENTATIVAS,
    })


@login_obrigatorio
def resultado_atividade(request, slug, numero):
    tentativa = get_object_or_404(
        Tentativa.objects.select_related('atividade__modulo'),
        atividade__modulo__slug=slug,
        numero=numero,
        usuario=request.user,
    )
    respostas = tentativa.respostas.select_related('pergunta', 'alternativa')

    tentativas_feitas = Tentativa.objects.filter(usuario=request.user, atividade=tentativa.atividade).count()
    restantes = max(0, Atividade.MAX_TENTATIVAS - tentativas_feitas)

    return render(request, 'atividades/resultado.html', {
        'tentativa': tentativa,
        'atividade': tentativa.atividade,
        'respostas': respostas,
        'restantes': restantes,
        'max_tentativas': Atividade.MAX_TENTATIVAS,
        'mostrar_gabarito': restantes == 0,
    })
