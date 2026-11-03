from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django.utils.safestring import mark_safe

class CadastroForm(UserCreationForm):
    email = forms.EmailField(required=True, label="E-mail")
    aceite_termos = forms.BooleanField(
        required=True,
        label=mark_safe(
            'Declaro ter <strong>16 anos ou mais</strong> e que li e aceito os '
            '<a href="/conta/termos-de-uso/" target="_blank">Termos de Uso</a> '
            'e a <a href="/conta/politica-de-privacidade/" target="_blank">Política de Privacidade</a>.'
        ),
        error_messages={'required': 'Para criar sua conta, é necessário ter 16 anos ou mais e aceitar os Termos de Uso e a Política de Privacidade.'}
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


class CodigoVerificacaoForm(forms.Form):
    codigo = forms.CharField(
        label="Código de verificação",
        max_length=6,
        min_length=6,
        widget=forms.TextInput(attrs={
            'inputmode': 'numeric',
            'autocomplete': 'one-time-code',
            'class': 'form-control',
            'autofocus': True,
        })
    )