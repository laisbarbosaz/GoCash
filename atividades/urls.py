from django.urls import path

from . import views

# Os endereços usam o nome do módulo (slug) e o número da tentativa do próprio aluno (1 a 3),
# nunca o id do banco. Ex.: /atividades/controles-e-dividas/resultado/2/
urlpatterns = [
    path('', views.listar_atividades, name='listar_atividades'),
    path('<slug:slug>/', views.responder_atividade, name='responder_atividade'),
    path('<slug:slug>/resultado/<int:numero>/', views.resultado_atividade, name='resultado_atividade'),
]
