from django.urls import path
from . import views

urlpatterns = [
    path('', views.pagina_inicial, name='pagina_inicial'),
    path('quem-somos/', views.quem_somos, name='quem_somos'),
]