from django.contrib.auth.models import User
from django.test import TestCase
from django.urls import reverse

from contas.models import CodigoVerificacao
from modulos.models import Modulo

from .cashs import cashs_da_nota, saldo_de_cashs
from .models import Alternativa, Atividade, AtividadeAberta, Pergunta, Tentativa


def criar_atividade(qtd_perguntas=3):
    """Cria um módulo com uma atividade e N perguntas; em cada uma a 1ª alternativa é a correta."""
    modulo = Modulo.objects.create(nome_modulo='Orçamento', descricao_modulo='Teste')
    atividade = Atividade.objects.create(modulo=modulo, titulo='Quiz de Orçamento')
    for i in range(1, qtd_perguntas + 1):
        pergunta = Pergunta.objects.create(atividade=atividade, enunciado=f'Pergunta {i}?', ordem=i)
        Alternativa.objects.create(pergunta=pergunta, texto='Certa', correta=True)
        Alternativa.objects.create(pergunta=pergunta, texto='Errada', correta=False)
    return atividade


def montar_respostas(atividade, acertos):
    """Monta o POST acertando as primeiras `acertos` perguntas e errando o resto."""
    dados = {}
    for indice, pergunta in enumerate(atividade.perguntas.all()):
        correta = indice < acertos
        alternativa = pergunta.alternativas.get(correta=correta)
        dados[f'pergunta_{pergunta.id}'] = alternativa.id
    return dados


class AcessoTests(TestCase):
    def setUp(self):
        self.atividade = criar_atividade()

    def test_visitante_sem_login_vai_para_o_login(self):
        for url in [
            reverse('listar_atividades'),
            reverse('responder_atividade', args=[self.atividade.modulo.slug]),
        ]:
            resposta = self.client.get(url)
            self.assertEqual(resposta.status_code, 302)
            self.assertIn('/conta/login/', resposta['Location'])
            self.assertIn('next=', resposta['Location'])

    def test_usuario_logado_ve_a_lista(self):
        usuario = User.objects.create_user('aluno', 'aluno@teste.com', 'SenhaForte!123')
        self.client.force_login(usuario)
        resposta = self.client.get(reverse('listar_atividades'))
        self.assertEqual(resposta.status_code, 200)
        self.assertContains(resposta, 'Quiz de Orçamento')

    def test_atividade_sem_perguntas_nao_aparece(self):
        modulo = Modulo.objects.create(nome_modulo='Vazio', descricao_modulo='x')
        Atividade.objects.create(modulo=modulo, titulo='Atividade vazia')
        usuario = User.objects.create_user('aluno', 'aluno@teste.com', 'SenhaForte!123')
        self.client.force_login(usuario)
        resposta = self.client.get(reverse('listar_atividades'))
        self.assertNotContains(resposta, 'Atividade vazia')


class ResponderTests(TestCase):
    def setUp(self):
        self.usuario = User.objects.create_user('aluno', 'aluno@teste.com', 'SenhaForte!123')
        self.client.force_login(self.usuario)

    def test_ca01_10_perguntas_7_acertos_registra_70_por_cento(self):
        atividade = criar_atividade(qtd_perguntas=10)
        url = reverse('responder_atividade', args=[atividade.modulo.slug])
        resposta = self.client.post(url, montar_respostas(atividade, acertos=7))

        tentativa = Tentativa.objects.get(usuario=self.usuario, atividade=atividade)
        self.assertEqual(tentativa.acertos, 7)
        self.assertEqual(tentativa.total_perguntas, 10)
        self.assertEqual(tentativa.aproveitamento, 70)
        self.assertRedirects(resposta, reverse('resultado_atividade', args=[atividade.modulo.slug, tentativa.numero]))

    def test_bloqueia_a_quarta_tentativa(self):
        atividade = criar_atividade()
        url = reverse('responder_atividade', args=[atividade.modulo.slug])
        for _ in range(Atividade.MAX_TENTATIVAS):
            self.client.post(url, montar_respostas(atividade, acertos=1))

        resposta = self.client.post(url, montar_respostas(atividade, acertos=3))
        self.assertRedirects(resposta, reverse('listar_atividades'))
        self.assertEqual(Tentativa.objects.filter(usuario=self.usuario).count(), Atividade.MAX_TENTATIVAS)

    def test_nao_registra_se_faltar_resposta(self):
        atividade = criar_atividade()
        dados = montar_respostas(atividade, acertos=3)
        dados.pop(next(iter(dados)))
        resposta = self.client.post(reverse('responder_atividade', args=[atividade.modulo.slug]), dados)
        self.assertEqual(resposta.status_code, 200)
        self.assertEqual(Tentativa.objects.count(), 0)

    def test_nao_aceita_alternativa_de_outra_pergunta(self):
        atividade = criar_atividade(qtd_perguntas=2)
        p1, p2 = atividade.perguntas.all()
        dados = {
            f'pergunta_{p1.id}': p2.alternativas.get(correta=True).id,
            f'pergunta_{p2.id}': p2.alternativas.get(correta=True).id,
        }
        self.client.post(reverse('responder_atividade', args=[atividade.modulo.slug]), dados)
        self.assertEqual(Tentativa.objects.count(), 0)

    def test_usuario_nao_ve_resultado_de_outro(self):
        atividade = criar_atividade()
        self.client.post(reverse('responder_atividade', args=[atividade.modulo.slug]), montar_respostas(atividade, 2))
        tentativa = Tentativa.objects.get()

        outro = User.objects.create_user('outro', 'outro@teste.com', 'SenhaForte!123')
        self.client.force_login(outro)
        resposta = self.client.get(reverse('resultado_atividade', args=[atividade.modulo.slug, tentativa.numero]))
        self.assertEqual(resposta.status_code, 404)

    def test_gabarito_so_aparece_depois_da_ultima_tentativa(self):
        atividade = criar_atividade(qtd_perguntas=1)
        url = reverse('responder_atividade', args=[atividade.modulo.slug])

        self.client.post(url, montar_respostas(atividade, acertos=0))
        primeira = Tentativa.objects.latest('id')
        resposta = self.client.get(reverse('resultado_atividade', args=[atividade.modulo.slug, primeira.numero]))
        self.assertNotContains(resposta, 'Resposta correta:')

        self.client.post(url, montar_respostas(atividade, acertos=0))
        self.client.post(url, montar_respostas(atividade, acertos=0))
        ultima = Tentativa.objects.latest('id')
        resposta = self.client.get(reverse('resultado_atividade', args=[atividade.modulo.slug, ultima.numero]))
        self.assertContains(resposta, 'Resposta correta:')


class VoltarDepoisDoLoginTests(TestCase):
    def test_depois_do_2fa_volta_para_a_pagina_pedida(self):
        User.objects.create_user('aluno', 'aluno@teste.com', 'SenhaForte!123')
        destino = reverse('listar_atividades')

        resposta = self.client.post(
            reverse('login') + f'?next={destino}',
            {'username': 'aluno', 'password': 'SenhaForte!123'},
        )
        self.assertRedirects(resposta, reverse('verificar_codigo'))

        codigo = CodigoVerificacao.objects.latest('criado_em').codigo
        resposta = self.client.post(reverse('verificar_codigo'), {'codigo': codigo})
        self.assertRedirects(resposta, destino)

    def test_ignora_next_para_outro_site(self):
        User.objects.create_user('aluno', 'aluno@teste.com', 'SenhaForte!123')
        self.client.post(
            reverse('login') + '?next=https://site-malicioso.com/',
            {'username': 'aluno', 'password': 'SenhaForte!123'},
        )
        codigo = CodigoVerificacao.objects.latest('criado_em').codigo
        resposta = self.client.post(reverse('verificar_codigo'), {'codigo': codigo})
        self.assertRedirects(resposta, '/', fetch_redirect_response=False)


class StatusDaAtividadeTests(TestCase):
    """RF05: a etiqueta mostrada para o aluno deve refletir o que ele já fez."""

    def setUp(self):
        self.usuario = User.objects.create_user('aluno', 'aluno@teste.com', 'SenhaForte!123')
        self.client.force_login(self.usuario)
        self.atividade = criar_atividade()

    def _item_na_lista(self):
        resposta = self.client.get(reverse('listar_atividades'))
        return next(i for i in resposta.context['itens'] if i['atividade'].id == self.atividade.id)

    def test_nao_iniciado_quando_nunca_abriu(self):
        item = self._item_na_lista()
        self.assertFalse(item['em_andamento'])
        self.assertEqual(item['tentativas_feitas'], 0)

    def test_em_andamento_quando_abriu_e_nao_enviou(self):
        self.client.get(reverse('responder_atividade', args=[self.atividade.modulo.slug]))
        item = self._item_na_lista()
        self.assertTrue(item['em_andamento'])
        self.assertEqual(item['tentativas_feitas'], 0)

    def test_concluida_quando_enviou_mesmo_com_tentativas_sobrando(self):
        self.client.post(
            reverse('responder_atividade', args=[self.atividade.modulo.slug]),
            montar_respostas(self.atividade, acertos=2),
        )
        item = self._item_na_lista()
        self.assertEqual(item['tentativas_feitas'], 1)
        self.assertFalse(item['em_andamento'])
        # Mesmo enviada, a marca de "aberta" dessa tentativa não deve sobrar no banco
        self.assertFalse(
            AtividadeAberta.objects.filter(usuario=self.usuario, atividade=self.atividade).exists()
        )


class CashsTests(TestCase):
    """RF06: cada 10% de acerto = 10 Cashs, e só a melhor nota de cada atividade conta."""

    def setUp(self):
        self.usuario = User.objects.create_user('aluno', 'aluno@teste.com', 'SenhaForte!123')
        self.client.force_login(self.usuario)

    def _responder(self, atividade, acertos):
        self.client.post(
            reverse('responder_atividade', args=[atividade.modulo.slug]),
            montar_respostas(atividade, acertos),
        )

    def test_conversao_so_conta_a_cada_10_por_cento(self):
        self.assertEqual(cashs_da_nota(100), 100)
        self.assertEqual(cashs_da_nota(75), 70)
        self.assertEqual(cashs_da_nota(9), 0)

    def test_so_a_melhor_nota_conta(self):
        atividade = criar_atividade(qtd_perguntas=10)
        self._responder(atividade, acertos=7)   # 70%
        self._responder(atividade, acertos=5)   # 50%, nota pior: não muda o saldo
        self.assertEqual(saldo_de_cashs(self.usuario), 70)

        self._responder(atividade, acertos=9)   # 90%, nota melhor: passa a valer esta
        self.assertEqual(saldo_de_cashs(self.usuario), 90)

    def test_soma_as_melhores_notas_de_atividades_diferentes(self):
        primeira = criar_atividade(qtd_perguntas=10)
        segunda = criar_atividade(qtd_perguntas=10)
        self._responder(primeira, acertos=8)    # 80
        self._responder(segunda, acertos=10)    # 100
        self.assertEqual(saldo_de_cashs(self.usuario), 180)

    def test_saldo_aparece_no_menu(self):
        atividade = criar_atividade(qtd_perguntas=10)
        self._responder(atividade, acertos=7)
        resposta = self.client.get(reverse('listar_atividades'))
        self.assertContains(resposta, '70 Cashs')

    def test_visitante_nao_ve_cashs(self):
        self.client.logout()
        resposta = self.client.get(reverse('listar_modulos'))  # página aberta, sem chamada à API de cotações
        self.assertNotContains(resposta, 'Cashs')


class EnderecosSemIdTests(TestCase):
    """As URLs usam o nome do módulo e o número da tentativa do aluno, nunca o id do banco."""

    def setUp(self):
        self.usuario = User.objects.create_user('aluno', 'aluno@teste.com', 'SenhaForte!123')
        self.client.force_login(self.usuario)

    def test_slug_gerado_a_partir_do_nome(self):
        modulo = Modulo.objects.create(nome_modulo='Controles e Dívidas', descricao_modulo='x')
        self.assertEqual(modulo.slug, 'controles-e-dividas')
        self.assertEqual(reverse('detalhe_modulo', args=[modulo.slug]), '/modulos/controles-e-dividas/')

    def test_nomes_repetidos_geram_enderecos_diferentes(self):
        primeiro = Modulo.objects.create(nome_modulo='Orçamento', descricao_modulo='x')
        segundo = Modulo.objects.create(nome_modulo='Orçamento', descricao_modulo='x')
        self.assertEqual(primeiro.slug, 'orcamento')
        self.assertEqual(segundo.slug, 'orcamento-2')

    def test_resultado_usa_numero_da_tentativa_do_aluno(self):
        atividade = criar_atividade()
        resposta = self.client.post(
            reverse('responder_atividade', args=[atividade.modulo.slug]),
            montar_respostas(atividade, acertos=2),
        )
        self.assertEqual(resposta['Location'], f'/atividades/{atividade.modulo.slug}/resultado/1/')

    def test_pagina_do_modulo_abre_pelo_slug(self):
        modulo = Modulo.objects.create(nome_modulo='Consumo Consciente', descricao_modulo='x')
        resposta = self.client.get('/modulos/consumo-consciente/')
        self.assertEqual(resposta.status_code, 200)
        self.assertContains(resposta, 'Consumo Consciente')

    def test_endereco_antigo_com_numero_nao_funciona_mais(self):
        modulo = Modulo.objects.create(nome_modulo='Investimentos', descricao_modulo='x')
        resposta = self.client.get(f'/modulos/modulos/{modulo.id}/')
        self.assertEqual(resposta.status_code, 404)
