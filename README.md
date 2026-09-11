# GoCash
O Go Cash é uma plataforma web de educação financeira aplicada, criada para apoiar estudantes do Ensino Médio no aprendizado de conceitos como planejamento financeiro, orçamento pessoal, consumo consciente e definição de metas financeiras.

🎯 Objetivos
Módulos educacionais sobre finanças pessoais.

Atividades interativas para fixação dos conteúdos.

Simuladores financeiros para prática.

Dashboard educacional para acompanhar evolução.

Integração com indicadores econômicos.

Segurança e LGPD aplicada em todo o sistema.

🛠️ Tecnologias
Frontend: HTML5, CSS3, JavaScript, Bootstrap

Backend: Python, Django

Banco de Dados: PostgreSQL

API Externa: AwesomeAPI (cotações financeiras)

Deploy: Render + Gunicorn

Versionamento: Git e GitHub

Prototipação: Figma

Gráficos: Chart.js

Segurança: Autenticação Django + Criptografia

-> Como Executar Localmente
1. Clonar o repositório
  git clone https://github.com/PFC-Go-Cash/GoCash.git
  cd GoCash
2. Criar ambiente virtual
3. Instalar dependências
4. Configurar banco de dados PostgreSQL
  Crie um banco chamado gocash.
  Configure usuário e senha no arquivo settings.py.
5. Executar migrações
  python manage.py migrate
6. Criar superusuário
  python manage.py createsuperuser
7. Rodar servidor local
  python manage.py runserver
  Acesse em: http://127.0.0.1:8000/

-> Hospedagem no Render
1. Criar conta no Render
2. Conectar ao GitHub e selecionar o repositório Go Cash
3. Configurar serviço web:
Build Command:
pip install -r requirements.txt
Start Command:
gunicorn gocash.wsgi:application
Environment: Python 3.10+

Banco de Dados: PostgreSQL (Render oferece instância gratuita).
