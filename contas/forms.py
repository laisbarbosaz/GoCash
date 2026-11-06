from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django.utils.safestring import mark_safe

from .convites import ConviteInvalido, buscar_convite


class CadastroForm(UserCreationForm):
    ALUNO = 'aluno'
    EDUCADOR = 'educador'

    tipo_conta = forms.ChoiceField(
        label="Quero me cadastrar como",
        choices=[(ALUNO, 'Aluno'), (EDUCADOR, 'Educador')],
        initial=ALUNO,
        widget=forms.RadioSelect,
    )
    first_name = forms.CharField(required=True, max_length=150, label="Nome")
    last_name = forms.CharField(required=True, max_length=150, label="Sobrenome")
    email = forms.EmailField(required=True, label="E-mail")
    confirmar_email = forms.EmailField(required=True, label="Confirmar e-mail")
    codigo_convite = forms.CharField(required=False, max_length=8, label="Código de convite")
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
        fields = ['first_name', 'last_name', 'username', 'email', 'password1', 'password2']

    def clean_email(self):
        email = self.cleaned_data['email'].strip()
        if User.objects.filter(email__iexact=email).exists():
            raise forms.ValidationError("Já existe uma conta com este e-mail.")
        return email

    def clean(self):
        dados = super().clean()

        email = dados.get('email')
        confirmacao = dados.get('confirmar_email')
        if email and confirmacao and email.lower() != confirmacao.strip().lower():
            self.add_error('confirmar_email', "Os e-mails não são iguais.")

        self.convite = None
        if dados.get('tipo_conta') == self.EDUCADOR:
            codigo = (dados.get('codigo_convite') or '').strip()
            if not codigo:
                self.add_error('codigo_convite', "Informe o código de convite que você recebeu por e-mail.")
            else:
                try:
                    self.convite = buscar_convite(codigo, email)
                except ConviteInvalido as erro:
                    self.add_error('codigo_convite', str(erro))

        return dados

    def save(self, commit=True):
        usuario = super().save(commit=False)
        usuario.email = self.cleaned_data['email']
        usuario.is_staff = False
        if commit:
            usuario.save()
            usuario.perfil.registrar_aceite()
        return usuario


class SenhaAtualForm(forms.Form):
    senha = forms.CharField(label="Senha atual", strip=False, widget=forms.PasswordInput)

    def __init__(self, usuario, *args, **kwargs):
        self.usuario = usuario
        super().__init__(*args, **kwargs)

    def clean_senha(self):
        senha = self.cleaned_data['senha']
        if not self.usuario.check_password(senha):
            raise forms.ValidationError("Senha incorreta.")
        return senha


class AlterarNomeForm(forms.ModelForm):
    first_name = forms.CharField(required=True, max_length=150, label="Nome")
    last_name = forms.CharField(required=True, max_length=150, label="Sobrenome")

    class Meta:
        model = User
        fields = ['first_name', 'last_name']


class RankingForm(forms.Form):
    aparecer_no_ranking = forms.BooleanField(required=False, label="Quero aparecer no ranking da página inicial")


class AlterarEmailForm(SenhaAtualForm):
    novo_email = forms.EmailField(label="Novo e-mail")
    field_order = ['novo_email', 'senha']

    def clean_novo_email(self):
        email = self.cleaned_data['novo_email'].strip()
        if email.lower() == (self.usuario.email or '').lower():
            raise forms.ValidationError("Esse já é o seu e-mail.")
        if User.objects.filter(email__iexact=email).exclude(pk=self.usuario.pk).exists():
            raise forms.ValidationError("Já existe uma conta com este e-mail.")
        return email


class ExcluirContaForm(SenhaAtualForm):
    confirmar = forms.BooleanField(
        label="Entendo que a exclusão é definitiva e não pode ser desfeita.",
        error_messages={'required': "Marque a confirmação para excluir a conta."},
    )


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
