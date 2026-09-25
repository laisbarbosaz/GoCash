# Go Cash - Plataforma de Educação Financeira
## Sobre o projeto
O **Go Cash** é uma plataforma web de educação financeira aplicada, voltada principalmente a estudantes do Ensino Médio como ferramenta complementar de aprendizagem. A proposta é ensinar conceitos de orçamento pessoal, planejamento financeiro e consumo consciente por meio de conteúdos educacionais, atividades interativas e simuladores financeiros.

## Tecnologias Utilizadas
* **Back-end:** Python + Django (v6.1.1)
* **Banco de dados:** PostgreSQL
* **Front-end:** HTML5, CSS3, JavaScript, Bootstrap *(Interface principal em desenvolvimento)*
* **API externa:** AwesomeAPI (Cotações em tempo real para os módulos e simuladores)
* **Deploy:** Render (Gunicorn) `-- a implementar`
* **Versionamento:** Git e GitHub

---

## Progresso do Desenvolvimento (Linha do Tempo)

### Funcionalidade 1 — Módulos de Aprendizagem em Educação Financeira *(Atualizado em 14.09)*
Primeira entrega prevista na ficha do PFC: o usuário consegue acessar módulos de conteúdo educacional (ex: orçamento pessoal, cartão de crédito, consumo consciente).

* **O que e como foi implementado:**
  * Configuração do ambiente virtual (`venv`) e instalação do Django pelo terminal.
  * Criação do projeto base (`gocash`) e do app `modulos`.
  * Integração com o banco de dados PostgreSQL via `psycopg2-binary`.
  * Modelagem dos dados: `Modulo` (nome, descrição, ordem de exibir) e `ConteudoModulo` (título, explicação, ordem de exibir), relacionados por `ForeignKey`.
  * Registro das models no painel administrativo do Django, permitindo que o administrador cadastre os módulos e conteúdos dinamicamente.
  * Desenvolvimento de Views, URLs e templates (com Bootstrap) para a interface pública: listagem de módulos (`/modulos/`) e detalhe de cada módulo com seus conteúdos (`/modulos/<id>/`).

* **Fluxo atual:** O administrador (superusuário Django) cadastra módulos e conteúdos em `/admin` e qualquer visitante consegue visualizar essa lista navegando por `/modulos/`.

### Funcionalidade 2 — Integração de Cotações em Tempo Real + Login/Cadastro com LGPD aplicada (Atualizado em 28.09)*
Segunda etapa de desenvolvimento: Integração com serviço externo de câmbio para alimentar a página inicial da aplicação com dados de mercado reais, servindo de base para os futuros simuladores financeiros.

* **O que e como foi implementado:**
  * Instalação e mapeamento da biblioteca externa `requests` no gerenciador de dependências.
  * Criação do app `home` para controle e centralização da página inicial do ecossistema.
  * Implementação do consumo da API pública da **AwesomeAPI** por meio do método `GET`.
  * Captura e tratamento em tempo real das cotações do **Dólar Americano (USD)**, **Euro (EUR)** e **Bitcoin (BTC)** em relação ao **Real Brasileiro (BRL)**.
  * Implementação de **Timeout de 5 segundos** na requisição para garantir a resiliência e evitar o travamento do servidor caso a API externa sofra instabilidade.
  * Criação de fluxo de **Fallback de Segurança (`erro_api = True`)**: caso ocorra uma falha de conexão (`requests.RequestException`), o sistema captura a exceção e impede a quebra da aplicação (evitando Erros 500), permitindo que o front-end exiba um aviso amigável ao estudante.


## Histórico de Resolução de Problemas (Troubleshooting)
Durante o desenvolvimento, os seguintes comportamentos foram identificados, documentados e corrigidos:
* **Banco de Dados:** Permissão de *schema public* negada no ambiente local do PostgreSQL. Resolvido aplicando comandos manuais de `GRANT` para o usuário do banco de dados.
* **Ambiente de Execução:** Cache antigo em sessões ativas do Shell do Django mantendo configurações desatualizadas de conexão. Resolvido reiniciando as instâncias e limpando os processos do terminal.
* **Sintaxe de Código:** Erros de compilação na View causados pela declaração de dados da API como texto literal puro. Resolvido com a devida tokenização e inserção de aspas adequadas nas chaves do dicionário e parâmetros de strings.


## Como Rodar o Projeto Localmente

1. **Ativar o ambiente virtual:**
   ```bash
   venv\Scripts\Activate.ps1
   ```

2. **Instalar as dependências necessárias:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Configurar o Ambiente:**
   Crie e configure o arquivo `.env` na raiz do projeto com as credenciais do seu PostgreSQL local.

4. **Rodar as migrações do banco de dados:**
   ```bash
   python manage.py migrate
   ```

5. **Criar um superusuário para acessar a página do admin:**
   ```bash
   python manage.py createsuperuser
   ```

6. **Iniciar o servidor de desenvolvimento:**
   ```bash
   python manage.py runserver