import random
import secrets
from datetime import timedelta

from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone


def nome_e_usuario(usuario):
    nome = usuario.get_full_name()
    return f"{nome} ({usuario.username})" if nome else usuario.username


class PerfilUsuario(models.Model):
    ALUNO = 'aluno'
    EDUCADOR = 'educador'
    ADMINISTRADOR = 'administrador'
    TIPO_USUARIO_CHOICES = [
        (ALUNO, 'Aluno'),
        (EDUCADOR, 'Educador'),
        (ADMINISTRADOR, 'Administrador'),
    ]

    usuario = models.OneToOneField(User, on_delete=models.CASCADE, related_name='perfil')
    tipo_usuario = models.CharField('Perfil', max_length=15, choices=TIPO_USUARIO_CHOICES, default=ALUNO)
    administrador_principal = models.BooleanField('Administrador principal', default=False)
    aparecer_no_ranking = models.BooleanField('Aparecer no ranking', default=False)
    aceitou_termos = models.BooleanField(default=False)
    data_aceite_termos = models.DateTimeField(null=True, blank=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['administrador_principal'],
                condition=models.Q(administrador_principal=True),
                name='apenas_um_administrador_principal',
            ),
        ]

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


LETRAS_DO_CONVITE = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
DIAS_VALIDADE_CONVITE = 2


def gerar_codigo_convite():
    return ''.join(secrets.choice(LETRAS_DO_CONVITE) for _ in range(8))


def validade_do_convite():
    return timezone.now() + timedelta(days=DIAS_VALIDADE_CONVITE)


class ConviteEducador(models.Model):
    PENDENTE = 'Aguardando cadastro'
    USADO = 'Usado'
    VENCIDO = 'Vencido'

    email = models.EmailField('E-mail do educador')
    codigo = models.CharField('Código', max_length=8, unique=True, default=gerar_codigo_convite, editable=False)
    criado_em = models.DateTimeField('Enviado em', auto_now_add=True)
    expira_em = models.DateTimeField('Vale até', default=validade_do_convite, editable=False)
    criado_por = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='convites_enviados',
        verbose_name='Enviado por',
    )
    usado_em = models.DateTimeField('Usado em', null=True, blank=True, editable=False)
    usado_por = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='+',
        verbose_name='Conta criada',
        editable=False,
    )

    class Meta:
        verbose_name = 'Convite de educador'
        verbose_name_plural = 'Convites de educador'
        ordering = ['-criado_em']

    def __str__(self):
        return f"{self.email} - {self.situacao}"

    @property
    def situacao(self):
        if self.usado_em:
            return self.USADO
        if timezone.now() > self.expira_em:
            return self.VENCIDO
        return self.PENDENTE

    def esta_valido(self):
        return self.situacao == self.PENDENTE

    def renovar(self):
        self.codigo = gerar_codigo_convite()
        self.expira_em = validade_do_convite()
        self.save(update_fields=['codigo', 'expira_em'])


class ConfiguracaoSite(models.Model):
    exigir_mfa = models.BooleanField(
        'Exigir código por e-mail no login',
        default=True,
        help_text='Quando desligado, todos os usuários entram só com usuário e senha.',
    )
    atualizada_em = models.DateTimeField('Última alteração', auto_now=True)
    atualizada_por = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='+',
        verbose_name='Alterada por',
    )

    class Meta:
        verbose_name = 'Configuração do site'
        verbose_name_plural = 'Configurações do site'

    def __str__(self):
        return 'Configurações do site'

    def save(self, *args, **kwargs):
        self.pk = 1
        super().save(*args, **kwargs)

    @classmethod
    def atual(cls):
        configuracao, _ = cls.objects.get_or_create(pk=1)
        return configuracao
