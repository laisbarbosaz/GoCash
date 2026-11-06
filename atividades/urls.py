from django.urls import path

from . import views

urlpatterns = [
    path('', views.listar_atividades, name='listar_atividades'),
    path('<slug:slug>/', views.responder_atividade, name='responder_atividade'),
    path('<slug:slug>/resultado/<int:numero>/', views.resultado_atividade, name='resultado_atividade'),
]
