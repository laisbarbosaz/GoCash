from unittest.mock import patch

import requests
from django.contrib.auth.models import User
from django.test import TestCase
from django.urls import reverse

from atividades.models import Alternativa, Atividade, Pergunta, ProgressoAtividade, Resposta, Tentativa
from contas.models import PerfilUsuario
from contas.papeis import definir_perfil
from modulos.models import Modulo

from .dashboards import minhas_atividades, painel_administrador, ranking

SENHA = 'SenhaForte!123'
sem_cotacoes = patch('home.cotacoes.requests.get', side_effect=requests.RequestException)


def criar_atividade(nome):
    modulo = Modulo.objects.create(nome_modulo=nome, descricao_modulo='x')
    atividade = Atividade.objects.create(modulo=modulo, titulo=f'Quiz {nome}')
    for ordem in range(10):
        pergunta = Pergunta.objects.create(atividade=atividade, enunciado=f'Pergunta {ordem}')
        Alternativa.objects.create(pergunta=pergunta, texto='Certa', correta=True)
        Alternativa.objects.create(pergunta=pergunta, texto='Errada', correta=False)
    return atividade


def enviar(usuario, atividade, acertos, numero=1):
    Tentativa.objects.create(usuario=usuario, atividade=atividade, numero=numero, acertos=acertos, total_perguntas=10)
    progresso, _ = ProgressoAtividade.objects.get_or_create(usuario=usuario, atividade=atividade)
    progresso.marcar_concluida()


def criar_usuario(nome, tipo=PerfilUsuario.ALUNO):
    usuario = User.objects.create_user(nome, f'{nome}@teste.com', SENHA)
    if tipo != PerfilUsuario.ALUNO:
        definir_perfil(usuario, tipo)
    return User.objects.get(pk=usuario.pk)


def errar(usuario, atividade, perguntas_erradas, numero=1):
    perguntas = list(atividade.perguntas.prefetch_related('alternativas'))
    tentativa = Tentativa.objects.create(
        usuario=usuario, atividade=atividade, numero=numero,
        acertos=len(perguntas) - len(perguntas_erradas), total_perguntas=len(perguntas),
    )
    for indice, pergunta in enumerate(perguntas):
        certo = indice not in perguntas_erradas
        alternativa = next(a for a in pergunta.alternativas.all() if a.correta == certo)
        Resposta.objects.create(tentativa=tentativa, pergunta=pergunta, alternativa=alternativa, correta=certo)
    progresso, _ = ProgressoAtividade.objects.get_or_create(usuario=usuario, atividade=atividade)
    progresso.marcar_concluida()


def participar_do_ranking(usuario):
    PerfilUsuario.objects.filter(usuario=usuario).update(aparecer_no_ranking=True)


class MinhasAtividadesTests(TestCase):
    def setUp(self):
        self.aluno = criar_usuario('aluno')
        self.dividas = criar_atividade('Dívidas')
        self.cartao = criar_atividade('Cartão')

    def test_numeros_usam_a_melhor_tentativa(self):
        enviar(self.aluno, self.dividas, 7)
        enviar(self.aluno, self.dividas, 9, numero=2)
        ProgressoAtividade.objects.create(usuario=self.aluno, atividade=self.cartao)
        painel = minhas_atividades(self.aluno)
        self.assertEqual(painel['cashs'], 90)
        self.assertEqual(painel['concluidas'], 1)
        self.assertEqual(painel['em_andamento'], 1)
        self.assertEqual(painel['total_atividades'], 2)
        self.assertEqual(painel['tentativas'], 2)
        linha = next(l for l in painel['linhas'] if l['atividade'] == self.dividas)
        self.assertEqual((linha['cashs'], linha['tentativas'], linha['pode_tentar']), (90, 2, True))

    def test_maiores_dificuldades(self):
        errar(self.aluno, self.dividas, {0, 1})
        errar(self.aluno, self.dividas, {0}, numero=2)
        dificuldades = minhas_atividades(self.aluno)['dificuldades']
        self.assertEqual(dificuldades[0]['enunciado'], 'Pergunta 0')
        self.assertEqual(dificuldades[0]['vezes'], 2)
        self.assertEqual(dificuldades[1]['vezes'], 1)

    def test_aluno_que_ainda_nao_fez_nada(self):
        painel = minhas_atividades(self.aluno)
        self.assertEqual(painel['cashs'], 0)
        self.assertEqual(painel['dificuldades'], [])

    @sem_cotacoes
    def test_painel_vem_antes_do_ranking(self, _):
        self.client.force_login(self.aluno)
        html = self.client.get(reverse('pagina_inicial')).content.decode()
        self.assertLess(html.index('Olá, '), html.index('Minhas atividades'))
        self.assertLess(html.index('Minhas atividades'), html.index('Ranking de Cashs'))

    @sem_cotacoes
    def test_visitante_ve_como_funciona_e_convite_para_cadastro(self, _):
        resposta = self.client.get(reverse('pagina_inicial'))
        self.assertContains(resposta, 'Como funciona')
        self.assertContains(resposta, 'Criar conta grátis')
        self.assertContains(resposta, reverse('cadastro'))
        self.client.force_login(self.aluno)
        resposta = self.client.get(reverse('pagina_inicial'))
        self.assertNotContains(resposta, 'Como funciona')
        self.assertNotContains(resposta, 'Criar conta grátis')

    @sem_cotacoes
    def test_visitante_e_equipe_nao_veem_minhas_atividades(self, _):
        self.assertNotContains(self.client.get(reverse('pagina_inicial')), 'Minhas atividades')
        self.client.force_login(criar_usuario('adm', PerfilUsuario.ADMINISTRADOR))
        self.assertNotContains(self.client.get(reverse('pagina_inicial')), 'Minhas atividades')


class RankingTests(TestCase):
    def setUp(self):
        self.atividade = criar_atividade('Dívidas')
        self.outra = criar_atividade('Cartão')

    def aluno_com(self, nome, *acertos, participa=True):
        aluno = criar_usuario(nome)
        if participa:
            participar_do_ranking(aluno)
        for atividade, quantidade in zip([self.atividade, self.outra], acertos):
            enviar(aluno, atividade, quantidade)
        return aluno

    def test_ordena_por_cashs_e_mostra_so_quem_participa(self):
        self.aluno_com('ana', 9, 9)
        self.aluno_com('bia', 10)
        self.aluno_com('caio', 10, 10, participa=False)
        linhas = ranking()['linhas']
        self.assertEqual([l['usuario'] for l in linhas], ['ana', 'bia'])
        self.assertEqual([l['cashs'] for l in linhas], [180, 100])

    def test_empate_divide_a_posicao(self):
        self.aluno_com('ana', 8)
        self.aluno_com('bia', 8)
        self.aluno_com('caio', 5)
        self.assertEqual([l['posicao'] for l in ranking()['linhas']], [1, 1, 3])

    def test_limite_de_dez_e_posicao_de_quem_ficou_fora(self):
        for numero in range(12):
            total = 12 - numero
            self.aluno_com(f'aluno{numero:02d}', min(10, total), max(0, total - 10))
        ultimo = User.objects.get(username='aluno10')
        resultado = ranking(ultimo)
        self.assertEqual(len(resultado['linhas']), 10)
        self.assertTrue(resultado['fora_do_top'])
        self.assertEqual(resultado['minha_linha']['posicao'], 11)

    def test_nome_publico_usa_inicial_do_sobrenome(self):
        aluno = self.aluno_com('mari', 7)
        User.objects.filter(pk=aluno.pk).update(first_name='Mariana', last_name='Souza')
        self.assertEqual(ranking()['linhas'][0]['nome'], 'Mariana S.')

    def test_equipe_e_contas_desativadas_ficam_de_fora(self):
        inativo = self.aluno_com('ana', 9)
        User.objects.filter(pk=inativo.pk).update(is_active=False)
        administrador = criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)
        participar_do_ranking(administrador)
        enviar(administrador, self.atividade, 10)
        self.assertEqual(ranking()['linhas'], [])

    @sem_cotacoes
    def test_visitante_ve_o_ranking(self, _):
        self.aluno_com('ana', 9)
        resposta = self.client.get(reverse('pagina_inicial'))
        self.assertContains(resposta, 'Ranking de Cashs')
        self.assertContains(resposta, '@ana')
        self.assertContains(resposta, 'Crie sua conta')

    @sem_cotacoes
    def test_aluno_fora_do_ranking_ve_onde_ativar(self, _):
        aluno = self.aluno_com('ana', 9, participa=False)
        self.client.force_login(aluno)
        resposta = self.client.get(reverse('pagina_inicial'))
        self.assertContains(resposta, 'Você não aparece no ranking')
        self.assertNotContains(resposta, '@ana')

    def test_aluno_ativa_e_desativa_no_perfil(self):
        aluno = criar_usuario('ana')
        self.client.force_login(aluno)
        self.client.post(reverse('meu_perfil'), {'acao': 'ranking', 'aparecer_no_ranking': 'on'})
        self.assertTrue(PerfilUsuario.objects.get(usuario=aluno).aparecer_no_ranking)
        self.client.post(reverse('meu_perfil'), {'acao': 'ranking'})
        self.assertFalse(PerfilUsuario.objects.get(usuario=aluno).aparecer_no_ranking)

    def test_ranking_comeca_desligado(self):
        self.assertFalse(PerfilUsuario.objects.get(usuario=criar_usuario('novo')).aparecer_no_ranking)


class PainelEquipeTests(TestCase):
    def setUp(self):
        self.dividas = criar_atividade('Dívidas')
        self.cartao = criar_atividade('Cartão')

        self.concluiu = criar_usuario('ana')
        enviar(self.concluiu, self.dividas, 8)
        self.abriu = criar_usuario('bruno')
        ProgressoAtividade.objects.create(usuario=self.abriu, atividade=self.dividas)
        self.nada = criar_usuario('carla')

        self.administrador = criar_usuario('adm', PerfilUsuario.ADMINISTRADOR)

    def test_numeros_de_engajamento(self):
        painel = painel_administrador()
        self.assertEqual(painel['alunos'], 3)
        self.assertEqual(painel['atividades'], 2)
        self.assertEqual(painel['taxa_conclusao'], 17)
        self.assertEqual(painel['cashs_total'], 80)
        self.assertEqual(painel['grafico_conclusao'], {
            'rotulos': ['Cartão', 'Dívidas'],
            'concluiram': [0, 1],
            'em_andamento': [0, 1],
            'nao_iniciaram': [3, 1],
        })
        self.assertEqual(painel['grafico_cashs']['valores'], [0, 80])

    def test_numeros_de_contas(self):
        self.nada.is_active = False
        self.nada.save()

        painel = painel_administrador()
        self.assertNotIn('educadores', painel)
        self.assertNotIn('convites_pendentes', painel)
        self.assertEqual(painel['contas_inativas'], 1)
        self.assertEqual(painel['alunos'], 2)
        self.assertEqual(len(painel['grafico_cadastros']['valores']), 6)
        self.assertEqual(painel['grafico_cadastros']['valores'][-1], User.objects.count())

    def test_administrador_ve_usuarios_e_engajamento(self):
        self.client.force_login(self.administrador)
        resposta = self.client.get(reverse('admin:index'))
        self.assertContains(resposta, 'Novos cadastros nos últimos 6 meses')
        self.assertContains(resposta, 'Situação dos alunos por módulo')
        self.assertContains(resposta, 'Cashs acumulados por módulo')
        self.assertContains(resposta, 'Contas desativadas')
        self.assertNotContains(resposta, 'Educador')
        self.assertNotContains(resposta, 'Convite')


class CotacoesNoModuloTests(TestCase):
    def setUp(self):
        from django.core.cache import cache
        cache.clear()
        self.modulo = Modulo.objects.create(
            nome_modulo='Economia Global', descricao_modulo='x', slug='economia-global',
        )
        self.resposta_api = {
            'USDBRL': {
                'name': 'Dólar Americano/Real Brasileiro', 'code': 'USD', 'bid': '5.4321', 'ask': '5.4400',
                'high': '5.5000', 'low': '5.4000', 'pctChange': '-0.35', 'create_date': '2026-11-06 15:00:00',
            },
        }

    def api_ok(self):
        resposta = patch('home.cotacoes.requests.get').start()
        self.addCleanup(patch.stopall)
        resposta.return_value.json.return_value = self.resposta_api
        resposta.return_value.raise_for_status.return_value = None
        return resposta

    def test_modulo_marcado_mostra_a_tabela(self):
        self.api_ok()
        resposta = self.client.get(reverse('detalhe_modulo', args=[self.modulo.slug]))
        self.assertContains(resposta, 'Cotações agora')
        self.assertContains(resposta, 'R$ 5,43')
        self.assertContains(resposta, '06/11/2026 às 15:00')

    def test_modulo_comum_nao_chama_a_api(self):
        outro = Modulo.objects.create(nome_modulo='Orçamento', descricao_modulo='x')
        chamada = self.api_ok()
        resposta = self.client.get(reverse('detalhe_modulo', args=[outro.slug]))
        self.assertNotContains(resposta, 'Cotações agora')
        chamada.assert_not_called()

    def test_api_fora_do_ar_mostra_aviso(self):
        with patch('home.cotacoes.requests.get', side_effect=requests.RequestException):
            resposta = self.client.get(reverse('detalhe_modulo', args=[self.modulo.slug]))
        self.assertContains(resposta, 'Não foi possível carregar as cotações')

    def test_pagina_inicial_convida_para_o_modulo_de_cotacoes(self):
        self.api_ok()
        resposta = self.client.get(reverse('pagina_inicial'))
        self.assertContains(resposta, 'Moedas hoje')
        self.assertContains(resposta, '<strong>Dólar</strong> R$ 5,43')
        self.assertContains(resposta, reverse('detalhe_modulo', args=[self.modulo.slug]))
        self.assertNotContains(resposta, 'Cotações agora')

    def test_pagina_inicial_sem_api_continua_com_o_convite(self):
        with patch('home.cotacoes.requests.get', side_effect=requests.RequestException):
            resposta = self.client.get(reverse('pagina_inicial'))
        self.assertContains(resposta, 'Moedas hoje')
        self.assertNotContains(resposta, '<strong>Dólar</strong>')
        self.assertContains(resposta, reverse('detalhe_modulo', args=[self.modulo.slug]))

    def test_cadastro_de_modulo_nao_tem_mais_a_opcao_de_cotacoes(self):
        self.client.force_login(criar_usuario('adm', PerfilUsuario.ADMINISTRADOR))
        resposta = self.client.get(reverse('admin:modulos_modulo_add'))
        self.assertEqual(resposta.status_code, 200)
        self.assertNotContains(resposta, 'Mostrar cotações')

    def test_sem_modulo_de_cotacoes_a_home_nao_chama_a_api(self):
        self.modulo.delete()
        chamada = self.api_ok()
        resposta = self.client.get(reverse('pagina_inicial'))
        self.assertNotContains(resposta, 'Moedas hoje')
        chamada.assert_not_called()

    def test_pagina_inicial_indica_por_onde_comecar(self):
        self.api_ok()
        Modulo.objects.create(nome_modulo='Entendendo o seu Orçamento', descricao_modulo='x', slug='entendendo-o-seu-orcamento')
        resposta = self.client.get(reverse('pagina_inicial'))
        self.assertContains(resposta, 'Por onde começar')
        self.assertContains(resposta, reverse('detalhe_modulo', args=['entendendo-o-seu-orcamento']))

    def test_cotacao_fica_guardada_por_alguns_minutos(self):
        chamada = self.api_ok()
        self.client.get(reverse('detalhe_modulo', args=[self.modulo.slug]))
        self.client.get(reverse('detalhe_modulo', args=[self.modulo.slug]))
        self.assertEqual(chamada.call_count, 1)


class QuemSomosTests(TestCase):
    @sem_cotacoes
    def test_pagina_abre_e_aparece_no_menu(self, _):
        resposta = self.client.get(reverse('quem_somos'))
        self.assertNotContains(resposta, 'educador')
        self.assertContains(resposta, 'mailto:gocashsuporte@gmail.com')
        self.assertContains(self.client.get(reverse('pagina_inicial')), reverse('quem_somos'))

    def test_link_tambem_no_painel(self):
        self.client.force_login(criar_usuario('adm', PerfilUsuario.ADMINISTRADOR))
        self.assertContains(self.client.get(reverse('admin:index')), reverse('quem_somos'))
