Sobre o projeto: O Go Cash é uma plataforma web de educação financeira aplicada, voltada principalmente a estudantes do Ensino Médio como ferramenta complementar de aprendizagem. A proposta é ensinar conceitos de orçamento pessoal, planejamento financeiro e consumo consciente por meio de conteúdos educacionais, atividades interativas e simuladores financeiros.

```python
  Back-end: Python + Django
  Banco de dados: PostgreSQL 
  Front-end: HTML5, CSS3, JavaScript, Bootstrap -  -- a implementar desenvolvimento do frontend
  API externa: AwesomeAPI (cotações e indicadores financeiros) -- a implementar
  Deploy: Render (Gunicorn)  -- a implementar
  Versionamento: Git e GitHub
  Progresso até aqui
  Funcionalidade 1 — Módulos de aprendizagem em educação financeira
```

```python
Primeira entrega prevista na ficha do PFC: o usuário consegue acessar módulos de conteúdo educacional (ex: orçamento pessoal, cartão de crédito, consumo consciente).
O que e como foi implementado:
- Ambiente virtual (venv) e instalação do Django pelo terminal
- Criação do projeto (gocash) e do app modulos
- Integração com PostgreSQL via psycopg2-binary, com variáveis sensíveis isoladas em .env usando python-decouple
- Modelagem dos dados: Modulo (nome, descrição, ordem de exibir) e ConteudoModulo (título, explicação, ordem de exibir), relacionados por ForeignKey
- Migrações aplicadas ao banco PostgreSQL
- Registro das models, deixando que o admin cadastre módulos e conteúdos
- Views, URLs e templates (usando Bootstrap) para a parte pública: listagem de módulos (/modulos/) e detalhe de cada módulo com seus conteúdos (/modulos/<id>/)
```

Fluxo atual: o administrador (superusuário Django por enquanto já que ainda não tem a divisão de usuários) cadastra módulos e conteúdos em /admin -> qualquer visitante consegue visualizar essa lista pelo /modulos/.


Durante a integração com o PostgreSQL, alguns erros comuns de configuração foram identificados e corrigidos, documentados aqui como registro do processo de desenvolvimento:
  Cache de uma sessão antiga do shell do Django mantendo configurações desatualizadas, tendo que refazer algumas partes | Permissão de schema public negada no PostgreSQL, tendo que fazer um GRANT para o usuário do BD.


Próximos passos: Demais funcionalidades, conforme plano de ensino e seguindo a orientação.


Como rodar o projeto localmente:
  1. Ativar o ambiente virtual: venv\Scripts\Activate.ps1
  2. Instalar o necessário: pip install -r requirements.txt
  3. Configurar o arquivo .env com as credenciais do PostgreSQL local

  Rodar as migrações: python manage.py migrate

  Criar um superusuário para acessar a página do admin: python manage.py createsuperuser

  Rodar o servidor: python manage.py runserver

