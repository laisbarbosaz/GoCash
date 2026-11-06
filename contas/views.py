from django.conf import settings
from django.contrib import messages
from django.contrib.auth import login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth.models import User
from django.core.mail import send_mail
from django.db import transaction
from django.shortcuts import render, redirect
from django.utils.http import url_has_allowed_host_and_scheme
from django.views import View

from .convites import ConviteInvalido, usar_convite
from .forms import (
    AlterarEmailForm,
    AlterarNomeForm,
    CadastroForm,
    CodigoVerificacaoForm,
    ExcluirContaForm,
    RankingForm,
)
from .models import CodigoVerificacao, ConfiguracaoSite, PerfilUsuario
from .papeis import eh_principal


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


def concluir_login(request, usuario, proxima_pagina=None):
    login(request, usuario)
    messages.success(request, "Login realizado com sucesso!")
    if proxima_pagina:
        return redirect(proxima_pagina)
    if usuario.is_staff:
        return redirect('/admin/')
    return redirect('/')


class LoginPersonalizado(View):
    template_name = 'contas/login.html'

    def get(self, request):
        form = AuthenticationForm()
        return render(request, self.template_name, {'form': form})

    def post(self, request):
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            usuario = form.get_user()

            proxima_pagina = request.GET.get('next') or request.POST.get('next')
            if not (proxima_pagina and url_has_allowed_host_and_scheme(
                proxima_pagina,
                allowed_hosts={request.get_host()},
                require_https=request.is_secure(),
            )):
                proxima_pagina = None

            if not ConfiguracaoSite.atual().exigir_mfa:
                return concluir_login(request, usuario, proxima_pagina)

            if not usuario.email:
                messages.error(request, "Sua conta não possui e-mail cadastrado para receber o código de verificação.")
                return render(request, self.template_name, {'form': form})

            codigo = CodigoVerificacao.objects.create(
                usuario=usuario,
                codigo=CodigoVerificacao.gerar_codigo(),
            )
            enviar_codigo_por_email(usuario, codigo.codigo)

            request.session['usuario_2fa_id'] = usuario.id

            if proxima_pagina:
                request.session['proxima_pagina'] = proxima_pagina
            else:
                request.session.pop('proxima_pagina', None)

            return redirect('verificar_codigo')

        nome = request.POST.get('username', '')
        senha = request.POST.get('password', '')
        inativo = User.objects.filter(username=nome, is_active=False).first()
        if inativo and inativo.check_password(senha):
            messages.error(request, "Sua conta está desativada. Procure um administrador.")
        else:
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
                if not usuario.is_active:
                    request.session.pop('usuario_2fa_id', None)
                    messages.error(request, "Sua conta está desativada. Procure um administrador.")
                    return redirect('login')
                proxima_pagina = request.session.pop('proxima_pagina', None)
                request.session.pop('usuario_2fa_id', None)
                return concluir_login(request, usuario, proxima_pagina)

            messages.error(request, "Código inválido ou expirado.")

        return render(request, self.template_name, {'form': form})


def reenviar_codigo(request):
    usuario_id = request.session.get('usuario_2fa_id')
    if not usuario_id:
        return redirect('login')

    usuario = User.objects.filter(id=usuario_id, is_active=True).first()
    if not usuario:
        request.session.pop('usuario_2fa_id', None)
        return redirect('login')
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
            educador = form.cleaned_data['tipo_conta'] == CadastroForm.EDUCADOR
            try:
                with transaction.atomic():
                    usuario = form.save()
                    if educador:
                        usar_convite(form.convite, usuario)
            except ConviteInvalido as erro:
                form.add_error('codigo_convite', str(erro))
            else:
                if educador:
                    messages.success(request, "Conta de educador criada! Faça login para acessar o painel.")
                else:
                    messages.success(request, "Conta criada com sucesso! Faça login para continuar.")
                return redirect("login")
        messages.error(request, "Houve um erro ao criar sua conta. Verifique os campos novamente.")
    else:
        codigo = request.GET.get('convite', '').strip().upper()[:8]
        inicial = {'tipo_conta': CadastroForm.EDUCADOR, 'codigo_convite': codigo} if codigo else {}
        form = CadastroForm(initial=inicial)
    return render(request, "contas/cadastro.html", {"form": form})


@login_required
def meu_perfil(request):
    usuario = request.user
    principal = eh_principal(usuario)
    form_nome = AlterarNomeForm(instance=usuario)
    form_email = AlterarEmailForm(usuario)
    form_excluir = ExcluirContaForm(usuario)

    if request.method == 'POST':
        acao = request.POST.get('acao')

        if acao == 'ranking' and not usuario.is_staff:
            form_ranking = RankingForm(request.POST)
            if form_ranking.is_valid():
                aparecer = form_ranking.cleaned_data['aparecer_no_ranking']
                PerfilUsuario.objects.filter(usuario=usuario).update(aparecer_no_ranking=aparecer)
                if aparecer:
                    messages.success(request, "Pronto! Você agora aparece no ranking da página inicial.")
                else:
                    messages.success(request, "Pronto! Você não aparece mais no ranking.")
                return redirect('meu_perfil')

        elif acao == 'nome':
            form_nome = AlterarNomeForm(request.POST, instance=usuario)
            if form_nome.is_valid():
                form_nome.save()
                messages.success(request, "Nome atualizado.")
                return redirect('meu_perfil')

        elif acao == 'email':
            form_email = AlterarEmailForm(usuario, request.POST)
            if form_email.is_valid():
                usuario.email = form_email.cleaned_data['novo_email']
                usuario.save(update_fields=['email'])
                messages.success(request, f"E-mail alterado para {usuario.email}.")
                return redirect('meu_perfil')

        elif acao == 'excluir' and not principal:
            form_excluir = ExcluirContaForm(usuario, request.POST)
            if form_excluir.is_valid():
                logout(request)
                usuario.delete()
                messages.success(request, "Sua conta e os seus dados foram excluídos.")
                return redirect('pagina_inicial')

        messages.error(request, "Não foi possível salvar. Confira os campos destacados.")

    perfil = getattr(usuario, 'perfil', None)
    if principal:
        nome_perfil = 'Administrador principal'
    else:
        nome_perfil = perfil.get_tipo_usuario_display() if perfil else '-'

    return render(request, 'contas/perfil.html', {
        'nome_perfil': nome_perfil,
        'perfil': perfil,
        'principal': principal,
        'form_nome': form_nome,
        'form_email': form_email,
        'form_excluir': form_excluir,
    })


def termos_de_uso(request):
    return render(request, 'contas/termos_de_uso.html')


def politica_de_privacidade(request):
    return render(request, 'contas/politica_de_privacidade.html')


def sair(request):
    logout(request)
    messages.success(request, "Você saiu da sua conta com sucesso!")
    return redirect("pagina_inicial")
