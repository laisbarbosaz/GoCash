from io import StringIO

from django.contrib.auth.models import Group, User
from django.core import mail
from django.core.management import call_command
from django.core.management.base import CommandError
from django.db import IntegrityError, transaction
from datetime import timedelta

from django.test import TestCase
from django.urls import reverse
from django.utils import timezone

from .models import ConfiguracaoSite, ConviteEducador, PerfilUsuario
from .papeis import NOME_GRUPO_EDUCADORES, definir_perfil, tornar_principal

SENHA = 'SenhaForte!123'


def criar_usuario(username, tipo=PerfilUsuario.ALUNO):
    usuario = User.objects.create_user(username, f'{username}@teste.com', SENHA)
    if tipo != PerfilUsuario.ALUNO:
        definir_perfil(usuario, tipo)
    return recarregar(usuario)


def recarregar(usuario):
    return User.objects.select_related('perfil').get(pk=usuario.pk)


class PerfisTests(TestCase):
    def test_novo_usuario_comeca_como_aluno(self):
        aluno = criar_usuario('aluno')
        self.assertEqual(aluno.perfil.tipo_usuario, PerfilUsuario.ALUNO)
        self.assertFalse(aluno.is_staff)

    def test_educador_acessa_o_painel_pelo_grupo(self):
        educador = criar_usuario('edu', PerfilUsuario.EDUCADOR)
        self.assertEqual(educador.perfil.tipo_usuario, PerfilUsuario.EDUCADOR)
        self.assertTrue(educador.is_staff)
        self.assertFalse(educador.is_superuser)
        self.assertTrue(educador.groups.filter(name=NOME_GRUPO_EDUCADORES).exists())
        self.assertTrue(educador.has_perm('atividades.add_pergunta'))
        self.assertFalse(educador.has_perm('auth.change_user'))

    def test_voltar_para_aluno_tira_o_acesso(self):
        educador = criar_usuario('edu', PerfilUsuario.EDUCADOR)
        definir_perfil(educador, PerfilUsuario.ALUNO)
        educador = recarregar(educador)
        self.assertFalse(educador.is_staff)
        self.assertFalse(educador.groups.exists())
        self.assertEqual(educador.perfil.tipo_usuario, PerfilUsuario.ALUNO)

    def test_superusuario_criado_pelo_django_vira_administrador(self):
        admin = User.objects.create_superuser('admin', 'admin@teste.com', SENHA)
        self.assertEqual(recarregar(admin).perfil.tipo_usuario, PerfilUsuario.ADMINISTRADOR)

    def test_grupo_educadores_criado_automaticamente(self):
        grupo = Group.objects.get(name=NOME_GRUPO_EDUCADORES)
        self.assertTrue(grupo.permissions.filter(codename='change_modulo').exists())
        self.assertFalse(grupo.permissions.filter(codename='change_tentativa').exists())


class AdministradorPrincipalTests(TestCase):
    def test_comando_define_o_principal(self):
        criar_usuario('laisb')
        call_command('definir_administrador_principal', 'laisb', stdout=StringIO())
        laisb = recarregar(User.objects.get(username='laisb'))
        self.assertTrue(laisb.perfil.administrador_principal)
        self.assertTrue(laisb.is_superuser)
        self.assertEqual(laisb.perfil.tipo_usuario, PerfilUsuario.ADMINISTRADOR)

    def test_so_existe_um_principal(self):
        primeiro = criar_usuario('primeiro')
        segundo = criar_usuario('segundo')
        tornar_principal(primeiro)
        tornar_principal(segundo)
        self.assertFalse(recarregar(primeiro).perfil.administrador_principal)
        self.assertTrue(recarregar(primeiro).is_superuser)
        self.assertTrue(recarregar(segundo).perfil.administrador_principal)
        self.assertEqual(PerfilUsuario.objects.filter(administrador_principal=True).count(), 1)

    def test_comando_com_usuario_inexistente(self):
        with self.assertRaises(CommandError):
            call_command('definir_administrador_principal', 'ninguem', stdout=StringIO())

    def test_perfil_do_principal_nao_pode_ser_alterado(self):
        principal = criar_usuario('chefe')
        tornar_principal(principal)
        with self.assertRaises(ValueError):
            definir_perfil(recarregar(principal), PerfilUsuario.ALUNO)


class AcoesDoPainelTests(TestCase):
    def setUp(self):
        self.principal = criar_usuario('chefe')
        tornar_principal(self.principal)
        self.principal = recarregar(self.principal)
        self.administrador = criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)
        self.outro_administrador = criar_usuario('adm2', PerfilUsuario.ADMINISTRADOR)
        self.educador = criar_usuario('edu', PerfilUsuario.EDUCADOR)
        self.aluno = criar_usuario('aluno')

    def executar(self, quem, acao, *alvos):
        self.client.force_login(quem)
        return self.client.post(reverse('admin:auth_user_changelist'), {
            'action': acao,
            '_selected_action': [str(alvo.pk) for alvo in alvos],
            'index': '0',
            'select_across': '0',
        })

    def test_principal_promove_aluno_a_administrador(self):
        self.executar(self.principal, 'definir_como_administrador', self.aluno)
        aluno = recarregar(self.aluno)
        self.assertTrue(aluno.is_superuser)
        self.assertEqual(aluno.perfil.tipo_usuario, PerfilUsuario.ADMINISTRADOR)

    def test_principal_promove_aluno_a_educador(self):
        self.executar(self.principal, 'definir_como_educador', self.aluno)
        self.assertEqual(recarregar(self.aluno).perfil.tipo_usuario, PerfilUsuario.EDUCADOR)

    def test_principal_despromove_educador_e_administrador(self):
        self.executar(self.principal, 'definir_como_aluno', self.educador, self.administrador)
        self.assertEqual(recarregar(self.educador).perfil.tipo_usuario, PerfilUsuario.ALUNO)
        self.assertEqual(recarregar(self.administrador).perfil.tipo_usuario, PerfilUsuario.ALUNO)

    def test_administrador_comum_nao_altera_perfil(self):
        self.executar(self.administrador, 'definir_como_educador', self.aluno)
        self.executar(self.administrador, 'definir_como_aluno', self.educador)
        self.assertEqual(recarregar(self.aluno).perfil.tipo_usuario, PerfilUsuario.ALUNO)
        self.assertEqual(recarregar(self.educador).perfil.tipo_usuario, PerfilUsuario.EDUCADOR)

    def test_administrador_comum_desativa_e_ativa_alunos_e_educadores(self):
        self.executar(self.administrador, 'desativar_contas', self.aluno, self.educador)
        self.assertFalse(recarregar(self.aluno).is_active)
        self.assertFalse(recarregar(self.educador).is_active)

        self.executar(self.administrador, 'ativar_contas', self.aluno, self.educador)
        self.assertTrue(recarregar(self.aluno).is_active)
        self.assertTrue(recarregar(self.educador).is_active)

    def test_administrador_comum_nao_desativa_outro_administrador(self):
        self.executar(self.administrador, 'desativar_contas', self.outro_administrador)
        self.assertTrue(recarregar(self.outro_administrador).is_active)

    def test_principal_desativa_administrador(self):
        self.executar(self.principal, 'desativar_contas', self.administrador)
        self.assertFalse(recarregar(self.administrador).is_active)

    def test_ninguem_desativa_o_principal(self):
        self.executar(self.administrador, 'desativar_contas', self.principal)
        self.executar(self.principal, 'desativar_contas', self.principal)
        self.assertTrue(recarregar(self.principal).is_active)

    def test_ninguem_altera_a_propria_conta(self):
        self.executar(self.administrador, 'desativar_contas', self.administrador)
        self.assertTrue(recarregar(self.administrador).is_active)

    def test_educador_nao_ve_usuarios(self):
        self.client.force_login(self.educador)
        resposta = self.client.get(reverse('admin:auth_user_changelist'))
        self.assertEqual(resposta.status_code, 403)

    def test_lista_mostra_perfil_e_situacao(self):
        self.client.force_login(self.administrador)
        resposta = self.client.get(reverse('admin:auth_user_changelist'))
        self.assertContains(resposta, 'Educador')
        self.assertContains(resposta, 'Ativo')


class LoginContaDesativadaTests(TestCase):
    def setUp(self):
        self.aluno = criar_usuario('aluno')
        self.aluno.is_active = False
        self.aluno.save()

    def test_conta_desativada_recebe_aviso_e_nenhum_codigo(self):
        resposta = self.client.post(reverse('login'), {'username': 'aluno', 'password': SENHA})
        self.assertContains(resposta, 'Sua conta está desativada')
        self.assertEqual(len(mail.outbox), 0)

    def test_senha_errada_nao_revela_que_a_conta_existe(self):
        resposta = self.client.post(reverse('login'), {'username': 'aluno', 'password': 'errada'})
        self.assertContains(resposta, 'Usuário ou senha inválidos')
        self.assertNotContains(resposta, 'desativada')

    def test_desativado_depois_de_logado_perde_o_acesso(self):
        ativo = criar_usuario('ativo')
        self.client.force_login(ativo)
        ativo.is_active = False
        ativo.save()
        resposta = self.client.get(reverse('listar_atividades'))
        self.assertEqual(resposta.status_code, 302)
        self.assertIn('/conta/login/', resposta['Location'])


class LogsTests(TestCase):
    def test_so_administradores_veem_os_logs(self):
        self.client.force_login(criar_usuario('aluno'))
        self.assertEqual(self.client.get(reverse('logs')).status_code, 403)

        self.client.force_login(criar_usuario('edu', PerfilUsuario.EDUCADOR))
        self.assertEqual(self.client.get(reverse('logs')).status_code, 403)

        self.client.force_login(criar_usuario('adm', PerfilUsuario.ADMINISTRADOR))
        self.assertEqual(self.client.get(reverse('logs')).status_code, 200)


def dados_cadastro(**extras):
    dados = {
        'tipo_conta': 'aluno',
        'first_name': 'Nova',
        'last_name': 'Pessoa',
        'username': 'novo',
        'email': 'novo@teste.com',
        'confirmar_email': 'novo@teste.com',
        'password1': SENHA,
        'password2': SENHA,
        'aceite_termos': 'on',
    }
    dados.update(extras)
    return dados


class CadastroTests(TestCase):
    def test_aluno_e_criado_ativo(self):
        resposta = self.client.post(reverse('cadastro'), dados_cadastro())
        self.assertRedirects(resposta, reverse('login'))
        novo = recarregar(User.objects.get(username='novo'))
        self.assertTrue(novo.is_active)
        self.assertEqual(novo.perfil.tipo_usuario, PerfilUsuario.ALUNO)
        self.assertFalse(novo.is_staff)

    def test_guarda_nome_e_sobrenome(self):
        self.client.post(reverse('cadastro'), dados_cadastro())
        self.assertEqual(User.objects.get(username='novo').get_full_name(), 'Nova Pessoa')

    def test_nome_e_obrigatorio(self):
        resposta = self.client.post(reverse('cadastro'), dados_cadastro(first_name='', last_name=''))
        self.assertEqual(resposta.status_code, 200)
        self.assertFalse(User.objects.filter(username='novo').exists())

    def test_emails_diferentes_nao_cadastram(self):
        resposta = self.client.post(reverse('cadastro'), dados_cadastro(confirmar_email='outro@teste.com'))
        self.assertContains(resposta, 'Os e-mails não são iguais')
        self.assertFalse(User.objects.filter(username='novo').exists())

    def test_senhas_diferentes_nao_cadastram(self):
        self.client.post(reverse('cadastro'), dados_cadastro(password2='OutraSenha!456'))
        self.assertFalse(User.objects.filter(username='novo').exists())

    def test_email_ja_usado_nao_cadastra(self):
        criar_usuario('antigo')
        resposta = self.client.post(reverse('cadastro'), dados_cadastro(email='ANTIGO@teste.com', confirmar_email='ANTIGO@teste.com'))
        self.assertContains(resposta, 'Já existe uma conta com este e-mail')

    def test_educador_precisa_do_codigo(self):
        resposta = self.client.post(reverse('cadastro'), dados_cadastro(tipo_conta='educador'))
        self.assertContains(resposta, 'Informe o código de convite')
        self.assertFalse(User.objects.filter(username='novo').exists())


def dados_educador(convite, **extras):
    dados = {
        'tipo_conta': 'educador',
        'email': convite.email,
        'confirmar_email': convite.email,
        'codigo_convite': convite.codigo,
    }
    dados.update(extras)
    return dados_cadastro(**dados)


class ConviteNoCadastroTests(TestCase):
    def setUp(self):
        self.administrador = criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)
        self.convite = ConviteEducador.objects.create(email='nova.educadora@teste.com', criado_por=self.administrador)

    def test_codigo_valido_cria_educador_ativo_na_hora(self):
        resposta = self.client.post(reverse('cadastro'), dados_educador(self.convite))
        self.assertRedirects(resposta, reverse('login'))

        novo = recarregar(User.objects.get(username='novo'))
        self.assertTrue(novo.is_active)
        self.assertTrue(novo.is_staff)
        self.assertEqual(novo.perfil.tipo_usuario, PerfilUsuario.EDUCADOR)
        self.assertTrue(novo.groups.filter(name=NOME_GRUPO_EDUCADORES).exists())

        convite = ConviteEducador.objects.get(pk=self.convite.pk)
        self.assertEqual(convite.usado_por, novo)
        self.assertEqual(convite.situacao, ConviteEducador.USADO)

    def test_codigo_aceita_minusculas_e_espacos(self):
        self.client.post(reverse('cadastro'), dados_educador(self.convite, codigo_convite=f' {self.convite.codigo.lower()} '))
        self.assertTrue(User.objects.filter(username='novo', is_staff=True).exists())

    def test_codigo_preso_ao_email(self):
        resposta = self.client.post(reverse('cadastro'), dados_educador(
            self.convite, email='outra@teste.com', confirmar_email='outra@teste.com',
        ))
        self.assertContains(resposta, 'foi enviado para outro e-mail')
        self.assertFalse(User.objects.filter(username='novo').exists())

    def test_codigo_vencido(self):
        ConviteEducador.objects.filter(pk=self.convite.pk).update(expira_em=timezone.now() - timedelta(minutes=1))
        resposta = self.client.post(reverse('cadastro'), dados_educador(self.convite))
        self.assertContains(resposta, 'venceu')
        self.assertFalse(User.objects.filter(username='novo').exists())

    def test_codigo_so_vale_uma_vez(self):
        self.client.post(reverse('cadastro'), dados_educador(self.convite))
        resposta = self.client.post(reverse('cadastro'), dados_educador(
            self.convite, username='segundo',
        ))
        self.assertFalse(User.objects.filter(username='segundo').exists())
        self.assertEqual(resposta.status_code, 200)

    def test_codigo_inexistente(self):
        resposta = self.client.post(reverse('cadastro'), dados_cadastro(
            tipo_conta='educador', codigo_convite='ZZZZZZZZ',
        ))
        self.assertContains(resposta, 'Código de convite inválido')

    def test_aluno_ignora_o_codigo(self):
        self.client.post(reverse('cadastro'), dados_cadastro(codigo_convite='QUALQUER'))
        novo = recarregar(User.objects.get(username='novo'))
        self.assertEqual(novo.perfil.tipo_usuario, PerfilUsuario.ALUNO)

    def test_link_do_email_ja_preenche_o_codigo(self):
        resposta = self.client.get(reverse('cadastro'), {'convite': self.convite.codigo})
        self.assertContains(resposta, f'value="{self.convite.codigo}"')
        self.assertContains(resposta, 'value="educador" checked')

    def test_convite_vale_por_dois_dias(self):
        restante = self.convite.expira_em - self.convite.criado_em
        self.assertAlmostEqual(restante.total_seconds(), timedelta(days=2).total_seconds(), delta=5)


class ConvitesNoPainelTests(TestCase):
    def setUp(self):
        self.administrador = criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)
        self.url_lista = reverse('admin:contas_conviteeducador_changelist')
        self.url_novo = reverse('admin:contas_conviteeducador_add')

    def acao(self, acao, *convites):
        return self.client.post(self.url_lista, {
            'action': acao,
            '_selected_action': [str(convite.pk) for convite in convites],
            'index': '0',
            'select_across': '0',
        })

    def test_administrador_comum_envia_convite_por_email(self):
        self.client.force_login(self.administrador)
        resposta = self.client.post(self.url_novo, {'email': 'parceiro@teste.com', '_save': 'Salvar'})
        self.assertRedirects(resposta, self.url_lista)

        convite = ConviteEducador.objects.get(email='parceiro@teste.com')
        self.assertEqual(convite.criado_por, self.administrador)
        self.assertEqual(len(convite.codigo), 8)
        self.assertEqual(mail.outbox[-1].to, ['parceiro@teste.com'])
        self.assertIn(convite.codigo, mail.outbox[-1].body)
        self.assertIn(f'?convite={convite.codigo}', mail.outbox[-1].body)

    def test_nao_convida_email_que_ja_tem_conta(self):
        criar_usuario('aluna')
        self.client.force_login(self.administrador)
        resposta = self.client.post(self.url_novo, {'email': 'ALUNA@teste.com', '_save': 'Salvar'})
        self.assertContains(resposta, 'Já existe uma conta com este e-mail')
        self.assertFalse(ConviteEducador.objects.exists())

    def test_nao_duplica_convite_valido(self):
        ConviteEducador.objects.create(email='parceiro@teste.com')
        self.client.force_login(self.administrador)
        resposta = self.client.post(self.url_novo, {'email': 'parceiro@teste.com', '_save': 'Salvar'})
        self.assertContains(resposta, 'Já existe um convite válido')
        self.assertEqual(ConviteEducador.objects.count(), 1)

    def test_reenviar_gera_codigo_novo_e_renova_o_prazo(self):
        convite = ConviteEducador.objects.create(email='parceiro@teste.com')
        ConviteEducador.objects.filter(pk=convite.pk).update(expira_em=timezone.now() - timedelta(days=1))
        codigo_antigo = convite.codigo

        self.client.force_login(self.administrador)
        self.acao('reenviar', convite)

        convite.refresh_from_db()
        self.assertNotEqual(convite.codigo, codigo_antigo)
        self.assertEqual(convite.situacao, ConviteEducador.PENDENTE)
        self.assertIn(convite.codigo, mail.outbox[-1].body)

    def test_cancelar_so_apaga_convites_nao_usados(self):
        aberto = ConviteEducador.objects.create(email='aberto@teste.com')
        usado = ConviteEducador.objects.create(email='usado@teste.com', usado_em=timezone.now())

        self.client.force_login(self.administrador)
        self.acao('cancelar', aberto, usado)

        self.assertFalse(ConviteEducador.objects.filter(pk=aberto.pk).exists())
        self.assertTrue(ConviteEducador.objects.filter(pk=usado.pk).exists())

    def test_educador_nao_ve_convites(self):
        self.client.force_login(criar_usuario('edu', PerfilUsuario.EDUCADOR))
        self.assertEqual(self.client.get(self.url_lista).status_code, 403)


class EmailUnicoNoBancoTests(TestCase):
    def test_banco_recusa_email_repetido_mesmo_com_maiusculas(self):
        User.objects.create_user('primeiro', 'mesmo@teste.com', SENHA)
        with self.assertRaises(IntegrityError), transaction.atomic():
            User.objects.create_user('segundo', 'MESMO@teste.com', SENHA)

    def test_contas_sem_email_continuam_permitidas(self):
        User.objects.create_user('sem_email_1', '', SENHA)
        User.objects.create_user('sem_email_2', '', SENHA)
        self.assertEqual(User.objects.filter(email='').count(), 2)


class InterruptorMfaTests(TestCase):
    def desligar_mfa(self):
        configuracao = ConfiguracaoSite.atual()
        configuracao.exigir_mfa = False
        configuracao.save()

    def test_mfa_vem_ligado(self):
        criar_usuario('aluno')
        resposta = self.client.post(reverse('login'), {'username': 'aluno', 'password': SENHA})
        self.assertRedirects(resposta, reverse('verificar_codigo'))
        self.assertEqual(len(mail.outbox), 1)

    def test_mfa_desligado_entra_direto(self):
        self.desligar_mfa()
        criar_usuario('aluno')
        resposta = self.client.post(reverse('login'), {'username': 'aluno', 'password': SENHA})
        self.assertRedirects(resposta, '/', fetch_redirect_response=False)
        self.assertEqual(len(mail.outbox), 0)
        self.assertEqual(self.client.get(reverse('listar_atividades')).status_code, 200)

    def test_mfa_desligado_vale_para_administradores(self):
        self.desligar_mfa()
        criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)
        resposta = self.client.post(reverse('login'), {'username': 'adm', 'password': SENHA})
        self.assertRedirects(resposta, '/admin/', fetch_redirect_response=False)
        self.assertEqual(len(mail.outbox), 0)

    def test_mfa_desligado_volta_para_a_pagina_pedida(self):
        self.desligar_mfa()
        criar_usuario('aluno')
        destino = reverse('listar_atividades')
        resposta = self.client.post(reverse('login') + f'?next={destino}', {'username': 'aluno', 'password': SENHA})
        self.assertRedirects(resposta, destino)

    def test_mfa_desligado_continua_bloqueando_conta_desativada(self):
        self.desligar_mfa()
        aluno = criar_usuario('aluno')
        aluno.is_active = False
        aluno.save()
        resposta = self.client.post(reverse('login'), {'username': 'aluno', 'password': SENHA})
        self.assertContains(resposta, 'Sua conta está desativada')

    def test_administrador_comum_desliga_o_mfa(self):
        administrador = criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)
        configuracao = ConfiguracaoSite.atual()
        self.client.force_login(administrador)
        self.client.post(reverse('admin:contas_configuracaosite_change', args=[configuracao.pk]), {'_save': 'Salvar'})
        configuracao = ConfiguracaoSite.atual()
        self.assertFalse(configuracao.exigir_mfa)
        self.assertEqual(configuracao.atualizada_por, administrador)

    def test_educador_nao_altera_o_mfa(self):
        configuracao = ConfiguracaoSite.atual()
        self.client.force_login(criar_usuario('edu', PerfilUsuario.EDUCADOR))
        url = reverse('admin:contas_configuracaosite_change', args=[configuracao.pk])
        self.assertEqual(self.client.get(url).status_code, 403)
        self.client.post(url, {'_save': 'Salvar'})
        self.assertTrue(ConfiguracaoSite.atual().exigir_mfa)

    def test_lista_abre_direto_a_configuracao(self):
        self.client.force_login(criar_usuario('adm', PerfilUsuario.ADMINISTRADOR))
        resposta = self.client.get(reverse('admin:contas_configuracaosite_changelist'))
        self.assertRedirects(resposta, reverse('admin:contas_configuracaosite_change', args=[1]))


class EsqueciSenhaTests(TestCase):
    def setUp(self):
        self.aluno = criar_usuario('aluno')

    def test_login_tem_o_link(self):
        resposta = self.client.get(reverse('login'))
        self.assertContains(resposta, reverse('senha_esqueci'))

    def test_envia_link_e_permite_criar_senha_nova(self):
        resposta = self.client.post(reverse('senha_esqueci'), {'email': 'ALUNO@teste.com'})
        self.assertRedirects(resposta, reverse('senha_enviada'))
        self.assertEqual(len(mail.outbox), 1)
        self.assertEqual(mail.outbox[0].subject, 'Redefinição de senha do Go Cash')

        link = next(linha for linha in mail.outbox[0].body.splitlines() if '/conta/senha/nova/' in linha)
        caminho = link.split('testserver', 1)[1]
        resposta = self.client.get(caminho, follow=True)
        self.assertContains(resposta, 'Criar senha nova')

        resposta = self.client.post(resposta.redirect_chain[-1][0], {
            'new_password1': 'OutraSenha!789',
            'new_password2': 'OutraSenha!789',
        })
        self.assertRedirects(resposta, reverse('senha_redefinida'))
        self.assertTrue(recarregar(self.aluno).check_password('OutraSenha!789'))

    def test_email_desconhecido_nao_revela_nada(self):
        resposta = self.client.post(reverse('senha_esqueci'), {'email': 'ninguem@teste.com'})
        self.assertRedirects(resposta, reverse('senha_enviada'))
        self.assertEqual(len(mail.outbox), 0)

    def test_link_falso(self):
        resposta = self.client.get(reverse('senha_nova', args=['xx', 'set-password']))
        self.assertContains(resposta, 'Link inválido')


class MeuPerfilTests(TestCase):
    def setUp(self):
        self.aluno = criar_usuario('aluno')
        self.client.force_login(self.aluno)
        self.url = reverse('meu_perfil')

    def test_precisa_estar_logado(self):
        self.client.logout()
        resposta = self.client.get(self.url)
        self.assertEqual(resposta.status_code, 302)

    def test_mostra_os_dados_da_pessoa(self):
        resposta = self.client.get(self.url)
        self.assertContains(resposta, 'aluno@teste.com')
        self.assertContains(resposta, 'Aluno')
        self.assertContains(resposta, 'Cashs')

    def test_educador_tambem_ve_o_perfil(self):
        self.client.force_login(criar_usuario('edu', PerfilUsuario.EDUCADOR))
        resposta = self.client.get(self.url)
        self.assertContains(resposta, 'Educador')

    def test_altera_o_nome(self):
        resposta = self.client.post(self.url, {'acao': 'nome', 'first_name': 'Ana', 'last_name': 'Lima'})
        self.assertRedirects(resposta, self.url)
        self.assertEqual(recarregar(self.aluno).get_full_name(), 'Ana Lima')

    def test_altera_o_email(self):
        resposta = self.client.post(self.url, {'acao': 'email', 'novo_email': 'novo@teste.com', 'senha': SENHA})
        self.assertRedirects(resposta, self.url)
        self.assertEqual(recarregar(self.aluno).email, 'novo@teste.com')

    def test_nao_altera_com_senha_errada(self):
        resposta = self.client.post(self.url, {'acao': 'email', 'novo_email': 'novo@teste.com', 'senha': 'errada'})
        self.assertContains(resposta, 'Senha incorreta')
        self.assertEqual(recarregar(self.aluno).email, 'aluno@teste.com')

    def test_nao_usa_email_de_outra_conta(self):
        criar_usuario('outro')
        resposta = self.client.post(self.url, {'acao': 'email', 'novo_email': 'OUTRO@teste.com', 'senha': SENHA})
        self.assertContains(resposta, 'Já existe uma conta com este e-mail')

    def test_exclui_a_conta_na_hora(self):
        resposta = self.client.post(self.url, {'acao': 'excluir', 'senha': SENHA, 'confirmar': 'on'})
        self.assertRedirects(resposta, reverse('pagina_inicial'), fetch_redirect_response=False)
        self.assertFalse(User.objects.filter(pk=self.aluno.pk).exists())
        self.assertNotIn('_auth_user_id', self.client.session)

    def test_exclusao_pede_confirmacao_e_senha(self):
        self.client.post(self.url, {'acao': 'excluir', 'senha': SENHA})
        self.client.post(self.url, {'acao': 'excluir', 'senha': 'errada', 'confirmar': 'on'})
        self.assertTrue(User.objects.filter(pk=self.aluno.pk).exists())

    def test_principal_nao_se_exclui(self):
        tornar_principal(self.aluno)
        self.client.force_login(recarregar(self.aluno))
        resposta = self.client.get(self.url)
        self.assertContains(resposta, 'Administrador principal')
        self.client.post(self.url, {'acao': 'excluir', 'senha': SENHA, 'confirmar': 'on'})
        self.assertTrue(User.objects.filter(pk=self.aluno.pk).exists())


class TraducaoDoPainelTests(TestCase):
    def test_opcao_vazia_das_acoes_em_portugues(self):
        self.client.force_login(criar_usuario('adm', PerfilUsuario.ADMINISTRADOR))
        resposta = self.client.get(reverse('admin:auth_user_changelist'))
        self.assertContains(resposta, 'Selecione uma opção')
        self.assertNotContains(resposta, 'Select an option')


class LogsDeAuditoriaTests(TestCase):
    def setUp(self):
        self.administrador = criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)
        self.client.force_login(self.administrador)
        configuracao = ConfiguracaoSite.atual()
        self.client.post(reverse('admin:contas_configuracaosite_change', args=[configuracao.pk]), {'_save': 'Salvar'})

    def test_visao_geral_resume_as_acoes(self):
        resposta = self.client.get(reverse('logs'))
        self.assertEqual(resposta.context['total'], 1)
        self.assertEqual(resposta.context['alteracoes'], 1)
        self.assertContains(resposta, 'adm</strong> alterou')
        self.assertContains(resposta, reverse('logs_detalhados'))

    def test_lista_mostra_a_mudanca_em_portugues(self):
        resposta = self.client.get(reverse('logs_detalhados'))
        self.assertNotContains(resposta, '[{&quot;changed')
        self.assertContains(resposta, 'Exigir código por e-mail no login')

    def test_filtro_por_acao(self):
        resposta = self.client.get(reverse('logs_detalhados'), {'acao': '1'})
        self.assertContains(resposta, 'Nenhum registro encontrado')

    def test_so_administrador_ve(self):
        self.client.force_login(criar_usuario('edu', PerfilUsuario.EDUCADOR))
        self.assertEqual(self.client.get(reverse('logs_detalhados')).status_code, 403)


class PermissoesEmPortuguesTests(TestCase):
    def test_nomes_traduzidos(self):
        from django.contrib.auth.models import Permission
        self.assertEqual(Permission.objects.get(codename='add_atividade').name, 'Pode adicionar Atividade')
        self.assertFalse(Permission.objects.filter(name__startswith='Can ').exists())

