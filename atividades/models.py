from django.conf import settings
from django.db import models
from django.utils import timezone

from modulos.models import Modulo


class Atividade(models.Model):
    MAX_TENTATIVAS = 3

    modulo = models.OneToOneField(
        Modulo,
        on_delete=models.CASCADE,
        related_name='atividade',
        verbose_name='Módulo',
    )
    titulo = models.CharField('Título', max_length=150)
    descricao = models.TextField('Descrição', blank=True)

    class Meta:
        verbose_name = 'Atividade'
        verbose_name_plural = 'Atividades dos Módulos'
        ordering = ['modulo__nome_modulo']

    def __str__(self):
        return f"{self.titulo} ({self.modulo})"

    def perguntas_validas(self):
        validas = []
        for pergunta in self.perguntas.all():
            alternativas = list(pergunta.alternativas.all())
            corretas = [a for a in alternativas if a.correta]
            if len(alternativas) >= 2 and len(corretas) == 1:
                validas.append(pergunta)
        return validas


class Pergunta(models.Model):
    atividade = models.ForeignKey(
        Atividade,
        on_delete=models.CASCADE,
        related_name='perguntas',
        verbose_name='Atividade',
    )
    enunciado = models.TextField('Enunciado')

    class Meta:
        verbose_name = 'Pergunta'
        verbose_name_plural = 'Perguntas das Atividades'
        ordering = ['id']

    def __str__(self):
        return self.enunciado if len(self.enunciado) <= 60 else self.enunciado[:57] + '...'

    def alternativa_correta(self):
        return self.alternativas.filter(correta=True).first()


class Alternativa(models.Model):
    pergunta = models.ForeignKey(
        Pergunta,
        on_delete=models.CASCADE,
        related_name='alternativas',
        verbose_name='Pergunta',
    )
    texto = models.CharField('Texto', max_length=255)
    correta = models.BooleanField('Correta', default=False)

    class Meta:
        verbose_name = 'Alternativa'
        verbose_name_plural = 'Alternativas'
        ordering = ['id']

    def __str__(self):
        return self.texto


class Tentativa(models.Model):
    usuario = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='tentativas_atividades',
        verbose_name='Usuário',
    )
    atividade = models.ForeignKey(
        Atividade,
        on_delete=models.CASCADE,
        related_name='tentativas',
        verbose_name='Atividade',
    )
    numero = models.PositiveSmallIntegerField('Nº da tentativa')
    acertos = models.PositiveIntegerField('Acertos')
    total_perguntas = models.PositiveIntegerField('Total de perguntas')
    realizada_em = models.DateTimeField('Realizada em', auto_now_add=True)

    class Meta:
        verbose_name = 'Tentativa'
        verbose_name_plural = 'Tentativas dos Usuários'
        ordering = ['-realizada_em', '-id']
        constraints = [
            models.UniqueConstraint(
                fields=['usuario', 'atividade', 'numero'],
                name='tentativa_unica_por_numero',
            ),
        ]

    def __str__(self):
        return f"{self.usuario} - {self.atividade.titulo} - tentativa {self.numero}"

    @property
    def aproveitamento(self):
        if not self.total_perguntas:
            return 0
        return round(self.acertos * 100 / self.total_perguntas)


class ProgressoAtividade(models.Model):
    EM_ANDAMENTO = 'em_andamento'
    CONCLUIDA = 'concluida'
    NAO_INICIADA = 'nao_iniciada'
    STATUS_CHOICES = [
        (EM_ANDAMENTO, 'Em andamento'),
        (CONCLUIDA, 'Concluída'),
    ]
    ROTULOS = {
        EM_ANDAMENTO: 'Em andamento',
        CONCLUIDA: 'Concluída',
        NAO_INICIADA: 'Não iniciado',
    }

    usuario = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='progressos_atividades',
        verbose_name='Aluno',
    )
    atividade = models.ForeignKey(
        Atividade,
        on_delete=models.CASCADE,
        related_name='progressos',
        verbose_name='Atividade',
    )
    status = models.CharField('Status', max_length=15, choices=STATUS_CHOICES, default=EM_ANDAMENTO)
    iniciada_em = models.DateTimeField('Começou em', default=timezone.now)
    concluida_em = models.DateTimeField('Concluiu em', null=True, blank=True)

    class Meta:
        verbose_name = 'Progresso na atividade'
        verbose_name_plural = 'Progresso nas atividades'
        ordering = ['atividade__modulo__nome_modulo', 'usuario__username']
        constraints = [
            models.UniqueConstraint(
                fields=['usuario', 'atividade'],
                name='progresso_unico_por_aluno_e_atividade',
            ),
        ]

    def __str__(self):
        return f"{self.usuario} - {self.atividade.titulo} - {self.get_status_display()}"

    def marcar_concluida(self):
        if self.status != self.CONCLUIDA:
            self.status = self.CONCLUIDA
            self.concluida_em = timezone.now()
            self.save(update_fields=['status', 'concluida_em'])


class Resposta(models.Model):
    tentativa = models.ForeignKey(
        Tentativa,
        on_delete=models.CASCADE,
        related_name='respostas',
        verbose_name='Tentativa',
    )
    pergunta = models.ForeignKey(Pergunta, on_delete=models.CASCADE, verbose_name='Pergunta')
    alternativa = models.ForeignKey(Alternativa, on_delete=models.CASCADE, verbose_name='Alternativa marcada')
    correta = models.BooleanField('Acertou?')

    class Meta:
        verbose_name = 'Resposta'
        verbose_name_plural = 'Respostas'
        ordering = ['pergunta__id']

    def __str__(self):
        return f"{self.pergunta} -> {self.alternativa}"
