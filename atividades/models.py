from django.conf import settings
from django.db import models

from modulos.models import Modulo


class Atividade(models.Model):
    """Quiz de um módulo. Cada módulo tem no máximo uma atividade."""

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
        """Perguntas prontas para uso: pelo menos 2 alternativas e exatamente 1 correta."""
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
    ordem = models.PositiveIntegerField('Ordem', default=1)

    class Meta:
        verbose_name = 'Pergunta'
        verbose_name_plural = 'Perguntas das Atividades'
        ordering = ['ordem', 'id']

    def __str__(self):
        resumo = self.enunciado if len(self.enunciado) <= 60 else self.enunciado[:57] + '...'
        return f"{self.ordem}. {resumo}"

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
    """Cada vez que o usuário envia as respostas de uma atividade."""

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
        """Percentual de acertos (RF05 - RN02). Ex.: 7 de 10 = 70."""
        if not self.total_perguntas:
            return 0
        return round(self.acertos * 100 / self.total_perguntas)


class AtividadeAberta(models.Model):
    """Marca que o usuário abriu a tela de responder, mas ainda não enviou essa tentativa.
    É apagada assim que a tentativa correspondente é enviada (vira um registro em Tentativa)."""

    usuario = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='atividades_abertas',
        verbose_name='Usuário',
    )
    atividade = models.ForeignKey(
        Atividade,
        on_delete=models.CASCADE,
        related_name='aberturas',
        verbose_name='Atividade',
    )
    numero = models.PositiveSmallIntegerField('Nº da tentativa')
    aberta_em = models.DateTimeField('Aberta em', auto_now_add=True)

    class Meta:
        verbose_name = 'Atividade em andamento'
        verbose_name_plural = 'Atividades em andamento'
        constraints = [
            models.UniqueConstraint(
                fields=['usuario', 'atividade', 'numero'],
                name='abertura_unica_por_numero',
            ),
        ]

    def __str__(self):
        return f"{self.usuario} - {self.atividade.titulo} - tentativa {self.numero} em andamento"


class Resposta(models.Model):
    """A alternativa que o usuário marcou em cada pergunta de uma tentativa."""

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
        ordering = ['pergunta__ordem', 'pergunta__id']

    def __str__(self):
        return f"{self.pergunta} -> {self.alternativa}"
