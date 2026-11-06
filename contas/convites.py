from django.conf import settings
from django.core.mail import send_mail
from django.db import transaction
from django.utils import timezone

from .models import DIAS_VALIDADE_CONVITE, ConviteEducador, PerfilUsuario
from .papeis import definir_perfil


class ConviteInvalido(Exception):
    pass


def enviar_convite(convite, link_cadastro):
    validade = timezone.localtime(convite.expira_em).strftime('%d/%m/%Y às %H:%M')
    try:
        send_mail(
            "Convite para ser educador no Go Cash",
            (
                "Olá!\n\n"
                "Você foi convidado para publicar módulos e atividades no Go Cash como educador.\n\n"
                f"Seu código de convite é: {convite.codigo}\n\n"
                f"Para criar sua conta, acesse {link_cadastro}, escolha \"Educador\" "
                "e use este mesmo e-mail no cadastro.\n\n"
                f"O código vale por {DIAS_VALIDADE_CONVITE} dias (até {validade}) e só pode ser usado uma vez."
            ),
            settings.DEFAULT_FROM_EMAIL,
            [convite.email],
            fail_silently=False,
        )
    except Exception:
        return False
    return True


def buscar_convite(codigo, email):
    convite = ConviteEducador.objects.filter(codigo=codigo.strip().upper()).first()
    if not convite:
        raise ConviteInvalido("Código de convite inválido.")
    if convite.situacao == ConviteEducador.USADO:
        raise ConviteInvalido("Este código de convite já foi usado.")
    if convite.situacao == ConviteEducador.VENCIDO:
        raise ConviteInvalido("Este código de convite venceu. Peça um novo convite ao administrador.")
    if email and convite.email.lower() != email.strip().lower():
        raise ConviteInvalido("Este convite foi enviado para outro e-mail. Use o e-mail que recebeu o convite.")
    return convite


@transaction.atomic
def usar_convite(convite, usuario):
    convite = ConviteEducador.objects.select_for_update().get(pk=convite.pk)
    if not convite.esta_valido():
        raise ConviteInvalido("Este código de convite não pode mais ser usado.")

    definir_perfil(usuario, PerfilUsuario.EDUCADOR)
    convite.usado_em = timezone.now()
    convite.usado_por = usuario
    convite.save(update_fields=['usado_em', 'usado_por'])
