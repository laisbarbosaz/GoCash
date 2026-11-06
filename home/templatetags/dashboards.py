from django import template

from home.dashboards import minhas_atividades, painel_administrador, painel_educador, ranking

register = template.Library()


@register.inclusion_tag('home/dashboards/minhas_atividades.html')
def dashboard_aluno(usuario):
    return {'usuario': usuario, 'painel': minhas_atividades(usuario)}


@register.inclusion_tag('home/dashboards/ranking.html')
def ranking_alunos(usuario):
    aluno = usuario.is_authenticated and not usuario.is_staff
    perfil = getattr(usuario, 'perfil', None) if aluno else None
    return {
        'usuario': usuario,
        'aluno': aluno,
        'participa': bool(perfil and perfil.aparecer_no_ranking),
        'ranking': ranking(usuario if aluno else None),
    }


@register.inclusion_tag('home/dashboards/equipe.html')
def dashboard_equipe(usuario):
    if usuario.is_superuser:
        return {'usuario': usuario, 'administrador': True, 'painel': painel_administrador()}
    return {'usuario': usuario, 'administrador': False, 'painel': painel_educador()}
