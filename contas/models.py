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