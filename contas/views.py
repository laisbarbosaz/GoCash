from django.shortcuts import render, redirect
from django.contrib.auth.views import LoginView
from django.contrib import messages
from .forms import CadastroForm
from django.contrib.auth import logout
from django.shortcuts import redirect

class LoginPersonalizado(LoginView):
    template_name = 'contas/login.html'

    def get_success_url(self):
        usuario = self.request.user
        if usuario.is_staff:
            return '/admin/'
        return '/'

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
