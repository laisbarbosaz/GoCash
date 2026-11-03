from django.db import migrations, models
from django.utils.text import slugify


def preencher_slugs(apps, schema_editor):
    """Gera o endereço (slug) dos módulos que já existiam antes deste campo."""
    Modulo = apps.get_model('modulos', 'Modulo')
    usados = set(Modulo.objects.exclude(slug__isnull=True).values_list('slug', flat=True))
    for modulo in Modulo.objects.filter(slug__isnull=True).order_by('id'):
        base = slugify(modulo.nome_modulo)[:100] or 'modulo'
        slug = base
        numero = 2
        while slug in usados:
            slug = f'{base}-{numero}'
            numero += 1
        usados.add(slug)
        modulo.slug = slug
        modulo.save(update_fields=['slug'])


class Migration(migrations.Migration):

    dependencies = [
        ('modulos', '0003_remove_conteudomodulo_ordem_conteudo_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='modulo',
            name='slug',
            field=models.SlugField(
                blank=True,
                help_text='Gerado automaticamente a partir do nome. Ex.: /modulos/controles-e-dividas/',
                max_length=110,
                null=True,
                unique=True,
                verbose_name='Endereço na URL',
            ),
        ),
        migrations.RunPython(preencher_slugs, migrations.RunPython.noop),
    ]
