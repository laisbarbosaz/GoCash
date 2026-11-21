from datetime import timedelta
from importlib import import_module
from io import StringIO

from django.apps import apps
from django.contrib.auth.models import Group, User
from django.core import mail
from django.core.management import call_command
from django.core.management.base import CommandError
from django.db import IntegrityError, transaction
from django.test import TestCase
from django.urls import reverse
from django.utils import timezone

from .limpeza import excluir_contas_desativadas
from .models import CodigoVerificacao, ConfiguracaoSite, PerfilUsuario
from .papeis import definir_perfil, tornar_principal

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

    def test_so_existem_aluno_e_administrador(self):
        self.assertEqual(
            [valor for valor, _ in PerfilUsuario.TIPO_USUARIO_CHOICES],
            [PerfilUsuario.ALUNO, PerfilUsuario.ADMINISTRADOR],
        )

    def test_administrador_entra_no_painel(self):
        administrador = criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)
        self.assertEqual(administrador.perfil.tipo_usuario, PerfilUsuario.ADMINISTRADOR)
        self.assertTrue(administrador.is_staff)
        self.assertTrue(administrador.is_superuser)

    def test_voltar_para_aluno_tira_o_acesso(self):
        administrador = criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)
        definir_perfil(administrador, PerfilUsuario.ALUNO)
        administrador = recarregar(administrador)
        self.assertFalse(administrador.is_staff)
        self.assertFalse(administrador.is_superuser)
        self.assertEqual(administrador.perfil.tipo_usuario, PerfilUsuario.ALUNO)

    def test_superusuario_criado_pelo_django_vira_administrador(self):
        admin = User.objects.create_superuser('admin', 'admin@teste.com', SENHA)
        self.assertEqual(recarregar(admin).perfil.tipo_usuario, PerfilUsuario.ADMINISTRADOR)

    def test_grupo_educadores_nao_e_mais_criado(self):
        self.assertFalse(Group.objects.filter(name='Educadores').exists())


class EducadoresViramAlunosTests(TestCase):
    def test_migracao_tira_o_acesso_dos_antigos_educadores(self):
        educador = criar_usuario('edu')
        educador.is_staff = True
        educador.save()
        PerfilUsuario.objects.filter(usuario=educador).update(tipo_usuario='educador')
        educador.groups.add(Group.objects.create(name='Educadores'))
        administrador = criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)

        migracao = import_module('contas.migrations.0012_educadores_viram_alunos')
        migracao.educadores_viram_alunos(apps, None)

        educador = recarregar(educador)
        self.assertFalse(educador.is_staff)
        self.assertEqual(educador.perfil.tipo_usuario, PerfilUsuario.ALUNO)
        self.assertFalse(Group.objects.filter(name='Educadores').exists())
        self.assertTrue(recarregar(administrador).is_staff)


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
        self.aluno = criar_usuario('aluno')
        self.outro_aluno = criar_usuario('aluno2')

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

    def test_principal_despromove_administrador(self):
        self.executar(self.principal, 'definir_como_aluno', self.administrador)
        administrador = recarregar(self.administrador)
        self.assertEqual(administrador.perfil.tipo_usuario, PerfilUsuario.ALUNO)
        self.assertFalse(administrador.is_staff)

    def test_administrador_comum_nao_altera_perfil(self):
        self.executar(self.administrador, 'definir_como_administrador', self.aluno)
        self.executar(self.administrador, 'definir_como_aluno', self.outro_administrador)
        self.assertEqual(recarregar(self.aluno).perfil.tipo_usuario, PerfilUsuario.ALUNO)
        self.assertEqual(recarregar(self.outro_administrador).perfil.tipo_usuario, PerfilUsuario.ADMINISTRADOR)

    def test_administrador_comum_desativa_e_ativa_alunos(self):
        self.executar(self.administrador, 'desativar_contas', self.aluno, self.outro_aluno)
        self.assertFalse(recarregar(self.aluno).is_active)
        self.assertFalse(recarregar(self.outro_aluno).is_active)

        self.executar(self.administrador, 'ativar_contas', self.aluno, self.outro_aluno)
        self.assertTrue(recarregar(self.aluno).is_active)
        self.assertTrue(recarregar(self.outro_aluno).is_active)

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

    def test_aluno_nao_entra_no_painel(self):
        self.client.force_login(self.aluno)
        resposta = self.client.get(reverse('admin:auth_user_changelist'))
        self.assertEqual(resposta.status_code, 302)

    def test_lista_mostra_perfil_e_situacao(self):
        self.client.force_login(self.principal)
        resposta = self.client.get(reverse('admin:auth_user_changelist'))
        self.assertContains(resposta, 'Administrador')
        self.assertContains(resposta, 'Ativo')
        self.assertContains(resposta, 'Definir como Administrador')
        self.assertNotContains(resposta, 'Educador')


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


class ExclusaoDeContasDesativadasTests(TestCase):
    def setUp(self):
        self.principal = criar_usuario('chefe')
        tornar_principal(self.principal)
        self.principal = recarregar(self.principal)
        self.aluno = criar_usuario('aluno')

    def desativar(self, *alvos):
        self.client.force_login(self.principal)
        return self.client.post(reverse('admin:auth_user_changelist'), {
            'action': 'desativar_contas',
            '_selected_action': [str(alvo.pk) for alvo in alvos],
            'index': '0',
            'select_across': '0',
        }, follow=True)

    def desativada_ha(self, usuario, dias):
        User.objects.filter(pk=usuario.pk).update(is_active=False)
        PerfilUsuario.objects.filter(usuario=usuario).update(
            desativada_em=timezone.now() - timedelta(days=dias)
        )

    def test_desativar_guarda_a_data_e_avisa_o_prazo(self):
        resposta = self.desativar(self.aluno)
        self.assertIsNotNone(recarregar(self.aluno).perfil.desativada_em)
        self.assertContains(resposta, 'excluídas em definitivo depois de 6 meses')
        self.assertContains(resposta, 'Inativo, excluído em')

    def test_reativar_cancela_a_exclusao(self):
        self.desativar(self.aluno)
        self.client.post(reverse('admin:auth_user_changelist'), {
            'action': 'ativar_contas',
            '_selected_action': [str(self.aluno.pk)],
            'index': '0',
            'select_across': '0',
        })
        self.assertIsNone(recarregar(self.aluno).perfil.desativada_em)

    def test_exclui_so_depois_de_180_dias(self):
        quase = criar_usuario('quase')
        self.desativada_ha(quase, 179)
        self.desativada_ha(self.aluno, 181)
        ativo = criar_usuario('ativo')

        self.assertEqual(excluir_contas_desativadas(), ['aluno'])
        self.assertFalse(User.objects.filter(username='aluno').exists())
        self.assertTrue(User.objects.filter(pk=quase.pk).exists())
        self.assertTrue(User.objects.filter(pk=ativo.pk).exists())

    def test_abrir_o_painel_roda_a_limpeza(self):
        self.desativada_ha(self.aluno, 200)
        self.client.force_login(self.principal)
        self.client.get(reverse('admin:index'))
        self.assertFalse(User.objects.filter(pk=self.aluno.pk).exists())

    def test_comando_manual(self):
        self.desativada_ha(self.aluno, 200)
        saida = StringIO()
        call_command('excluir_contas_desativadas', stdout=saida)
        self.assertIn('aluno', saida.getvalue())
        self.assertFalse(User.objects.filter(pk=self.aluno.pk).exists())

    def test_migracao_marca_as_contas_que_ja_estavam_desativadas(self):
        User.objects.filter(pk=self.aluno.pk).update(is_active=False)
        migracao = import_module('contas.migrations.0015_marcar_contas_ja_desativadas')
        migracao.marcar_contas_ja_desativadas(apps, None)
        self.assertIsNotNone(recarregar(self.aluno).perfil.desativada_em)
        self.assertIsNone(recarregar(self.principal).perfil.desativada_em)


class LogsTests(TestCase):
    def test_so_administradores_veem_os_logs(self):
        self.client.force_login(criar_usuario('aluno'))
        self.assertEqual(self.client.get(reverse('logs')).status_code, 403)

        self.client.force_login(criar_usuario('adm', PerfilUsuario.ADMINISTRADOR))
        self.assertEqual(self.client.get(reverse('logs')).status_code, 200)


def dados_cadastro(**extras):
    dados = {
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

    def test_cadastro_nao_tem_mais_opcao_de_educador(self):
        resposta = self.client.get(reverse('cadastro'))
        self.assertNotContains(resposta, 'Educador')
        self.assertNotContains(resposta, 'convite')

    def test_campos_antigos_de_educador_sao_ignorados(self):
        self.client.post(reverse('cadastro'), dados_cadastro(tipo_conta='educador', codigo_convite='ABCDEFGH'))
        novo = recarregar(User.objects.get(username='novo'))
        self.assertEqual(novo.perfil.tipo_usuario, PerfilUsuario.ALUNO)
        self.assertFalse(novo.is_staff)


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

    def test_aluno_nao_altera_o_mfa(self):
        configuracao = ConfiguracaoSite.atual()
        self.client.force_login(criar_usuario('aluno'))
        url = reverse('admin:contas_configuracaosite_change', args=[configuracao.pk])
        self.assertEqual(self.client.get(url).status_code, 302)
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

    def test_administrador_tambem_ve_o_perfil(self):
        self.client.force_login(criar_usuario('adm', PerfilUsuario.ADMINISTRADOR))
        resposta = self.client.get(self.url)
        self.assertContains(resposta, 'Administrador')

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
        self.client.force_login(criar_usuario('aluno'))
        self.assertEqual(self.client.get(reverse('logs_detalhados')).status_code, 403)


class PermissoesEmPortuguesTests(TestCase):
    def test_nomes_traduzidos(self):
        from django.contrib.auth.models import Permission
        self.assertEqual(Permission.objects.get(codename='add_atividade').name, 'Pode adicionar Atividade')
        self.assertFalse(Permission.objects.filter(name__startswith='Can ').exists())



class CodigoDeVerificacaoTests(TestCase):
    def setUp(self):
        self.usuario = criar_usuario('aluno')
        self.client.post(reverse('login'), {'username': 'aluno', 'password': SENHA})

    def codigo_enviado(self):
        return CodigoVerificacao.objects.filter(usuario=self.usuario).latest('criado_em')

    def test_reenviar_gera_um_codigo_novo(self):
        primeiro = self.codigo_enviado()
        resposta = self.client.get(reverse('reenviar_codigo'), follow=True)
        self.assertRedirects(resposta, reverse('verificar_codigo'))
        self.assertContains(resposta, 'Um novo código foi enviado')
        self.assertEqual(len(mail.outbox), 2)
        self.assertNotEqual(self.codigo_enviado().pk, primeiro.pk)

    def test_reenviar_sem_passar_pelo_login_volta_para_o_login(self):
        self.client.logout()
        resposta = self.client.get(reverse('reenviar_codigo'))
        self.assertRedirects(resposta, reverse('login'))

    def test_tela_do_codigo_sem_login_volta_para_o_login(self):
        self.client.logout()
        self.assertRedirects(self.client.get(reverse('verificar_codigo')), reverse('login'))
        self.assertRedirects(self.client.post(reverse('verificar_codigo'), {'codigo': '123456'}), reverse('login'))

    def test_codigo_errado_nao_entra(self):
        certo = self.codigo_enviado().codigo
        errado = '000000' if certo != '000000' else '111111'
        resposta = self.client.post(reverse('verificar_codigo'), {'codigo': errado})
        self.assertContains(resposta, 'Código inválido ou expirado.')
        self.assertNotIn('_auth_user_id', self.client.session)

    def test_codigo_expirado_nao_entra(self):
        codigo = self.codigo_enviado()
        CodigoVerificacao.objects.filter(pk=codigo.pk).update(criado_em=timezone.now() - timedelta(minutes=6))
        resposta = self.client.post(reverse('verificar_codigo'), {'codigo': codigo.codigo})
        self.assertContains(resposta, 'Código inválido ou expirado.')
        self.assertNotIn('_auth_user_id', self.client.session)

    def test_conta_desativada_durante_o_login_nao_entra(self):
        codigo = self.codigo_enviado().codigo
        User.objects.filter(pk=self.usuario.pk).update(is_active=False)
        resposta = self.client.post(reverse('verificar_codigo'), {'codigo': codigo}, follow=True)
        self.assertRedirects(resposta, reverse('login'))
        self.assertContains(resposta, 'Sua conta está desativada.')

    def test_conta_sem_email_nao_recebe_codigo(self):
        sem_email = User.objects.create_user('sememail', '', SENHA)
        resposta = self.client.post(reverse('login'), {'username': 'sememail', 'password': SENHA})
        self.assertContains(resposta, 'não possui e-mail cadastrado')
        self.assertFalse(CodigoVerificacao.objects.filter(usuario=sem_email).exists())


class PaginasDaContaTests(TestCase):
    def test_termos_de_uso_abre(self):
        resposta = self.client.get(reverse('termos_de_uso'))
        self.assertEqual(resposta.status_code, 200)
        self.assertContains(resposta, 'Termos de Uso')

    def test_politica_de_privacidade_abre(self):
        resposta = self.client.get(reverse('politica_de_privacidade'))
        self.assertEqual(resposta.status_code, 200)
        self.assertContains(resposta, 'Política de Privacidade')

    def test_sair_encerra_a_sessao(self):
        self.client.force_login(criar_usuario('aluno'))
        resposta = self.client.get(reverse('logout'), follow=True)
        self.assertRedirects(resposta, reverse('pagina_inicial'))
        self.assertContains(resposta, 'Você saiu da sua conta com sucesso!')
        self.assertNotIn('_auth_user_id', self.client.session)
