from django.conf import settings
from django.contrib import messages
from django.contrib.auth import login, logout
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth.models import User
from django.core.mail import send_mail
from django.shortcuts import render, redirect
from django.views import View

from .forms import CadastroForm, CodigoVerificacaoForm
from .models import CodigoVerificacao


def enviar_codigo_por_email(usuario, codigo):
    send_mail(
        subject="Seu código de verificação",
        message=(
            f"Olá, {usuario.username}!\n\n"
            f"Seu código de verificação é: {codigo}\n"
            f"Ele expira em {CodigoVerificacao.MINUTOS_VALIDADE} minutos.\n\n"
            "Se você não tentou fazer login, ignore este e-mail."
        ),
        from_email=settings.DEFAULT_FROM_EMAIL,
        recipient_list=[usuario.email],
        fail_silently=False,
    )


class LoginPersonalizado(View):
    template_name = 'contas/login.html'

    def get(self, request):
        form = AuthenticationForm()
        return render(request, self.template_name, {'form': form})

    def post(self, request):
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            usuario = form.get_user()

            if not usuario.email:
                messages.error(request, "Sua conta não possui e-mail cadastrado para receber o código de verificação.")
                return render(request, self.template_name, {'form': form})

            codigo = CodigoVerificacao.objects.create(
                usuario=usuario,
                codigo=CodigoVerificacao.gerar_codigo(),
            )
            enviar_codigo_por_email(usuario, codigo.codigo)

            request.session['usuario_2fa_id'] = usuario.id
            return redirect('verificar_codigo')

        messages.error(request, "Usuário ou senha inválidos.")
        return render(request, self.template_name, {'form': form})


class VerificarCodigoView(View):
    template_name = 'contas/verificar_codigo.html'

    def get(self, request):
        if not request.session.get('usuario_2fa_id'):
            return redirect('login')
        form = CodigoVerificacaoForm()
        return render(request, self.template_name, {'form': form})

    def post(self, request):
        usuario_id = request.session.get('usuario_2fa_id')
        if not usuario_id:
            return redirect('login')

        form = CodigoVerificacaoForm(request.POST)
        if form.is_valid():
            codigo_digitado = form.cleaned_data['codigo']
            codigo_obj = (
                CodigoVerificacao.objects
                .filter(usuario_id=usuario_id, codigo=codigo_digitado)
                .order_by('-criado_em')
                .first()
            )

            if codigo_obj and codigo_obj.esta_valido():
                codigo_obj.usado = True
                codigo_obj.save()

                usuario = codigo_obj.usuario
                login(request, usuario)
                del request.session['usuario_2fa_id']

                messages.success(request, "Login realizado com sucesso!")
                if usuario.is_staff:
                    return redirect('/admin/')
                return redirect('/')

            messages.error(request, "Código inválido ou expirado.")

        return render(request, self.template_name, {'form': form})


def reenviar_codigo(request):
    usuario_id = request.session.get('usuario_2fa_id')
    if not usuario_id:
        return redirect('login')

    usuario = User.objects.get(id=usuario_id)
    codigo = CodigoVerificacao.objects.create(
        usuario=usuario,
        codigo=CodigoVerificacao.gerar_codigo(),
    )
    enviar_codigo_por_email(usuario, codigo.codigo)
    messages.success(request, "Um novo código foi enviado para o seu e-mail.")
    return redirect('verificar_codigo')


def cadastro(request):
    if request.method == "POST":
        form = CadastroForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, "Conta criada com sucesso! Faça login para continuar.")
            return redirect("login")
        else:
            messages.error(request, "Houve um erro ao criar sua conta. Verifique os campos novamente.")
    else:
        form = CadastroForm()
    return render(request, "contas/cadastro.html", {"form": form})


def termos_de_uso(request):
    return render(request, 'contas/termos_de_uso.html')


def politica_de_privacidade(request):
    return render(request, 'contas/politica_de_privacidade.html')


def sair(request):
    logout(request)
    messages.success(request, "Você saiu da sua conta com sucesso!")
    return redirect("pagina_inicial")
