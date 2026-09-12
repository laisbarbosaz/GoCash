from django.urls import path
from . import views

urlpatterns = [
    path('', views.listar_modulos, name='listar_modulos'),
    path('<int:modulo_id>/', views.detalhe_modulo, name='detalhe_modulo'),
]