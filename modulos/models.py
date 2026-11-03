from django.db import models
from django.utils.text import slugify


class Modulo(models.Model):
    nome_modulo = models.CharField(max_length=100)
    descricao_modulo = models.TextField()
    # Nome do módulo em formato de endereço (ex.: "Controles e Dívidas" -> "controles-e-dividas").
    # É usado nas URLs no lugar do id do banco, para não expor a numeração interna.
    slug = models.SlugField(
        'Endereço na URL',
        max_length=110,
        unique=True,
        null=True,
        blank=True,
        help_text='Gerado automaticamente a partir do nome. Ex.: /modulos/controles-e-dividas/',
    )

    class Meta:
        verbose_name = "Módulo"
        verbose_name_plural = "Módulos de Aprendizagem"

    def __str__(self):
        return self.nome_modulo

    def save(self, *args, **kwargs):
        # Só gera na primeira vez: se o nome mudar depois, o endereço continua o mesmo
        # e links antigos não quebram. O administrador pode editar o campo se quiser.
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
