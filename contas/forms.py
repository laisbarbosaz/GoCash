from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django.utils.safestring import mark_safe

class CadastroForm(UserCreationForm):
    email = forms.EmailField(required=True, label="E-mail")
    aceite_termos = forms.BooleanField(
        required=True,
        label=mark_safe(
            'Li e aceito o <a href="/conta/termo-de-aceite/" target="_blank">Termo de Aceite</a> '
            'e a <a href="/conta/politica-de-privacidade/" target="_blank">Política de Privacidade</a>.'
        ),
        error_messages={'required': 'É necessário aceitar os termos para criar sua conta.'}
    )

    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2']

    def save(self, commit=True):
        usuario = super().save(commit=False)
        usuario.email = self.cleaned_data['email']
        usuario.is_staff = False
        if commit:
            usuario.save()
            usuario.perfil.registrar_aceite()
        return usuario