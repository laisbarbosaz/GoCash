from django.db import models
from django.utils.text import slugify


class Modulo(models.Model):
    nome_modulo = models.CharField(max_length=100)
    descricao_modulo = models.TextField()
    slug = models.SlugField(
        'Endereço na URL',
        max_length=110,
        unique=True,
        null=True,
        blank=True,
    )

    class Meta:
        verbose_name = "Módulo"
        verbose_name_plural = "Módulos de Aprendizagem"

    def __str__(self):
        return self.nome_modulo

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = self._gerar_slug_unico()
        super().save(*args, **kwargs)

    def _gerar_slug_unico(self):
        base = slugify(self.nome_modulo)[:100] or 'modulo'
        slug = base
        numero = 2
        while Modulo.objects.filter(slug=slug).exclude(pk=self.pk).exists():
            slug = f'{base}-{numero}'
            numero += 1
        return slug


class ConteudoModulo(models.Model):
    modulo = models.ForeignKey(Modulo, on_delete=models.CASCADE, related_name='conteudos')
    titulo_conteudo = models.CharField(max_length=150)
    explicacao_conteudo = models.TextField()

    class Meta:
        verbose_name = "Conteúdo"
        verbose_name_plural = "Conteúdos dos Módulos"

    def __str__(self):
        return self.titulo_conteudo


class LeituraConteudo(models.Model):
    usuario = models.ForeignKey(
        'auth.User',
        on_delete=models.CASCADE,
        related_name='leituras',
        verbose_name='Aluno',
    )
    conteudo = models.ForeignKey(
        ConteudoModulo,
        on_delete=models.CASCADE,
        related_name='leituras',
        verbose_name='Conteúdo',
    )
    lida_em = models.DateTimeField('Lida em', auto_now_add=True)

    class Meta:
        verbose_name = 'Leitura de conteúdo'
        verbose_name_plural = 'Leituras de conteúdos'
        constraints = [
            models.UniqueConstraint(fields=['usuario', 'conteudo'], name='leitura_unica_por_aluno_e_conteudo'),
        ]

    def __str__(self):
        return f"{self.usuario} - {self.conteudo}"
