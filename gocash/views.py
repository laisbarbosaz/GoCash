from datetime import timedelta

from django.contrib import admin
from django.contrib.admin.models import ADDITION, CHANGE, DELETION, LogEntry
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.core.exceptions import PermissionDenied
from django.core.paginator import Paginator
from django.db.models import Count, Max, Q
from django.shortcuts import render
from django.utils import timezone

VERBOS = {ADDITION: 'adicionou', CHANGE: 'alterou', DELETION: 'excluiu'}
ROTULOS = {ADDITION: 'Adição', CHANGE: 'Alteração', DELETION: 'Exclusão'}
PERIODOS = {'7': 7, '30': 30, '90': 90}


def _so_superusuario(request):
    if not request.user.is_superuser:
        raise PermissionDenied


def _contexto(request, titulo):
    return {**admin.site.each_context(request), 'title': titulo}


def _area(registro):
    if not registro.content_type:
        return '-'
    modelo = registro.content_type.model_class()
    if modelo is None:
        return registro.content_type.name
    return f"{modelo._meta.app_config.verbose_name} › {modelo._meta.verbose_name}"


def _descrever(registro):
    return {
        'quando': registro.action_time,
        'usuario': registro.user,
        'verbo': VERBOS.get(registro.action_flag, 'mexeu em'),
        'acao': ROTULOS.get(registro.action_flag, '-'),
        'area': _area(registro),
        'objeto': registro.object_repr,
        'mudancas': registro.get_change_message() or '-',
    }


@login_required
def logs_view(request):
    _so_superusuario(request)
    inicio = timezone.now() - timedelta(days=30)
    recentes = LogEntry.objects.filter(action_time__gte=inicio)

    por_tipo = dict(recentes.values_list('action_flag').annotate(total=Count('id')))
    por_usuario = (
        recentes.values('user__username', 'user__first_name', 'user__last_name')
        .annotate(total=Count('id'), ultima=Max('action_time'))
        .order_by('-total')
    )
    por_area = {}
    for registro in recentes.select_related('content_type'):
        area = _area(registro)
        por_area[area] = por_area.get(area, 0) + 1

    ultimas = LogEntry.objects.select_related('user', 'content_type').order_by('-action_time')[:10]

    return render(request, 'logs.html', {
        **_contexto(request, 'Logs de auditoria'),
        'total': recentes.count(),
        'adicoes': por_tipo.get(ADDITION, 0),
        'alteracoes': por_tipo.get(CHANGE, 0),
        'exclusoes': por_tipo.get(DELETION, 0),
        'por_usuario': por_usuario,
        'por_area': sorted(por_area.items(), key=lambda item: -item[1]),
        'ultimas': [_descrever(registro) for registro in ultimas],
    })


@login_required
def logs_detalhados(request):
    _so_superusuario(request)
    registros = LogEntry.objects.select_related('user', 'content_type').order_by('-action_time')

    usuario = request.GET.get('usuario', '')
    acao = request.GET.get('acao', '')
    periodo = request.GET.get('periodo', '')
    busca = request.GET.get('busca', '').strip()

    if usuario:
        registros = registros.filter(user__username=usuario)
    if acao in {str(ADDITION), str(CHANGE), str(DELETION)}:
        registros = registros.filter(action_flag=int(acao))
    if periodo in PERIODOS:
        registros = registros.filter(action_time__gte=timezone.now() - timedelta(days=PERIODOS[periodo]))
    if busca:
        registros = registros.filter(Q(object_repr__icontains=busca) | Q(change_message__icontains=busca))

    pagina = Paginator(registros, 50).get_page(request.GET.get('pagina'))
    filtros = request.GET.copy()
    filtros.pop('pagina', None)

    return render(request, 'logs_lista.html', {
        **_contexto(request, 'Lista completa dos logs'),
        'pagina': pagina,
        'linhas': [_descrever(registro) for registro in pagina],
        'usuarios': User.objects.filter(logentry__isnull=False).distinct().order_by('username'),
        'filtros': filtros.urlencode(),
        'usuario': usuario,
        'acao': acao,
        'periodo': periodo,
        'busca': busca,
        'acoes': list(ROTULOS.items()),
    })
