# Go Cash - Plataforma de Educação Financeira

Plataforma web gratuita de educação financeira para jovens a partir de 16 anos. O aluno estuda módulos curtos, faz atividades, ganha Cashs (pontuação) e acompanha o próprio progresso. A equipe (administradores) publica os conteúdos e acompanha o uso pelo painel.

## Tecnologias
- **Back-end:** Python + Django 6.1.1
- **Banco de dados:** PostgreSQL
- **Front-end:** HTML, CSS, JavaScript, Bootstrap 5 e Chart.js (gráficos)
- **API externa:** AwesomeAPI (cotações do dólar, euro e bitcoin)
- **E-mails:** Brevo (SMTP)
- **Deploy:** Render (a implementar)

## O que foi implementado

### Requisitos funcionais (front-end e back-end integrados) implementados até agora
- **Contas e perfis:** cadastro de aluno, login, perfis Aluno, Administrador e Administrador principal, com permissões diferentes.
- **Segurança:** verificação em duas etapas por código no e-mail (pode ser ligada ou desligada no painel), recuperação de senha por link e logs de auditoria.
- **Módulos de aprendizagem:** módulos com conteúdos e referências; URLs pelo nome (`/modulos/economia-global/`).
- **Atividades:** um quiz por módulo, 3 tentativas, resultado com as respostas certas e erradas.
- **Cashs e ranking:** 10 Cashs a cada 10% de acerto, contando só a melhor tentativa; ranking dos 10 alunos com mais Cashs na página inicial, só para quem autorizar no perfil.
- **Meu perfil:** ver os próprios dados, alterar nome e e-mail, participar do ranking e excluir a conta.
- **Cotações:** consumo da AwesomeAPI na tabela do módulo Economia Global e num resumo no fim da página inicial que convida para o módulo, com cache de 2 minutos e aviso caso a API esteja fora do ar.
- **Painel administrativo:** menu lateral próprio, acompanhamento dos alunos por módulo, ativar e desativar contas, alterar perfis.
- **LGPD:** Termos de Uso e Política de Privacidade, idade mínima de 16 anos e aceite registrado no cadastro.

### Validações e tratamento de entradas inválidas
- Cadastro: e-mail e confirmação iguais, e-mail único (também no banco, sem diferenciar maiúsculas), senha forte, aceite dos termos obrigatório.
- Login: senha errada, conta desativada e código de verificação expirado ou incorreto.
- Painel: pergunta com pelo menos 2 alternativas e exatamente 1 correta.
- Perfil: troca de e-mail e exclusão de conta exigem a senha atual.
- Mensagens de erro em português, ao lado de cada campo.

### Dashboard
- **Administrador:** Big Numbers (alunos ativos, atividades disponíveis, taxa de conclusão, Cashs acumulados e contas desativadas) e gráficos de novos cadastros por mês, situação dos alunos por módulo e Cashs acumulados por módulo.
- **Aluno (página inicial):** ranking, Minhas atividades (Cashs, concluídas, em andamento, tentativas), situação de cada atividade e as perguntas em que mais errou.
- Os números são calculados no servidor a partir do banco; os gráficos usam Chart.js e têm a opção "Ver em tabela".

### Persistência e regras de negócio
- Todos os dados ficam no PostgreSQL: usuários, perfis, módulos, atividades, tentativas, respostas e progresso.
- Regras aplicadas: limite de 3 tentativas, Cashs pela melhor tentativa, status da atividade (não iniciada, em andamento, concluída), um único Administrador principal, ranking só com consentimento e exclusão automática de contas desativadas há mais de 6 meses.
<<<<<<< HEAD
- 129 testes automatizados (`python manage.py test`).
=======
- 128 testes automatizados (`python manage.py test`).
>>>>>>> 590b5c549d2da81969b5f9e3bacb31f9dc6b298f

## Como rodar localmente
1. Ative o ambiente virtual: `venv\Scripts\Activate`
2. Instale as dependências: `pip install -r requirements.txt`
3. Crie o `.env` na raiz com as credenciais do PostgreSQL e do e-mail.
4. Rode as migrações: `python manage.py migrate`
5. Crie um superusuário: `python manage.py createsuperuser`
6. Defina o Administrador principal: `python manage.py definir_administrador_principal <usuario>`
7. Inicie o servidor: `python manage.py runserver`
