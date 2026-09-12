from django.db import models

class Modulo(models.Model):
    nome_modulo = models.CharField(max_length=100)
    descricao_modulo = models.TextField()
    ordem_modulo = models.PositiveIntegerField(default=0)

    class Meta:
        verbose_name = "Módulo"
        verbose_name_plural = "Módulos de Aprendizagem"

    def __str__(self):
        return self.nome_modulo
    


class ConteudoModulo(models.Model):
    modulo = models.ForeignKey(Modulo, on_delete=models.CASCADE, related_name='conteudos')
    titulo_conteudo = models.CharField(max_length=150)
    explicacao_conteudo = models.TextField()
    ordem_conteudo = models.PositiveIntegerField(default=0)

    class Meta:
        verbose_name = "Conteúdo"
        verbose_name_plural = "Conteúdos dos Módulos"

    def __str__(self):
        return self.titulo_conteudo