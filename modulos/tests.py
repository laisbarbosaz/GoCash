from unittest.mock import patch

from django.contrib.auth.models import User
from django.test import TestCase
from django.urls import reverse

from atividades.models import Alternativa, Atividade, Pergunta, Tentativa
from contas.models import CodigoVerificacao

from .leitura import leu_tudo
from .models import ConteudoModulo, LeituraConteudo, Modulo


def criar_modulo_com_partes(quantidade=3):
    modulo = Modulo.objects.create(nome_modulo='Orçamento', descricao_modulo='Como montar um orçamento')
    for numero in range(1, quantidade + 1):
        ConteudoModulo.objects.create(
            modulo=modulo,
            titulo_conteudo=f'Parte {numero}: título',
            explicacao_conteudo=f'Texto da parte {numero}.',
        )
    atividade = Atividade.objects.create(modulo=modulo, titulo='Quiz de Orçamento')
    pergunta = Pergunta.objects.create(atividade=atividade, enunciado='Pergunta?')
    Alternativa.objects.create(pergunta=pergunta, texto='Certa', correta=True)
    Alternativa.objects.create(pergunta=pergunta, texto='Errada', correta=False)
    return modulo


@patch('modulos.views.buscar_cotacoes', return_value=([], False))
class LeituraEmPartesTests(TestCase):
    def setUp(self):
        self.modulo = criar_modulo_com_partes()
        self.url = reverse('detalhe_modulo', args=[self.modulo.slug])
        self.aluno = User.objects.create_user('aluno', 'aluno@teste.com', 'SenhaForte!123')

    def ler(self, numero):
        return self.client.get(self.url, {'parte': numero})

    def test_mostra_uma_parte_por_vez(self, _):
        resposta = self.client.get(self.url)
        self.assertContains(resposta, 'Parte 1 de 3')
        self.assertContains(resposta, 'Texto da parte 1.')
        self.assertNotContains(resposta, 'Texto da parte 2.')
        self.assertContains(resposta, 'Próxima parte')
        self.assertNotContains(resposta, 'Parte anterior')

    def test_nao_pula_partes(self, _):
        self.client.force_login(self.aluno)
        self.ler(1)
        resposta = self.ler(3)
        self.assertRedirects(resposta, f'{self.url}?parte=2', fetch_redirect_response=False)

    def test_visitante_tambem_segue_a_ordem(self, _):
        resposta = self.ler(2)
        self.assertRedirects(resposta, f'{self.url}?parte=1', fetch_redirect_response=False)
        self.ler(1)
        self.assertContains(self.ler(2), 'Texto da parte 2.')

    def test_parte_fora_do_intervalo_volta_para_um_numero_valido(self, _):
        self.assertContains(self.client.get(self.url, {'parte': 'abc'}), 'Parte 1 de 3')
        self.assertContains(self.client.get(self.url, {'parte': '-4'}), 'Parte 1 de 3')

    def test_atividade_libera_so_na_ultima_parte(self, _):
        self.client.force_login(self.aluno)
        self.assertContains(self.ler(1), 'A atividade deste módulo libera')
        self.ler(2)
        resposta = self.ler(3)
        self.assertContains(resposta, 'Você leu todas as partes')
        self.assertContains(resposta, reverse('responder_atividade', args=[self.modulo.slug]))
        self.assertNotContains(resposta, 'Próxima parte')
        self.assertTrue(leu_tudo(self.aluno, self.modulo))

    def test_registra_a_leitura_uma_vez_por_parte(self, _):
        self.client.force_login(self.aluno)
        self.ler(1)
        self.ler(1)
        self.assertEqual(LeituraConteudo.objects.filter(usuario=self.aluno).count(), 1)

    def test_atividade_bloqueada_manda_para_a_parte_que_falta(self, _):
        self.client.force_login(self.aluno)
        self.ler(1)
        resposta = self.client.get(reverse('responder_atividade', args=[self.modulo.slug]))
        self.assertRedirects(resposta, f'{self.url}?parte=2', fetch_redirect_response=False)

    def test_atividade_abre_depois_de_ler_tudo(self, _):
        self.client.force_login(self.aluno)
        for numero in (1, 2, 3):
            self.ler(numero)
        resposta = self.client.get(reverse('responder_atividade', args=[self.modulo.slug]))
        self.assertEqual(resposta.status_code, 200)

    def test_quem_ja_fez_a_atividade_nao_fica_bloqueado(self, _):
        Tentativa.objects.create(usuario=self.aluno, atividade=self.modulo.atividade, numero=1, acertos=1, total_perguntas=1)
        self.client.force_login(self.aluno)
        resposta = self.client.get(reverse('responder_atividade', args=[self.modulo.slug]))
        self.assertEqual(resposta.status_code, 200)

    def test_leituras_somem_com_a_conta(self, _):
        self.client.force_login(self.aluno)
        self.ler(1)
        self.aluno.delete()
        self.assertFalse(LeituraConteudo.objects.exists())

    def test_modulo_sem_conteudo_mostra_aviso_e_libera_a_atividade(self, _):
        vazio = Modulo.objects.create(nome_modulo='Vazio', descricao_modulo='x')
        Atividade.objects.create(modulo=vazio, titulo='Quiz vazio')
        resposta = self.client.get(reverse('detalhe_modulo', args=[vazio.slug]))
        self.assertContains(resposta, 'Este módulo ainda não tem conteúdo.')
        self.assertTrue(leu_tudo(self.aluno, vazio))

    def test_leitura_feita_antes_de_entrar_fica_na_conta(self, _):
        for numero in (1, 2, 3):
            self.ler(numero)
        self.client.post(reverse('login'), {'username': 'aluno', 'password': 'SenhaForte!123'})
        codigo = CodigoVerificacao.objects.filter(usuario=self.aluno).latest('criado_em').codigo
        self.client.post(reverse('verificar_codigo'), {'codigo': codigo})
        self.assertTrue(leu_tudo(self.aluno, self.modulo))
        resposta = self.client.get(reverse('responder_atividade', args=[self.modulo.slug]))
        self.assertEqual(resposta.status_code, 200)
