--
-- PostgreSQL database dump
--

\restrict pBHc6NigEolhT9TH6teJY3xWJ1veUriGdR75TrtsOepjj9GyyWvw1QFeIc0GsUM

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.modulos_conteudomodulo DROP CONSTRAINT IF EXISTS modulos_conteudomodulo_modulo_id_744299b8_fk_modulos_modulo_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_user_id_c564eba6_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_content_type_id_c4bce8eb_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.contas_perfilusuario DROP CONSTRAINT IF EXISTS contas_perfilusuario_usuario_id_16684c3a_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.contas_conviteeducador DROP CONSTRAINT IF EXISTS contas_conviteeducador_usado_por_id_7a122649_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.contas_conviteeducador DROP CONSTRAINT IF EXISTS contas_conviteeducador_criado_por_id_34b531c8_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.contas_configuracaosite DROP CONSTRAINT IF EXISTS contas_configuracaos_atualizada_por_id_4e67342b_fk_auth_user;
ALTER TABLE IF EXISTS ONLY public.contas_codigoverificacao DROP CONSTRAINT IF EXISTS contas_codigoverificacao_usuario_id_8da56468_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_group_id_97559544_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_2f476e4b_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.atividades_tentativa DROP CONSTRAINT IF EXISTS atividades_tentativa_usuario_id_1ed9d825_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.atividades_tentativa DROP CONSTRAINT IF EXISTS atividades_tentativa_atividade_id_3f3a4684_fk_atividade;
ALTER TABLE IF EXISTS ONLY public.atividades_resposta DROP CONSTRAINT IF EXISTS atividades_resposta_tentativa_id_1578c89a_fk_atividade;
ALTER TABLE IF EXISTS ONLY public.atividades_resposta DROP CONSTRAINT IF EXISTS atividades_resposta_pergunta_id_88261d72_fk_atividade;
ALTER TABLE IF EXISTS ONLY public.atividades_resposta DROP CONSTRAINT IF EXISTS atividades_resposta_alternativa_id_df124603_fk_atividade;
ALTER TABLE IF EXISTS ONLY public.atividades_progressoatividade DROP CONSTRAINT IF EXISTS atividades_progresso_usuario_id_6f2e9384_fk_auth_user;
ALTER TABLE IF EXISTS ONLY public.atividades_progressoatividade DROP CONSTRAINT IF EXISTS atividades_progresso_atividade_id_54a86027_fk_atividade;
ALTER TABLE IF EXISTS ONLY public.atividades_pergunta DROP CONSTRAINT IF EXISTS atividades_pergunta_atividade_id_392d1001_fk_atividade;
ALTER TABLE IF EXISTS ONLY public.atividades_atividade DROP CONSTRAINT IF EXISTS atividades_atividade_modulo_id_eec1056d_fk_modulos_modulo_id;
ALTER TABLE IF EXISTS ONLY public.atividades_alternativa DROP CONSTRAINT IF EXISTS atividades_alternati_pergunta_id_7c6d5976_fk_atividade;
DROP INDEX IF EXISTS public.modulos_modulo_slug_77838c2f_like;
DROP INDEX IF EXISTS public.modulos_conteudomodulo_modulo_id_744299b8;
DROP INDEX IF EXISTS public.django_session_session_key_c0390e0f_like;
DROP INDEX IF EXISTS public.django_session_expire_date_a5c62663;
DROP INDEX IF EXISTS public.django_admin_log_user_id_c564eba6;
DROP INDEX IF EXISTS public.django_admin_log_content_type_id_c4bce8eb;
DROP INDEX IF EXISTS public.contas_conviteeducador_usado_por_id_7a122649;
DROP INDEX IF EXISTS public.contas_conviteeducador_criado_por_id_34b531c8;
DROP INDEX IF EXISTS public.contas_conviteeducador_codigo_a4143307_like;
DROP INDEX IF EXISTS public.contas_configuracaosite_atualizada_por_id_4e67342b;
DROP INDEX IF EXISTS public.contas_codigoverificacao_usuario_id_8da56468;
DROP INDEX IF EXISTS public.auth_user_username_6821ab7c_like;
DROP INDEX IF EXISTS public.auth_user_user_permissions_user_id_a95ead1b;
DROP INDEX IF EXISTS public.auth_user_user_permissions_permission_id_1fbb5f2c;
DROP INDEX IF EXISTS public.auth_user_groups_user_id_6a12ed8b;
DROP INDEX IF EXISTS public.auth_user_groups_group_id_97559544;
DROP INDEX IF EXISTS public.auth_user_email_unico;
DROP INDEX IF EXISTS public.auth_permission_content_type_id_2f476e4b;
DROP INDEX IF EXISTS public.auth_group_permissions_permission_id_84c5c92e;
DROP INDEX IF EXISTS public.auth_group_permissions_group_id_b120cbf9;
DROP INDEX IF EXISTS public.auth_group_name_a6ea08ec_like;
DROP INDEX IF EXISTS public.atividades_tentativa_usuario_id_1ed9d825;
DROP INDEX IF EXISTS public.atividades_tentativa_atividade_id_3f3a4684;
DROP INDEX IF EXISTS public.atividades_resposta_tentativa_id_1578c89a;
DROP INDEX IF EXISTS public.atividades_resposta_pergunta_id_88261d72;
DROP INDEX IF EXISTS public.atividades_resposta_alternativa_id_df124603;
DROP INDEX IF EXISTS public.atividades_progressoatividade_usuario_id_6f2e9384;
DROP INDEX IF EXISTS public.atividades_progressoatividade_atividade_id_54a86027;
DROP INDEX IF EXISTS public.atividades_pergunta_atividade_id_392d1001;
DROP INDEX IF EXISTS public.atividades_alternativa_pergunta_id_7c6d5976;
DROP INDEX IF EXISTS public.apenas_um_administrador_principal;
ALTER TABLE IF EXISTS ONLY public.atividades_tentativa DROP CONSTRAINT IF EXISTS tentativa_unica_por_numero;
ALTER TABLE IF EXISTS ONLY public.atividades_progressoatividade DROP CONSTRAINT IF EXISTS progresso_unico_por_aluno_e_atividade;
ALTER TABLE IF EXISTS ONLY public.modulos_modulo DROP CONSTRAINT IF EXISTS modulos_modulo_slug_key;
ALTER TABLE IF EXISTS ONLY public.modulos_modulo DROP CONSTRAINT IF EXISTS modulos_modulo_pkey;
ALTER TABLE IF EXISTS ONLY public.modulos_conteudomodulo DROP CONSTRAINT IF EXISTS modulos_conteudomodulo_pkey;
ALTER TABLE IF EXISTS ONLY public.django_session DROP CONSTRAINT IF EXISTS django_session_pkey;
ALTER TABLE IF EXISTS ONLY public.django_migrations DROP CONSTRAINT IF EXISTS django_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_app_label_model_76bd3d3b_uniq;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_pkey;
ALTER TABLE IF EXISTS ONLY public.contas_perfilusuario DROP CONSTRAINT IF EXISTS contas_perfilusuario_usuario_id_key;
ALTER TABLE IF EXISTS ONLY public.contas_perfilusuario DROP CONSTRAINT IF EXISTS contas_perfilusuario_pkey;
ALTER TABLE IF EXISTS ONLY public.contas_conviteeducador DROP CONSTRAINT IF EXISTS contas_conviteeducador_pkey;
ALTER TABLE IF EXISTS ONLY public.contas_conviteeducador DROP CONSTRAINT IF EXISTS contas_conviteeducador_codigo_key;
ALTER TABLE IF EXISTS ONLY public.contas_configuracaosite DROP CONSTRAINT IF EXISTS contas_configuracaosite_pkey;
ALTER TABLE IF EXISTS ONLY public.contas_codigoverificacao DROP CONSTRAINT IF EXISTS contas_codigoverificacao_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_username_key;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_group_id_94350c0c_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_codename_01ab375a_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_name_key;
ALTER TABLE IF EXISTS ONLY public.atividades_tentativa DROP CONSTRAINT IF EXISTS atividades_tentativa_pkey;
ALTER TABLE IF EXISTS ONLY public.atividades_resposta DROP CONSTRAINT IF EXISTS atividades_resposta_pkey;
ALTER TABLE IF EXISTS ONLY public.atividades_progressoatividade DROP CONSTRAINT IF EXISTS atividades_progressoatividade_pkey;
ALTER TABLE IF EXISTS ONLY public.atividades_pergunta DROP CONSTRAINT IF EXISTS atividades_pergunta_pkey;
ALTER TABLE IF EXISTS ONLY public.atividades_atividade DROP CONSTRAINT IF EXISTS atividades_atividade_pkey;
ALTER TABLE IF EXISTS ONLY public.atividades_atividade DROP CONSTRAINT IF EXISTS atividades_atividade_modulo_id_key;
ALTER TABLE IF EXISTS ONLY public.atividades_alternativa DROP CONSTRAINT IF EXISTS atividades_alternativa_pkey;
DROP TABLE IF EXISTS public.modulos_modulo;
DROP TABLE IF EXISTS public.modulos_conteudomodulo;
DROP TABLE IF EXISTS public.django_session;
DROP TABLE IF EXISTS public.django_migrations;
DROP TABLE IF EXISTS public.django_content_type;
DROP TABLE IF EXISTS public.django_admin_log;
DROP TABLE IF EXISTS public.contas_perfilusuario;
DROP TABLE IF EXISTS public.contas_conviteeducador;
DROP TABLE IF EXISTS public.contas_configuracaosite;
DROP TABLE IF EXISTS public.contas_codigoverificacao;
DROP TABLE IF EXISTS public.auth_user_user_permissions;
DROP TABLE IF EXISTS public.auth_user_groups;
DROP TABLE IF EXISTS public.auth_user;
DROP TABLE IF EXISTS public.auth_permission;
DROP TABLE IF EXISTS public.auth_group_permissions;
DROP TABLE IF EXISTS public.auth_group;
DROP TABLE IF EXISTS public.atividades_tentativa;
DROP TABLE IF EXISTS public.atividades_resposta;
DROP TABLE IF EXISTS public.atividades_progressoatividade;
DROP TABLE IF EXISTS public.atividades_pergunta;
DROP TABLE IF EXISTS public.atividades_atividade;
DROP TABLE IF EXISTS public.atividades_alternativa;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: atividades_alternativa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.atividades_alternativa (
    id bigint NOT NULL,
    texto character varying(255) NOT NULL,
    correta boolean NOT NULL,
    pergunta_id bigint NOT NULL
);


--
-- Name: atividades_alternativa_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.atividades_alternativa ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.atividades_alternativa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: atividades_atividade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.atividades_atividade (
    id bigint NOT NULL,
    titulo character varying(150) NOT NULL,
    descricao text NOT NULL,
    modulo_id bigint NOT NULL
);


--
-- Name: atividades_atividade_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.atividades_atividade ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.atividades_atividade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: atividades_pergunta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.atividades_pergunta (
    id bigint NOT NULL,
    enunciado text NOT NULL,
    atividade_id bigint NOT NULL
);


--
-- Name: atividades_pergunta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.atividades_pergunta ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.atividades_pergunta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: atividades_progressoatividade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.atividades_progressoatividade (
    id bigint NOT NULL,
    status character varying(15) NOT NULL,
    iniciada_em timestamp with time zone NOT NULL,
    concluida_em timestamp with time zone,
    atividade_id bigint NOT NULL,
    usuario_id integer NOT NULL
);


--
-- Name: atividades_progressoatividade_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.atividades_progressoatividade ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.atividades_progressoatividade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: atividades_resposta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.atividades_resposta (
    id bigint NOT NULL,
    correta boolean NOT NULL,
    alternativa_id bigint NOT NULL,
    pergunta_id bigint NOT NULL,
    tentativa_id bigint NOT NULL
);


--
-- Name: atividades_resposta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.atividades_resposta ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.atividades_resposta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: atividades_tentativa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.atividades_tentativa (
    id bigint NOT NULL,
    numero smallint NOT NULL,
    acertos integer NOT NULL,
    total_perguntas integer NOT NULL,
    realizada_em timestamp with time zone NOT NULL,
    atividade_id bigint NOT NULL,
    usuario_id integer NOT NULL,
    CONSTRAINT atividades_tentativa_acertos_check CHECK ((acertos >= 0)),
    CONSTRAINT atividades_tentativa_numero_check CHECK ((numero >= 0)),
    CONSTRAINT atividades_tentativa_total_perguntas_check CHECK ((total_perguntas >= 0))
);


--
-- Name: atividades_tentativa_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.atividades_tentativa ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.atividades_tentativa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contas_codigoverificacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contas_codigoverificacao (
    id bigint NOT NULL,
    codigo character varying(6) NOT NULL,
    criado_em timestamp with time zone NOT NULL,
    usado boolean NOT NULL,
    usuario_id integer NOT NULL
);


--
-- Name: contas_codigoverificacao_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.contas_codigoverificacao ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.contas_codigoverificacao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contas_configuracaosite; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contas_configuracaosite (
    id bigint NOT NULL,
    exigir_mfa boolean NOT NULL,
    atualizada_em timestamp with time zone NOT NULL,
    atualizada_por_id integer
);


--
-- Name: contas_configuracaosite_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.contas_configuracaosite ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.contas_configuracaosite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contas_conviteeducador; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contas_conviteeducador (
    id bigint NOT NULL,
    email character varying(254) NOT NULL,
    codigo character varying(8) NOT NULL,
    criado_em timestamp with time zone NOT NULL,
    expira_em timestamp with time zone NOT NULL,
    usado_em timestamp with time zone,
    criado_por_id integer,
    usado_por_id integer
);


--
-- Name: contas_conviteeducador_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.contas_conviteeducador ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.contas_conviteeducador_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contas_perfilusuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contas_perfilusuario (
    id bigint NOT NULL,
    aceitou_termos boolean NOT NULL,
    data_aceite_termos timestamp with time zone,
    usuario_id integer NOT NULL,
    tipo_usuario character varying(15) NOT NULL,
    administrador_principal boolean NOT NULL,
    aparecer_no_ranking boolean NOT NULL
);


--
-- Name: contas_perfilusuario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.contas_perfilusuario ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.contas_perfilusuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- Name: modulos_conteudomodulo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.modulos_conteudomodulo (
    id bigint NOT NULL,
    titulo_conteudo character varying(150) NOT NULL,
    explicacao_conteudo text NOT NULL,
    modulo_id bigint NOT NULL
);


--
-- Name: modulos_conteudomodulo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.modulos_conteudomodulo ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.modulos_conteudomodulo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: modulos_modulo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.modulos_modulo (
    id bigint NOT NULL,
    nome_modulo character varying(100) NOT NULL,
    descricao_modulo text NOT NULL,
    slug character varying(110),
    mostrar_cotacoes boolean NOT NULL
);


--
-- Name: modulos_modulo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.modulos_modulo ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.modulos_modulo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: atividades_alternativa; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.atividades_alternativa (id, texto, correta, pergunta_id) FROM stdin;
1	Um limite de gastos imposto pelo banco	f	1
2	Um planejamento que organiza quanto você ganha e quanto pode gastar ou guardar	t	1
3	Um tipo de empréstimo com juros baixos	f	1
4	Um documento exigido apenas por empresas	f	1
5	Ele some, já que você pagou uma parte	f	2
6	Fica guardado sem juros até o mês seguinte	f	2
7	Entra no rotativo e passa a render juros bem altos	t	2
8	O banco cancela automaticamente a dívida	f	2
9	Não tem problema nenhum, é uma boa prática	f	3
10	O cartão pode ser bloqueado por pagamento incompleto	f	3
11	O valor que faltou vira dívida com uma das taxas de juros mais altas do mercado	t	3
12	O banco avisa o empregador sobre o atraso	f	3
13	Pela mais antiga, não importa o juro	f	4
14	Pela que tem o juro mais alto, geralmente a do cartão	t	4
15	Pela do amigo, porque as outras têm prazo mais longo	f	4
16	Por nenhuma, é melhor esperar sobrar dinheiro no fim do mês	f	4
17	Regra do 50-30-20	t	5
18	Tabela Price	f	5
19	Taxa Selic	f	5
20	CDB	f	5
21	Comprar logo, antes que o preço suba	f	6
22	Esperar alguns dias e ver se ainda faz sentido dentro do seu orçamento	t	6
23	Usar todo o limite disponível do cartão	f	6
24	Parcelar sempre no maior número de vezes possível	f	6
25	Serasa Limpa Nome	f	7
26	Registrato	t	7
27	Pix	f	7
28	Tesouro Direto	f	7
29	30%	f	8
30	50%	f	8
31	10%	f	8
32	20%	t	8
33	Não existe limite	f	9
34	50% do seu salário	f	9
35	100% do valor da dívida	t	9
36	10% do valor da dívida	f	9
37	Evitar fazer dívidas novas	t	10
38	Esperar o banco perdoar a dívida	f	10
39	Aumentar o limite do cartão	f	10
40	Pagar só o mínimo de tudo	f	10
41	O mapa da viagem	f	11
42	O painel, que mostra a situação em tempo real	t	11
43	O destino final	f	11
44	O seguro do carro	f	11
45	O registro de todo o dinheiro que entra e sai	t	12
46	O valor do salário bruto	f	12
47	O saldo da poupança	f	12
48	O limite do cartão de crédito	f	12
49	Aluguel	t	13
50	Roupa nova	f	13
51	Delivery no fim de semana	f	13
52	Ingresso de cinema	f	13
53	Lanche fora de casa	t	14
54	Mensalidade da internet	f	14
55	Aluguel	f	14
56	Parcela do financiamento	f	14
57	Despesas variáveis	f	15
58	Despesas fixas	f	15
59	Dívidas	f	15
60	Receitas	t	15
61	Porque eles têm juros	f	16
62	Porque é neles que aparecem as surpresas	t	16
63	Não vale, só os grandes importam	f	16
64	Porque o banco exige	f	16
65	Decidir para onde vai a sobra, como guardar ou quitar uma dívida	t	17
66	Deixar parado sem pensar nisso	f	17
67	Gastar tudo no fim de semana	f	17
68	Aumentar o limite do cartão	f	17
69	Pelas despesas variáveis	t	18
70	Por nenhuma, é só usar o cartão	f	18
71	Pelo aluguel	f	18
72	Pela conta de luz	f	18
73	Resolve o problema de vez	f	19
74	Empurra o problema para o mês seguinte, com juros	t	19
75	Aumenta a receita	f	19
76	É sempre gratuito	f	19
77	Um aplicativo pago	f	20
78	Uma conta em banco digital	f	20
79	O hábito de anotar, seja no caderno, na planilha ou no app	t	20
80	Um cartão de crédito	f	20
81	Quanto custa comprar uma unidade da moeda	t	21
82	O lucro do banco	f	21
83	Quanto o mercado paga pela moeda	f	21
84	A variação do dia	f	21
85	Selic	f	22
86	Inflação	f	22
87	Spread	t	22
88	PTAX	f	22
89	Caiu em relação ao fechamento anterior	t	23
90	Subiu em relação ao fechamento anterior	f	23
91	Vai cair amanhã	f	23
92	Ficou igual	f	23
93	O mesmo valor da tabela	f	24
94	A PTAX	f	24
95	O dólar turismo, mais caro que o comercial	t	24
96	O dólar comercial	f	24
97	Porque bancos centrais do mundo todo guardam dólares	t	25
98	Porque não varia	f	25
99	Porque é a moeda mais barata	f	25
100	Porque só pode ser usado em reservas de hotel	f	25
101	Nada, o real não é afetado	f	26
102	Só os produtos feitos no Brasil	f	26
103	Produtos importados, como celulares	t	26
104	Apenas o bitcoin	f	26
105	35	f	27
106	12	f	27
107	27	f	27
108	21	t	27
109	É emitido pelo Banco Central do Brasil	f	28
110	Não tem um banco central por trás e o preço oscila muito	t	28
111	Só pode ser usado nos Estados Unidos	f	28
112	Tem valor fixo	f	28
113	Ficar mais forte	t	29
114	Ficar mais fraco	f	29
115	Ficar igual ao euro	f	29
116	Deixar de ser negociado	f	29
117	Selic	f	30
118	PTAX, do Banco Central	f	30
119	Ibovespa	f	30
120	IPCA, do IBGE	t	30
361	Líquido	t	91
362	Base	f	91
363	Bruto	f	91
364	Mínimo	f	91
365	Guardar dinheiro para as férias	f	92
366	Pagar o vale-refeição	f	92
367	Contribuir para a aposentadoria e benefícios da Previdência	t	92
368	Pagar o Imposto de Renda	f	92
369	No fim do mês, com o que sobrou	f	93
370	Só quando faltar dinheiro	f	93
371	Assim que o dinheiro entra	t	93
372	Quando chegar a fatura do cartão	f	93
373	Pagar a fatura do cartão todo mês	f	94
374	Comprar coisas em promoção	f	94
375	Cobrir imprevistos sem precisar se endividar	t	94
376	Viajar nas férias	f	94
377	Em dinheiro vivo dentro de casa	f	95
378	Emprestado para amigos	f	95
379	Em um lugar seguro e fácil de sacar	t	95
380	Em ações de uma única empresa	f	95
381	Guardar só o que sobrar no fim do mês	f	96
382	Guardar tudo e não gastar nada	f	96
383	Criar o hábito de guardar todo mês, mesmo que pouco	t	96
384	Esperar ganhar mais para começar	f	96
385	Um empréstimo	f	97
386	Uma multa	f	97
387	Um bônus	f	97
388	Um desconto	t	97
389	Roupa nova de marca	f	98
390	Transporte para o trabalho	t	98
391	Assinatura de streaming	f	98
392	Lanche no shopping	f	98
393	Pedir um aumento	f	99
394	Fazer um cartão de crédito	f	99
395	Saber quanto realmente entra na conta	t	99
396	Parcelar as compras	f	99
397	R$ 1.500	f	100
398	R$ 900	t	100
399	R$ 600	f	100
400	R$ 150	f	100
401	Mandar metade do valor	f	101
402	Ligar para o número antigo da pessoa e confirmar	t	101
403	Pedir para ele mandar uma foto	f	101
404	Fazer o Pix logo para ajudar	f	101
405	O nome do beneficiário	t	102
406	Se o boleto tem logotipo	f	102
407	O tamanho do arquivo	f	102
408	A cor do boleto	f	102
409	Encaminhar para os amigos	f	103
410	Clicar no link e conferir	f	103
411	Responder o SMS com seus dados	f	103
412	Ignorar o link e abrir o aplicativo oficial do banco	t	103
413	Não, é preciso conferir no aplicativo se o dinheiro entrou	t	104
414	Sim, se ele mandar áudio confirmando	f	104
415	Sim, o print é prova suficiente	f	104
416	Sim, se o print tiver o logotipo do banco	f	104
417	Apagar a conversa com o golpista	f	105
418	Fazer outro Pix para testar	f	105
419	Esperar alguns dias para ver se o dinheiro volta	f	105
420	Avisar o banco o quanto antes	t	105
421	Pressa e urgência para você agir	t	106
422	Pedido para você conferir com calma	f	106
423	Atendimento pelo app oficial	f	106
424	Boleto com o nome certo da empresa	f	106
425	Uma ótima oportunidade	f	107
426	Um sinal clássico de golpe	t	107
427	Algo garantido pelo governo	f	107
428	Um investimento sem risco	f	107
429	Passar a senha se ele souber seu nome	f	108
430	Passar só metade da senha	f	108
431	Passar a senha por mensagem	f	108
432	Desligar: o banco nunca pede senha	t	108
433	Registrar um boletim de ocorrência	t	109
434	Apagar o aplicativo do banco	f	109
435	Mudar de número de celular	f	109
436	Não contar para ninguém	f	109
437	Esperar o golpista desistir	f	110
438	Pedir dinheiro aos contatos para cobrir o prejuízo	f	110
439	Avisar seus contatos para não atenderem pedidos de dinheiro	t	110
440	Nada, isso não traz risco	f	110
441	Vale cada vez mais	f	111
442	Rende juros automaticamente	f	111
443	Continua comprando as mesmas coisas	f	111
444	Perde poder de compra por causa da inflação	t	111
445	O desconto do salário	f	112
446	O aumento geral dos preços	t	112
447	A taxa do cartão de crédito	f	112
448	Um tipo de investimento	f	112
449	Nunca pode resgatar o dinheiro	f	113
450	Precisa de muito dinheiro para começar	f	113
451	Sabe a regra do rendimento quando aplica	t	113
452	Sempre ganha mais que na bolsa	f	113
453	Criptomoedas	f	114
454	Ações de uma empresa	f	114
455	Figurinhas raras	f	114
456	Tesouro Direto	t	114
457	A facilidade de resgatar o dinheiro	t	115
458	O imposto cobrado	f	115
459	O quanto o investimento rende	f	115
460	O risco de perder dinheiro	f	115
461	Garantir que todo investimento dê lucro	f	116
462	Emprestar dinheiro para quem investe	f	116
463	Proteger parte do dinheiro aplicado em alguns investimentos se o banco quebrar	t	116
464	Cobrar taxas dos investidores	f	116
465	Um ótimo investimento de renda fixa	f	117
466	Garantido pelo FGC	f	117
467	Normal para quem está começando	f	117
468	Muito provavelmente um golpe	t	117
469	Render muito mais	f	118
470	Render menos	t	118
471	Ter menos liquidez	f	118
472	Ter mais risco	f	118
473	Só se o banco é famoso	f	119
474	Risco, prazo e liquidez	t	119
475	Só o rendimento	f	119
476	Só a opinião de influenciadores	f	119
477	Ter muito risco para render mais	f	120
478	Segurança e poder resgatar rápido	t	120
479	O maior rendimento possível	f	120
480	Ficar aplicado por muitos anos	f	120
481	Não tem direito	f	121
482	30 dias	f	121
483	7 dias	t	121
484	90 dias	f	121
485	Todo o valor pago, inclusive o frete	t	122
486	Só o valor do produto, sem o frete	f	122
487	Um vale-compras	f	122
488	Só metade do valor	f	122
489	Só em lojas de shopping	f	123
490	Fora da loja física, como pela internet	t	123
491	Só com cartão de crédito	f	123
492	Só em supermercados	f	123
493	90 dias	t	124
494	1 ano sempre	f	124
495	7 dias	f	124
496	15 dias	f	124
497	90 dias	f	125
498	7 dias	f	125
499	2 anos	f	125
500	30 dias	t	125
501	Só aceitar o conserto	f	126
502	Só esperar mais	f	126
503	Escolher entre troca, dinheiro de volta ou desconto	t	126
504	Só pedir um vale	f	126
505	Nada	f	127
506	Um brinde da empresa	f	127
507	O dobro do que pagou a mais	t	127
508	Só metade	f	127
509	Fazer um boletim de ocorrência	f	128
510	Falar com o SAC da empresa e anotar o protocolo	t	128
511	Postar só nas redes sociais	f	128
512	Desistir da reclamação	f	128
513	Um banco digital	f	129
514	Uma loja do governo	f	129
515	Um site de compras	f	129
516	Um serviço público e gratuito para reclamar de empresas	t	129
517	Código de Defesa do Consumidor	t	130
518	Código Penal	f	130
519	Estatuto da Juventude	f	130
520	Consolidação das Leis do Trabalho	f	130
521	Só depois dos 18 anos	f	131
522	Não, só quem trabalha paga	f	131
523	Sim, porque muitos impostos vêm embutidos no preço das compras	t	131
524	Só se tiver conta em banco	f	131
525	Cobrado só de empresas estrangeiras	f	132
526	Federal, sobre a renda	f	132
527	Estadual, sobre circulação de mercadorias e alguns serviços	t	132
528	Municipal, sobre imóveis	f	132
529	Salários	f	133
530	Serviços	t	133
531	Imóveis	f	133
532	Heranças	f	133
533	O que a pessoa compra no mercado	f	134
534	A gasolina	f	134
535	O que a pessoa ganha	t	134
536	A conta de luz	f	134
537	O valor aproximado dos tributos da compra	t	135
538	O CPF do dono da loja	f	135
539	O salário do vendedor	f	135
540	O lucro da loja	f	135
541	Porque é obrigatório para usar o Pix	f	136
542	Não faz diferença	f	136
543	Porque dá desconto automático	f	136
544	Ajuda a garantir que o imposto pago chegue aos cofres públicos	t	136
545	As multas de trânsito	f	137
546	A herança	f	137
547	O consumo	t	137
548	Os imóveis	f	137
549	IOF e ITR	f	138
550	INSS e FGTS	f	138
551	CBS e IBS	t	138
552	IPTU e IPVA	f	138
553	2050	f	139
554	2026	f	139
555	2033	t	139
556	2024	f	139
557	Imposto de Renda	f	140
558	IPTU	f	140
559	IPVA	f	140
560	ICMS	t	140
561	São devolvidos no fim do mês	f	141
562	Só valem para dívidas	f	141
563	Ficam separados e não rendem	f	141
564	Passam a render juros também	t	141
565	R$ 102	f	142
566	R$ 101	t	142
567	R$ 110	f	142
568	R$ 100,10	f	142
569	R$ 121	t	143
570	R$ 200	f	143
571	R$ 120	f	143
572	R$ 110	f	143
573	Não faz diferença	f	144
574	Porque o dinheiro não perde valor	f	144
575	Porque o banco dá bônus para jovens	f	144
576	Os juros têm mais tempo para render sobre os juros	t	144
577	Valores a Receber	f	145
578	Calculadora do Cidadão	t	145
579	Pix Agendado	f	145
580	Registrato	f	145
581	Não se aplicam	f	146
582	Fazem a dívida crescer cada vez mais rápido	t	146
583	Fazem a dívida diminuir sozinha	f	146
584	Só aparecem depois de um ano	f	146
585	Usa o cartão de débito	f	147
586	Faz um Pix	f	147
587	Paga menos que o total da fatura	t	147
588	Paga a fatura inteira	f	147
589	50% do salário	f	148
590	100% do valor da dívida	t	148
591	10% do valor da dívida	f	148
592	Não existe limite	f	148
593	Usar dois cartões	f	149
594	Pagar a fatura inteira até o vencimento	t	149
595	Pagar só o mínimo	f	149
596	Atrasar uma semana	f	149
597	Trocar por uma dívida com juros menores	t	150
598	Ignorar até prescrever	f	150
599	Fazer outra dívida maior	f	150
600	Pagar só os juros para sempre	f	150
\.


--
-- Data for Name: atividades_atividade; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.atividades_atividade (id, titulo, descricao, modulo_id) FROM stdin;
1	Quiz - O que você sabe sobre endividamento?	Teste o que você aprendeu sobre orçamento, juros e como sair do endividamento.	1
2	Quiz: entendendo o seu orçamento	Teste o que você aprendeu sobre orçamento e fluxo de caixa.	3
3	Quiz: economia global	Teste o que você aprendeu sobre câmbio e como ele chega ao seu bolso.	4
10	Quiz: primeiro salário	Responda as perguntas para testar o que você aprendeu no módulo.	11
11	Quiz: golpes financeiros	Responda as perguntas para testar o que você aprendeu no módulo.	12
12	Quiz: investir pela primeira vez	Responda as perguntas para testar o que você aprendeu no módulo.	13
13	Quiz: direitos do consumidor	Responda as perguntas para testar o que você aprendeu no módulo.	14
14	Quiz: impostos no dia a dia	Responda as perguntas para testar o que você aprendeu no módulo.	15
15	Quiz: juros compostos na prática	Responda as perguntas para testar o que você aprendeu no módulo.	16
\.


--
-- Data for Name: atividades_pergunta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.atividades_pergunta (id, enunciado, atividade_id) FROM stdin;
1	O que é um orçamento pessoal?	1
2	Você compra algo parcelado no cartão e, no mês seguinte, não consegue pagar a fatura inteira. Paga só uma parte e deixa o resto "rolar". O que acontece com o valor que ficou pra trás?	1
3	Um amigo te diz: "Pago só o mínimo da fatura, assim sobra dinheiro pra outras coisas." Qual é o problema dessa estratégia?	1
4	Você tem três dívidas em aberto: uma no cartão, uma com um amigo e um financiamento. Por onde é mais inteligente começar a pagar primeiro?	1
5	Dividir a renda em "gastos fixos", "coisas que eu quero" e "guardar/pagar dívida" é a lógica por trás de qual estratégia de orçamento?	1
6	Você está na loja, vê algo que não precisava comprar e pensa "ah, vou parcelar, não dói tanto". O que costuma ajudar a evitar esse tipo de compra por impulso?	1
7	Qual serviço gratuito do Banco Central mostra os empréstimos e financiamentos no seu CPF?	1
8	Na regra 50-30-20, qual parte da renda vai para guardar ou pagar dívidas?	1
9	Desde 2024, os juros e encargos do rotativo do cartão estão limitados a…	1
10	Enquanto está pagando as dívidas, o mais importante é…	1
11	Na comparação com uma viagem de carro, o fluxo de caixa é…	2
12	O que é o fluxo de caixa pessoal?	2
13	Qual destes é uma despesa fixa?	2
14	Qual destes é uma despesa variável?	2
15	Mesada, salário e renda extra são exemplos de…	2
16	No primeiro mês de orçamento, por que vale anotar até os gastos pequenos?	2
17	Se o orçamento fechou com sobra, o melhor é…	2
18	Se as despesas estão maiores que as receitas, por onde começar a cortar?	2
19	Cobrir o mês que não fechou com o cheque especial…	2
20	Qual é a ferramenta mais importante para fazer um orçamento?	2
21	Na tabela de cotações, a coluna "Venda" mostra…	3
22	A diferença entre o preço de venda e o de compra de uma moeda se chama…	3
23	Uma variação de -0,50% na tabela quer dizer que a moeda…	3
24	Quem compra dólar em espécie para viajar paga, em geral…	3
25	Por que o dólar é chamado de moeda de reserva?	3
26	Quando o dólar sobe, o que tende a ficar mais caro no Brasil?	3
27	Quantos países usam o euro desde a entrada da Bulgária, em 2026?	3
28	O que diferencia o bitcoin do dólar e do euro?	3
29	Quando os juros nos Estados Unidos sobem, o dólar costuma…	3
30	Qual índice oficial mostra quando a alta do dólar chega aos preços no Brasil?	3
91	O valor que cai na sua conta depois dos descontos é o salário…	10
92	Para que serve o desconto do INSS no holerite?	10
93	Qual é o melhor momento para decidir o destino do salário?	10
94	Reserva de emergência serve principalmente para…	10
95	Onde faz mais sentido deixar a reserva de emergência?	10
96	Você recebeu o primeiro salário e quer começar a guardar. O mais importante no começo é…	10
97	O vale-transporte pode aparecer no holerite como…	10
98	Qual destes é um gasto essencial?	10
99	Antes de planejar os gastos do mês, o primeiro passo é…	10
100	Se a sua renda é de R$ 1.500 e você guarda R$ 150 por mês, quanto terá guardado em 6 meses (sem rendimento)?	10
101	Um "amigo" manda mensagem de um número novo pedindo um Pix urgente. O que fazer primeiro?	11
102	Antes de pagar um boleto, o que você deve conferir?	11
103	Você recebeu um SMS dizendo que sua conta foi bloqueada, com um link. O mais seguro é…	11
104	Um comprador te mandou o print de um comprovante de Pix. Isso basta para entregar o produto?	11
105	Caiu em um golpe com Pix. Qual é a primeira atitude?	11
106	Qual sinal é comum em quase todo golpe?	11
107	Uma promessa de "dinheiro fácil com retorno garantido e alto" é…	11
108	Alguém liga dizendo ser do banco e pede sua senha. Você deve…	11
109	Depois de cair em um golpe, além de avisar o banco, é recomendado…	11
110	Se sua conta de mensagens foi clonada, o que fazer?	11
111	O que acontece com dinheiro parado, sem render nada, ao longo do tempo?	12
112	Inflação é…	12
113	Na renda fixa, você…	12
114	Qual destas é uma opção de renda fixa?	12
115	Liquidez é…	12
116	O FGC serve para…	12
117	Alguém promete 20% de lucro por mês, sem nenhum risco. Isso é…	12
118	A poupança, comparada com outras opções de renda fixa, costuma…	12
119	Antes de escolher um investimento, você deve olhar…	12
120	Para a reserva de emergência, o mais importante é…	12
121	Você comprou um fone pela internet e se arrependeu. Quantos dias tem para desistir?	13
122	No direito de arrependimento, a loja deve devolver…	13
123	O direito de arrependimento vale principalmente para compras feitas…	13
124	Qual é o prazo para reclamar de defeito em um celular (produto durável)?	13
125	E para reclamar de defeito em um alimento (produto não durável)?	13
126	Se a empresa não resolver o defeito em 30 dias, você pode…	13
127	Você pagou uma cobrança que não devia. Em regra, tem direito a receber…	13
128	Antes de reclamar em outro lugar, o primeiro passo costuma ser…	13
129	O consumidor.gov.br é…	13
130	Qual lei reúne os direitos de quem compra produtos e serviços no Brasil?	13
131	Quem não tem salário paga imposto?	14
132	O ICMS é um imposto…	14
133	O ISS é cobrado principalmente sobre…	14
134	O Imposto de Renda incide sobre…	14
135	Desde 2012, a nota fiscal deve informar…	14
136	Por que vale a pena pedir a nota fiscal?	14
137	A reforma tributária aprovada em 2023 trata principalmente de impostos sobre…	14
138	Quais são os dois novos tributos criados pela reforma?	14
139	Até quando vai a transição da reforma tributária?	14
140	Qual destes tributos a reforma vai substituir?	14
141	Nos juros compostos, os juros de cada mês…	15
142	R$ 100 aplicados a 1% ao mês viram quanto depois de 1 mês?	15
143	R$ 100 a 10% ao mês, com juros compostos, viram quanto depois de 2 meses?	15
144	Por que começar a guardar cedo faz diferença?	15
145	Qual ferramenta do Banco Central ajuda a simular quanto um valor guardado pode virar?	15
146	Nas dívidas, os juros compostos…	15
147	O rotativo do cartão de crédito é usado quando você…	15
148	Desde 2024, o total de juros e encargos do rotativo do cartão é limitado a…	15
149	Qual é a melhor forma de evitar os juros do cartão?	15
150	Se você já tem uma dívida cara, uma boa estratégia é…	15
\.


--
-- Data for Name: atividades_progressoatividade; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.atividades_progressoatividade (id, status, iniciada_em, concluida_em, atividade_id, usuario_id) FROM stdin;
1	concluida	2026-11-03 01:11:15.475916-03	2026-11-03 01:11:15.475916-03	1	1
293	em_andamento	2026-11-06 16:03:05.643999-03	\N	13	1
165	concluida	2026-06-20 08:23:43.307064-03	2026-06-22 12:46:43.307064-03	11	50
166	concluida	2026-06-23 13:46:43.307064-03	2026-06-23 13:54:43.307064-03	1	50
167	concluida	2026-06-23 21:54:43.307064-03	2026-06-23 22:19:43.307064-03	2	50
168	concluida	2026-06-29 08:19:43.307064-03	2026-06-29 08:23:43.307064-03	3	50
169	concluida	2026-06-29 19:23:43.307064-03	2026-06-29 19:46:43.307064-03	10	50
170	concluida	2026-06-30 20:28:43.307064-03	2026-07-01 15:41:43.307064-03	13	50
171	concluida	2026-07-02 17:41:43.307064-03	2026-07-02 17:57:43.307064-03	12	50
172	em_andamento	2026-07-05 19:57:43.307064-03	\N	14	50
173	concluida	2026-07-18 10:47:43.307064-03	2026-07-18 11:04:43.307064-03	15	51
174	concluida	2026-07-24 21:04:43.307064-03	2026-07-24 21:28:43.307064-03	3	51
175	concluida	2026-07-26 09:51:43.307064-03	2026-07-26 10:03:43.307064-03	1	51
176	concluida	2026-07-26 12:03:43.307064-03	2026-07-31 13:42:43.307064-03	12	51
177	concluida	2026-08-03 13:54:43.307064-03	2026-08-03 14:07:43.307064-03	2	51
178	concluida	2026-08-05 21:07:43.307064-03	2026-08-05 21:21:43.307064-03	13	51
179	concluida	2026-08-08 20:23:43.307064-03	2026-08-08 20:36:43.307064-03	14	51
180	concluida	2026-08-09 12:29:43.307064-03	2026-08-09 15:13:43.307064-03	10	51
181	concluida	2026-06-05 14:47:43.307064-03	2026-06-07 19:34:43.307064-03	2	52
182	concluida	2026-06-13 13:31:43.307064-03	2026-06-13 13:46:43.307064-03	12	52
183	concluida	2026-06-17 22:46:43.307064-03	2026-06-18 08:04:43.307064-03	10	52
184	concluida	2026-06-24 14:04:43.307064-03	2026-06-27 10:46:43.307064-03	13	52
185	concluida	2026-06-30 15:46:43.307064-03	2026-06-30 17:40:43.307064-03	15	52
186	concluida	2026-07-06 22:40:43.307064-03	2026-07-06 21:43:43.307064-03	3	52
187	concluida	2026-07-12 08:45:43.307064-03	2026-07-12 09:01:43.307064-03	11	52
148	concluida	2026-07-11 07:21:43.307064-03	2026-07-11 07:44:43.307064-03	10	47
149	concluida	2026-07-15 17:44:43.307064-03	2026-07-15 17:56:43.307064-03	3	47
150	concluida	2026-07-18 20:56:43.307064-03	2026-07-18 21:09:43.307064-03	13	47
151	concluida	2026-07-25 13:44:43.307064-03	2026-07-26 16:32:43.307064-03	1	47
152	concluida	2026-07-28 21:32:43.307064-03	2026-07-28 21:38:43.307064-03	2	47
153	concluida	2026-07-29 08:49:43.307064-03	2026-07-31 13:47:43.307064-03	12	47
154	concluida	2026-09-06 13:30:43.307064-03	2026-09-11 15:14:43.307064-03	2	48
155	concluida	2026-07-06 15:58:43.307064-03	2026-07-06 16:12:43.307064-03	14	49
156	concluida	2026-07-13 14:25:43.307064-03	2026-07-13 14:34:43.307064-03	1	49
157	concluida	2026-07-18 17:34:43.307064-03	2026-07-20 14:37:43.307064-03	3	49
158	concluida	2026-07-25 10:06:43.307064-03	2026-07-30 13:31:43.307064-03	12	49
159	concluida	2026-08-04 14:31:43.307064-03	2026-08-04 14:50:43.307064-03	15	49
160	em_andamento	2026-08-07 20:50:43.307064-03	\N	10	49
161	concluida	2026-08-16 20:50:43.307064-03	2026-08-16 20:54:43.307064-03	2	49
162	concluida	2026-08-17 21:54:43.307064-03	2026-08-26 15:31:43.307064-03	13	49
163	em_andamento	2026-09-01 14:17:43.307064-03	\N	11	49
164	em_andamento	2026-06-14 08:23:43.307064-03	\N	15	50
188	concluida	2026-07-14 16:01:43.307064-03	2026-07-19 16:42:43.307064-03	1	52
189	concluida	2026-07-23 19:42:43.307064-03	2026-07-24 21:43:43.307064-03	14	52
190	concluida	2026-06-16 12:04:43.307064-03	2026-06-16 12:29:43.307064-03	13	53
191	concluida	2026-06-21 20:29:43.307064-03	2026-06-21 11:07:43.307064-03	11	53
192	concluida	2026-06-21 18:07:43.307064-03	2026-06-21 18:22:43.307064-03	1	53
193	concluida	2026-06-23 11:52:43.307064-03	2026-06-25 16:13:43.307064-03	3	53
194	em_andamento	2026-06-29 15:45:43.307064-03	\N	10	53
195	concluida	2026-07-04 15:45:43.307064-03	2026-07-04 16:07:43.307064-03	14	53
196	concluida	2026-07-08 11:13:43.307064-03	2026-07-08 11:38:43.307064-03	2	53
197	concluida	2026-08-29 08:20:43.307064-03	2026-08-29 08:39:43.307064-03	13	54
198	concluida	2026-10-15 14:16:43.307064-03	2026-10-15 14:22:43.307064-03	1	55
199	concluida	2026-10-16 21:38:43.307064-03	2026-10-24 21:13:43.307064-03	3	55
123	concluida	2026-08-16 22:08:43.307064-03	2026-08-16 22:19:43.307064-03	13	43
124	concluida	2026-08-20 07:19:43.307064-03	2026-08-20 07:35:43.307064-03	10	43
125	concluida	2026-08-24 09:35:43.307064-03	2026-08-29 12:23:43.307064-03	12	43
126	concluida	2026-09-03 20:23:43.307064-03	2026-09-03 20:33:43.307064-03	2	43
127	concluida	2026-08-23 08:04:43.307064-03	2026-08-28 10:29:43.307064-03	12	44
128	concluida	2026-08-31 21:29:43.307064-03	2026-08-31 21:44:43.307064-03	13	44
129	concluida	2026-09-06 08:01:43.307064-03	2026-09-06 08:19:43.307064-03	10	44
130	concluida	2026-09-09 13:19:43.307064-03	2026-09-09 13:27:43.307064-03	14	44
131	concluida	2026-09-13 21:19:43.307064-03	2026-09-13 21:36:43.307064-03	3	44
132	concluida	2026-09-19 08:36:43.307064-03	2026-09-19 08:47:43.307064-03	15	44
133	concluida	2026-09-22 12:47:43.307064-03	2026-09-22 13:10:43.307064-03	11	44
134	concluida	2026-09-28 16:21:43.307064-03	2026-09-28 16:32:43.307064-03	1	44
135	concluida	2026-09-30 16:14:43.307064-03	2026-09-30 16:30:43.307064-03	2	44
136	concluida	2026-07-15 22:03:43.307064-03	2026-07-20 09:05:43.307064-03	1	45
137	concluida	2026-07-25 17:05:43.307064-03	2026-07-25 17:23:43.307064-03	13	45
138	concluida	2026-07-26 18:23:43.307064-03	2026-07-31 21:24:43.307064-03	11	45
98	concluida	2026-10-26 17:09:43.307064-03	2026-10-26 17:18:43.307064-03	11	40
99	concluida	2026-10-27 17:34:43.307064-03	2026-10-27 22:34:43.307064-03	15	40
100	concluida	2026-10-30 07:34:43.307064-03	2026-10-30 07:54:43.307064-03	14	40
101	concluida	2026-11-04 12:54:43.307064-03	2026-11-04 13:13:43.307064-03	1	40
102	concluida	2026-07-06 10:19:43.307064-03	2026-07-06 10:35:43.307064-03	11	41
103	concluida	2026-07-10 18:35:43.307064-03	2026-07-11 20:25:43.307064-03	13	41
104	concluida	2026-07-18 09:27:43.307064-03	2026-07-19 17:00:43.307064-03	15	41
105	concluida	2026-07-25 08:47:43.307064-03	2026-07-25 09:00:43.307064-03	14	41
106	concluida	2026-07-30 11:00:43.307064-03	2026-07-30 11:05:43.307064-03	3	41
107	concluida	2026-07-31 14:05:43.307064-03	2026-07-31 19:19:43.307064-03	1	41
108	concluida	2026-07-31 18:32:43.307064-03	2026-08-07 09:05:43.307064-03	12	41
109	concluida	2026-08-08 21:05:43.307064-03	2026-08-08 21:18:43.307064-03	2	41
110	concluida	2026-08-13 08:18:43.307064-03	2026-08-16 12:34:43.307064-03	10	41
111	concluida	2026-07-25 11:28:43.307064-03	2026-07-26 13:53:43.307064-03	2	42
112	concluida	2026-07-27 20:59:43.307064-03	2026-07-27 21:23:43.307064-03	14	42
113	concluida	2026-07-30 07:23:43.307064-03	2026-07-30 07:42:43.307064-03	15	42
114	concluida	2026-08-03 12:42:43.307064-03	2026-08-09 22:14:43.307064-03	3	42
115	concluida	2026-08-12 07:14:43.307064-03	2026-08-12 07:24:43.307064-03	12	42
116	concluida	2026-08-18 16:24:43.307064-03	2026-08-18 16:49:43.307064-03	10	42
117	concluida	2026-08-22 20:49:43.307064-03	2026-08-22 21:06:43.307064-03	11	42
118	concluida	2026-08-28 16:39:43.307064-03	2026-08-28 17:02:43.307064-03	13	42
119	concluida	2026-07-29 18:09:43.307064-03	2026-07-29 18:17:43.307064-03	15	43
120	concluida	2026-08-04 20:17:43.307064-03	2026-08-07 17:30:43.307064-03	11	43
121	concluida	2026-08-10 18:30:43.307064-03	2026-08-12 12:02:43.307064-03	1	43
122	concluida	2026-08-13 18:02:43.307064-03	2026-08-13 18:08:43.307064-03	14	43
139	concluida	2026-08-03 19:59:43.307064-03	2026-08-03 20:19:43.307064-03	14	45
140	concluida	2026-08-06 18:27:43.307064-03	2026-08-06 18:52:43.307064-03	10	45
141	em_andamento	2026-08-09 08:23:43.307064-03	\N	12	45
142	concluida	2026-06-01 13:27:43.307064-03	2026-06-03 16:44:43.307064-03	15	46
143	concluida	2026-06-09 17:44:43.307064-03	2026-06-09 21:06:43.307064-03	14	46
144	concluida	2026-06-10 09:44:43.307064-03	2026-06-10 09:52:43.307064-03	1	46
145	concluida	2026-06-15 19:52:43.307064-03	2026-06-15 22:09:43.307064-03	13	46
146	concluida	2026-06-22 09:56:43.307064-03	2026-06-22 13:30:43.307064-03	10	46
147	concluida	2026-06-26 19:30:43.307064-03	2026-06-26 19:36:43.307064-03	2	46
200	em_andamento	2026-10-25 09:13:43.307064-03	\N	11	55
201	concluida	2026-11-02 09:13:43.307064-03	2026-11-02 09:31:43.307064-03	12	55
202	concluida	2026-11-05 12:31:43.307064-03	2026-11-06 10:04:43.307064-03	10	55
203	concluida	2026-08-12 11:35:43.307064-03	2026-08-14 14:23:43.307064-03	15	56
204	concluida	2026-09-05 22:27:43.307064-03	2026-09-05 22:46:43.307064-03	1	57
205	concluida	2026-09-06 18:41:43.307064-03	2026-09-06 18:57:43.307064-03	10	57
206	concluida	2026-09-09 20:57:43.307064-03	2026-09-09 21:07:43.307064-03	14	57
207	concluida	2026-09-10 11:07:43.307064-03	2026-09-12 12:38:43.307064-03	3	57
208	concluida	2026-09-12 19:38:43.307064-03	2026-09-12 16:16:43.307064-03	15	57
209	concluida	2026-09-13 16:14:43.307064-03	2026-09-13 16:27:43.307064-03	12	57
210	concluida	2026-09-18 18:08:43.307064-03	2026-09-18 18:12:43.307064-03	13	57
211	concluida	2026-09-23 13:09:43.307064-03	2026-09-23 13:22:43.307064-03	11	57
212	concluida	2026-09-26 14:22:43.307064-03	2026-09-26 15:44:43.307064-03	2	57
213	concluida	2026-09-12 17:45:43.307064-03	2026-09-13 21:35:43.307064-03	14	58
214	concluida	2026-09-17 10:44:43.307064-03	2026-09-24 17:25:43.307064-03	13	58
215	concluida	2026-09-29 21:27:43.307064-03	2026-10-02 08:14:43.307064-03	15	58
216	concluida	2026-10-06 14:14:43.307064-03	2026-10-06 18:16:43.307064-03	3	58
217	concluida	2026-10-11 22:12:43.307064-03	2026-10-16 18:23:43.307064-03	2	58
218	concluida	2026-10-23 14:17:43.307064-03	2026-10-23 14:41:43.307064-03	1	58
219	concluida	2026-10-29 15:41:43.307064-03	2026-10-29 15:51:43.307064-03	12	58
220	concluida	2026-10-31 17:51:43.307064-03	2026-10-31 18:06:43.307064-03	11	58
221	concluida	2026-10-19 22:52:43.307064-03	2026-10-22 20:14:43.307064-03	15	59
222	concluida	2026-10-23 22:14:43.307064-03	2026-10-23 22:28:43.307064-03	10	59
223	concluida	2026-09-03 18:13:43.307064-03	2026-09-03 18:33:43.307064-03	11	60
224	concluida	2026-09-08 09:02:43.307064-03	2026-09-08 09:19:43.307064-03	3	60
225	concluida	2026-09-14 14:19:43.307064-03	2026-09-14 14:37:43.307064-03	10	60
226	concluida	2026-09-16 15:37:43.307064-03	2026-09-16 20:21:43.307064-03	13	60
227	concluida	2026-09-17 19:56:43.307064-03	2026-09-17 20:02:43.307064-03	1	60
228	concluida	2026-09-21 07:02:43.307064-03	2026-09-21 07:07:43.307064-03	2	60
229	concluida	2026-09-25 19:07:43.307064-03	2026-09-26 21:06:43.307064-03	12	60
230	concluida	2026-09-28 08:18:43.307064-03	2026-09-28 12:11:43.307064-03	15	60
231	concluida	2026-06-03 16:37:43.307064-03	2026-06-03 16:58:43.307064-03	13	61
232	concluida	2026-06-06 22:58:43.307064-03	2026-06-06 23:10:43.307064-03	3	61
233	concluida	2026-06-12 20:18:43.307064-03	2026-06-12 20:32:43.307064-03	10	61
234	concluida	2026-06-19 13:03:43.307064-03	2026-06-19 13:23:43.307064-03	12	61
235	concluida	2026-06-23 14:23:43.307064-03	2026-06-23 14:27:43.307064-03	1	61
236	concluida	2026-06-23 20:19:43.307064-03	2026-06-24 21:35:43.307064-03	11	61
237	concluida	2026-06-30 11:22:43.307064-03	2026-06-30 11:29:43.307064-03	15	61
238	concluida	2026-10-19 19:32:43.307064-03	2026-10-19 19:41:43.307064-03	15	62
239	concluida	2026-10-19 17:47:43.307064-03	2026-10-19 17:55:43.307064-03	12	62
240	concluida	2026-10-23 19:15:43.307064-03	2026-10-23 19:36:43.307064-03	3	62
241	concluida	2026-10-25 10:01:43.307064-03	2026-10-25 10:26:43.307064-03	2	62
242	concluida	2026-10-28 21:26:43.307064-03	2026-10-28 21:37:43.307064-03	10	62
243	concluida	2026-11-01 20:23:43.307064-03	2026-11-03 22:49:43.307064-03	1	62
244	em_andamento	2026-11-05 08:55:43.307064-03	\N	13	62
245	concluida	2026-07-13 19:33:43.307064-03	2026-07-13 19:47:43.307064-03	3	63
246	concluida	2026-07-13 22:47:43.307064-03	2026-07-13 23:00:43.307064-03	12	63
247	concluida	2026-07-18 08:00:43.307064-03	2026-07-18 08:04:43.307064-03	2	63
248	concluida	2026-07-24 14:04:43.307064-03	2026-07-29 16:40:43.307064-03	10	63
249	concluida	2026-08-03 11:43:43.307064-03	2026-08-03 11:50:43.307064-03	1	63
250	concluida	2026-08-08 18:50:43.307064-03	2026-08-08 19:08:43.307064-03	13	63
251	concluida	2026-08-11 11:34:43.307064-03	2026-08-11 11:48:43.307064-03	15	63
252	concluida	2026-08-13 14:48:43.307064-03	2026-08-13 15:13:43.307064-03	11	63
253	concluida	2026-08-18 16:13:43.307064-03	2026-08-18 16:36:43.307064-03	14	63
254	concluida	2026-06-28 16:05:43.307064-03	2026-06-28 16:22:43.307064-03	13	64
255	em_andamento	2026-07-02 16:26:43.307064-03	\N	1	64
256	concluida	2026-07-10 16:26:43.307064-03	2026-07-10 18:01:43.307064-03	12	64
257	concluida	2026-07-12 13:23:43.307064-03	2026-07-12 17:52:43.307064-03	15	64
258	concluida	2026-07-14 12:02:43.307064-03	2026-07-16 14:54:43.307064-03	10	64
259	concluida	2026-07-18 16:54:43.307064-03	2026-07-18 17:19:43.307064-03	14	64
260	concluida	2026-07-24 22:19:43.307064-03	2026-07-24 22:29:43.307064-03	11	64
261	concluida	2026-07-26 07:29:43.307064-03	2026-07-26 07:53:43.307064-03	2	64
262	concluida	2026-08-01 14:53:43.307064-03	2026-08-01 15:01:43.307064-03	3	64
263	concluida	2026-10-11 20:06:43.307064-03	2026-10-12 22:14:43.307064-03	3	65
264	concluida	2026-10-16 08:14:43.307064-03	2026-10-16 08:29:43.307064-03	11	65
265	concluida	2026-10-16 10:29:43.307064-03	2026-10-16 10:39:43.307064-03	15	65
266	em_andamento	2026-09-04 19:46:43.307064-03	\N	13	66
267	concluida	2026-09-12 19:46:43.307064-03	2026-09-12 20:34:43.307064-03	12	66
268	concluida	2026-09-13 16:45:43.307064-03	2026-09-13 17:06:43.307064-03	1	66
269	concluida	2026-09-16 14:23:43.307064-03	2026-09-16 14:38:43.307064-03	15	66
270	concluida	2026-09-19 21:36:43.307064-03	2026-09-19 22:01:43.307064-03	11	66
271	concluida	2026-09-23 22:18:43.307064-03	2026-09-23 22:34:43.307064-03	14	66
272	concluida	2026-09-27 19:00:43.307064-03	2026-09-27 19:23:43.307064-03	2	66
273	concluida	2026-10-04 11:01:43.307064-03	2026-10-05 14:31:43.307064-03	3	66
274	concluida	2026-08-04 12:52:43.307064-03	2026-08-09 11:34:43.307064-03	13	67
275	concluida	2026-08-14 19:34:43.307064-03	2026-08-15 11:07:43.307064-03	10	67
276	concluida	2026-08-17 16:07:43.307064-03	2026-08-17 16:21:43.307064-03	3	67
277	concluida	2026-06-25 15:38:43.307064-03	2026-06-25 15:42:43.307064-03	11	68
278	concluida	2026-06-30 21:42:43.307064-03	2026-06-30 21:54:43.307064-03	14	68
279	concluida	2026-07-01 14:16:43.307064-03	2026-07-01 14:33:43.307064-03	13	68
280	em_andamento	2026-07-06 10:31:43.307064-03	\N	3	68
281	concluida	2026-07-11 10:31:43.307064-03	2026-07-11 10:42:43.307064-03	15	68
282	concluida	2026-07-17 21:42:43.307064-03	2026-07-17 21:57:43.307064-03	12	68
283	concluida	2026-07-20 08:57:43.307064-03	2026-07-20 09:04:43.307064-03	2	68
284	concluida	2026-07-18 12:02:43.307064-03	2026-07-18 12:11:43.307064-03	10	69
285	concluida	2026-07-19 16:11:43.307064-03	2026-07-21 17:19:43.307064-03	1	69
286	concluida	2026-07-23 18:19:43.307064-03	2026-07-25 19:38:43.307064-03	12	69
287	concluida	2026-07-27 17:18:43.307064-03	2026-07-27 17:37:43.307064-03	15	69
288	concluida	2026-08-02 14:04:43.307064-03	2026-08-02 14:21:43.307064-03	11	69
289	concluida	2026-08-09 09:52:43.307064-03	2026-08-09 09:58:43.307064-03	3	69
290	concluida	2026-08-09 20:58:43.307064-03	2026-08-09 21:12:43.307064-03	14	69
291	concluida	2026-08-10 09:36:43.307064-03	2026-08-10 09:48:43.307064-03	13	69
292	concluida	2026-08-11 15:48:43.307064-03	2026-08-11 16:08:43.307064-03	2	69
\.


--
-- Data for Name: atividades_resposta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.atividades_resposta (id, correta, alternativa_id, pergunta_id, tentativa_id) FROM stdin;
1	t	2	1	1
2	t	7	2	1
3	t	11	3	1
4	t	14	4	1
5	t	17	5	1
6	t	22	6	1
1057	t	402	101	107
1058	t	405	102	107
1059	t	412	103	107
1060	f	415	104	107
1061	t	420	105	107
1062	t	421	106	107
1063	f	427	107	107
1064	t	432	108	107
1065	t	433	109	107
1066	t	439	110	107
1067	f	561	141	108
1068	f	568	142	108
1069	t	569	143	108
1070	t	576	144	108
1071	t	578	145	108
1072	t	582	146	108
1073	f	586	147	108
1074	t	590	148	108
1075	t	594	149	108
1076	t	597	150	108
1077	f	561	141	109
1078	t	566	142	109
1079	t	569	143	109
1080	t	576	144	109
1081	t	578	145	109
1082	t	582	146	109
1083	t	587	147	109
1084	t	590	148	109
1085	t	594	149	109
1086	t	597	150	109
1087	t	523	131	110
1088	t	527	132	110
1089	t	530	133	110
1090	t	535	134	110
1091	f	538	135	110
1092	t	544	136	110
1093	t	547	137	110
1094	t	551	138	110
1095	t	555	139	110
1096	f	559	140	110
1097	t	2	1	111
1098	t	7	2	111
1099	t	11	3	111
1100	f	13	4	111
1101	t	17	5	111
1102	t	22	6	111
1103	t	26	7	111
1104	t	32	8	111
1105	t	35	9	111
1106	f	38	10	111
1107	f	403	101	112
1108	t	405	102	112
1109	t	412	103	112
1110	t	413	104	112
1111	f	417	105	112
1112	f	422	106	112
1113	f	428	107	112
1114	t	432	108	112
1115	t	433	109	112
1116	f	437	110	112
1117	t	483	121	113
1118	t	485	122	113
1119	t	490	123	113
1120	f	496	124	113
1121	t	500	125	113
1122	t	503	126	113
1123	t	507	127	113
1124	f	509	128	113
1125	t	516	129	113
1126	t	517	130	113
1127	f	484	121	114
1128	t	485	122	114
1129	t	490	123	114
1130	f	494	124	114
1131	t	500	125	114
1132	f	504	126	114
1133	t	507	127	114
1134	t	510	128	114
1135	t	516	129	114
1136	t	517	130	114
1137	t	564	141	115
1138	f	567	142	115
1139	t	569	143	115
1140	t	576	144	115
1141	f	577	145	115
1142	t	582	146	115
1143	f	586	147	115
1144	f	591	148	115
1145	f	596	149	115
1146	f	600	150	115
1147	t	564	141	116
1148	f	567	142	116
1149	f	572	143	116
1150	t	576	144	116
1151	f	580	145	116
1152	t	582	146	116
1153	t	587	147	116
1154	t	590	148	116
1155	t	594	149	116
1156	t	597	150	116
1157	t	564	141	117
1158	f	567	142	117
1159	t	569	143	117
1160	t	576	144	117
1161	t	578	145	117
1162	t	582	146	117
1163	t	587	147	117
1164	t	590	148	117
1165	t	594	149	117
1166	t	597	150	117
1167	t	523	131	118
1168	f	525	132	118
1169	t	530	133	118
1170	t	535	134	118
1171	f	540	135	118
1172	t	544	136	118
1173	t	547	137	118
1174	t	551	138	118
1175	t	555	139	118
1176	f	559	140	118
1177	f	82	21	119
1178	f	85	22	119
1179	t	89	23	119
1180	t	95	24	119
1181	f	100	25	119
1182	t	103	26	119
1183	f	106	27	119
1184	f	111	28	119
1185	f	114	29	119
1186	t	120	30	119
1187	t	2	1	120
1188	t	7	2	120
1189	f	9	3	120
1190	f	16	4	120
1191	f	18	5	120
1192	t	22	6	120
1193	t	26	7	120
1194	f	31	8	120
1195	f	33	9	120
1196	t	37	10	120
1197	f	3	1	121
1198	t	7	2	121
1199	t	11	3	121
1200	t	14	4	121
1201	t	17	5	121
1202	t	22	6	121
1203	t	26	7	121
1204	f	29	8	121
1205	t	35	9	121
1206	t	37	10	121
1207	t	444	111	122
1208	t	446	112	122
1209	t	451	113	122
1210	t	456	114	122
1211	f	460	115	122
1212	t	463	116	122
1213	f	467	117	122
1214	t	470	118	122
1215	t	474	119	122
1216	t	478	120	122
1217	f	441	111	123
1218	t	446	112	123
1219	t	451	113	123
1220	f	455	114	123
1221	t	457	115	123
1222	t	463	116	123
1223	t	468	117	123
1224	t	470	118	123
1225	f	473	119	123
1226	f	480	120	123
1227	f	441	111	124
1228	t	446	112	124
1229	t	451	113	124
1230	f	455	114	124
1231	t	457	115	124
1232	t	463	116	124
1233	t	468	117	124
1234	t	470	118	124
1235	t	474	119	124
1236	t	478	120	124
1237	f	43	11	125
1238	t	45	12	125
1239	t	49	13	125
1240	f	54	14	125
1241	f	58	15	125
1242	t	62	16	125
1243	f	66	17	125
1244	t	69	18	125
1245	f	75	19	125
1246	t	79	20	125
1247	f	364	91	126
1248	t	367	92	126
1249	f	370	93	126
1250	t	375	94	126
1251	f	378	95	126
1252	t	383	96	126
1253	t	388	97	126
1254	t	390	98	126
1255	t	395	99	126
1256	f	400	100	126
1257	f	364	91	127
1258	f	366	92	127
1259	t	371	93	127
1260	t	375	94	127
1261	t	379	95	127
1262	t	383	96	127
1263	t	388	97	127
1264	t	390	98	127
1265	t	395	99	127
1266	t	398	100	127
1267	t	361	91	128
1268	t	367	92	128
1269	t	371	93	128
1270	t	375	94	128
1271	t	379	95	128
1272	t	383	96	128
1273	f	387	97	128
1274	t	390	98	128
1275	t	395	99	128
1276	t	398	100	128
1277	f	44	11	129
1278	t	45	12	129
1279	t	49	13	129
1280	t	53	14	129
1281	f	59	15	129
1282	f	64	16	129
1283	f	66	17	129
1284	t	69	18	129
1285	t	74	19	129
1286	t	79	20	129
1287	t	42	11	130
1288	f	48	12	130
1289	t	49	13	130
1290	t	53	14	130
1291	t	60	15	130
1292	t	62	16	130
1293	t	65	17	130
1294	t	69	18	130
1295	t	74	19	130
1296	t	79	20	130
1297	t	523	131	131
1298	t	527	132	131
1299	t	530	133	131
1300	f	533	134	131
1301	t	537	135	131
1302	t	544	136	131
1303	t	547	137	131
1304	t	551	138	131
1305	f	556	139	131
1306	t	560	140	131
1307	t	564	141	132
1308	t	566	142	132
1309	f	570	143	132
1310	t	576	144	132
1311	t	578	145	132
1312	t	582	146	132
1313	t	587	147	132
1314	t	590	148	132
1315	t	594	149	132
1316	t	597	150	132
1317	t	81	21	133
1318	t	87	22	133
1319	f	92	23	133
1320	f	93	24	133
1321	f	98	25	133
1322	f	102	26	133
1323	t	108	27	133
1324	t	110	28	133
1325	f	116	29	133
1326	t	120	30	133
1327	f	82	21	134
1328	f	86	22	134
1329	t	89	23	134
1330	f	93	24	134
1331	t	97	25	134
1332	t	103	26	134
1333	f	106	27	134
1334	t	110	28	134
1335	t	113	29	134
1336	t	120	30	134
1337	t	81	21	135
1338	t	87	22	135
1339	t	89	23	135
1340	t	95	24	135
1341	t	97	25	135
1342	f	102	26	135
1343	t	108	27	135
1344	t	110	28	135
1345	t	113	29	135
1346	t	120	30	135
1347	t	444	111	136
1348	t	446	112	136
1349	t	451	113	136
1350	t	456	114	136
1351	t	457	115	136
1352	t	463	116	136
1353	t	468	117	136
1354	t	470	118	136
1355	t	474	119	136
1356	t	478	120	136
1357	t	361	91	137
1358	f	366	92	137
1359	t	371	93	137
1360	t	375	94	137
1361	f	377	95	137
1362	f	382	96	137
1363	t	388	97	137
1364	t	390	98	137
1365	t	395	99	137
1366	f	400	100	137
1367	t	402	101	138
1368	t	405	102	138
1369	t	412	103	138
1370	t	413	104	138
1371	t	420	105	138
1372	t	421	106	138
1373	t	426	107	138
1374	t	432	108	138
1375	t	433	109	138
1376	f	437	110	138
1377	t	483	121	139
1378	t	485	122	139
1379	t	490	123	139
1380	f	496	124	139
1381	t	500	125	139
1382	t	503	126	139
1383	f	506	127	139
1384	t	510	128	139
1385	f	514	129	139
1386	t	517	130	139
1387	t	564	141	140
1388	f	567	142	140
1389	f	572	143	140
1390	f	575	144	140
1391	t	578	145	140
1392	t	582	146	140
1393	t	587	147	140
1394	f	589	148	140
1395	t	594	149	140
1396	f	598	150	140
1397	f	404	101	141
1398	t	405	102	141
1399	t	412	103	141
1400	f	415	104	141
1401	t	420	105	141
1402	t	421	106	141
1403	t	426	107	141
1404	t	432	108	141
1405	f	435	109	141
1406	f	438	110	141
1407	f	401	101	142
1408	t	405	102	142
1409	t	412	103	142
1410	f	415	104	142
1411	f	419	105	142
1412	t	421	106	142
1413	t	426	107	142
1414	f	430	108	142
1415	f	434	109	142
1416	t	439	110	142
1417	t	2	1	143
1418	f	8	2	143
1419	f	10	3	143
1420	f	16	4	143
1421	t	17	5	143
1422	t	22	6	143
1423	t	26	7	143
1424	t	32	8	143
1425	f	33	9	143
1426	t	37	10	143
1427	t	2	1	144
1428	t	7	2	144
1429	f	10	3	144
1430	t	14	4	144
1431	t	17	5	144
1432	t	22	6	144
1433	t	26	7	144
1434	f	31	8	144
1435	t	35	9	144
1436	t	37	10	144
1437	t	2	1	145
1438	f	5	2	145
1439	t	11	3	145
1440	t	14	4	145
1441	t	17	5	145
1442	t	22	6	145
1443	t	26	7	145
1444	t	32	8	145
1445	t	35	9	145
1446	t	37	10	145
1447	f	524	131	146
1448	t	527	132	146
1449	f	529	133	146
1450	f	533	134	146
1451	t	537	135	146
1452	t	544	136	146
1453	t	547	137	146
1454	t	551	138	146
1455	t	555	139	146
1456	f	557	140	146
1457	f	482	121	147
1458	t	485	122	147
1459	t	490	123	147
1460	t	493	124	147
1461	t	500	125	147
1462	t	503	126	147
1463	t	507	127	147
1464	t	510	128	147
1465	t	516	129	147
1466	t	517	130	147
1467	t	361	91	148
1468	t	367	92	148
1469	t	371	93	148
1470	t	375	94	148
1471	t	379	95	148
1472	f	384	96	148
1473	t	388	97	148
1474	t	390	98	148
1475	t	395	99	148
1476	f	397	100	148
1477	f	443	111	149
1478	f	447	112	149
1479	f	449	113	149
1480	f	453	114	149
1481	f	459	115	149
1482	t	463	116	149
1483	f	467	117	149
1484	f	471	118	149
1485	f	476	119	149
1486	f	477	120	149
1487	t	444	111	150
1488	f	447	112	150
1489	f	449	113	150
1490	t	456	114	150
1491	f	459	115	150
1492	t	463	116	150
1493	t	468	117	150
1494	t	470	118	150
1495	t	474	119	150
1496	t	478	120	150
1497	t	42	11	151
1498	t	45	12	151
1499	f	50	13	151
1500	f	55	14	151
1501	t	60	15	151
1502	f	61	16	151
1503	f	67	17	151
1504	t	69	18	151
1505	f	73	19	151
1506	t	79	20	151
1507	f	443	111	152
1508	t	446	112	152
1509	t	451	113	152
1510	t	456	114	152
1511	t	457	115	152
1512	t	463	116	152
1513	t	468	117	152
1514	f	469	118	152
1515	f	476	119	152
1516	t	478	120	152
1517	t	444	111	153
1518	t	446	112	153
1519	t	451	113	153
1520	t	456	114	153
1521	t	457	115	153
1522	t	463	116	153
1523	f	466	117	153
1524	f	471	118	153
1525	t	474	119	153
1526	t	478	120	153
1527	f	484	121	154
1528	t	485	122	154
1529	f	491	123	154
1530	t	493	124	154
1531	t	500	125	154
1532	t	503	126	154
1533	t	507	127	154
1534	t	510	128	154
1535	t	516	129	154
1536	t	517	130	154
1537	t	361	91	155
1538	t	367	92	155
1539	t	371	93	155
1540	t	375	94	155
1541	t	379	95	155
1542	t	383	96	155
1543	t	388	97	155
1544	f	392	98	155
1545	f	396	99	155
1546	t	398	100	155
1547	t	523	131	156
1548	t	527	132	156
1549	t	530	133	156
1550	f	534	134	156
1551	t	537	135	156
1552	t	544	136	156
1553	t	547	137	156
1554	t	551	138	156
1555	t	555	139	156
1556	t	560	140	156
1557	t	81	21	157
1558	t	87	22	157
1559	t	89	23	157
1560	t	95	24	157
1561	t	97	25	157
1562	f	104	26	157
1563	t	108	27	157
1564	f	112	28	157
1565	t	113	29	157
1566	t	120	30	157
1567	t	564	141	158
1568	t	566	142	158
1569	t	569	143	158
1570	t	576	144	158
1571	t	578	145	158
1572	t	582	146	158
1573	t	587	147	158
1574	t	590	148	158
1575	t	594	149	158
1576	f	599	150	158
1577	t	402	101	159
1578	t	405	102	159
1579	t	412	103	159
1580	t	413	104	159
1581	t	420	105	159
1582	t	421	106	159
1583	t	426	107	159
1584	t	432	108	159
1585	t	433	109	159
1586	t	439	110	159
1587	t	2	1	160
1588	t	7	2	160
1589	t	11	3	160
1590	t	14	4	160
1591	t	17	5	160
1592	t	22	6	160
1593	t	26	7	160
1594	t	32	8	160
1595	t	35	9	160
1596	t	37	10	160
1597	t	42	11	161
1598	t	45	12	161
1599	t	49	13	161
1600	t	53	14	161
1601	t	60	15	161
1602	t	62	16	161
1603	t	65	17	161
1604	t	69	18	161
1605	f	75	19	161
1606	t	79	20	161
1607	t	2	1	162
1608	f	6	2	162
1609	t	11	3	162
1610	f	16	4	162
1611	t	17	5	162
1612	f	21	6	162
1613	f	25	7	162
1614	t	32	8	162
1615	t	35	9	162
1616	t	37	10	162
1617	t	2	1	163
1618	t	7	2	163
1619	t	11	3	163
1620	t	14	4	163
1621	t	17	5	163
1622	t	22	6	163
1623	t	26	7	163
1624	t	32	8	163
1625	t	35	9	163
1626	f	40	10	163
1627	t	483	121	164
1628	t	485	122	164
1629	t	490	123	164
1630	f	494	124	164
1631	f	499	125	164
1632	f	502	126	164
1633	t	507	127	164
1634	f	512	128	164
1635	t	516	129	164
1636	f	519	130	164
1637	t	402	101	165
1638	t	405	102	165
1639	f	410	103	165
1640	t	413	104	165
1641	t	420	105	165
1642	f	424	106	165
1643	t	426	107	165
1644	f	429	108	165
1645	t	433	109	165
1646	f	437	110	165
1647	t	402	101	166
1648	t	405	102	166
1649	t	412	103	166
1650	t	413	104	166
1651	t	420	105	166
1652	t	421	106	166
1653	t	426	107	166
1654	t	432	108	166
1655	t	433	109	166
1656	t	439	110	166
1657	t	523	131	167
1658	t	527	132	167
1659	f	531	133	167
1660	t	535	134	167
1661	f	538	135	167
1662	t	544	136	167
1663	t	547	137	167
1664	t	551	138	167
1665	t	555	139	167
1666	t	560	140	167
1667	f	364	91	168
1668	t	367	92	168
1669	t	371	93	168
1670	t	375	94	168
1671	t	379	95	168
1672	t	383	96	168
1673	t	388	97	168
1674	t	390	98	168
1675	t	395	99	168
1676	f	397	100	168
1677	f	563	141	169
1678	t	566	142	169
1679	f	571	143	169
1680	f	575	144	169
1681	t	578	145	169
1682	f	584	146	169
1683	t	587	147	169
1684	f	592	148	169
1685	f	596	149	169
1686	t	597	150	169
1687	f	561	141	170
1688	t	566	142	170
1689	t	569	143	170
1690	f	573	144	170
1691	t	578	145	170
1692	t	582	146	170
1693	t	587	147	170
1694	t	590	148	170
1695	t	594	149	170
1696	t	597	150	170
1697	t	564	141	171
1698	t	566	142	171
1699	t	569	143	171
1700	t	576	144	171
1701	f	577	145	171
1702	t	582	146	171
1703	t	587	147	171
1704	t	590	148	171
1705	t	594	149	171
1706	t	597	150	171
1707	t	523	131	172
1708	f	525	132	172
1709	t	530	133	172
1710	t	535	134	172
1711	f	540	135	172
1712	t	544	136	172
1713	t	547	137	172
1714	t	551	138	172
1715	f	553	139	172
1716	f	557	140	172
1717	t	523	131	173
1718	f	525	132	173
1719	t	530	133	173
1720	t	535	134	173
1721	t	537	135	173
1722	t	544	136	173
1723	t	547	137	173
1724	t	551	138	173
1725	t	555	139	173
1726	t	560	140	173
1727	f	1	1	174
1728	f	6	2	174
1729	f	12	3	174
1730	f	16	4	174
1731	t	17	5	174
1732	t	22	6	174
1733	f	25	7	174
1734	f	30	8	174
1735	f	36	9	174
1736	f	38	10	174
1737	f	482	121	175
1738	t	485	122	175
1739	t	490	123	175
1740	f	496	124	175
1741	f	499	125	175
1742	t	503	126	175
1743	f	508	127	175
1744	f	512	128	175
1745	f	513	129	175
1746	f	519	130	175
1747	f	482	121	176
1748	f	486	122	176
1749	t	490	123	176
1750	t	493	124	176
1751	t	500	125	176
1752	f	502	126	176
1753	t	507	127	176
1754	t	510	128	176
1755	t	516	129	176
1756	f	520	130	176
1757	f	362	91	177
1758	t	367	92	177
1759	f	372	93	177
1760	t	375	94	177
1761	f	378	95	177
1762	f	381	96	177
1763	t	388	97	177
1764	t	390	98	177
1765	t	395	99	177
1766	f	397	100	177
1767	t	361	91	178
1768	t	367	92	178
1769	t	371	93	178
1770	t	375	94	178
1771	t	379	95	178
1772	f	381	96	178
1773	t	388	97	178
1774	t	390	98	178
1775	f	393	99	178
1776	t	398	100	178
1777	t	42	11	179
1778	t	45	12	179
1779	t	49	13	179
1780	t	53	14	179
1781	t	60	15	179
1782	f	61	16	179
1783	t	65	17	179
1784	t	69	18	179
1785	t	74	19	179
1786	t	79	20	179
1787	t	361	91	180
1788	t	367	92	180
1789	t	371	93	180
1790	t	375	94	180
1791	t	379	95	180
1792	t	383	96	180
1793	f	387	97	180
1794	t	390	98	180
1795	t	395	99	180
1796	f	397	100	180
1797	t	81	21	181
1798	t	87	22	181
1799	t	89	23	181
1800	t	95	24	181
1801	t	97	25	181
1802	t	103	26	181
1803	t	108	27	181
1804	t	110	28	181
1805	t	113	29	181
1806	t	120	30	181
1807	t	483	121	182
1808	t	485	122	182
1809	t	490	123	182
1810	t	493	124	182
1811	t	500	125	182
1812	t	503	126	182
1813	t	507	127	182
1814	t	510	128	182
1815	t	516	129	182
1816	f	520	130	182
1817	t	2	1	183
1818	f	5	2	183
1819	f	10	3	183
1820	t	14	4	183
1821	t	17	5	183
1822	t	22	6	183
1823	t	26	7	183
1824	f	30	8	183
1825	t	35	9	183
1826	t	37	10	183
1827	f	1	1	184
1828	t	7	2	184
1829	f	12	3	184
1830	t	14	4	184
1831	t	17	5	184
1832	t	22	6	184
1833	t	26	7	184
1834	t	32	8	184
1835	t	35	9	184
1836	f	39	10	184
1837	t	42	11	185
1838	t	45	12	185
1839	t	49	13	185
1840	f	56	14	185
1841	t	60	15	185
1842	f	63	16	185
1843	t	65	17	185
1844	t	69	18	185
1845	f	73	19	185
1846	t	79	20	185
1847	t	444	111	186
1848	t	446	112	186
1849	t	451	113	186
1850	f	453	114	186
1851	f	460	115	186
1852	t	463	116	186
1853	f	465	117	186
1854	f	471	118	186
1855	f	475	119	186
1856	t	478	120	186
1857	t	444	111	187
1858	t	446	112	187
1859	t	451	113	187
1860	t	456	114	187
1861	t	457	115	187
1862	t	463	116	187
1863	f	467	117	187
1864	f	471	118	187
1865	f	473	119	187
1866	f	479	120	187
1867	t	42	11	188
1868	f	47	12	188
1869	t	49	13	188
1870	t	53	14	188
1871	t	60	15	188
1872	t	62	16	188
1873	t	65	17	188
1874	f	70	18	188
1875	f	76	19	188
1876	t	79	20	188
1877	t	42	11	189
1878	t	45	12	189
1879	f	52	13	189
1880	t	53	14	189
1881	f	59	15	189
1882	t	62	16	189
1883	t	65	17	189
1884	t	69	18	189
1885	t	74	19	189
1886	f	78	20	189
1887	t	523	131	190
1888	f	526	132	190
1889	t	530	133	190
1890	f	533	134	190
1891	t	537	135	190
1892	t	544	136	190
1893	t	547	137	190
1894	t	551	138	190
1895	t	555	139	190
1896	f	557	140	190
1897	t	2	1	191
1898	t	7	2	191
1899	t	11	3	191
1900	t	14	4	191
1901	t	17	5	191
1902	t	22	6	191
1903	t	26	7	191
1904	t	32	8	191
1905	t	35	9	191
1906	t	37	10	191
1907	f	83	21	192
1908	f	86	22	192
1909	t	89	23	192
1910	t	95	24	192
1911	t	97	25	192
1912	t	103	26	192
1913	t	108	27	192
1914	t	110	28	192
1915	f	116	29	192
1916	f	118	30	192
1917	t	81	21	193
1918	t	87	22	193
1919	t	89	23	193
1920	f	94	24	193
1921	f	98	25	193
1922	f	104	26	193
1923	t	108	27	193
1924	f	111	28	193
1925	f	116	29	193
1926	t	120	30	193
1927	t	81	21	194
1928	t	87	22	194
1929	t	89	23	194
1930	t	95	24	194
1931	t	97	25	194
1932	t	103	26	194
1933	t	108	27	194
1934	f	112	28	194
1935	t	113	29	194
1936	t	120	30	194
1937	f	443	111	195
1938	t	446	112	195
1939	t	451	113	195
1940	t	456	114	195
1941	f	458	115	195
1942	f	461	116	195
1943	f	465	117	195
1944	f	471	118	195
1945	t	474	119	195
1946	t	478	120	195
1947	f	441	111	196
1948	t	446	112	196
1949	t	451	113	196
1950	t	456	114	196
1951	t	457	115	196
1952	t	463	116	196
1953	f	465	117	196
1954	t	470	118	196
1955	t	474	119	196
1956	t	478	120	196
1957	t	564	141	197
1958	t	566	142	197
1959	t	569	143	197
1960	t	576	144	197
1961	f	579	145	197
1962	t	582	146	197
1963	f	588	147	197
1964	t	590	148	197
1965	t	594	149	197
1966	f	598	150	197
1967	t	42	11	198
1968	t	45	12	198
1969	t	49	13	198
1970	t	53	14	198
1971	f	57	15	198
1972	t	62	16	198
1973	t	65	17	198
1974	t	69	18	198
1975	t	74	19	198
1976	f	77	20	198
1977	f	481	121	199
1978	t	485	122	199
1979	t	490	123	199
1980	f	494	124	199
1981	f	497	125	199
1982	t	503	126	199
1983	t	507	127	199
1984	f	512	128	199
1985	f	515	129	199
1986	t	517	130	199
1987	f	484	121	200
1988	t	485	122	200
1989	t	490	123	200
1990	t	493	124	200
1991	t	500	125	200
1992	f	502	126	200
1993	t	507	127	200
1994	f	511	128	200
1995	t	516	129	200
1996	t	517	130	200
1997	t	483	121	201
1998	t	485	122	201
1999	f	489	123	201
2000	t	493	124	201
2001	t	500	125	201
2002	t	503	126	201
2003	t	507	127	201
2004	t	510	128	201
2005	t	516	129	201
2006	t	517	130	201
2007	t	402	101	202
2008	t	405	102	202
2009	t	412	103	202
2010	f	416	104	202
2011	t	420	105	202
2012	t	421	106	202
2013	f	425	107	202
2014	t	432	108	202
2015	t	433	109	202
2016	t	439	110	202
2017	t	402	101	203
2018	t	405	102	203
2019	t	412	103	203
2020	t	413	104	203
2021	t	420	105	203
2022	t	421	106	203
2023	t	426	107	203
2024	t	432	108	203
2025	f	435	109	203
2026	t	439	110	203
2027	t	2	1	204
2028	t	7	2	204
2029	t	11	3	204
2030	f	15	4	204
2031	t	17	5	204
2032	t	22	6	204
2033	t	26	7	204
2034	t	32	8	204
2035	t	35	9	204
2036	t	37	10	204
2037	t	42	11	205
2038	t	45	12	205
2039	t	49	13	205
2040	t	53	14	205
2041	f	57	15	205
2042	t	62	16	205
2043	t	65	17	205
2044	t	69	18	205
2045	t	74	19	205
2046	t	79	20	205
2047	t	81	21	206
2048	t	87	22	206
2049	t	89	23	206
2050	t	95	24	206
2051	f	99	25	206
2052	f	104	26	206
2053	t	108	27	206
2054	f	111	28	206
2055	t	113	29	206
2056	t	120	30	206
2057	f	362	91	207
2058	t	367	92	207
2059	t	371	93	207
2060	t	375	94	207
2061	t	379	95	207
2062	f	384	96	207
2063	t	388	97	207
2064	t	390	98	207
2065	t	395	99	207
2066	f	399	100	207
2067	f	484	121	208
2068	f	488	122	208
2069	f	489	123	208
2070	t	493	124	208
2071	t	500	125	208
2072	t	503	126	208
2073	t	507	127	208
2074	f	512	128	208
2075	f	513	129	208
2076	t	517	130	208
2077	t	483	121	209
2078	t	485	122	209
2079	t	490	123	209
2080	t	493	124	209
2081	t	500	125	209
2082	t	503	126	209
2083	t	507	127	209
2084	t	510	128	209
2085	f	513	129	209
2086	t	517	130	209
2087	t	444	111	210
2088	t	446	112	210
2089	f	452	113	210
2090	t	456	114	210
2091	t	457	115	210
2092	t	463	116	210
2093	t	468	117	210
2094	t	470	118	210
2095	f	473	119	210
2096	t	478	120	210
2097	t	564	141	211
2098	f	567	142	211
2099	t	569	143	211
2100	t	576	144	211
2101	f	580	145	211
2102	t	582	146	211
2103	f	588	147	211
2104	t	590	148	211
2105	t	594	149	211
2106	t	597	150	211
2107	t	81	21	212
2108	f	85	22	212
2109	t	89	23	212
2110	f	94	24	212
2111	f	99	25	212
2112	f	102	26	212
2113	t	108	27	212
2114	f	111	28	212
2115	t	113	29	212
2116	t	120	30	212
2117	t	2	1	213
2118	f	5	2	213
2119	t	11	3	213
2120	f	16	4	213
2121	t	17	5	213
2122	t	22	6	213
2123	f	28	7	213
2124	t	32	8	213
2125	t	35	9	213
2126	t	37	10	213
2127	t	444	111	214
2128	t	446	112	214
2129	t	451	113	214
2130	t	456	114	214
2131	f	458	115	214
2132	f	461	116	214
2133	f	465	117	214
2134	t	470	118	214
2135	t	474	119	214
2136	f	480	120	214
2137	f	442	111	215
2138	t	446	112	215
2139	t	451	113	215
2140	t	456	114	215
2141	f	458	115	215
2142	t	463	116	215
2143	t	468	117	215
2144	f	472	118	215
2145	t	474	119	215
2146	f	480	120	215
2147	t	444	111	216
2148	t	446	112	216
2149	t	451	113	216
2150	t	456	114	216
2151	t	457	115	216
2152	t	463	116	216
2153	t	468	117	216
2154	t	470	118	216
2155	t	474	119	216
2156	t	478	120	216
2157	f	44	11	217
2158	t	45	12	217
2159	t	49	13	217
2160	t	53	14	217
2161	f	57	15	217
2162	t	62	16	217
2163	t	65	17	217
2164	t	69	18	217
2165	t	74	19	217
2166	t	79	20	217
2167	f	484	121	218
2168	f	488	122	218
2169	t	490	123	218
2170	t	493	124	218
2171	t	500	125	218
2172	t	503	126	218
2173	t	507	127	218
2174	f	512	128	218
2175	f	514	129	218
2176	f	519	130	218
2177	f	524	131	219
2178	t	527	132	219
2179	t	530	133	219
2180	t	535	134	219
2181	f	539	135	219
2182	t	544	136	219
2183	t	547	137	219
2184	f	552	138	219
2185	t	555	139	219
2186	t	560	140	219
2187	t	361	91	220
2188	t	367	92	220
2189	t	371	93	220
2190	t	375	94	220
2191	f	377	95	220
2192	f	382	96	220
2193	t	388	97	220
2194	t	390	98	220
2195	t	395	99	220
2196	t	398	100	220
2197	f	362	91	221
2198	t	367	92	221
2199	t	371	93	221
2200	t	375	94	221
2201	t	379	95	221
2202	t	383	96	221
2203	t	388	97	221
2204	t	390	98	221
2205	t	395	99	221
2206	t	398	100	221
2207	f	43	11	222
2208	t	45	12	222
2209	t	49	13	222
2210	f	55	14	222
2211	t	60	15	222
2212	t	62	16	222
2213	f	66	17	222
2214	f	71	18	222
2215	f	73	19	222
2216	t	79	20	222
2217	f	43	11	223
2218	t	45	12	223
2219	t	49	13	223
2220	t	53	14	223
2221	f	59	15	223
2222	t	62	16	223
2223	t	65	17	223
2224	t	69	18	223
2225	f	73	19	223
2226	t	79	20	223
2227	f	443	111	224
2228	t	446	112	224
2229	t	451	113	224
2230	f	453	114	224
2231	t	457	115	224
2232	t	463	116	224
2233	t	468	117	224
2234	t	470	118	224
2235	t	474	119	224
2236	t	478	120	224
2237	f	363	91	225
2238	t	367	92	225
2239	f	370	93	225
2240	t	375	94	225
2241	t	379	95	225
2242	f	384	96	225
2243	t	388	97	225
2244	t	390	98	225
2245	t	395	99	225
2246	f	399	100	225
2247	t	361	91	226
2248	t	367	92	226
2249	t	371	93	226
2250	t	375	94	226
2251	f	378	95	226
2252	t	383	96	226
2253	t	388	97	226
2254	t	390	98	226
2255	f	396	99	226
2256	t	398	100	226
2257	f	484	121	227
2258	f	487	122	227
2259	t	490	123	227
2260	f	495	124	227
2261	t	500	125	227
2262	f	504	126	227
2263	t	507	127	227
2264	t	510	128	227
2265	t	516	129	227
2266	f	518	130	227
2267	f	481	121	228
2268	f	486	122	228
2269	t	490	123	228
2270	f	494	124	228
2271	t	500	125	228
2272	f	504	126	228
2273	t	507	127	228
2274	t	510	128	228
2275	t	516	129	228
2276	f	519	130	228
2277	f	482	121	229
2278	t	485	122	229
2279	f	491	123	229
2280	t	493	124	229
2281	t	500	125	229
2282	t	503	126	229
2283	t	507	127	229
2284	t	510	128	229
2285	t	516	129	229
2286	t	517	130	229
2287	f	561	141	230
2288	t	566	142	230
2289	t	569	143	230
2290	t	576	144	230
2291	f	577	145	230
2292	f	583	146	230
2293	t	587	147	230
2294	t	590	148	230
2295	f	593	149	230
2296	f	598	150	230
2297	f	563	141	231
2298	f	567	142	231
2299	t	569	143	231
2300	t	576	144	231
2301	f	577	145	231
2302	t	582	146	231
2303	t	587	147	231
2304	t	590	148	231
2305	t	594	149	231
2306	t	597	150	231
2307	f	83	21	232
2308	f	86	22	232
2309	t	89	23	232
2310	f	96	24	232
2311	f	100	25	232
2312	t	103	26	232
2313	f	105	27	232
2314	t	110	28	232
2315	t	113	29	232
2316	t	120	30	232
2317	t	81	21	233
2318	t	87	22	233
2319	t	89	23	233
2320	t	95	24	233
2321	t	97	25	233
2322	t	103	26	233
2323	f	105	27	233
2324	f	111	28	233
2325	t	113	29	233
2326	t	120	30	233
2327	t	402	101	234
2328	t	405	102	234
2329	t	412	103	234
2330	f	416	104	234
2331	f	419	105	234
2332	t	421	106	234
2333	t	426	107	234
2334	f	429	108	234
2335	t	433	109	234
2336	t	439	110	234
2337	t	2	1	235
2338	f	5	2	235
2339	f	12	3	235
2340	t	14	4	235
2341	t	17	5	235
2342	t	22	6	235
2343	f	27	7	235
2344	t	32	8	235
2345	f	36	9	235
2346	t	37	10	235
2347	t	2	1	236
2348	t	7	2	236
2349	f	10	3	236
2350	t	14	4	236
2351	t	17	5	236
2352	f	23	6	236
2353	t	26	7	236
2354	t	32	8	236
2355	t	35	9	236
2356	t	37	10	236
2357	f	521	131	237
2358	f	526	132	237
2359	t	530	133	237
2360	f	533	134	237
2361	f	540	135	237
2362	t	544	136	237
2363	t	547	137	237
2364	t	551	138	237
2365	t	555	139	237
2366	t	560	140	237
2367	t	523	131	238
2368	t	527	132	238
2369	t	530	133	238
2370	t	535	134	238
2371	t	537	135	238
2372	t	544	136	238
2373	t	547	137	238
2374	t	551	138	238
2375	t	555	139	238
2376	t	560	140	238
2377	t	483	121	239
2378	f	486	122	239
2379	f	489	123	239
2380	t	493	124	239
2381	t	500	125	239
2382	t	503	126	239
2383	f	506	127	239
2384	f	512	128	239
2385	f	515	129	239
2386	f	520	130	239
2387	f	401	101	240
2388	t	405	102	240
2389	f	411	103	240
2390	t	413	104	240
2391	f	419	105	240
2392	f	424	106	240
2393	f	427	107	240
2394	f	429	108	240
2395	f	434	109	240
2396	f	437	110	240
2397	f	403	101	241
2398	t	405	102	241
2399	f	410	103	241
2400	f	414	104	241
2401	t	420	105	241
2402	t	421	106	241
2403	f	428	107	241
2404	t	432	108	241
2405	t	433	109	241
2406	t	439	110	241
2407	t	2	1	242
2408	t	7	2	242
2409	t	11	3	242
2410	f	13	4	242
2411	t	17	5	242
2412	t	22	6	242
2413	f	28	7	242
2414	t	32	8	242
2415	t	35	9	242
2416	t	37	10	242
2417	t	81	21	243
2418	t	87	22	243
2419	f	90	23	243
2420	f	94	24	243
2421	t	97	25	243
2422	f	102	26	243
2423	t	108	27	243
2424	t	110	28	243
2425	t	113	29	243
2426	f	118	30	243
2427	t	81	21	244
2428	t	87	22	244
2429	t	89	23	244
2430	t	95	24	244
2431	t	97	25	244
2432	t	103	26	244
2433	t	108	27	244
2434	t	110	28	244
2435	t	113	29	244
2436	t	120	30	244
2437	t	523	131	245
2438	t	527	132	245
2439	f	532	133	245
2440	t	535	134	245
2441	t	537	135	245
2442	t	544	136	245
2443	t	547	137	245
2444	t	551	138	245
2445	t	555	139	245
2446	f	558	140	245
2447	t	42	11	246
2448	t	45	12	246
2449	t	49	13	246
2450	t	53	14	246
2451	f	59	15	246
2452	t	62	16	246
2453	t	65	17	246
2454	t	69	18	246
2455	f	76	19	246
2456	t	79	20	246
2457	t	483	121	247
2458	t	485	122	247
2459	t	490	123	247
2460	t	493	124	247
2461	t	500	125	247
2462	t	503	126	247
2463	t	507	127	247
2464	t	510	128	247
2465	t	516	129	247
2466	f	518	130	247
2467	t	2	1	248
2468	t	7	2	248
2469	t	11	3	248
2470	f	16	4	248
2471	t	17	5	248
2472	t	22	6	248
2473	t	26	7	248
2474	t	32	8	248
2475	t	35	9	248
2476	t	37	10	248
2477	t	81	21	249
2478	t	87	22	249
2479	t	89	23	249
2480	t	95	24	249
2481	f	100	25	249
2482	f	102	26	249
2483	f	105	27	249
2484	t	110	28	249
2485	t	113	29	249
2486	f	119	30	249
2487	t	81	21	250
2488	t	87	22	250
2489	t	89	23	250
2490	t	95	24	250
2491	f	99	25	250
2492	t	103	26	250
2493	f	105	27	250
2494	f	109	28	250
2495	f	114	29	250
2496	t	120	30	250
2497	t	81	21	251
2498	t	87	22	251
2499	t	89	23	251
2500	t	95	24	251
2501	t	97	25	251
2502	t	103	26	251
2503	t	108	27	251
2504	t	110	28	251
2505	t	113	29	251
2506	t	120	30	251
2507	t	444	111	252
2508	t	446	112	252
2509	t	451	113	252
2510	t	456	114	252
2511	f	459	115	252
2512	t	463	116	252
2513	t	468	117	252
2514	t	470	118	252
2515	t	474	119	252
2516	t	478	120	252
2517	f	363	91	253
2518	f	365	92	253
2519	t	371	93	253
2520	t	375	94	253
2521	f	378	95	253
2522	t	383	96	253
2523	t	388	97	253
2524	t	390	98	253
2525	f	396	99	253
2526	f	397	100	253
2527	t	361	91	254
2528	t	367	92	254
2529	t	371	93	254
2530	t	375	94	254
2531	t	379	95	254
2532	f	382	96	254
2533	f	387	97	254
2534	t	390	98	254
2535	t	395	99	254
2536	t	398	100	254
2537	t	361	91	255
2538	f	368	92	255
2539	t	371	93	255
2540	t	375	94	255
2541	f	380	95	255
2542	t	383	96	255
2543	t	388	97	255
2544	t	390	98	255
2545	t	395	99	255
2546	t	398	100	255
2547	t	564	141	256
2548	f	565	142	256
2549	t	569	143	256
2550	f	573	144	256
2551	t	578	145	256
2552	t	582	146	256
2553	f	588	147	256
2554	t	590	148	256
2555	f	595	149	256
2556	t	597	150	256
2557	f	561	141	257
2558	f	565	142	257
2559	t	569	143	257
2560	f	574	144	257
2561	t	578	145	257
2562	t	582	146	257
2563	t	587	147	257
2564	t	590	148	257
2565	t	594	149	257
2566	f	600	150	257
2567	t	564	141	258
2568	f	567	142	258
2569	t	569	143	258
2570	t	576	144	258
2571	t	578	145	258
2572	t	582	146	258
2573	t	587	147	258
2574	t	590	148	258
2575	t	594	149	258
2576	t	597	150	258
2577	t	2	1	259
2578	t	7	2	259
2579	f	9	3	259
2580	t	14	4	259
2581	t	17	5	259
2582	t	22	6	259
2583	t	26	7	259
2584	t	32	8	259
2585	t	35	9	259
2586	t	37	10	259
2587	t	361	91	260
2588	t	367	92	260
2589	t	371	93	260
2590	t	375	94	260
2591	t	379	95	260
2592	t	383	96	260
2593	t	388	97	260
2594	t	390	98	260
2595	t	395	99	260
2596	t	398	100	260
2597	t	523	131	261
2598	t	527	132	261
2599	t	530	133	261
2600	f	534	134	261
2601	t	537	135	261
2602	t	544	136	261
2603	t	547	137	261
2604	t	551	138	261
2605	t	555	139	261
2606	t	560	140	261
2607	t	81	21	262
2608	f	86	22	262
2609	f	92	23	262
2610	t	95	24	262
2611	t	97	25	262
2612	f	101	26	262
2613	t	108	27	262
2614	f	112	28	262
2615	t	113	29	262
2616	t	120	30	262
2617	t	81	21	263
2618	t	87	22	263
2619	t	89	23	263
2620	t	95	24	263
2621	t	97	25	263
2622	t	103	26	263
2623	t	108	27	263
2624	t	110	28	263
2625	t	113	29	263
2626	t	120	30	263
2627	t	564	141	264
2628	f	567	142	264
2629	f	572	143	264
2630	t	576	144	264
2631	t	578	145	264
2632	t	582	146	264
2633	t	587	147	264
2634	t	590	148	264
2635	f	593	149	264
2636	t	597	150	264
2637	t	564	141	265
2638	t	566	142	265
2639	t	569	143	265
2640	t	576	144	265
2641	t	578	145	265
2642	t	582	146	265
2643	t	587	147	265
2644	t	590	148	265
2645	t	594	149	265
2646	t	597	150	265
2647	f	442	111	266
2648	t	446	112	266
2649	t	451	113	266
2650	t	456	114	266
2651	t	457	115	266
2652	t	463	116	266
2653	t	468	117	266
2654	t	470	118	266
2655	f	475	119	266
2656	t	478	120	266
2657	t	483	121	267
2658	t	485	122	267
2659	t	490	123	267
2660	f	494	124	267
2661	t	500	125	267
2662	t	503	126	267
2663	t	507	127	267
2664	t	510	128	267
2665	t	516	129	267
2666	f	520	130	267
2667	t	402	101	268
2668	t	405	102	268
2669	f	409	103	268
2670	t	413	104	268
2671	t	420	105	268
2672	t	421	106	268
2673	t	426	107	268
2674	t	432	108	268
2675	t	433	109	268
2676	t	439	110	268
2677	t	42	11	269
2678	t	45	12	269
2679	t	49	13	269
2680	f	55	14	269
2681	f	58	15	269
2682	f	63	16	269
2683	t	65	17	269
2684	t	69	18	269
2685	t	74	19	269
2686	f	77	20	269
2687	t	42	11	270
2688	t	45	12	270
2689	t	49	13	270
2690	t	53	14	270
2691	f	57	15	270
2692	f	63	16	270
2693	t	65	17	270
2694	t	69	18	270
2695	t	74	19	270
2696	t	79	20	270
2697	t	523	131	271
2698	t	527	132	271
2699	t	530	133	271
2700	t	535	134	271
2701	t	537	135	271
2702	t	544	136	271
2703	t	547	137	271
2704	f	552	138	271
2705	t	555	139	271
2706	f	558	140	271
2707	t	523	131	272
2708	t	527	132	272
2709	t	530	133	272
2710	t	535	134	272
2711	f	539	135	272
2712	t	544	136	272
2713	t	547	137	272
2714	t	551	138	272
2715	t	555	139	272
2716	t	560	140	272
2717	t	483	121	273
2718	t	485	122	273
2719	f	491	123	273
2720	f	494	124	273
2721	t	500	125	273
2722	t	503	126	273
2723	f	505	127	273
2724	f	511	128	273
2725	t	516	129	273
2726	t	517	130	273
2727	t	483	121	274
2728	f	487	122	274
2729	t	490	123	274
2730	f	495	124	274
2731	t	500	125	274
2732	t	503	126	274
2733	f	505	127	274
2734	f	511	128	274
2735	t	516	129	274
2736	t	517	130	274
2737	t	483	121	275
2738	t	485	122	275
2739	f	492	123	275
2740	t	493	124	275
2741	t	500	125	275
2742	f	502	126	275
2743	t	507	127	275
2744	f	512	128	275
2745	t	516	129	275
2746	t	517	130	275
2747	f	562	141	276
2748	f	567	142	276
2749	f	571	143	276
2750	t	576	144	276
2751	f	577	145	276
2752	t	582	146	276
2753	t	587	147	276
2754	t	590	148	276
2755	t	594	149	276
2756	t	597	150	276
2757	f	562	141	277
2758	f	568	142	277
2759	f	572	143	277
2760	t	576	144	277
2761	t	578	145	277
2762	t	582	146	277
2763	t	587	147	277
2764	t	590	148	277
2765	f	596	149	277
2766	t	597	150	277
2767	t	564	141	278
2768	t	566	142	278
2769	t	569	143	278
2770	t	576	144	278
2771	t	578	145	278
2772	t	582	146	278
2773	t	587	147	278
2774	t	590	148	278
2775	t	594	149	278
2776	t	597	150	278
2777	f	84	21	279
2778	f	88	22	279
2779	t	89	23	279
2780	t	95	24	279
2781	f	98	25	279
2782	f	104	26	279
2783	t	108	27	279
2784	t	110	28	279
2785	f	116	29	279
2786	t	120	30	279
2787	f	82	21	280
2788	t	87	22	280
2789	t	89	23	280
2790	t	95	24	280
2791	t	97	25	280
2792	t	103	26	280
2793	f	106	27	280
2794	t	110	28	280
2795	t	113	29	280
2796	t	120	30	280
2797	t	81	21	281
2798	t	87	22	281
2799	t	89	23	281
2800	t	95	24	281
2801	t	97	25	281
2802	f	101	26	281
2803	t	108	27	281
2804	t	110	28	281
2805	t	113	29	281
2806	t	120	30	281
2807	t	42	11	282
2808	f	47	12	282
2809	t	49	13	282
2810	f	55	14	282
2811	f	57	15	282
2812	t	62	16	282
2813	f	66	17	282
2814	t	69	18	282
2815	f	75	19	282
2816	f	78	20	282
2817	t	42	11	283
2818	t	45	12	283
2819	t	49	13	283
2820	t	53	14	283
2821	t	60	15	283
2822	f	63	16	283
2823	t	65	17	283
2824	t	69	18	283
2825	f	76	19	283
2826	t	79	20	283
2827	t	42	11	284
2828	t	45	12	284
2829	t	49	13	284
2830	t	53	14	284
2831	t	60	15	284
2832	t	62	16	284
2833	f	67	17	284
2834	t	69	18	284
2835	t	74	19	284
2836	t	79	20	284
2837	t	2	1	285
2838	t	7	2	285
2839	t	11	3	285
2840	t	14	4	285
2841	t	17	5	285
2842	t	22	6	285
2843	t	26	7	285
2844	t	32	8	285
2845	t	35	9	285
2846	t	37	10	285
2847	f	442	111	286
2848	t	446	112	286
2849	f	452	113	286
2850	t	456	114	286
2851	t	457	115	286
2852	t	463	116	286
2853	f	467	117	286
2854	t	470	118	286
2855	t	474	119	286
2856	t	478	120	286
2857	t	402	101	287
2858	t	405	102	287
2859	t	412	103	287
2860	t	413	104	287
2861	t	420	105	287
2862	f	424	106	287
2863	t	426	107	287
2864	t	432	108	287
2865	f	434	109	287
2866	t	439	110	287
2867	f	561	141	288
2868	t	566	142	288
2869	f	570	143	288
2870	f	573	144	288
2871	t	578	145	288
2872	t	582	146	288
2873	f	588	147	288
2874	t	590	148	288
2875	f	593	149	288
2876	t	597	150	288
2877	f	561	141	289
2878	t	566	142	289
2879	t	569	143	289
2880	t	576	144	289
2881	t	578	145	289
2882	t	582	146	289
2883	t	587	147	289
2884	t	590	148	289
2885	f	596	149	289
2886	f	598	150	289
2887	t	361	91	290
2888	f	368	92	290
2889	f	370	93	290
2890	t	375	94	290
2891	f	378	95	290
2892	t	383	96	290
2893	t	388	97	290
2894	t	390	98	290
2895	f	394	99	290
2896	t	398	100	290
2897	t	402	101	291
2898	t	405	102	291
2899	t	412	103	291
2900	t	413	104	291
2901	t	420	105	291
2902	f	423	106	291
2903	t	426	107	291
2904	t	432	108	291
2905	t	433	109	291
2906	t	439	110	291
2907	t	81	21	292
2908	t	87	22	292
2909	t	89	23	292
2910	t	95	24	292
2911	t	97	25	292
2912	f	102	26	292
2913	t	108	27	292
2914	t	110	28	292
2915	t	113	29	292
2916	t	120	30	292
2917	t	361	91	293
2918	t	367	92	293
2919	t	371	93	293
2920	t	375	94	293
2921	t	379	95	293
2922	t	383	96	293
2923	t	388	97	293
2924	t	390	98	293
2925	t	395	99	293
2926	t	398	100	293
2927	t	483	121	294
2928	t	485	122	294
2929	t	490	123	294
2930	t	493	124	294
2931	t	500	125	294
2932	f	501	126	294
2933	t	507	127	294
2934	f	509	128	294
2935	t	516	129	294
2936	f	520	130	294
2937	t	483	121	295
2938	t	485	122	295
2939	t	490	123	295
2940	t	493	124	295
2941	t	500	125	295
2942	t	503	126	295
2943	t	507	127	295
2944	t	510	128	295
2945	t	516	129	295
2946	f	520	130	295
2947	t	2	1	296
2948	t	7	2	296
2949	t	11	3	296
2950	f	15	4	296
2951	t	17	5	296
2952	t	22	6	296
2953	t	26	7	296
2954	t	32	8	296
2955	t	35	9	296
2956	t	37	10	296
2957	t	42	11	297
2958	t	45	12	297
2959	t	49	13	297
2960	t	53	14	297
2961	f	59	15	297
2962	t	62	16	297
2963	t	65	17	297
2964	t	69	18	297
2965	t	74	19	297
2966	t	79	20	297
2967	t	444	111	298
2968	t	446	112	298
2969	t	451	113	298
2970	t	456	114	298
2971	f	459	115	298
2972	t	463	116	298
2973	f	467	117	298
2974	t	470	118	298
2975	t	474	119	298
2976	t	478	120	298
2977	t	444	111	299
2978	t	446	112	299
2979	t	451	113	299
2980	t	456	114	299
2981	t	457	115	299
2982	t	463	116	299
2983	t	468	117	299
2984	t	470	118	299
2985	t	474	119	299
2986	t	478	120	299
2987	t	564	141	300
2988	t	566	142	300
2989	t	569	143	300
2990	t	576	144	300
2991	t	578	145	300
2992	t	582	146	300
2993	t	587	147	300
2994	f	589	148	300
2995	f	593	149	300
2996	f	599	150	300
2997	f	562	141	301
2998	f	568	142	301
2999	t	569	143	301
3000	t	576	144	301
3001	t	578	145	301
3002	t	582	146	301
3003	t	587	147	301
3004	t	590	148	301
3005	t	594	149	301
3006	f	600	150	301
3007	f	484	121	302
3008	t	485	122	302
3009	t	490	123	302
3010	t	493	124	302
3011	t	500	125	302
3012	t	503	126	302
3013	t	507	127	302
3014	t	510	128	302
3015	f	513	129	302
3016	t	517	130	302
3017	f	83	21	303
3018	t	87	22	303
3019	f	90	23	303
3020	t	95	24	303
3021	f	98	25	303
3022	t	103	26	303
3023	t	108	27	303
3024	t	110	28	303
3025	f	114	29	303
3026	t	120	30	303
3027	f	362	91	304
3028	t	367	92	304
3029	t	371	93	304
3030	t	375	94	304
3031	f	378	95	304
3032	t	383	96	304
3033	t	388	97	304
3034	t	390	98	304
3035	t	395	99	304
3036	f	397	100	304
3037	f	443	111	305
3038	t	446	112	305
3039	t	451	113	305
3040	t	456	114	305
3041	f	460	115	305
3042	t	463	116	305
3043	f	467	117	305
3044	f	469	118	305
3045	t	474	119	305
3046	t	478	120	305
3047	t	2	1	306
3048	t	7	2	306
3049	t	11	3	306
3050	t	14	4	306
3051	f	18	5	306
3052	t	22	6	306
3053	t	26	7	306
3054	f	31	8	306
3055	t	35	9	306
3056	f	38	10	306
3057	f	403	101	307
3058	t	405	102	307
3059	f	410	103	307
3060	t	413	104	307
3061	t	420	105	307
3062	t	421	106	307
3063	f	427	107	307
3064	f	431	108	307
3065	t	433	109	307
3066	t	439	110	307
3067	t	402	101	308
3068	t	405	102	308
3069	t	412	103	308
3070	f	415	104	308
3071	t	420	105	308
3072	t	421	106	308
3073	t	426	107	308
3074	t	432	108	308
3075	t	433	109	308
3076	t	439	110	308
3077	t	564	141	309
3078	t	566	142	309
3079	t	569	143	309
3080	f	574	144	309
3081	t	578	145	309
3082	t	582	146	309
3083	t	587	147	309
3084	t	590	148	309
3085	f	593	149	309
3086	t	597	150	309
3087	t	564	141	310
3088	t	566	142	310
3089	t	569	143	310
3090	t	576	144	310
3091	t	578	145	310
3092	t	582	146	310
3093	f	585	147	310
3094	f	591	148	310
3095	t	594	149	310
3096	t	597	150	310
3097	t	444	111	311
3098	t	446	112	311
3099	t	451	113	311
3100	f	453	114	311
3101	t	457	115	311
3102	t	463	116	311
3103	t	468	117	311
3104	t	470	118	311
3105	t	474	119	311
3106	t	478	120	311
3107	t	81	21	312
3108	t	87	22	312
3109	t	89	23	312
3110	t	95	24	312
3111	t	97	25	312
3112	t	103	26	312
3113	f	107	27	312
3114	t	110	28	312
3115	t	113	29	312
3116	t	120	30	312
3117	t	42	11	313
3118	t	45	12	313
3119	t	49	13	313
3120	t	53	14	313
3121	t	60	15	313
3122	t	62	16	313
3123	t	65	17	313
3124	t	69	18	313
3125	t	74	19	313
3126	t	79	20	313
3127	t	361	91	314
3128	t	367	92	314
3129	t	371	93	314
3130	t	375	94	314
3131	f	377	95	314
3132	t	383	96	314
3133	t	388	97	314
3134	t	390	98	314
3135	t	395	99	314
3136	f	400	100	314
3137	t	2	1	315
3138	t	7	2	315
3139	t	11	3	315
3140	f	16	4	315
3141	t	17	5	315
3142	t	22	6	315
3143	f	28	7	315
3144	f	30	8	315
3145	t	35	9	315
3146	t	37	10	315
3147	t	2	1	316
3148	t	7	2	316
3149	t	11	3	316
3150	t	14	4	316
3151	t	17	5	316
3152	t	22	6	316
3153	t	26	7	316
3154	t	32	8	316
3155	t	35	9	316
3156	t	37	10	316
3157	t	81	21	317
3158	f	86	22	317
3159	t	89	23	317
3160	t	95	24	317
3161	t	97	25	317
3162	f	101	26	317
3163	f	105	27	317
3164	t	110	28	317
3165	t	113	29	317
3166	t	120	30	317
3167	t	444	111	318
3168	t	446	112	318
3169	f	452	113	318
3170	f	453	114	318
3171	t	457	115	318
3172	t	463	116	318
3173	t	468	117	318
3174	t	470	118	318
3175	t	474	119	318
3176	t	478	120	318
3177	t	42	11	319
3178	f	48	12	319
3179	t	49	13	319
3180	t	53	14	319
3181	t	60	15	319
3182	t	62	16	319
3183	t	65	17	319
3184	t	69	18	319
3185	t	74	19	319
3186	t	79	20	319
3187	t	361	91	320
3188	t	367	92	320
3189	t	371	93	320
3190	t	375	94	320
3191	t	379	95	320
3192	t	383	96	320
3193	t	388	97	320
3194	f	392	98	320
3195	t	395	99	320
3196	f	400	100	320
3197	t	361	91	321
3198	t	367	92	321
3199	t	371	93	321
3200	t	375	94	321
3201	t	379	95	321
3202	t	383	96	321
3203	t	388	97	321
3204	t	390	98	321
3205	t	395	99	321
3206	f	399	100	321
3207	t	2	1	322
3208	f	8	2	322
3209	t	11	3	322
3210	t	14	4	322
3211	t	17	5	322
3212	t	22	6	322
3213	t	26	7	322
3214	t	32	8	322
3215	f	33	9	322
3216	t	37	10	322
3217	t	483	121	323
3218	t	485	122	323
3219	t	490	123	323
3220	t	493	124	323
3221	t	500	125	323
3222	t	503	126	323
3223	t	507	127	323
3224	f	511	128	323
3225	t	516	129	323
3226	f	518	130	323
3227	f	561	141	324
3228	t	566	142	324
3229	t	569	143	324
3230	t	576	144	324
3231	t	578	145	324
3232	t	582	146	324
3233	t	587	147	324
3234	t	590	148	324
3235	t	594	149	324
3236	t	597	150	324
3237	t	402	101	325
3238	t	405	102	325
3239	t	412	103	325
3240	t	413	104	325
3241	t	420	105	325
3242	t	421	106	325
3243	t	426	107	325
3244	f	429	108	325
3245	t	433	109	325
3246	t	439	110	325
3247	t	523	131	326
3248	t	527	132	326
3249	t	530	133	326
3250	t	535	134	326
3251	t	537	135	326
3252	t	544	136	326
3253	t	547	137	326
3254	t	551	138	326
3255	t	555	139	326
3256	f	557	140	326
3257	t	483	121	327
3258	f	486	122	327
3259	t	490	123	327
3260	t	493	124	327
3261	t	500	125	327
3262	f	502	126	327
3263	t	507	127	327
3264	t	510	128	327
3265	t	516	129	327
3266	t	517	130	327
3267	f	443	111	328
3268	t	446	112	328
3269	t	451	113	328
3270	t	456	114	328
3271	f	460	115	328
3272	t	463	116	328
3273	t	468	117	328
3274	t	470	118	328
3275	f	476	119	328
3276	t	478	120	328
3277	t	444	111	329
3278	t	446	112	329
3279	f	450	113	329
3280	t	456	114	329
3281	t	457	115	329
3282	t	463	116	329
3283	t	468	117	329
3284	t	470	118	329
3285	t	474	119	329
3286	t	478	120	329
3287	t	564	141	330
3288	f	568	142	330
3289	t	569	143	330
3290	t	576	144	330
3291	t	578	145	330
3292	t	582	146	330
3293	f	585	147	330
3294	t	590	148	330
3295	t	594	149	330
3296	t	597	150	330
3297	t	564	141	331
3298	f	567	142	331
3299	t	569	143	331
3300	t	576	144	331
3301	t	578	145	331
3302	t	582	146	331
3303	t	587	147	331
3304	t	590	148	331
3305	t	594	149	331
3306	t	597	150	331
3307	t	361	91	332
3308	t	367	92	332
3309	t	371	93	332
3310	t	375	94	332
3311	f	378	95	332
3312	f	381	96	332
3313	t	388	97	332
3314	t	390	98	332
3315	t	395	99	332
3316	t	398	100	332
3317	t	361	91	333
3318	t	367	92	333
3319	t	371	93	333
3320	t	375	94	333
3321	t	379	95	333
3322	f	384	96	333
3323	t	388	97	333
3324	t	390	98	333
3325	t	395	99	333
3326	t	398	100	333
3327	t	523	131	334
3328	t	527	132	334
3329	t	530	133	334
3330	t	535	134	334
3331	t	537	135	334
3332	t	544	136	334
3333	t	547	137	334
3334	t	551	138	334
3335	t	555	139	334
3336	t	560	140	334
3337	t	402	101	335
3338	f	408	102	335
3339	t	412	103	335
3340	t	413	104	335
3341	t	420	105	335
3342	t	421	106	335
3343	t	426	107	335
3344	t	432	108	335
3345	t	433	109	335
3346	t	439	110	335
3347	t	42	11	336
3348	t	45	12	336
3349	t	49	13	336
3350	t	53	14	336
3351	t	60	15	336
3352	t	62	16	336
3353	t	65	17	336
3354	t	69	18	336
3355	f	73	19	336
3356	t	79	20	336
3357	t	81	21	337
3358	t	87	22	337
3359	t	89	23	337
3360	t	95	24	337
3361	t	97	25	337
3362	f	104	26	337
3363	t	108	27	337
3364	t	110	28	337
3365	t	113	29	337
3366	t	120	30	337
3367	t	81	21	338
3368	t	87	22	338
3369	t	89	23	338
3370	f	94	24	338
3371	f	99	25	338
3372	t	103	26	338
3373	f	105	27	338
3374	f	112	28	338
3375	t	113	29	338
3376	t	120	30	338
3377	t	81	21	339
3378	f	86	22	339
3379	t	89	23	339
3380	t	95	24	339
3381	t	97	25	339
3382	t	103	26	339
3383	f	107	27	339
3384	t	110	28	339
3385	t	113	29	339
3386	t	120	30	339
3387	t	402	101	340
3388	t	405	102	340
3389	t	412	103	340
3390	f	415	104	340
3391	t	420	105	340
3392	t	421	106	340
3393	t	426	107	340
3394	f	431	108	340
3395	t	433	109	340
3396	t	439	110	340
3397	t	564	141	341
3398	f	567	142	341
3399	t	569	143	341
3400	t	576	144	341
3401	t	578	145	341
3402	t	582	146	341
3403	t	587	147	341
3404	t	590	148	341
3405	t	594	149	341
3406	f	599	150	341
3407	t	444	111	342
3408	t	446	112	342
3409	f	449	113	342
3410	f	454	114	342
3411	t	457	115	342
3412	t	463	116	342
3413	t	468	117	342
3414	t	470	118	342
3415	t	474	119	342
3416	t	478	120	342
3417	f	441	111	343
3418	t	446	112	343
3419	t	451	113	343
3420	t	456	114	343
3421	t	457	115	343
3422	t	463	116	343
3423	t	468	117	343
3424	t	470	118	343
3425	t	474	119	343
3426	t	478	120	343
3427	t	2	1	344
3428	t	7	2	344
3429	f	10	3	344
3430	t	14	4	344
3431	t	17	5	344
3432	t	22	6	344
3433	f	28	7	344
3434	t	32	8	344
3435	f	36	9	344
3436	f	39	10	344
3437	f	563	141	345
3438	t	566	142	345
3439	t	569	143	345
3440	t	576	144	345
3441	t	578	145	345
3442	t	582	146	345
3443	t	587	147	345
3444	t	590	148	345
3445	f	595	149	345
3446	f	600	150	345
3447	f	403	101	346
3448	t	405	102	346
3449	t	412	103	346
3450	t	413	104	346
3451	t	420	105	346
3452	f	424	106	346
3453	t	426	107	346
3454	f	430	108	346
3455	t	433	109	346
3456	f	440	110	346
3457	t	523	131	347
3458	t	527	132	347
3459	t	530	133	347
3460	t	535	134	347
3461	t	537	135	347
3462	t	544	136	347
3463	t	547	137	347
3464	t	551	138	347
3465	t	555	139	347
3466	f	559	140	347
3467	t	42	11	348
3468	t	45	12	348
3469	t	49	13	348
3470	t	53	14	348
3471	f	59	15	348
3472	t	62	16	348
3473	t	65	17	348
3474	t	69	18	348
3475	t	74	19	348
3476	t	79	20	348
3477	f	84	21	349
3478	t	87	22	349
3479	t	89	23	349
3480	t	95	24	349
3481	t	97	25	349
3482	t	103	26	349
3483	f	105	27	349
3484	f	111	28	349
3485	t	113	29	349
3486	t	120	30	349
3487	t	81	21	350
3488	t	87	22	350
3489	t	89	23	350
3490	t	95	24	350
3491	t	97	25	350
3492	f	101	26	350
3493	t	108	27	350
3494	t	110	28	350
3495	t	113	29	350
3496	t	120	30	350
3497	t	483	121	351
3498	f	488	122	351
3499	t	490	123	351
3500	f	496	124	351
3501	t	500	125	351
3502	t	503	126	351
3503	t	507	127	351
3504	f	509	128	351
3505	t	516	129	351
3506	f	519	130	351
3507	t	483	121	352
3508	t	485	122	352
3509	f	489	123	352
3510	t	493	124	352
3511	t	500	125	352
3512	f	501	126	352
3513	f	506	127	352
3514	t	510	128	352
3515	t	516	129	352
3516	f	519	130	352
3517	t	483	121	353
3518	t	485	122	353
3519	t	490	123	353
3520	f	496	124	353
3521	t	500	125	353
3522	t	503	126	353
3523	t	507	127	353
3524	f	512	128	353
3525	t	516	129	353
3526	f	519	130	353
3527	t	361	91	354
3528	t	367	92	354
3529	t	371	93	354
3530	t	375	94	354
3531	f	378	95	354
3532	t	383	96	354
3533	f	387	97	354
3534	f	391	98	354
3535	f	394	99	354
3536	f	397	100	354
3537	f	363	91	355
3538	t	367	92	355
3539	f	370	93	355
3540	t	375	94	355
3541	f	380	95	355
3542	t	383	96	355
3543	t	388	97	355
3544	f	392	98	355
3545	t	395	99	355
3546	t	398	100	355
3547	f	363	91	356
3548	f	366	92	356
3549	t	371	93	356
3550	t	375	94	356
3551	t	379	95	356
3552	t	383	96	356
3553	t	388	97	356
3554	t	390	98	356
3555	t	395	99	356
3556	t	398	100	356
3557	t	81	21	357
3558	f	85	22	357
3559	f	90	23	357
3560	t	95	24	357
3561	t	97	25	357
3562	f	102	26	357
3563	f	106	27	357
3564	t	110	28	357
3565	t	113	29	357
3566	t	120	30	357
3567	f	401	101	358
3568	t	405	102	358
3569	t	412	103	358
3570	t	413	104	358
3571	t	420	105	358
3572	t	421	106	358
3573	f	427	107	358
3574	t	432	108	358
3575	t	433	109	358
3576	t	439	110	358
3577	t	523	131	359
3578	t	527	132	359
3579	t	530	133	359
3580	t	535	134	359
3581	f	538	135	359
3582	t	544	136	359
3583	t	547	137	359
3584	t	551	138	359
3585	t	555	139	359
3586	f	559	140	359
3587	t	483	121	360
3588	t	485	122	360
3589	t	490	123	360
3590	t	493	124	360
3591	t	500	125	360
3592	t	503	126	360
3593	f	505	127	360
3594	t	510	128	360
3595	f	513	129	360
3596	t	517	130	360
3597	t	564	141	361
3598	t	566	142	361
3599	t	569	143	361
3600	f	573	144	361
3601	t	578	145	361
3602	t	582	146	361
3603	t	587	147	361
3604	t	590	148	361
3605	t	594	149	361
3606	t	597	150	361
3607	t	444	111	362
3608	t	446	112	362
3609	t	451	113	362
3610	t	456	114	362
3611	t	457	115	362
3612	t	463	116	362
3613	t	468	117	362
3614	t	470	118	362
3615	t	474	119	362
3616	t	478	120	362
3617	t	42	11	363
3618	t	45	12	363
3619	t	49	13	363
3620	f	56	14	363
3621	f	59	15	363
3622	f	64	16	363
3623	f	66	17	363
3624	t	69	18	363
3625	t	74	19	363
3626	t	79	20	363
3627	t	361	91	364
3628	t	367	92	364
3629	f	372	93	364
3630	t	375	94	364
3631	t	379	95	364
3632	t	383	96	364
3633	t	388	97	364
3634	t	390	98	364
3635	t	395	99	364
3636	f	399	100	364
3637	f	3	1	365
3638	t	7	2	365
3639	t	11	3	365
3640	f	15	4	365
3641	t	17	5	365
3642	t	22	6	365
3643	t	26	7	365
3644	f	29	8	365
3645	f	36	9	365
3646	t	37	10	365
3647	t	2	1	366
3648	t	7	2	366
3649	t	11	3	366
3650	t	14	4	366
3651	t	17	5	366
3652	t	22	6	366
3653	f	27	7	366
3654	t	32	8	366
3655	t	35	9	366
3656	t	37	10	366
3657	f	442	111	367
3658	f	447	112	367
3659	t	451	113	367
3660	f	455	114	367
3661	f	460	115	367
3662	t	463	116	367
3663	t	468	117	367
3664	f	472	118	367
3665	t	474	119	367
3666	f	479	120	367
3667	t	444	111	368
3668	t	446	112	368
3669	t	451	113	368
3670	t	456	114	368
3671	t	457	115	368
3672	t	463	116	368
3673	t	468	117	368
3674	f	472	118	368
3675	t	474	119	368
3676	t	478	120	368
3677	t	564	141	369
3678	f	567	142	369
3679	f	571	143	369
3680	t	576	144	369
3681	t	578	145	369
3682	t	582	146	369
3683	t	587	147	369
3684	t	590	148	369
3685	f	593	149	369
3686	t	597	150	369
3687	f	403	101	370
3688	f	408	102	370
3689	f	409	103	370
3690	t	413	104	370
3691	t	420	105	370
3692	t	421	106	370
3693	f	427	107	370
3694	t	432	108	370
3695	t	433	109	370
3696	t	439	110	370
3697	t	81	21	371
3698	t	87	22	371
3699	t	89	23	371
3700	t	95	24	371
3701	t	97	25	371
3702	f	102	26	371
3703	f	106	27	371
3704	t	110	28	371
3705	t	113	29	371
3706	t	120	30	371
3707	t	523	131	372
3708	f	528	132	372
3709	t	530	133	372
3710	t	535	134	372
3711	t	537	135	372
3712	t	544	136	372
3713	t	547	137	372
3714	t	551	138	372
3715	t	555	139	372
3716	t	560	140	372
3717	t	483	121	373
3718	t	485	122	373
3719	t	490	123	373
3720	f	494	124	373
3721	t	500	125	373
3722	t	503	126	373
3723	t	507	127	373
3724	t	510	128	373
3725	t	516	129	373
3726	f	518	130	373
3727	t	42	11	374
3728	f	46	12	374
3729	t	49	13	374
3730	t	53	14	374
3731	t	60	15	374
3732	f	64	16	374
3733	f	68	17	374
3734	t	69	18	374
3735	f	76	19	374
3736	t	79	20	374
\.


--
-- Data for Name: atividades_tentativa; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.atividades_tentativa (id, numero, acertos, total_perguntas, realizada_em, atividade_id, usuario_id) FROM stdin;
1	1	6	6	2026-11-03 01:11:15.475916-03	1	1
127	2	8	10	2026-08-14 11:23:43.307064-03	10	41
128	3	9	10	2026-08-16 12:34:43.307064-03	10	41
129	1	6	10	2026-07-25 11:44:43.307064-03	2	42
130	2	9	10	2026-07-26 13:53:43.307064-03	2	42
131	1	8	10	2026-07-27 21:23:43.307064-03	14	42
132	1	9	10	2026-07-30 07:42:43.307064-03	15	42
133	1	5	10	2026-08-03 13:03:43.307064-03	3	42
134	2	6	10	2026-08-08 17:59:43.307064-03	3	42
135	3	9	10	2026-08-09 22:14:43.307064-03	3	42
136	1	10	10	2026-08-12 07:24:43.307064-03	12	42
137	1	6	10	2026-08-18 16:49:43.307064-03	10	42
138	1	9	10	2026-08-22 21:06:43.307064-03	11	42
139	1	7	10	2026-08-28 17:02:43.307064-03	13	42
140	1	5	10	2026-07-29 18:17:43.307064-03	15	43
141	1	6	10	2026-08-04 20:26:43.307064-03	11	43
142	2	5	10	2026-08-07 17:30:43.307064-03	11	43
143	1	6	10	2026-08-10 18:54:43.307064-03	1	43
144	2	8	10	2026-08-11 22:57:43.307064-03	1	43
145	3	9	10	2026-08-12 12:02:43.307064-03	1	43
146	1	6	10	2026-08-13 18:08:43.307064-03	14	43
147	1	9	10	2026-08-16 22:19:43.307064-03	13	43
148	1	8	10	2026-08-20 07:35:43.307064-03	10	43
149	1	1	10	2026-08-24 09:57:43.307064-03	12	43
150	2	7	10	2026-08-29 12:23:43.307064-03	12	43
151	1	5	10	2026-09-03 20:33:43.307064-03	2	43
152	1	7	10	2026-08-23 08:15:43.307064-03	12	44
153	2	8	10	2026-08-28 10:29:43.307064-03	12	44
107	1	8	10	2026-10-26 17:18:43.307064-03	11	40
108	1	7	10	2026-10-27 17:45:43.307064-03	15	40
109	2	9	10	2026-10-27 22:34:43.307064-03	15	40
110	1	8	10	2026-10-30 07:54:43.307064-03	14	40
111	1	8	10	2026-11-04 13:13:43.307064-03	1	40
112	1	5	10	2026-07-06 10:35:43.307064-03	11	41
113	1	8	10	2026-07-10 18:55:43.307064-03	13	41
114	2	7	10	2026-07-11 20:25:43.307064-03	13	41
115	1	4	10	2026-07-18 09:42:43.307064-03	15	41
116	2	7	10	2026-07-19 13:24:43.307064-03	15	41
117	3	9	10	2026-07-19 17:00:43.307064-03	15	41
118	1	7	10	2026-07-25 09:00:43.307064-03	14	41
119	1	4	10	2026-07-30 11:05:43.307064-03	3	41
120	1	5	10	2026-07-31 14:26:43.307064-03	1	41
121	2	8	10	2026-07-31 19:19:43.307064-03	1	41
122	1	8	10	2026-07-31 18:48:43.307064-03	12	41
123	2	6	10	2026-08-01 20:34:43.307064-03	12	41
124	3	8	10	2026-08-06 22:59:43.307064-03	12	41
125	1	5	10	2026-08-08 21:18:43.307064-03	2	41
126	1	6	10	2026-08-13 08:39:43.307064-03	10	41
154	1	8	10	2026-08-31 21:44:43.307064-03	13	44
155	1	8	10	2026-09-06 08:19:43.307064-03	10	44
156	1	9	10	2026-09-09 13:27:43.307064-03	14	44
157	1	8	10	2026-09-13 21:36:43.307064-03	3	44
179	1	9	10	2026-06-26 19:36:43.307064-03	2	46
180	1	8	10	2026-07-11 07:44:43.307064-03	10	47
181	1	10	10	2026-07-15 17:56:43.307064-03	3	47
182	1	9	10	2026-07-18 21:09:43.307064-03	13	47
183	1	7	10	2026-07-25 14:04:43.307064-03	1	47
184	2	7	10	2026-07-26 16:32:43.307064-03	1	47
185	1	7	10	2026-07-28 21:38:43.307064-03	2	47
186	1	5	10	2026-07-29 09:07:43.307064-03	12	47
187	2	6	10	2026-07-31 13:47:43.307064-03	12	47
188	1	7	10	2026-09-06 13:38:43.307064-03	2	48
189	2	7	10	2026-09-11 15:14:43.307064-03	2	48
190	1	7	10	2026-07-06 16:12:43.307064-03	14	49
191	1	10	10	2026-07-13 14:34:43.307064-03	1	49
192	1	6	10	2026-07-18 17:50:43.307064-03	3	49
193	2	5	10	2026-07-18 22:37:43.307064-03	3	49
194	3	9	10	2026-07-20 14:37:43.307064-03	3	49
195	1	5	10	2026-07-25 10:30:43.307064-03	12	49
196	2	8	10	2026-07-30 13:31:43.307064-03	12	49
197	1	7	10	2026-08-04 14:50:43.307064-03	15	49
198	1	8	10	2026-08-16 20:54:43.307064-03	2	49
199	1	5	10	2026-08-17 22:00:43.307064-03	13	49
200	2	7	10	2026-08-23 19:40:43.307064-03	13	49
201	3	9	10	2026-08-26 15:31:43.307064-03	13	49
202	1	8	10	2026-06-20 08:39:43.307064-03	11	50
203	2	9	10	2026-06-22 12:46:43.307064-03	11	50
204	1	9	10	2026-06-23 13:54:43.307064-03	1	50
158	1	9	10	2026-09-19 08:47:43.307064-03	15	44
159	1	10	10	2026-09-22 13:10:43.307064-03	11	44
160	1	10	10	2026-09-28 16:32:43.307064-03	1	44
161	1	9	10	2026-09-30 16:30:43.307064-03	2	44
162	1	6	10	2026-07-15 22:07:43.307064-03	1	45
163	2	9	10	2026-07-20 09:05:43.307064-03	1	45
164	1	5	10	2026-07-25 17:23:43.307064-03	13	45
165	1	6	10	2026-07-26 18:35:43.307064-03	11	45
166	2	10	10	2026-07-31 21:24:43.307064-03	11	45
167	1	8	10	2026-08-03 20:19:43.307064-03	14	45
168	1	8	10	2026-08-06 18:52:43.307064-03	10	45
169	1	4	10	2026-06-01 13:50:43.307064-03	15	46
170	2	8	10	2026-06-03 14:18:43.307064-03	15	46
171	3	9	10	2026-06-03 16:44:43.307064-03	15	46
172	1	6	10	2026-06-09 17:52:43.307064-03	14	46
173	2	9	10	2026-06-09 21:06:43.307064-03	14	46
174	1	2	10	2026-06-10 09:52:43.307064-03	1	46
175	1	3	10	2026-06-15 20:13:43.307064-03	13	46
176	2	6	10	2026-06-15 22:09:43.307064-03	13	46
177	1	5	10	2026-06-22 10:17:43.307064-03	10	46
178	2	8	10	2026-06-22 13:30:43.307064-03	10	46
205	1	9	10	2026-06-23 22:19:43.307064-03	2	50
206	1	7	10	2026-06-29 08:23:43.307064-03	3	50
207	1	7	10	2026-06-29 19:46:43.307064-03	10	50
208	1	5	10	2026-06-30 20:44:43.307064-03	13	50
209	2	9	10	2026-07-01 15:41:43.307064-03	13	50
210	1	8	10	2026-07-02 17:57:43.307064-03	12	50
211	1	7	10	2026-07-18 11:04:43.307064-03	15	51
212	1	5	10	2026-07-24 21:28:43.307064-03	3	51
213	1	7	10	2026-07-26 10:03:43.307064-03	1	51
214	1	6	10	2026-07-26 12:17:43.307064-03	12	51
215	2	6	10	2026-07-26 13:02:43.307064-03	12	51
216	3	10	10	2026-07-31 13:42:43.307064-03	12	51
217	1	8	10	2026-08-03 14:07:43.307064-03	2	51
218	1	5	10	2026-08-05 21:21:43.307064-03	13	51
219	1	7	10	2026-08-08 20:36:43.307064-03	14	51
220	1	8	10	2026-08-09 12:54:43.307064-03	10	51
221	2	9	10	2026-08-09 15:13:43.307064-03	10	51
222	1	5	10	2026-06-05 14:51:43.307064-03	2	52
223	2	7	10	2026-06-07 19:34:43.307064-03	2	52
224	1	8	10	2026-06-13 13:46:43.307064-03	12	52
225	1	6	10	2026-06-17 22:56:43.307064-03	10	52
226	2	8	10	2026-06-18 08:04:43.307064-03	10	52
227	1	5	10	2026-06-24 14:26:43.307064-03	13	52
228	2	5	10	2026-06-26 16:59:43.307064-03	13	52
229	3	8	10	2026-06-27 21:16:43.307064-03	13	52
230	1	5	10	2026-06-30 15:50:43.307064-03	15	52
231	2	7	10	2026-06-30 17:40:43.307064-03	15	52
232	1	5	10	2026-07-06 23:01:43.307064-03	3	52
233	2	8	10	2026-07-06 21:43:43.307064-03	3	52
234	1	7	10	2026-07-12 09:01:43.307064-03	11	52
235	1	6	10	2026-07-14 16:15:43.307064-03	1	52
236	2	8	10	2026-07-19 16:42:43.307064-03	1	52
237	1	6	10	2026-07-23 19:56:43.307064-03	14	52
238	2	10	10	2026-07-24 21:43:43.307064-03	14	52
239	1	4	10	2026-06-16 12:29:43.307064-03	13	53
240	1	2	10	2026-06-21 20:51:43.307064-03	11	53
241	2	6	10	2026-06-21 11:07:43.307064-03	11	53
242	1	8	10	2026-06-21 18:22:43.307064-03	1	53
243	1	6	10	2026-06-23 11:56:43.307064-03	3	53
244	2	10	10	2026-06-25 16:13:43.307064-03	3	53
245	1	8	10	2026-07-04 16:07:43.307064-03	14	53
246	1	8	10	2026-07-08 11:38:43.307064-03	2	53
247	1	9	10	2026-08-29 08:39:43.307064-03	13	54
248	1	9	10	2026-10-15 14:22:43.307064-03	1	55
249	1	6	10	2026-10-16 21:57:43.307064-03	3	55
250	2	6	10	2026-10-22 18:54:43.307064-03	3	55
251	3	10	10	2026-10-24 21:13:43.307064-03	3	55
252	1	9	10	2026-11-02 09:31:43.307064-03	12	55
253	1	5	10	2026-11-05 12:40:43.307064-03	10	55
254	2	8	10	2026-11-05 17:30:43.307064-03	10	55
255	3	8	10	2026-11-05 21:24:43.307064-03	10	55
256	1	6	10	2026-08-12 11:39:43.307064-03	15	56
257	2	6	10	2026-08-14 12:30:43.307064-03	15	56
258	3	9	10	2026-08-14 14:23:43.307064-03	15	56
259	1	9	10	2026-09-05 22:46:43.307064-03	1	57
260	1	10	10	2026-09-06 18:57:43.307064-03	10	57
261	1	9	10	2026-09-09 21:07:43.307064-03	14	57
262	1	6	10	2026-09-10 11:26:43.307064-03	3	57
263	2	10	10	2026-09-12 12:38:43.307064-03	3	57
264	1	7	10	2026-09-12 19:59:43.307064-03	15	57
265	2	10	10	2026-09-12 16:16:43.307064-03	15	57
266	1	8	10	2026-09-13 16:27:43.307064-03	12	57
267	1	8	10	2026-09-18 18:12:43.307064-03	13	57
268	1	9	10	2026-09-23 13:22:43.307064-03	11	57
269	1	6	10	2026-09-26 14:36:43.307064-03	2	57
270	2	8	10	2026-09-26 15:44:43.307064-03	2	57
271	1	8	10	2026-09-12 17:52:43.307064-03	14	58
272	2	9	10	2026-09-13 21:35:43.307064-03	14	58
273	1	6	10	2026-09-17 10:58:43.307064-03	13	58
274	2	6	10	2026-09-22 14:56:43.307064-03	13	58
275	3	7	10	2026-09-24 17:25:43.307064-03	13	58
276	1	6	10	2026-09-29 21:32:43.307064-03	15	58
277	2	6	10	2026-10-01 22:47:43.307064-03	15	58
278	3	10	10	2026-10-02 08:14:43.307064-03	15	58
279	1	5	10	2026-10-06 14:24:43.307064-03	3	58
280	2	8	10	2026-10-06 15:55:43.307064-03	3	58
281	3	9	10	2026-10-06 18:16:43.307064-03	3	58
282	1	4	10	2026-10-11 22:32:43.307064-03	2	58
283	2	8	10	2026-10-11 15:31:43.307064-03	2	58
284	3	9	10	2026-10-16 18:23:43.307064-03	2	58
285	1	10	10	2026-10-23 14:41:43.307064-03	1	58
286	1	7	10	2026-10-29 15:51:43.307064-03	12	58
287	1	8	10	2026-10-31 18:06:43.307064-03	11	58
288	1	5	10	2026-10-19 23:05:43.307064-03	15	59
289	2	7	10	2026-10-22 20:14:43.307064-03	15	59
290	1	6	10	2026-10-23 22:28:43.307064-03	10	59
291	1	9	10	2026-09-03 18:33:43.307064-03	11	60
292	1	9	10	2026-09-08 09:19:43.307064-03	3	60
293	1	10	10	2026-09-14 14:37:43.307064-03	10	60
294	1	7	10	2026-09-16 15:44:43.307064-03	13	60
295	2	9	10	2026-09-16 20:21:43.307064-03	13	60
296	1	9	10	2026-09-17 20:02:43.307064-03	1	60
297	1	9	10	2026-09-21 07:07:43.307064-03	2	60
298	1	8	10	2026-09-25 19:30:43.307064-03	12	60
299	2	10	10	2026-09-26 21:06:43.307064-03	12	60
300	1	7	10	2026-09-28 08:24:43.307064-03	15	60
301	2	7	10	2026-09-28 12:11:43.307064-03	15	60
302	1	8	10	2026-06-03 16:58:43.307064-03	13	61
303	1	6	10	2026-06-06 23:10:43.307064-03	3	61
304	1	7	10	2026-06-12 20:32:43.307064-03	10	61
305	1	6	10	2026-06-19 13:23:43.307064-03	12	61
306	1	7	10	2026-06-23 14:27:43.307064-03	1	61
307	1	6	10	2026-06-23 20:32:43.307064-03	11	61
308	2	9	10	2026-06-24 21:35:43.307064-03	11	61
309	1	8	10	2026-06-30 11:29:43.307064-03	15	61
310	1	8	10	2026-10-19 19:41:43.307064-03	15	62
311	1	9	10	2026-10-19 17:55:43.307064-03	12	62
312	1	9	10	2026-10-23 19:36:43.307064-03	3	62
313	1	10	10	2026-10-25 10:26:43.307064-03	2	62
314	1	8	10	2026-10-28 21:37:43.307064-03	10	62
315	1	7	10	2026-11-01 20:35:43.307064-03	1	62
316	2	10	10	2026-11-03 22:49:43.307064-03	1	62
317	1	7	10	2026-07-13 19:47:43.307064-03	3	63
318	1	8	10	2026-07-13 23:00:43.307064-03	12	63
319	1	9	10	2026-07-18 08:04:43.307064-03	2	63
320	1	8	10	2026-07-24 14:21:43.307064-03	10	63
321	2	9	10	2026-07-29 16:40:43.307064-03	10	63
322	1	8	10	2026-08-03 11:50:43.307064-03	1	63
323	1	8	10	2026-08-08 19:08:43.307064-03	13	63
324	1	9	10	2026-08-11 11:48:43.307064-03	15	63
325	1	9	10	2026-08-13 15:13:43.307064-03	11	63
326	1	9	10	2026-08-18 16:36:43.307064-03	14	63
327	1	8	10	2026-06-28 16:22:43.307064-03	13	64
328	1	7	10	2026-07-10 16:40:43.307064-03	12	64
329	2	9	10	2026-07-10 18:01:43.307064-03	12	64
330	1	8	10	2026-07-12 13:45:43.307064-03	15	64
331	2	9	10	2026-07-12 17:52:43.307064-03	15	64
332	1	8	10	2026-07-14 12:21:43.307064-03	10	64
333	2	9	10	2026-07-16 14:54:43.307064-03	10	64
334	1	10	10	2026-07-18 17:19:43.307064-03	14	64
335	1	9	10	2026-07-24 22:29:43.307064-03	11	64
336	1	9	10	2026-07-26 07:53:43.307064-03	2	64
337	1	9	10	2026-08-01 15:01:43.307064-03	3	64
338	1	6	10	2026-10-11 20:13:43.307064-03	3	65
339	2	8	10	2026-10-12 22:14:43.307064-03	3	65
340	1	8	10	2026-10-16 08:29:43.307064-03	11	65
341	1	8	10	2026-10-16 10:39:43.307064-03	15	65
342	1	8	10	2026-09-12 20:01:43.307064-03	12	66
343	2	9	10	2026-09-12 20:34:43.307064-03	12	66
344	1	6	10	2026-09-13 17:06:43.307064-03	1	66
345	1	7	10	2026-09-16 14:38:43.307064-03	15	66
346	1	6	10	2026-09-19 22:01:43.307064-03	11	66
347	1	9	10	2026-09-23 22:34:43.307064-03	14	66
348	1	9	10	2026-09-27 19:23:43.307064-03	2	66
349	1	7	10	2026-10-04 11:20:43.307064-03	3	66
350	2	9	10	2026-10-05 14:31:43.307064-03	3	66
351	1	6	10	2026-08-04 13:01:43.307064-03	13	67
352	2	6	10	2026-08-06 16:46:43.307064-03	13	67
353	3	7	10	2026-08-08 21:05:43.307064-03	13	67
354	1	5	10	2026-08-14 19:38:43.307064-03	10	67
355	2	6	10	2026-08-15 09:43:43.307064-03	10	67
356	3	8	10	2026-08-15 11:07:43.307064-03	10	67
357	1	6	10	2026-08-17 16:21:43.307064-03	3	67
358	1	8	10	2026-06-25 15:42:43.307064-03	11	68
359	1	8	10	2026-06-30 21:54:43.307064-03	14	68
360	1	8	10	2026-07-01 14:33:43.307064-03	13	68
361	1	9	10	2026-07-11 10:42:43.307064-03	15	68
362	1	10	10	2026-07-17 21:57:43.307064-03	12	68
363	1	6	10	2026-07-20 09:04:43.307064-03	2	68
364	1	8	10	2026-07-18 12:11:43.307064-03	10	69
365	1	6	10	2026-07-19 16:30:43.307064-03	1	69
366	2	9	10	2026-07-21 17:19:43.307064-03	1	69
367	1	4	10	2026-07-23 18:25:43.307064-03	12	69
368	2	9	10	2026-07-25 19:38:43.307064-03	12	69
369	1	7	10	2026-07-27 17:37:43.307064-03	15	69
370	1	6	10	2026-08-02 14:21:43.307064-03	11	69
371	1	8	10	2026-08-09 09:58:43.307064-03	3	69
372	1	9	10	2026-08-09 21:12:43.307064-03	14	69
373	1	8	10	2026-08-10 09:48:43.307064-03	13	69
374	1	6	10	2026-08-11 16:08:43.307064-03	2	69
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group (id, name) FROM stdin;
1	Educadores
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
1	1	25
2	1	26
3	1	27
4	1	28
5	1	29
6	1	30
7	1	31
8	1	32
9	1	41
10	1	42
11	1	43
12	1	44
13	1	45
14	1	46
15	1	47
16	1	48
17	1	49
18	1	50
19	1	51
20	1	52
21	1	56
23	1	73
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Pode adicionar entrada de log	1	add_logentry
2	Pode alterar entrada de log	1	change_logentry
3	Pode excluir entrada de log	1	delete_logentry
4	Pode ver entrada de log	1	view_logentry
49	Pode adicionar Alternativa	11	add_alternativa
50	Pode alterar Alternativa	11	change_alternativa
51	Pode excluir Alternativa	11	delete_alternativa
52	Pode ver Alternativa	11	view_alternativa
41	Pode adicionar Atividade	12	add_atividade
42	Pode alterar Atividade	12	change_atividade
43	Pode excluir Atividade	12	delete_atividade
44	Pode ver Atividade	12	view_atividade
45	Pode adicionar Pergunta	13	add_pergunta
46	Pode alterar Pergunta	13	change_pergunta
47	Pode excluir Pergunta	13	delete_pergunta
48	Pode ver Pergunta	13	view_pergunta
74	Pode adicionar Progresso na atividade	19	add_progressoatividade
75	Pode alterar Progresso na atividade	19	change_progressoatividade
76	Pode excluir Progresso na atividade	19	delete_progressoatividade
73	Pode ver Progresso na atividade	19	view_progressoatividade
57	Pode adicionar Resposta	14	add_resposta
58	Pode alterar Resposta	14	change_resposta
59	Pode excluir Resposta	14	delete_resposta
60	Pode ver Resposta	14	view_resposta
53	Pode adicionar Tentativa	15	add_tentativa
54	Pode alterar Tentativa	15	change_tentativa
55	Pode excluir Tentativa	15	delete_tentativa
56	Pode ver Tentativa	15	view_tentativa
9	Pode adicionar grupo	2	add_group
10	Pode alterar grupo	2	change_group
11	Pode excluir grupo	2	delete_group
12	Pode ver grupo	2	view_group
5	Pode adicionar permissão	3	add_permission
6	Pode alterar permissão	3	change_permission
7	Pode excluir permissão	3	delete_permission
8	Pode ver permissão	3	view_permission
13	Pode adicionar usuário	4	add_user
14	Pode alterar usuário	4	change_user
15	Pode excluir usuário	4	delete_user
16	Pode ver usuário	4	view_user
37	Pode adicionar codigo verificacao	10	add_codigoverificacao
38	Pode alterar codigo verificacao	10	change_codigoverificacao
39	Pode excluir codigo verificacao	10	delete_codigoverificacao
40	Pode ver codigo verificacao	10	view_codigoverificacao
69	Pode adicionar Configuração do site	18	add_configuracaosite
70	Pode alterar Configuração do site	18	change_configuracaosite
71	Pode excluir Configuração do site	18	delete_configuracaosite
72	Pode ver Configuração do site	18	view_configuracaosite
77	Pode adicionar Convite de educador	20	add_conviteeducador
78	Pode alterar Convite de educador	20	change_conviteeducador
79	Pode excluir Convite de educador	20	delete_conviteeducador
80	Pode ver Convite de educador	20	view_conviteeducador
33	Pode adicionar perfil usuario	9	add_perfilusuario
34	Pode alterar perfil usuario	9	change_perfilusuario
35	Pode excluir perfil usuario	9	delete_perfilusuario
36	Pode ver perfil usuario	9	view_perfilusuario
17	Pode adicionar tipo de conteúdo	5	add_contenttype
18	Pode alterar tipo de conteúdo	5	change_contenttype
19	Pode excluir tipo de conteúdo	5	delete_contenttype
20	Pode ver tipo de conteúdo	5	view_contenttype
29	Pode adicionar Conteúdo	7	add_conteudomodulo
30	Pode alterar Conteúdo	7	change_conteudomodulo
31	Pode excluir Conteúdo	7	delete_conteudomodulo
32	Pode ver Conteúdo	7	view_conteudomodulo
25	Pode adicionar Módulo	8	add_modulo
26	Pode alterar Módulo	8	change_modulo
27	Pode excluir Módulo	8	delete_modulo
28	Pode ver Módulo	8	view_modulo
21	Pode adicionar sessão	6	add_session
22	Pode alterar sessão	6	change_session
23	Pode excluir sessão	6	delete_session
24	Pode ver sessão	6	view_session
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
6	pbkdf2_sha256$1500000$sJab6dRN1sPQanYtyDOYcJ$Ml1B8/YhGdoBzg9hfBhp1JiRKTn6mKOBpBfo4+IN6K8=	2026-11-06 14:52:39.063728-03	f	Taís			laisbarbosa884@gmail.com	t	f	2026-11-03 00:38:18.44593-03
2	pbkdf2_sha256$1500000$GT5lO5e48vyzF2uyiJ0XlY$LKHO0M1TRhid9M+qisIlDjXJR6KkuTBKp9C4VJMm1Gc=	2026-09-25 00:43:55.061881-03	f	mariaa_			maria24@hotmail.com	f	f	2026-09-25 00:42:26.640486-03
1	pbkdf2_sha256$1500000$MvGjJILZERZlBKyclpeSCo$B4MRR88ISfDVUSm00Xlx90xfjAoz2ydn2rG2L01A5Xk=	2026-11-06 16:58:50.886176-03	t	laisb	Laís	Barbosa	laisbarbosa383@gmail.com	t	t	2026-09-11 23:06:48.953489-03
4	pbkdf2_sha256$1500000$4UlqPb9QkD9qdscMf0fMUR$MZaJ2/bDxsAZPij9LpYf5QJNP7F/9GC7NXJKGx96JOA=	\N	f	joao			joao@email.com	f	t	2026-09-25 14:12:53.120774-03
5	pbkdf2_sha256$1500000$QNgECQomVXfm2sS42Jda6t$cLV/4cCm8SGM32UhaU+EvWoa2V4YYkfwX4cOqGOn354=	2026-09-25 14:33:24.578149-03	f	ana			ana@email.com	f	t	2026-09-25 14:16:05.469678-03
72	pbkdf2_sha256$1500000$1821LyqasLPKLcC1Z4aLu6$VvU9A0scma4BMwaRAwl9qeoRlBlTKdjcM9wSa/DGVls=	2026-11-06 16:50:29.21756-03	f	patricia.teixeira	Patrícia	Teixeira	pati.teixeira@email.com	t	t	2026-05-28 07:50:43.307064-03
70	pbkdf2_sha256$1500000$EuUKhh38Yqwcf7W5WcX4df$JbXCJRcQOO7XPPQaOg0hOilTRLOH9WTXuDrczOxC9co=	2026-11-04 12:50:43.307064-03	f	prof.renata	Renata	Moreira	renata.moreira@email.com	t	t	2026-06-03 19:20:43.307064-03
71	pbkdf2_sha256$1500000$H6XL99STpJNe3QkN7ZYq5j$cp5QPkJZvi6e72hGcJx66iQbVgJb1ae5z990shOHwY8=	2026-11-03 13:50:43.307064-03	f	carlos.nunes	Carlos Eduardo	Nunes	carloseduardo.nunes@email.com	t	t	2026-05-22 11:16:43.307064-03
40	pbkdf2_sha256$1500000$nClz9KQiNJlmJaaz0w7v4F$NNWX83vYEUn1NptzY+wIaeAb9W0KnD1idGBDUhIAHH0=	2026-11-04 13:17:43.307064-03	f	mariana.souza	Mariana	Souza	mari.souza@email.com	f	t	2026-10-24 08:35:43.307064-03
41	pbkdf2_sha256$1500000$yRvLyiIn62FvmxTv0q86wN$EVUIbN0Ehigc0uCMgGB7eQRE19YFI53kWw4b5hz81IA=	2026-08-16 12:56:43.307064-03	f	gabriel_oliveira	Gabriel	Oliveira	gabriel.oliveira07@email.com	f	t	2026-07-03 22:54:43.307064-03
42	pbkdf2_sha256$1500000$rbzaUKa8m5VRofbMZs9Jxw$eQjYFemyTOP79OZtDWSm63j1tvBqMxIRVlqPdIai4OA=	2026-08-28 17:12:43.307064-03	f	anaclara.s	Ana Clara	Santos	anaclarasantos@email.com	f	t	2026-07-22 22:00:43.307064-03
43	pbkdf2_sha256$1500000$32U9ohYKWAZc0JBRAImOW6$6gOzGFGos9rdlXL0fDt5jNo9r32jE81Xr3nxmR2HFkg=	2026-09-03 21:09:43.307064-03	f	lucasp	Lucas	Pereira	lucas.pereira@email.com	f	t	2026-07-28 16:58:43.307064-03
44	pbkdf2_sha256$1500000$hZWMfJhiicoUx3BBwk9yye$W9KnBlqTgmGSWFNuup4M5jj7ruyNEfyccfxxCaYXFIw=	2026-09-30 17:02:43.307064-03	f	bia.lima	Beatriz	Lima	beatriz.lima2008@email.com	f	t	2026-08-22 15:40:43.307064-03
49	pbkdf2_sha256$1500000$Tsc9Ju7wWeuaujEe1GVd27$fv6dxODJ7Qfts4Pvkusa3X7npnsUszFKlPk3mh032B8=	2026-11-06 16:08:08.277222-03	f	gui.carvalho	Guilherme	Carvalho	guilherme.carvalho@email.com	f	t	2026-07-05 16:33:43.307064-03
45	pbkdf2_sha256$1500000$hEl5IEOWWpz1hCGXis2HaJ$P96h7nHY/eGsmYJvkD3War2yGvaLocFmGqNKOGRHINk=	2026-08-09 08:43:43.307064-03	f	pedroh.costa	Pedro Henrique	Costa	pedrohenrique.costa@email.com	f	t	2026-07-14 20:22:43.307064-03
46	pbkdf2_sha256$1500000$pq0AXXOuV8YdgRPyABpa8L$PCvGyznxAol/pYoCoKqhfztyCG7hVm8MRkTG4s8r6F4=	2026-06-26 20:00:43.307064-03	f	juliaferreira	Júlia	Ferreira	ju.ferreira@email.com	f	t	2026-05-29 21:34:43.307064-03
47	pbkdf2_sha256$1500000$EXWaLUwT4QLc0nuYc9GUxP$UDdR9u859sNXYodQei2HHvtWg5GF7BUu32bQfo/kiK4=	2026-07-31 13:51:43.307064-03	f	matheus.rod	Matheus	Rodrigues	matheusrodrigues@email.com	f	t	2026-07-10 15:48:43.307064-03
48	pbkdf2_sha256$1500000$zblNddLglssTtf8bHrnCbZ$tsKezMiLXUORDySi8Dr0oaE34ts+386CBX2iuPjjVmM=	2026-09-11 15:47:43.307064-03	f	lari_almeida	Larissa	Almeida	larissa.almeida@email.com	f	t	2026-09-04 18:21:43.307064-03
50	pbkdf2_sha256$1500000$FgQIzUaLUTRC2tMqtPejmL$DiV59nY63rKTSEQAzVz0GOPuMyKe/dsBCP0JrB0nFVo=	2026-07-05 20:07:43.307064-03	f	isabelaribeiro	Isabela	Ribeiro	isa.ribeiro@email.com	f	t	2026-06-12 22:46:43.307064-03
51	pbkdf2_sha256$1500000$FWnMQygAEbFnyseO0OQIrW$BbqHUk12wxM51hTb/5SZYXzWPcrwy4qXJ9On5IOvkDg=	2026-08-09 15:40:43.307064-03	f	rafa.gomes	Rafael	Gomes	rafaelgomes@email.com	f	t	2026-07-16 16:35:43.307064-03
52	pbkdf2_sha256$1500000$jkunOIa2XjniOSrNvOU0DX$hehbQnuaBtmKyW8ybRwRd8mr8P2zNAXjd+5koA9dakU=	2026-07-24 21:45:43.307064-03	f	leticia.martins	Letícia	Martins	le.martins@email.com	f	t	2026-06-04 08:09:43.307064-03
53	pbkdf2_sha256$1500000$ANrfEqaa9VWPS8NamRY6dI$Cd0TfuWJBveYzZW5qbmMV6Yr7ZB/i23iHcp1arOWnEw=	2026-07-08 11:53:43.307064-03	f	vini_araujo	Vinícius	Araújo	vinicius.araujo@email.com	f	t	2026-06-13 21:38:43.307064-03
54	pbkdf2_sha256$1500000$Ngy5zvGnmhIfvDKhYQborc$tTbx10E0TkE1YUhwFm7TGVNy7UhDN019/7bJLS2hjiM=	2026-08-29 08:49:43.307064-03	f	camilabarbosa	Camila	Barbosa	camila.b@email.com	f	t	2026-08-26 14:11:43.307064-03
55	pbkdf2_sha256$1500000$wm0Bd3CnsA24Y5B4VoHDlL$V8+mQdlQiRHS1svMwpwUAgT7mB2yhC4AHWEBB3+U7A8=	2026-11-05 21:58:43.307064-03	f	felipe.rocha	Felipe	Rocha	feliperocha@email.com	f	t	2026-10-15 08:18:43.307064-03
56	pbkdf2_sha256$1500000$bpsYtqvBtMso5bwdjyR6jk$PuCl/2cFHWvsfrG41hHyUd6TRsqIo2hyhp18Mib/Ig8=	2026-08-14 14:30:43.307064-03	f	yasmin.cardoso	Yasmin	Cardoso	yas.cardoso@email.com	f	t	2026-08-11 13:14:43.307064-03
57	pbkdf2_sha256$1500000$ZDXPjIlaXlRohuRqJtOT9x$9O6O9BzgGaOO9tF7GTjOlMXId71NdDa9WPqP7XLPT1k=	2026-09-26 16:04:43.307064-03	f	joaovictor.m	João Victor	Mendes	joaovictor.mendes@email.com	f	t	2026-09-04 20:45:43.307064-03
58	pbkdf2_sha256$1500000$cAFkEcpiCM84D10OCoCo4L$b5N/Io7P5rHFWRNOom9GsLUivjXg6JCjBx+Nyiiz8a8=	2026-10-31 18:14:43.307064-03	f	sofiacastro	Sofia	Castro	sofia.castro@email.com	f	t	2026-09-11 18:03:43.307064-03
59	pbkdf2_sha256$1500000$4hur14DfdM6it9H2ZLTo3b$FqJT8Oul5pS8s4CVBkrkJIagu5BOhvO0MyAzpiDST2I=	2026-10-23 22:59:43.307064-03	f	enzo.monteiro	Enzo	Monteiro	enzomonteiro09@email.com	f	t	2026-10-18 16:43:43.307064-03
60	pbkdf2_sha256$1500000$6ZwYCRVr8i0DNaBueiC0ef$j91G6WX692odc2wguWBfFSczmWF2CORuF+yfMcpBcEc=	2026-09-28 12:44:43.307064-03	f	manu.dias	Manuela	Dias	manuela.dias@email.com	f	t	2026-09-02 07:45:43.307064-03
61	pbkdf2_sha256$1500000$mIlf5dsKJmIYg45hRVmQLG$nLcRcnqSanyvlLkdZTZ8H8F00lsPFPYo+JmeIYq/zpg=	2026-06-30 11:53:43.307064-03	f	thiago_correia	Thiago	Correia	thiago.correia@email.com	f	t	2026-06-01 07:17:43.307064-03
62	pbkdf2_sha256$1500000$KwiRjJSFwWJgfv8jfA0xio$ELaQyGvkFmN+ab65Va+cqP6L95Sgib4wSenYmCEqXVA=	2026-11-05 09:21:43.307064-03	f	gi.pinto	Giovanna	Pinto	giovanna.pinto@email.com	f	t	2026-10-17 17:48:43.307064-03
63	pbkdf2_sha256$1500000$sKbY5fiaY3Ij1xDbOw5gzf$SCCT7NI85ha6a5X46PlHlMiSOOpG8a+0BbFS1yiClPM=	2026-08-18 17:08:43.307064-03	f	arthurfreitas	Arthur	Freitas	arthur.freitas@email.com	f	t	2026-07-10 20:29:43.307064-03
64	pbkdf2_sha256$1500000$X1pWmGMaFW1JBZwEDQDK1S$p56L1cf6CPTPV9EWSu2Hk4cOSjTU6ioJqf7kpk1zop8=	2026-08-01 15:25:43.307064-03	f	livia.cavalcanti	Lívia	Cavalcanti	livia.c@email.com	f	t	2026-06-27 08:15:43.307064-03
65	pbkdf2_sha256$1500000$CR5O2xNZ80ERvIyi7gP0Pn$Xt9ir6YAJlGBionFQLr1qM369yeubhCcDFKR65cBynE=	2026-10-16 11:18:43.307064-03	f	davi.nasc	Davi	Nascimento	davi.nascimento@email.com	f	t	2026-10-10 11:33:43.307064-03
66	pbkdf2_sha256$1500000$CuBIVKFpvqGxhgaopeQau3$c8I6Cy98BvA+A2frNMGDzQREwK8K6D8EyhiUEmOelQo=	2026-10-05 15:00:43.307064-03	f	rebeca_azevedo	Rebeca	Azevedo	rebeca.azevedo@email.com	f	t	2026-09-03 22:20:43.307064-03
67	pbkdf2_sha256$1500000$eNp8ZCqyZVVrFJzO2E1s3A$Who8PUWc66n+jf+eSnF/HaEFcMLt6ahg1un3baD4gB8=	2026-08-17 17:01:43.307064-03	f	samuelbatista	Samuel	Batista	samuel.batista@email.com	f	t	2026-08-02 22:25:43.307064-03
68	pbkdf2_sha256$1500000$qYiupsIKSrg7KgM2Vw7yRE$I9+27GqkRLhHFYDTs0PQmlxI4KOF/zHqROfgLIw8jpk=	2026-07-20 09:22:43.307064-03	f	clara.fernandes	Clara	Fernandes	clarinha.fernandes@email.com	f	t	2026-06-24 08:09:43.307064-03
69	pbkdf2_sha256$1500000$ctgsjVSG8mELVkHGDsmWj4$x1kyTTCHXXwKkGQf72vzX+uB6u2Qv3N3a2EzmWb3OrI=	2026-08-11 16:44:43.307064-03	f	kaua.vieira	Kauã	Vieira	kauavieira@email.com	f	t	2026-07-16 08:28:43.307064-03
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
1	6	1
6	70	1
7	71	1
8	72	1
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: contas_codigoverificacao; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contas_codigoverificacao (id, codigo, criado_em, usado, usuario_id) FROM stdin;
1	584971	2026-09-26 14:11:24.805639-03	f	1
2	535563	2026-09-26 14:27:18.627411-03	f	1
3	711954	2026-09-26 14:28:57.812028-03	f	1
4	381283	2026-09-26 14:36:33.410263-03	f	1
5	298487	2026-09-26 14:38:13.55171-03	f	1
6	306863	2026-09-26 14:42:33.023874-03	t	1
7	758215	2026-09-26 14:50:57.409455-03	t	1
8	717956	2026-09-26 15:04:36.852792-03	t	1
9	626499	2026-09-26 15:16:38.225806-03	t	1
11	445880	2026-11-03 00:38:56.77793-03	f	6
10	713840	2026-11-03 00:38:28.317892-03	t	6
12	591833	2026-11-03 00:47:05.914691-03	t	1
13	576548	2026-11-06 11:33:32.690087-03	t	1
\.


--
-- Data for Name: contas_configuracaosite; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contas_configuracaosite (id, exigir_mfa, atualizada_em, atualizada_por_id) FROM stdin;
1	f	2026-11-06 11:34:33.778812-03	1
\.


--
-- Data for Name: contas_conviteeducador; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contas_conviteeducador (id, email, codigo, criado_em, expira_em, usado_em, criado_por_id, usado_por_id) FROM stdin;
\.


--
-- Data for Name: contas_perfilusuario; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contas_perfilusuario (id, aceitou_termos, data_aceite_termos, usuario_id, tipo_usuario, administrador_principal, aparecer_no_ranking) FROM stdin;
40	t	2026-10-24 08:35:43.307064-03	40	aluno	f	t
59	t	2026-10-18 16:43:43.307064-03	59	aluno	f	t
2	t	2026-09-25 00:42:27.210258-03	2	aluno	f	f
4	t	2026-09-25 14:12:53.76186-03	4	aluno	f	f
5	t	2026-09-25 14:16:06.054254-03	5	aluno	f	f
41	t	2026-07-03 22:54:43.307064-03	41	aluno	f	t
1	f	\N	1	administrador	t	f
6	t	2026-11-03 00:38:19.278726-03	6	educador	f	f
42	t	2026-07-22 22:00:43.307064-03	42	aluno	f	t
60	t	2026-09-02 07:45:43.307064-03	60	aluno	f	t
43	t	2026-07-28 16:58:43.307064-03	43	aluno	f	t
61	t	2026-06-01 07:17:43.307064-03	61	aluno	f	t
44	t	2026-08-22 15:40:43.307064-03	44	aluno	f	t
62	t	2026-10-17 17:48:43.307064-03	62	aluno	f	f
45	t	2026-07-14 20:22:43.307064-03	45	aluno	f	f
63	t	2026-07-10 20:29:43.307064-03	63	aluno	f	t
46	t	2026-05-29 21:34:43.307064-03	46	aluno	f	t
64	t	2026-06-27 08:15:43.307064-03	64	aluno	f	t
47	t	2026-07-10 15:48:43.307064-03	47	aluno	f	f
65	t	2026-10-10 11:33:43.307064-03	65	aluno	f	f
48	t	2026-09-04 18:21:43.307064-03	48	aluno	f	f
66	t	2026-09-03 22:20:43.307064-03	66	aluno	f	t
49	t	2026-07-05 16:33:43.307064-03	49	aluno	f	t
67	t	2026-08-02 22:25:43.307064-03	67	aluno	f	t
50	t	2026-06-12 22:46:43.307064-03	50	aluno	f	t
51	t	2026-07-16 16:35:43.307064-03	51	aluno	f	f
52	t	2026-06-04 08:09:43.307064-03	52	aluno	f	f
53	t	2026-06-13 21:38:43.307064-03	53	aluno	f	t
54	t	2026-08-26 14:11:43.307064-03	54	aluno	f	t
55	t	2026-10-15 08:18:43.307064-03	55	aluno	f	t
56	t	2026-08-11 13:14:43.307064-03	56	aluno	f	t
57	t	2026-09-04 20:45:43.307064-03	57	aluno	f	t
58	t	2026-09-11 18:03:43.307064-03	58	aluno	f	t
68	t	2026-06-24 08:09:43.307064-03	68	aluno	f	f
69	t	2026-07-16 08:28:43.307064-03	69	aluno	f	t
70	t	2026-06-03 19:20:43.307064-03	70	educador	f	f
71	t	2026-05-22 11:16:43.307064-03	71	educador	f	f
72	t	2026-05-28 07:50:43.307064-03	72	educador	f	f
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2026-09-11 23:12:56.037092-03	1	Controles e Dívidas	1	[{"added": {}}]	8	1
2	2026-09-11 23:14:43.917721-03	1	Cartão de Crédito	1	[{"added": {}}]	7	1
3	2026-09-12 00:07:58.588787-03	1	Cartão de Crédito	2	[{"changed": {"fields": ["Explicacao conteudo"]}}]	7	1
4	2026-09-12 01:19:26.840965-03	2	Orçamento	1	[{"added": {}}]	8	1
5	2026-09-12 01:19:57.36264-03	2	Orçamento	3		8	1
6	2026-09-12 01:26:18.030347-03	3	Entendendo o seu Orçamento	1	[{"added": {}}]	8	1
7	2026-09-12 01:27:15.188265-03	2	Introdução: o que é?	1	[{"added": {}}]	7	1
8	2026-09-25 02:20:54.074926-03	4	Economia Global	1	[{"added": {}}]	8	1
9	2026-09-25 02:42:47.846134-03	3	Moedas estrangeiras: como te afetam?	1	[{"added": {}}]	7	1
10	2026-11-03 00:52:48.364247-03	1	Quiz - O que você sabe sobre endividamento? (Controles e Dívidas)	1	[{"added": {}}]	12	1
11	2026-11-03 00:55:28.051813-03	1	1. O que é um orçamento pessoal?	1	[{"added": {}}, {"added": {"name": "Alternativa", "object": "Um limite de gastos imposto pelo banco"}}, {"added": {"name": "Alternativa", "object": "Um planejamento que organiza quanto voc\\u00ea ganha e quanto pode gastar ou guardar"}}, {"added": {"name": "Alternativa", "object": "Um tipo de empr\\u00e9stimo com juros baixos"}}, {"added": {"name": "Alternativa", "object": "Um documento exigido apenas por empresas"}}]	13	1
12	2026-11-06 11:34:33.780976-03	1	Configurações do site	2	[{"changed": {"fields": ["Exigir c\\u00f3digo por e-mail no login"]}}]	18	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	group
3	auth	permission
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	modulos	conteudomodulo
8	modulos	modulo
9	contas	perfilusuario
10	contas	codigoverificacao
11	atividades	alternativa
12	atividades	atividade
13	atividades	pergunta
14	atividades	resposta
15	atividades	tentativa
18	contas	configuracaosite
19	atividades	progressoatividade
20	contas	conviteeducador
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-09-11 21:56:06.660573-03
2	auth	0001_initial	2026-09-11 21:56:06.734088-03
3	admin	0001_initial	2026-09-11 21:56:06.757046-03
4	admin	0002_logentry_remove_auto_add	2026-09-11 21:56:06.762681-03
5	admin	0003_logentry_add_action_flag_choices	2026-09-11 21:56:06.76868-03
6	contenttypes	0002_remove_content_type_name	2026-09-11 21:56:06.781031-03
7	auth	0002_alter_permission_name_max_length	2026-09-11 21:56:06.789762-03
8	auth	0003_alter_user_email_max_length	2026-09-11 21:56:06.794939-03
9	auth	0004_alter_user_username_opts	2026-09-11 21:56:06.802262-03
10	auth	0005_alter_user_last_login_null	2026-09-11 21:56:06.8098-03
11	auth	0006_require_contenttypes_0002	2026-09-11 21:56:06.810823-03
12	auth	0007_alter_validators_add_error_messages	2026-09-11 21:56:06.819246-03
13	auth	0008_alter_user_username_max_length	2026-09-11 21:56:06.840069-03
14	auth	0009_alter_user_last_name_max_length	2026-09-11 21:56:06.84865-03
15	auth	0010_alter_group_name_max_length	2026-09-11 21:56:06.857904-03
16	auth	0011_update_proxy_permissions	2026-09-11 21:56:06.863385-03
17	auth	0012_alter_user_first_name_max_length	2026-09-11 21:56:06.871156-03
18	modulos	0001_initial	2026-09-11 21:56:06.888526-03
19	sessions	0001_initial	2026-09-11 21:56:06.898294-03
20	modulos	0002_alter_conteudomodulo_options_alter_modulo_options	2026-09-12 11:29:11.814497-03
21	contas	0001_initial	2026-09-24 23:42:23.563154-03
22	contas	0002_perfilusuario_tipo_usuario	2026-09-24 23:46:20.446946-03
23	modulos	0003_remove_conteudomodulo_ordem_conteudo_and_more	2026-09-25 02:22:42.312111-03
24	contas	0003_codigoverificacao	2026-09-26 14:10:33.523834-03
25	atividades	0001_initial	2026-11-03 00:43:10.603606-03
26	atividades	0002_atividadeaberta	2026-11-03 01:19:15.489099-03
27	modulos	0004_modulo_slug	2026-11-03 01:47:12.50277-03
28	contas	0004_perfis_e_administrador_principal	2026-11-06 11:04:03.583127-03
29	contas	0005_solicitacaoprofessor	2026-11-06 11:21:42.683613-03
30	contas	0006_email_unico	2026-11-06 11:30:20.087107-03
31	contas	0007_configuracaosite	2026-11-06 11:32:57.774427-03
32	atividades	0003_limpar_aberturas_de_atividades_concluidas	2026-11-06 11:55:25.605769-03
33	atividades	0004_progressoatividade	2026-11-06 11:55:25.699538-03
34	atividades	0005_delete_atividadeaberta	2026-11-06 11:55:25.710975-03
35	contas	0008_educador_e_convites	2026-11-06 14:57:58.313095-03
36	contas	0009_professores_viram_educadores	2026-11-06 14:57:58.36019-03
37	contas	0010_delete_solicitacaoprofessor	2026-11-06 14:57:58.37796-03
38	modulos	0005_modulo_mostrar_cotacoes	2026-11-06 15:30:48.056997-03
39	contas	0011_perfilusuario_aparecer_no_ranking	2026-11-06 15:49:29.713853-03
40	atividades	0006_renomear_ordem	2026-11-06 16:11:44.358236-03
41	modulos	0006_remover_textos_de_ajuda	2026-11-06 16:11:44.374399-03
42	atividades	0007_remover_ordem_das_perguntas	2026-11-06 17:37:09.257288-03
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
izpgoxwuf8mlfovcizwfjb3sbg93cikh	.eJxVjDEOgzAMAP_iuYpiiHFg7N43RHFiGtoKJAJT1b9XSAztene6N4S4byXsVdcwZRgA4fLLJKanzofIjzjfF5OWeVsnMUdiTlvNbcn6up7t36DEWmAAYRQW7Jhw9G2S6NSxWMqJR8aGxXpHqUFkR06J2r5jdGRj06vXnuDzBcv-Nrk:1xAWRE:zFKieQNgkH378VaNvf6uElZE7AIUI3ne0QDVDeBghbA	2026-10-10 14:43:52.52059-03
\.


--
-- Data for Name: modulos_conteudomodulo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.modulos_conteudomodulo (id, titulo_conteudo, explicacao_conteudo, modulo_id) FROM stdin;
4	Cartão de crédito	O cartão é uma forma de pagamento, não um dinheiro extra. Ele ajuda quando você usa com planejamento, e vira problema quando a fatura passa a ser maior do que o seu salário aguenta.\n\n1. Planeje os gastos: use o cartão só para compras que já cabem no seu orçamento do mês.\n\n2. Pague sempre o valor total da fatura. Se você paga só uma parte, o que ficou para trás entra no crédito rotativo, que tem uma das taxas de juros mais altas do mercado.\n\n3. Cuidado com o pagamento mínimo: ele evita o atraso, mas o restante da fatura continua no rotativo e cresce com juros. Desde 2024, a lei limita os juros e encargos do rotativo a 100% do valor da dívida, mas isso ainda pode dobrar o que você deve.\n\n4. Acompanhe o limite e a fatura pelo aplicativo, e não só quando ela chega.\n\n5. Evite parcelamentos longos: várias parcelas pequenas somadas ocupam o limite e o orçamento dos próximos meses.\n\n6. Pontos e cashback são bons, mas não justificam gastar mais do que o necessário.\n\nEm resumo: controle no cartão vem de planejar antes, acompanhar durante e pagar a fatura inteira.\n\nReferências:\nBrasil. Lei nº 14.690, de 3 de outubro de 2023 (limite de juros do rotativo do cartão). https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2023/lei/l14690.htm\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	1
5	Dividindo a renda: a regra 50-30-20	Uma forma simples de organizar o dinheiro do mês é dividir a renda em três partes:\n\n50% para as necessidades: moradia, transporte, alimentação, contas da casa.\n30% para os desejos: lazer, delivery, roupas, assinaturas.\n20% para guardar ou pagar dívidas.\n\nOs números não são uma lei. Quem mora com a família pode guardar mais; quem está pagando uma dívida pode usar parte dos 30% para quitá-la mais rápido. O que importa é decidir o destino do dinheiro assim que ele entra.\n\nPara as compras por impulso, uma dica que funciona: quando bater vontade de comprar algo que não estava no plano, espere alguns dias. Se depois disso ainda fizer sentido e couber no orçamento, aí sim.\n\nReferência:\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	1
6	Saindo das dívidas	O primeiro passo é saber exatamente o que você deve. Anote todas as dívidas com o valor, os juros e o prazo. O Registrato, um serviço gratuito do Banco Central, mostra os empréstimos e financiamentos que existem no seu CPF.\n\nDepois, priorize a dívida com os juros mais altos, que costuma ser a do cartão ou do cheque especial: é ela que mais cresce a cada mês. Vale também tentar negociar com o credor ou trocar uma dívida cara por uma mais barata, como um empréstimo com juros menores para quitar o rotativo.\n\nE, enquanto estiver pagando, evite fazer dívidas novas. Não adianta tirar água do barco com um furo aberto.\n\nReferências:\nBanco Central do Brasil. Registrato: consulte empréstimos, contas e chaves Pix em seu nome. https://www.bcb.gov.br/cidadaniafinanceira/registrato\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	1
7	Orçamento e fluxo de caixa: o que são	Pense numa viagem de carro: o orçamento é o mapa, o plano de rota. O fluxo de caixa é o painel do carro, que mostra em tempo real a velocidade e quanto ainda tem de combustível.\n\nPara ter uma vida financeira saudável, o primeiro passo não é investir, e sim entender o seu orçamento. O fluxo de caixa é o registro de todo o dinheiro que entra e sai da sua conta. Quando você não acompanha esses números, perde o controle das próprias escolhas.\n\nOs três pilares do fluxo de caixa:\n1. Receitas: todo o dinheiro que você recebe, como salário, mesada ou renda extra.\n2. Despesas fixas: gastos que se repetem todo mês com valor parecido, como aluguel, internet e transporte.\n3. Despesas variáveis: gastos que mudam de valor ou de frequência, como lazer, delivery e compras por impulso.\n\nReferência:\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	3
8	Montando o seu orçamento em 4 passos	1. Anote quanto entra: some tudo o que você recebe no mês, já com os descontos.\n\n2. Liste as despesas fixas: elas são as mais fáceis de prever e devem ser pagas primeiro.\n\n3. Acompanhe as variáveis por um mês inteiro: anote cada gasto, até o lanche e o aplicativo de transporte. É aqui que aparecem as surpresas.\n\n4. Compare e ajuste: receitas menos despesas. Se sobrar, decida para onde vai a sobra (guardar, investir, quitar uma dívida). Se faltar, é hora de cortar.\n\nPode ser num caderno, numa planilha ou num aplicativo. A ferramenta importa menos do que o hábito de anotar.\n\nReferências:\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf\nGoverno Federal / Banco Central do Brasil. Aprender Valor: educação financeira pessoal. https://www.gov.br/pt-br/servicos/aprender-educacao-financeira-pessoal-no-aprender-valor	3
9	Quando a conta não fecha	Se as despesas estão maiores que as receitas, comece pelas variáveis: são as mais fáceis de reduzir no curto prazo.\n\nDepois olhe as fixas com calma. Dá para trocar o plano de celular, renegociar a internet, cancelar assinaturas que você quase não usa?\n\nSe mesmo assim não fechar, o caminho é aumentar a receita com uma renda extra, ao menos por um tempo. E evite cobrir o buraco com cartão ou cheque especial: isso só empurra o problema para o mês seguinte, com juros.\n\nReferência:\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	3
10	Lendo as cotações do dia	A tabela no topo deste módulo mostra as cotações do dólar, do euro e do bitcoin em reais, buscadas na hora na AwesomeAPI, um serviço gratuito que reúne cotações do mercado. O que cada coluna quer dizer:\n\nCompra: quanto o mercado paga por uma unidade da moeda.\nVenda: quanto custa comprar uma unidade. A diferença entre venda e compra se chama spread, e é parte do ganho de quem faz o câmbio.\nMínima e máxima do dia: o menor e o maior valor negociado até agora.\nVariação: quanto a moeda subiu (+) ou caiu (-) em relação ao fechamento anterior, em porcentagem.\n\nO dólar da tabela é o dólar comercial, usado entre empresas e bancos. Quem compra dólar para viajar paga o dólar turismo, que sai mais caro por causa dos custos de transporte, da segurança e dos impostos. Já a PTAX é uma taxa média calculada pelo Banco Central todos os dias e usada como referência em contratos.\n\nReferências:\nAwesomeAPI. API de Cotações de Moedas (documentação). https://docs.awesomeapi.com.br/api-de-moedas\nB3. Bora Investir: entenda a diferença entre o dólar comercial e o dólar turismo. https://borainvestir.b3.com.br/tipos-de-investimentos/renda-variavel/cambio/entenda-a-diferenca-entre-o-dolar-comercial-e-o-dolar-turismo/\nBanco Central do Brasil. Circular nº 3.506/2010 (cálculo da taxa PTAX). https://www.bcb.gov.br/pre/normativos/circ/2010/pdf/circ_3506_v2_l.pdf	4
11	Moedas estrangeiras: como te afetam?	Dólar (USD)\nÉ a moeda mais usada no comércio internacional e a principal moeda de reserva do mundo: bancos centrais guardam dólares para dar estabilidade às suas economias. Quando o dólar sobe, ficam mais caros os produtos importados (celulares, computadores, peças de carro), os combustíveis e alimentos cujo preço é definido em dólar, como trigo e petróleo, e as viagens internacionais.\n\nEuro (EUR)\nÉ a moeda de 21 países da União Europeia desde que a Bulgária entrou na zona do euro, em 2026, e a segunda moeda mais importante do mundo. Ele varia conforme a economia europeia, as decisões do Banco Central Europeu e as crises da região, como guerras e problemas de energia. Empresas brasileiras que importam máquinas, remédios ou tecnologia da Europa pagam em euro, e isso chega ao preço final.\n\nBitcoin (BTC)\nÉ uma criptomoeda que não tem um banco central por trás e funciona numa rede chamada blockchain. O preço depende da procura, da confiança dos investidores e de notícias, e pode subir ou cair dezenas de por cento em poucos dias. No Brasil, as empresas que negociam criptoativos seguem o marco legal de 2022, mas isso não garante o valor da moeda: quem investe pode ganhar rápido e também perder muito.\n\nReferências:\nBanco Central Europeu. A Bulgária adota o euro (comunicado de 1º de janeiro de 2026). https://www.ecb.europa.eu/press/pr/date/2026/html/ecb.pr260101~c830245e42.pt.html\nBrasil. Lei nº 14.478, de 21 de dezembro de 2022 (marco legal dos criptoativos). https://www.planalto.gov.br/ccivil_03/_ato2019-2022/2022/lei/l14478.htm	4
12	Do câmbio ao preço no mercado	O dólar sobe ou cai por vários motivos ao mesmo tempo. Os principais:\n\nJuros: quando os juros nos Estados Unidos sobem, investidores levam dinheiro para lá e o dólar fica mais forte. Quando a Selic, os juros do Brasil, está alta, acontece o contrário: entra dinheiro e o real se valoriza.\nConfiança: incertezas políticas ou nas contas do governo fazem investidores tirarem dinheiro do país, e o dólar sobe.\nExportações: quando o mundo compra mais soja, minério e petróleo do Brasil, entram mais dólares e a cotação tende a cair.\n\nEssa mudança não fica só no noticiário. Um dólar mais caro encarece o que é importado e o que depende de insumos importados, e isso aparece na inflação medida pelo IPCA, o índice oficial do IBGE. É por isso que a cotação do dia, lá em cima, acaba chegando ao seu orçamento.\n\nReferências:\nInstituto Brasileiro de Geografia e Estatística (IBGE). IPCA: o que é a inflação oficial. https://www.ibge.gov.br/explica/inflacao.php\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	4
42	Cobrança indevida e onde reclamar	Se você pagou uma cobrança que não devia, tem direito a receber de volta o dobro do valor pago a mais, com correção, salvo engano justificável da empresa. Para reclamar, comece pelo SAC da empresa e anote o protocolo. Se não resolver, use o consumidor.gov.br, um serviço público e gratuito, ou procure o Procon da sua cidade.\n\nReferências:\nBrasil. Código de Defesa do Consumidor (Lei nº 8.078, de 11 de setembro de 1990). https://www.planalto.gov.br/ccivil_03/leis/l8078compilado.htm\nSecretaria Nacional do Consumidor. Plataforma consumidor.gov.br. https://www.consumidor.gov.br	14
31	Bruto, líquido e os descontos	O salário que aparece na proposta é o bruto. O que cai na conta é o líquido, depois dos descontos. Os mais comuns são o INSS, que é a contribuição para a aposentadoria, e o Imposto de Renda. Desde 2026, quem ganha até R$ 5 mil por mês não tem mais o IR descontado na fonte. Vale-transporte e plano de saúde também podem aparecer. Antes de planejar qualquer gasto, olhe o holerite e anote quanto realmente sobra.\n\nReferências:\nInstituto Nacional do Seguro Social (INSS). Inscrição e contribuição. https://www.gov.br/inss\nBrasil. Lei nº 15.270, de 26 de novembro de 2025 (isenção do Imposto de Renda para quem ganha até R$ 5 mil por mês). Portal da Legislação: https://www4.planalto.gov.br/legislacao\nReceita Federal do Brasil. https://www.gov.br/receitafederal	11
32	Dividindo o dinheiro do mês	Uma forma simples de começar é separar o salário em três partes: o que é essencial (transporte, comida, contas da casa), o que é para você aproveitar e o que vai ser guardado. Não precisa ser exato. O importante é decidir o destino do dinheiro assim que ele entra, e não no fim do mês.\n\nReferência:\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	11
33	Reserva de emergência	Reserva de emergência é um dinheiro guardado só para imprevistos: um celular que quebrou, um remédio, um mês sem renda. O ideal é deixar em um lugar seguro e que dê para sacar rápido. Começar com pouco já ajuda: o hábito de guardar todo mês conta mais do que o valor.\n\nReferência:\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	11
34	Golpes com Pix	O golpe mais comum é alguém se passar por um conhecido pedindo dinheiro por mensagem, quase sempre com pressa e um número novo. Antes de transferir, ligue para a pessoa no número que você já tinha. Desconfie também de comprovantes de Pix enviados por print: confira sempre no aplicativo do banco.\n\nReferências:\nBanco Central do Brasil. Pix. https://www.bcb.gov.br/estabilidadefinanceira/pix\nFederação Brasileira de Bancos (Febraban). Portal com alertas e dicas de segurança. https://portal.febraban.org.br	12
35	Boletos e links falsos	Boletos falsos parecem verdadeiros, mas o dinheiro vai para outra conta. Confira o nome do beneficiário antes de pagar. Links recebidos por SMS ou mensagem dizendo que sua conta foi bloqueada ou que você ganhou um prêmio costumam levar a sites que roubam senha. Na dúvida, entre direto pelo app oficial.\n\nReferência:\nFederação Brasileira de Bancos (Febraban). Portal com alertas e dicas de segurança. https://portal.febraban.org.br	12
36	Caí em um golpe. E agora?	Avise o banco o quanto antes: no caso do Pix, existe um mecanismo de devolução que funciona melhor se acionado rápido. Registre um boletim de ocorrência, que pode ser feito pela internet em muitos estados. Troque as senhas que podem ter sido expostas e avise os seus contatos se a sua conta foi clonada.\n\nReferências:\nBanco Central do Brasil. Guia do Mecanismo Especial de Devolução (MED) do Pix. https://www.bcb.gov.br/content/estabilidadefinanceira/pix/Guia_MED.pdf\nBanco Central do Brasil. Pix. https://www.bcb.gov.br/estabilidadefinanceira/pix	12
37	Guardar x investir	Guardar é separar o dinheiro. Investir é colocar esse dinheiro em algo que rende ao longo do tempo. Dinheiro parado perde valor com a inflação, que é a subida geral dos preços. Por isso, mesmo a reserva de emergência pode ficar em uma aplicação simples que renda alguma coisa.\n\nReferências:\nInstituto Brasileiro de Geografia e Estatística (IBGE). IPCA: o que é a inflação oficial. https://www.ibge.gov.br/explica/inflacao.php\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	13
38	Renda fixa para começar	Na renda fixa você sabe a regra do rendimento quando aplica. A poupança é a mais conhecida, mas costuma render menos que outras opções. O Tesouro Direto e os CDBs de bancos também são renda fixa e aceitam valores baixos. Muitos CDBs têm a proteção do FGC, o Fundo Garantidor de Créditos.\n\nReferências:\nTesouro Nacional. Tesouro Direto: como funciona. https://www.tesourodireto.com.br\nFundo Garantidor de Créditos (FGC). Sobre a garantia. https://www.fgc.org.br	13
39	Risco, prazo e liquidez	Todo investimento tem três pontos a olhar: o risco (a chance de perder dinheiro), o prazo (quanto tempo o dinheiro fica aplicado) e a liquidez (a facilidade de resgatar). Desconfie de quem promete muito retorno sem risco: isso não existe.\n\nReferências:\nComissão de Valores Mobiliários (CVM). https://www.gov.br/cvm\nFundo Garantidor de Créditos (FGC). Sobre a garantia. https://www.fgc.org.br	13
40	Comprou pela internet e se arrependeu	Quando a compra é feita fora da loja física, como pela internet, telefone ou aplicativo, você tem 7 dias para desistir, sem precisar explicar o motivo. O prazo conta da assinatura do contrato ou do dia em que o produto chegou. A loja deve devolver todo o valor pago, inclusive o frete. Isso está no artigo 49 do Código de Defesa do Consumidor.\n\nReferência:\nBrasil. Código de Defesa do Consumidor (Lei nº 8.078, de 11 de setembro de 1990). https://www.planalto.gov.br/ccivil_03/leis/l8078compilado.htm	14
41	Produto com defeito	Se o produto veio com defeito, você tem 30 dias para reclamar quando é algo que acaba rápido, como comida, e 90 dias quando é um produto durável, como um celular ou uma roupa. A empresa tem até 30 dias para resolver. Se não resolver, você pode escolher entre a troca, o dinheiro de volta ou um desconto no preço.\n\nReferência:\nBrasil. Código de Defesa do Consumidor (Lei nº 8.078, de 11 de setembro de 1990). https://www.planalto.gov.br/ccivil_03/leis/l8078compilado.htm	14
43	Você paga imposto até no lanche	Mesmo quem não tem salário paga imposto, porque boa parte deles já vem embutida no preço do que a gente compra. São os impostos sobre o consumo, como o ICMS (estadual), o ISS (municipal, sobre serviços) e o IPI (federal, sobre produtos industrializados). Já o Imposto de Renda incide sobre o que a pessoa ganha.\n\nReferência:\nReceita Federal do Brasil. https://www.gov.br/receitafederal	15
44	O imposto aparece na nota fiscal	Desde 2012, a lei obriga as lojas a informar na nota fiscal o valor aproximado dos tributos de cada compra. Da próxima vez que pegar um cupom fiscal, procure a linha com o valor dos tributos: ela mostra quanto daquele preço foi para o governo. Pedir a nota também ajuda a garantir que o imposto pago chegue aos cofres públicos.\n\nReferência:\nBrasil. Lei nº 12.741, de 8 de dezembro de 2012 (impostos informados na nota fiscal). https://www.planalto.gov.br/ccivil_03/_ato2011-2014/2012/lei/l12741.htm	15
45	O que muda com a reforma tributária	Em 2023 foi aprovada a reforma tributária sobre o consumo. Aos poucos, até 2033, cinco tributos (PIS, Cofins, IPI, ICMS e ISS) vão dar lugar a dois novos: a CBS, federal, e o IBS, de estados e municípios. A ideia é simplificar a cobrança e deixar mais claro quanto de imposto existe em cada compra. A mudança é gradual, com um período de testes que começou em 2026.\n\nReferência:\nBrasil. Emenda Constitucional nº 132, de 20 de dezembro de 2023 (Reforma Tributária). https://www.planalto.gov.br/ccivil_03/constituicao/emendas/emc/emc132.htm	15
46	Juros sobre juros	Nos juros compostos, os juros de cada mês entram na conta e passam a render juros também. Exemplo: R$ 100 a 1% ao mês viram R$ 101 depois de um mês. No mês seguinte, o 1% é calculado sobre R$ 101, e não sobre R$ 100. Parece pouco no começo, mas com o tempo a diferença fica grande.\n\nReferência:\nBanco Central do Brasil. Calculadora do Cidadão. https://www.gov.br/pt-br/servicos/obter-auxilio-para-executar-calculos-financeiros	16
47	O tempo trabalha a favor de quem guarda	Quem começa a guardar cedo deixa os juros compostos agirem por mais tempo. Duas pessoas que guardam o mesmo valor por mês podem chegar a resultados bem diferentes só porque uma começou alguns anos antes. Para fazer simulações, a Calculadora do Cidadão, do Banco Central, mostra quanto um valor guardado todo mês pode virar.\n\nReferências:\nBanco Central do Brasil. Calculadora do Cidadão. https://www.gov.br/pt-br/servicos/obter-auxilio-para-executar-calculos-financeiros\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	16
48	E contra quem deve	A mesma lógica vale para as dívidas. No rotativo do cartão de crédito, os juros estão entre os mais altos do mercado, e uma dívida pequena pode crescer rápido. Desde 2024, a lei limita o total de juros e encargos do rotativo a 100% do valor da dívida. Mesmo assim, o melhor caminho é pagar a fatura inteira ou trocar a dívida por uma mais barata.\n\nReferências:\nBrasil. Lei nº 14.690, de 3 de outubro de 2023 (limite de juros do rotativo do cartão). https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2023/lei/l14690.htm\nBanco Central do Brasil. Caderno de Educação Financeira: Gestão de Finanças Pessoais. https://www.bcb.gov.br/pre/pef/port/caderno_cidadania_financeira.pdf	16
\.


--
-- Data for Name: modulos_modulo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.modulos_modulo (id, nome_modulo, descricao_modulo, slug, mostrar_cotacoes) FROM stdin;
1	Controles e Dívidas	Como controlar os gastos, usar o cartão de crédito sem se enrolar e sair das dívidas.	controles-e-dividas	f
3	Entendendo o seu Orçamento	O que é o fluxo de caixa e como montar um orçamento para saber para onde vai o seu dinheiro.	entendendo-o-seu-orcamento	f
4	Economia Global	Entenda como os movimentos da economia mundial impactam o seu orçamento e o de sua família.	economia-global	t
11	Primeiro salário	O que vem no holerite, para onde vai cada parte do dinheiro e como começar a guardar desde o primeiro mês.	primeiro-salario	f
12	Golpes financeiros	Como reconhecer os golpes mais comuns com Pix, boletos e mensagens, e o que fazer se cair em um.	golpes-financeiros	f
13	Investir pela primeira vez	Diferença entre guardar e investir, as opções mais simples para começar e os riscos de cada uma.	investir-pela-primeira-vez	f
14	Direitos do consumidor	O que a lei garante quando você compra alguma coisa: troca, arrependimento, cobrança indevida e onde reclamar.	direitos-do-consumidor	f
15	Impostos no dia a dia	Os impostos que você paga sem perceber, como encontrar o valor deles na nota fiscal e o que muda com a reforma tributária.	impostos-no-dia-a-dia	f
16	Juros compostos na prática	Como os juros crescem com o tempo, a favor de quem investe e contra quem deve, com contas simples.	juros-compostos-na-pratica	f
\.


--
-- Name: atividades_alternativa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.atividades_alternativa_id_seq', 600, true);


--
-- Name: atividades_atividade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.atividades_atividade_id_seq', 15, true);


--
-- Name: atividades_pergunta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.atividades_pergunta_id_seq', 150, true);


--
-- Name: atividades_progressoatividade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.atividades_progressoatividade_id_seq', 293, true);


--
-- Name: atividades_resposta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.atividades_resposta_id_seq', 3736, true);


--
-- Name: atividades_tentativa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.atividades_tentativa_id_seq', 374, true);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 23, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 80, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 8, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 72, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: contas_codigoverificacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contas_codigoverificacao_id_seq', 13, true);


--
-- Name: contas_configuracaosite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contas_configuracaosite_id_seq', 1, false);


--
-- Name: contas_conviteeducador_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contas_conviteeducador_id_seq', 1, false);


--
-- Name: contas_perfilusuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contas_perfilusuario_id_seq', 72, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 12, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 20, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 42, true);


--
-- Name: modulos_conteudomodulo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.modulos_conteudomodulo_id_seq', 48, true);


--
-- Name: modulos_modulo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.modulos_modulo_id_seq', 16, true);


--
-- Name: atividades_alternativa atividades_alternativa_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_alternativa
    ADD CONSTRAINT atividades_alternativa_pkey PRIMARY KEY (id);


--
-- Name: atividades_atividade atividades_atividade_modulo_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_atividade
    ADD CONSTRAINT atividades_atividade_modulo_id_key UNIQUE (modulo_id);


--
-- Name: atividades_atividade atividades_atividade_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_atividade
    ADD CONSTRAINT atividades_atividade_pkey PRIMARY KEY (id);


--
-- Name: atividades_pergunta atividades_pergunta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_pergunta
    ADD CONSTRAINT atividades_pergunta_pkey PRIMARY KEY (id);


--
-- Name: atividades_progressoatividade atividades_progressoatividade_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_progressoatividade
    ADD CONSTRAINT atividades_progressoatividade_pkey PRIMARY KEY (id);


--
-- Name: atividades_resposta atividades_resposta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_resposta
    ADD CONSTRAINT atividades_resposta_pkey PRIMARY KEY (id);


--
-- Name: atividades_tentativa atividades_tentativa_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_tentativa
    ADD CONSTRAINT atividades_tentativa_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: contas_codigoverificacao contas_codigoverificacao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_codigoverificacao
    ADD CONSTRAINT contas_codigoverificacao_pkey PRIMARY KEY (id);


--
-- Name: contas_configuracaosite contas_configuracaosite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_configuracaosite
    ADD CONSTRAINT contas_configuracaosite_pkey PRIMARY KEY (id);


--
-- Name: contas_conviteeducador contas_conviteeducador_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_conviteeducador
    ADD CONSTRAINT contas_conviteeducador_codigo_key UNIQUE (codigo);


--
-- Name: contas_conviteeducador contas_conviteeducador_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_conviteeducador
    ADD CONSTRAINT contas_conviteeducador_pkey PRIMARY KEY (id);


--
-- Name: contas_perfilusuario contas_perfilusuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_perfilusuario
    ADD CONSTRAINT contas_perfilusuario_pkey PRIMARY KEY (id);


--
-- Name: contas_perfilusuario contas_perfilusuario_usuario_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_perfilusuario
    ADD CONSTRAINT contas_perfilusuario_usuario_id_key UNIQUE (usuario_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: modulos_conteudomodulo modulos_conteudomodulo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modulos_conteudomodulo
    ADD CONSTRAINT modulos_conteudomodulo_pkey PRIMARY KEY (id);


--
-- Name: modulos_modulo modulos_modulo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modulos_modulo
    ADD CONSTRAINT modulos_modulo_pkey PRIMARY KEY (id);


--
-- Name: modulos_modulo modulos_modulo_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modulos_modulo
    ADD CONSTRAINT modulos_modulo_slug_key UNIQUE (slug);


--
-- Name: atividades_progressoatividade progresso_unico_por_aluno_e_atividade; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_progressoatividade
    ADD CONSTRAINT progresso_unico_por_aluno_e_atividade UNIQUE (usuario_id, atividade_id);


--
-- Name: atividades_tentativa tentativa_unica_por_numero; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_tentativa
    ADD CONSTRAINT tentativa_unica_por_numero UNIQUE (usuario_id, atividade_id, numero);


--
-- Name: apenas_um_administrador_principal; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX apenas_um_administrador_principal ON public.contas_perfilusuario USING btree (administrador_principal) WHERE administrador_principal;


--
-- Name: atividades_alternativa_pergunta_id_7c6d5976; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX atividades_alternativa_pergunta_id_7c6d5976 ON public.atividades_alternativa USING btree (pergunta_id);


--
-- Name: atividades_pergunta_atividade_id_392d1001; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX atividades_pergunta_atividade_id_392d1001 ON public.atividades_pergunta USING btree (atividade_id);


--
-- Name: atividades_progressoatividade_atividade_id_54a86027; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX atividades_progressoatividade_atividade_id_54a86027 ON public.atividades_progressoatividade USING btree (atividade_id);


--
-- Name: atividades_progressoatividade_usuario_id_6f2e9384; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX atividades_progressoatividade_usuario_id_6f2e9384 ON public.atividades_progressoatividade USING btree (usuario_id);


--
-- Name: atividades_resposta_alternativa_id_df124603; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX atividades_resposta_alternativa_id_df124603 ON public.atividades_resposta USING btree (alternativa_id);


--
-- Name: atividades_resposta_pergunta_id_88261d72; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX atividades_resposta_pergunta_id_88261d72 ON public.atividades_resposta USING btree (pergunta_id);


--
-- Name: atividades_resposta_tentativa_id_1578c89a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX atividades_resposta_tentativa_id_1578c89a ON public.atividades_resposta USING btree (tentativa_id);


--
-- Name: atividades_tentativa_atividade_id_3f3a4684; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX atividades_tentativa_atividade_id_3f3a4684 ON public.atividades_tentativa USING btree (atividade_id);


--
-- Name: atividades_tentativa_usuario_id_1ed9d825; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX atividades_tentativa_usuario_id_1ed9d825 ON public.atividades_tentativa USING btree (usuario_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_email_unico; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX auth_user_email_unico ON public.auth_user USING btree (lower((email)::text)) WHERE ((email)::text <> ''::text);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: contas_codigoverificacao_usuario_id_8da56468; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contas_codigoverificacao_usuario_id_8da56468 ON public.contas_codigoverificacao USING btree (usuario_id);


--
-- Name: contas_configuracaosite_atualizada_por_id_4e67342b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contas_configuracaosite_atualizada_por_id_4e67342b ON public.contas_configuracaosite USING btree (atualizada_por_id);


--
-- Name: contas_conviteeducador_codigo_a4143307_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contas_conviteeducador_codigo_a4143307_like ON public.contas_conviteeducador USING btree (codigo varchar_pattern_ops);


--
-- Name: contas_conviteeducador_criado_por_id_34b531c8; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contas_conviteeducador_criado_por_id_34b531c8 ON public.contas_conviteeducador USING btree (criado_por_id);


--
-- Name: contas_conviteeducador_usado_por_id_7a122649; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contas_conviteeducador_usado_por_id_7a122649 ON public.contas_conviteeducador USING btree (usado_por_id);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: modulos_conteudomodulo_modulo_id_744299b8; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX modulos_conteudomodulo_modulo_id_744299b8 ON public.modulos_conteudomodulo USING btree (modulo_id);


--
-- Name: modulos_modulo_slug_77838c2f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX modulos_modulo_slug_77838c2f_like ON public.modulos_modulo USING btree (slug varchar_pattern_ops);


--
-- Name: atividades_alternativa atividades_alternati_pergunta_id_7c6d5976_fk_atividade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_alternativa
    ADD CONSTRAINT atividades_alternati_pergunta_id_7c6d5976_fk_atividade FOREIGN KEY (pergunta_id) REFERENCES public.atividades_pergunta(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: atividades_atividade atividades_atividade_modulo_id_eec1056d_fk_modulos_modulo_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_atividade
    ADD CONSTRAINT atividades_atividade_modulo_id_eec1056d_fk_modulos_modulo_id FOREIGN KEY (modulo_id) REFERENCES public.modulos_modulo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: atividades_pergunta atividades_pergunta_atividade_id_392d1001_fk_atividade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_pergunta
    ADD CONSTRAINT atividades_pergunta_atividade_id_392d1001_fk_atividade FOREIGN KEY (atividade_id) REFERENCES public.atividades_atividade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: atividades_progressoatividade atividades_progresso_atividade_id_54a86027_fk_atividade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_progressoatividade
    ADD CONSTRAINT atividades_progresso_atividade_id_54a86027_fk_atividade FOREIGN KEY (atividade_id) REFERENCES public.atividades_atividade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: atividades_progressoatividade atividades_progresso_usuario_id_6f2e9384_fk_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_progressoatividade
    ADD CONSTRAINT atividades_progresso_usuario_id_6f2e9384_fk_auth_user FOREIGN KEY (usuario_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: atividades_resposta atividades_resposta_alternativa_id_df124603_fk_atividade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_resposta
    ADD CONSTRAINT atividades_resposta_alternativa_id_df124603_fk_atividade FOREIGN KEY (alternativa_id) REFERENCES public.atividades_alternativa(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: atividades_resposta atividades_resposta_pergunta_id_88261d72_fk_atividade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_resposta
    ADD CONSTRAINT atividades_resposta_pergunta_id_88261d72_fk_atividade FOREIGN KEY (pergunta_id) REFERENCES public.atividades_pergunta(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: atividades_resposta atividades_resposta_tentativa_id_1578c89a_fk_atividade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_resposta
    ADD CONSTRAINT atividades_resposta_tentativa_id_1578c89a_fk_atividade FOREIGN KEY (tentativa_id) REFERENCES public.atividades_tentativa(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: atividades_tentativa atividades_tentativa_atividade_id_3f3a4684_fk_atividade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_tentativa
    ADD CONSTRAINT atividades_tentativa_atividade_id_3f3a4684_fk_atividade FOREIGN KEY (atividade_id) REFERENCES public.atividades_atividade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: atividades_tentativa atividades_tentativa_usuario_id_1ed9d825_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.atividades_tentativa
    ADD CONSTRAINT atividades_tentativa_usuario_id_1ed9d825_fk_auth_user_id FOREIGN KEY (usuario_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contas_codigoverificacao contas_codigoverificacao_usuario_id_8da56468_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_codigoverificacao
    ADD CONSTRAINT contas_codigoverificacao_usuario_id_8da56468_fk_auth_user_id FOREIGN KEY (usuario_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contas_configuracaosite contas_configuracaos_atualizada_por_id_4e67342b_fk_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_configuracaosite
    ADD CONSTRAINT contas_configuracaos_atualizada_por_id_4e67342b_fk_auth_user FOREIGN KEY (atualizada_por_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contas_conviteeducador contas_conviteeducador_criado_por_id_34b531c8_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_conviteeducador
    ADD CONSTRAINT contas_conviteeducador_criado_por_id_34b531c8_fk_auth_user_id FOREIGN KEY (criado_por_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contas_conviteeducador contas_conviteeducador_usado_por_id_7a122649_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_conviteeducador
    ADD CONSTRAINT contas_conviteeducador_usado_por_id_7a122649_fk_auth_user_id FOREIGN KEY (usado_por_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contas_perfilusuario contas_perfilusuario_usuario_id_16684c3a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_perfilusuario
    ADD CONSTRAINT contas_perfilusuario_usuario_id_16684c3a_fk_auth_user_id FOREIGN KEY (usuario_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: modulos_conteudomodulo modulos_conteudomodulo_modulo_id_744299b8_fk_modulos_modulo_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modulos_conteudomodulo
    ADD CONSTRAINT modulos_conteudomodulo_modulo_id_744299b8_fk_modulos_modulo_id FOREIGN KEY (modulo_id) REFERENCES public.modulos_modulo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\unrestrict pBHc6NigEolhT9TH6teJY3xWJ1veUriGdR75TrtsOepjj9GyyWvw1QFeIc0GsUM

