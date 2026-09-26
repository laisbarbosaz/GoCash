import random
from datetime import timedelta

from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone


class PerfilUsuario(models.Model):
    ADMIN = 'admin'
    ALUNO = 'aluno'
    TIPO_USUARIO_CHOICES = [
        (ADMIN, 'Administrador'),
        (ALUNO, 'Aluno'),
    ]

    usuario = models.OneToOneField(User, on_delete=models.CASCADE, related_name='perfil')
    tipo_usuario = models.CharField(max_length=10, choices=TIPO_USUARIO_CHOICES, default=ALUNO)
    aceitou_termos = models.BooleanField(default=False)
    data_aceite_termos = models.DateTimeField(null=True, blank=True)

    def registrar_aceite(self):
        self.aceitou_termos = True
        self.data_aceite_termos = timezone.now()
        self.save()

    def __str__(self):
        return f"{self.usuario.username} ({self.get_tipo_usuario_display()})"


class CodigoVerificacao(models.Model):
    usuario = models.ForeignKey(User, on_delete=models.CASCADE, related_name='codigos_verificacao')
    codigo = models.CharField(max_length=6)
    criado_em = models.DateTimeField(auto_now_add=True)
    usado = models.BooleanField(default=False)

    MINUTOS_VALIDADE = 5

    def esta_valido(self):
        expira_em = self.criado_em + timedelta(minutes=self.MINUTOS_VALIDADE)
        return (not self.usado) and timezone.now() <= expira_em

    @staticmethod
    def gerar_codigo():
        return f"{random.randint(0, 999999):06d}"

    def __str__(self):
        return f"{self.usuario.username} - {self.codigo}"