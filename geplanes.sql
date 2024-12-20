--
-- PostgreSQL database dump
--

---
---  geplanes_bsc (v4.0.0)
---

SET client_encoding = 'UTF-8';
--- SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
--- SET escape_string_warning = off;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- Name: fc_anexoanomalia_exclusao_arquivo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fc_anexoanomalia_exclusao_arquivo() RETURNS "trigger"
    AS $$
BEGIN
  delete from Arquivo where Arquivo.id=old.arquivo_id;
  RETURN OLD;
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.fc_anexoanomalia_exclusao_arquivo() OWNER TO postgres;

--
-- Name: fc_anexoindicador_exclusao_arquivo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fc_anexoindicador_exclusao_arquivo() RETURNS "trigger"
    AS $$
BEGIN
  delete from Arquivo where Arquivo.id=old.arquivo_id;
  RETURN OLD;
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.fc_anexoindicador_exclusao_arquivo() OWNER TO postgres;

--
-- Name: fc_indicador_exclusao_dono(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fc_indicador_exclusao_dono() RETURNS "trigger"
    AS $$
BEGIN
  delete from Indicador where dono_id=old.id;
  /*delete from Indicador where id=old.id;*/
  RETURN OLD;
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.fc_indicador_exclusao_dono() OWNER TO postgres;

--
-- Name: fc_trg_planogestao_exclusao_arquivo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fc_trg_planogestao_exclusao_arquivo() RETURNS "trigger"
    AS $$
BEGIN
  delete from Arquivo where id = old.mapaEstrategico_id;
  RETURN OLD;
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.fc_trg_planogestao_exclusao_arquivo() OWNER TO postgres;

--
-- Name: tg_indicador_ins(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tg_indicador_ins() RETURNS "trigger"
    AS $$
    DECLARE 
    BEGIN

	IF(TG_OP <> 'DELETE')THEN 
		IF(TG_OP = 'INSERT') THEN
			INSERT INTO indicadorsincronizacaodashboard (idindicador,criar,deletar) values (NEW.id,true,false);
		ELSEIF(TG_OP = 'UPDATE') THEN
			UPDATE indicadorsincronizacaodashboard
			SET deletar = false,
			criar = true,
			dtsincronizacao = NULL
			WHERE idindicador = NEW.id;
		END IF;
	ELSE
		UPDATE indicadorsincronizacaodashboard
		SET deletar = true,
		criar = false,
		dtsincronizacao = NULL
		WHERE idindicador = OLD.id;
	END IF;
	RETURN NULL;		
    END;
  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.tg_indicador_ins() OWNER TO postgres;

--
-- Name: tiraacento(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

-- CREATE FUNCTION tiraacento(character varying) RETURNS character varying
--     AS $_$
-- SELECT to_ascii($1,'LATIN1') AS ANSWER
-- $_$
--     LANGUAGE sql IMMUTABLE STRICT;


-- ALTER FUNCTION public.tiraacento(character varying) OWNER TO postgres;

-- --
-- -- Name: FUNCTION tiraacento(character varying); Type: COMMENT; Schema: public; Owner: postgres
-- --

-- COMMENT ON FUNCTION tiraacento(character varying) IS 'Tira acentos de uma string';


-- SET default_tablespace = '';

-- SET default_with_oids = true;

--
-- Name: acaopreventiva; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE acaopreventiva (
    id integer NOT NULL,
    sequencial integer NOT NULL,
    ugregistro_id integer NOT NULL,
    dataabertura date NOT NULL,
    dataencerramento date,
    origem integer,
    descricao character varying(3000),
    observacoes character varying(1500),
    conclusao character varying(3000),
    avaleficaciaacao integer,
    evidenciaeficaciaacao character varying(1000),
    tipo integer,
    status integer NOT NULL
);


ALTER TABLE public.acaopreventiva OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: acompanhamentoindicador; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE acompanhamentoindicador (
    id integer NOT NULL,
    indice integer NOT NULL,
    datainicial date NOT NULL,
    datafinal date NOT NULL,
    valorlimitesuperior money,
    valorreal money,
    valorlimiteinferior money,
    valorbaseok boolean,
    valorrealok boolean,
    indicador_id integer NOT NULL,
    anomalia_id integer,
    dtlemblancres date,
    acaopreventiva_id integer,
    naoaplicavel boolean
);


ALTER TABLE public.acompanhamentoindicador OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: anexoanomalia; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE anexoanomalia (
    id integer NOT NULL,
    nome character varying(30) NOT NULL,
    descricao character varying(500),
    arquivo_id uuid NOT NULL,
    anomalia_id integer NOT NULL
);


ALTER TABLE public.anexoanomalia OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: anexoindicador; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE anexoindicador (
    id integer NOT NULL,
    nome character varying(30) NOT NULL,
    descricao character varying(500),
    arquivo_id uuid NOT NULL,
    indicador_id integer NOT NULL
);


ALTER TABLE public.anexoindicador OWNER TO postgres;

--
-- Name: anomalia; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE anomalia (
    id integer NOT NULL,
    conclusao text,
    dataabertura date NOT NULL,
    dataencerramento date,
    descricao character varying(1800),
    "local" integer NOT NULL,
    contramedidasimediatas character varying(1500),
    ugresponsavel_id integer NOT NULL,
    ugregistro_id integer NOT NULL,
    sequencial integer NOT NULL,
    observacoes character varying(1500),
    classificacao integer,
    responsavel character varying(100),
    verificacao character varying(1500),
    padronizacao character varying(1500),
    ocorrencia_id integer,
    analisecausas character varying(1500),
    datadestravamento date,
    lembreteenviado boolean,
    status integer NOT NULL,
    statustratamento integer,
    tipo integer,
    origem integer,
    datasolicitacaoencerramento date,
    subordinacao_id integer,
    tipoauditoria character varying(255),
    itemauditoriainterna_id integer
);


ALTER TABLE public.anomalia OWNER TO postgres;

--
-- Name: arquivo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE arquivo (
    id uuid NOT NULL,
    nome character varying(60) NOT NULL,
    contenttype character varying(100) NOT NULL,
    size integer,
    -- content character varying(1),
    conteudo bytea NOT NULL
);


ALTER TABLE public.arquivo OWNER TO postgres;

--
-- Name: atividade; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE atividade (
    id integer NOT NULL,
    mapacompetencia_id integer NOT NULL,
    descricao character varying(500)
);


ALTER TABLE public.atividade OWNER TO postgres;

--
-- Name: auditoriagestao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auditoriagestao (
    id integer NOT NULL,
    descricao character varying(100) NOT NULL,
    unidadegerencial_id integer NOT NULL,
    modeloauditoriagestao_id integer NOT NULL,
    responsavel character varying(100) NOT NULL,
    dataauditoria date NOT NULL
);


ALTER TABLE public.auditoriagestao OWNER TO postgres;

--
-- Name: auditoriagestaoindicador; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auditoriagestaoindicador (
    id integer NOT NULL,
    auditoriagestao_id integer NOT NULL,
    indicador_id integer NOT NULL
);


ALTER TABLE public.auditoriagestaoindicador OWNER TO postgres;

--
-- Name: auditoriagestaoindicadoritem; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auditoriagestaoindicadoritem (
    id integer NOT NULL,
    auditoriagestaoindicador_id integer NOT NULL,
    itemmodeloauditoriagestao_id integer NOT NULL,
    itemfatoravaliacao_id integer,
    texto character varying(500)
);


ALTER TABLE public.auditoriagestaoindicadoritem OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: auditoriainterna; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auditoriainterna (
    id integer NOT NULL,
    ugregistro_id integer NOT NULL,
    ugresponsavel_id integer NOT NULL,
    dataauditoria date NOT NULL,
    observacoes character varying(3000),
    norma_id integer NOT NULL,
    status integer NOT NULL,
    dataencerramento date
);


ALTER TABLE public.auditoriainterna OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: causaefeito; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE causaefeito (
    id integer NOT NULL,
    descricao character varying(150) NOT NULL,
    efeito_id integer,
    anomalia_id integer
);


ALTER TABLE public.causaefeito OWNER TO postgres;

--
-- Name: comentario; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comentario (
    id integer NOT NULL
);


ALTER TABLE public.comentario OWNER TO postgres;

--
-- Name: comentarioitem; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comentarioitem (
    id integer NOT NULL,
    comentario_id integer NOT NULL,
    usuario_id integer NOT NULL,
    texto text NOT NULL,
    data date NOT NULL
);


ALTER TABLE public.comentarioitem OWNER TO postgres;

--
-- Name: competencia; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE competencia (
    id integer NOT NULL,
    mapacompetencia_id integer NOT NULL,
    competenciaorganizacional_id integer
);


ALTER TABLE public.competencia OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: competenciaorganizacional; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE competenciaorganizacional (
    id integer NOT NULL,
    nome character varying(150) NOT NULL,
    descricao character varying(1000)
);


ALTER TABLE public.competenciaorganizacional OWNER TO postgres;

--
-- Name: emailhistorico; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE emailhistorico (
    id integer NOT NULL,
    remetente character varying(60) NOT NULL,
    assunto character varying(100) NOT NULL,
    mensagem character varying(3000) NOT NULL,
    data timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.emailhistorico OWNER TO postgres;

--
-- Name: emailhistoricousuario; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE emailhistoricousuario (
    id integer NOT NULL,
    emailhistorico_id integer NOT NULL,
    usuarioemail character varying(100) NOT NULL,
    tipousuarioemail integer NOT NULL
);


ALTER TABLE public.emailhistoricousuario OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: fatoravaliacao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fatoravaliacao (
    id integer NOT NULL,
    nome character varying(50) NOT NULL,
    utilizarmatrizfcs boolean
);


ALTER TABLE public.fatoravaliacao OWNER TO postgres;

--
-- Name: indicador; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE indicador (
    id integer NOT NULL,
    nome character varying(80) NOT NULL,
    descricao character varying(1500),
    peso double precision NOT NULL,
    precisao integer,
    tolerancia double precision,
    frequencia integer,
    melhor integer,
    unidademedida_id integer,
    status integer NOT NULL,
    responsavel character varying(100),
    relevancia integer,
    frequenciaacompanhamento integer,
    mecanismocontrole character varying(500),
    fontedados character varying(500),
    formulacalculo character varying(1500),
    unidadegerencial_id integer NOT NULL,
    objetivomapaestrategico_id integer NOT NULL
);


ALTER TABLE public.indicador OWNER TO postgres;

--
-- Name: indicadoralerta; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE indicadoralerta (
    id integer NOT NULL,
    idacompanhamentoindicador integer,
    idalerta integer,
    idindicador integer
);


ALTER TABLE public.indicadoralerta OWNER TO postgres;

--
-- Name: indicadorsincronizacaodashboard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE indicadorsincronizacaodashboard (
    idindicador integer NOT NULL,
    dtsincronizacao timestamp without time zone,
    codigoerro integer,
    mensagemerro character varying,
    criar boolean,
    deletar boolean
);


ALTER TABLE public.indicadorsincronizacaodashboard OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: iniciativa; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE iniciativa (
    id integer NOT NULL,
    unidadegerencial_id integer NOT NULL,
    objetivomapaestrategico_id integer NOT NULL,
    descricao character varying(100) NOT NULL
);


ALTER TABLE public.iniciativa OWNER TO postgres;

--
-- Name: itemauditoriainterna; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE itemauditoriainterna (
    id integer NOT NULL,
    auditoriainterna_id integer NOT NULL,
    requisitonorma_id integer,
    descricao character varying(3000) NOT NULL,
    ugexterna_id integer
);


ALTER TABLE public.itemauditoriainterna OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: itemfatoravaliacao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE itemfatoravaliacao (
    id integer NOT NULL,
    fatoravaliacao_id integer NOT NULL,
    valor double precision NOT NULL,
    descricao character varying(100) NOT NULL
);


ALTER TABLE public.itemfatoravaliacao OWNER TO postgres;

--
-- Name: itemmodeloauditoriagestao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE itemmodeloauditoriagestao (
    id integer NOT NULL,
    modeloauditoriagestao_id integer NOT NULL,
    nome character varying(100) NOT NULL,
    descricao character varying(500),
    fatoravaliacao_id integer,
    ordem integer NOT NULL
);


ALTER TABLE public.itemmodeloauditoriagestao OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: logprocesso; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE logprocesso (
    id integer NOT NULL,
    dtlemblancresultado timestamp(0) without time zone,
    dtatualizastatusanomalia timestamp(0) without time zone,
    dtlembtratanomalia timestamp(0) without time zone,
    dtlembcriacaoindicador timestamp(0) without time zone,
    dtatualizalancamentoresultados timestamp(0) without time zone
);


ALTER TABLE public.logprocesso OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: mapacompetencia; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mapacompetencia (
    id integer NOT NULL,
    unidadegerencial_id integer NOT NULL
);


ALTER TABLE public.mapacompetencia OWNER TO postgres;

--
-- Name: mapaestrategico; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mapaestrategico (
    id integer NOT NULL,
    unidadegerencial_id integer NOT NULL,
    visao character varying(500)
);


ALTER TABLE public.mapaestrategico OWNER TO postgres;

--
-- Name: mapanegocio; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mapanegocio (
    id integer NOT NULL,
    unidadegerencial_id integer NOT NULL,
    missao character varying(1500),
    fornecedores character varying(1500),
    insumos character varying(1500),
    negocio character varying(1500),
    pessoal character varying(1500),
    equipamentos character varying(1500),
    produtos character varying(1500),
    clientes character varying(1500),
    produto character varying(200),
    cliente character varying(200),
    descqualidade character varying(200),
    indqualidade character varying(200),
    exprqualidade character varying(200),
    freqqualidade character varying(200),
    metaqualidade character varying(200),
    desccusto character varying(200),
    indcusto character varying(200),
    exprcusto character varying(200),
    freqcusto character varying(200),
    metacusto character varying(200),
    descentrega character varying(200),
    indentrega character varying(200),
    exprentrega character varying(200),
    freqentrega character varying(200),
    metaentrega character varying(200),
    descseguranca character varying(200),
    indseguranca character varying(200),
    exprseguranca character varying(200),
    freqseguranca character varying(200),
    metaseguranca character varying(200)
);


ALTER TABLE public.mapanegocio OWNER TO postgres;

--
-- Name: matrizfcs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE matrizfcs (
    id integer NOT NULL,
    unidadegerencial_id integer NOT NULL,
    objetivomapaestrategico_id integer NOT NULL,
    fatoravaliacao_id integer NOT NULL
);


ALTER TABLE public.matrizfcs OWNER TO postgres;

--
-- Name: matrizfcsfator; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE matrizfcsfator (
    id integer NOT NULL,
    matrizfcs_id integer NOT NULL,
    descfator character varying(100) NOT NULL
);


ALTER TABLE public.matrizfcsfator OWNER TO postgres;

--
-- Name: matrizfcsiniciativa; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE matrizfcsiniciativa (
    id integer NOT NULL,
    matrizfcs_id integer NOT NULL,
    desciniciativa character varying(100) NOT NULL,
    prioritaria boolean NOT NULL
);


ALTER TABLE public.matrizfcsiniciativa OWNER TO postgres;

--
-- Name: matrizfcsiniciativafator; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE matrizfcsiniciativafator (
    id integer NOT NULL,
    matrizfcsiniciativa_id integer NOT NULL,
    matrizfcsfator_id integer NOT NULL,
    itemfatoravaliacao_id integer NOT NULL
);


ALTER TABLE public.matrizfcsiniciativafator OWNER TO postgres;

--
-- Name: mensagem; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mensagem (
    id integer NOT NULL,
    conteudo text NOT NULL,
    datalancamento date NOT NULL,
    visivel boolean NOT NULL
);


ALTER TABLE public.mensagem OWNER TO postgres;

--
-- Name: modeloauditoriagestao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE modeloauditoriagestao (
    id integer NOT NULL,
    nome character varying(100) NOT NULL
);


ALTER TABLE public.modeloauditoriagestao OWNER TO postgres;

--
-- Name: nivelhierarquico; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nivelhierarquico (
    id integer NOT NULL,
    descricao character varying(100) NOT NULL
);


ALTER TABLE public.nivelhierarquico OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: norma; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE norma (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    descricao character varying(1000)
);


ALTER TABLE public.norma OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: objetivoestrategico; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE objetivoestrategico (
    id integer NOT NULL,
    descricao character varying(255) NOT NULL
);


ALTER TABLE public.objetivoestrategico OWNER TO postgres;

--
-- Name: objetivomapaestrategico; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE objetivomapaestrategico (
    id integer NOT NULL,
    perspectivamapaestrategico_id integer NOT NULL,
    objetivoestrategico_id integer NOT NULL
);


ALTER TABLE public.objetivomapaestrategico OWNER TO postgres;

--
-- Name: ocorrencia; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ocorrencia (
    id integer NOT NULL,
    descricao character varying(1800),
    datalancamento date NOT NULL,
    situacao character varying(100),
    unidadegerencial_id integer NOT NULL,
    relator_id integer,
    reincidente boolean,
    contramedidasimediatas character varying(1500),
    numero integer NOT NULL
);


ALTER TABLE public.ocorrencia OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: painelindicadorfiltro; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE painelindicadorfiltro (
    id integer NOT NULL,
    unidadegerencial_id integer NOT NULL,
    objetivomapaestrategico_id integer NOT NULL
);


ALTER TABLE public.painelindicadorfiltro OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: papel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE papel (
    id integer NOT NULL,
    nome character varying(60) NOT NULL,
    administrador boolean NOT NULL
);


ALTER TABLE public.papel OWNER TO postgres;

--
-- Name: parametrossistema; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE parametrossistema (
    id integer NOT NULL,
    diaslembretecriacaometasindicadores integer NOT NULL,
    diaslembretelancamentovaloresreais integer NOT NULL,
    notificarenvolvidosanomalia boolean NOT NULL,
    emailneedauth boolean NOT NULL,
    emailservidorsmtp character varying(100) NOT NULL,
    emailusuariodominio character varying(100),
    emailsenha character varying(64),
    emailremetente character varying(100) NOT NULL,
    diastravtratanomalia integer NOT NULL,
    diaslembtratanomalia integer NOT NULL,
    diasencerramentoanomalia integer NOT NULL,
    imgempresa_id integer,
    imgempresarelatorio_id integer,
    emailportasmtp integer NOT NULL,
    emailservidorusassl boolean,
    urldashboard character varying,
    urlservidor character varying
);


ALTER TABLE public.parametrossistema OWNER TO postgres;

--
-- Name: permissao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE permissao (
    id integer NOT NULL,
    papel_id integer NOT NULL,
    tela_id integer NOT NULL,
    permissionstring character varying(256) NOT NULL
);


ALTER TABLE public.permissao OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: perspectiva; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE perspectiva (
    id integer NOT NULL,
    descricao character varying(100) NOT NULL
);


ALTER TABLE public.perspectiva OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: perspectivamapaestrategico; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE perspectivamapaestrategico (
    id integer NOT NULL,
    mapaestrategico_id integer NOT NULL,
    perspectiva_id integer NOT NULL,
    ordem integer NOT NULL
);


ALTER TABLE public.perspectivamapaestrategico OWNER TO postgres;

--
-- Name: planoacao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE planoacao (
    id integer NOT NULL,
    texto text NOT NULL,
    textocomo text,
    textoporque text,
    textoquem text,
    anomalia_id integer,
    dtplano date,
    status integer,
    dtatualizacaostatus date,
    acaopreventiva_id integer,
    unidadegerencial_id integer,
    iniciativa_id integer,
    usuario_id integer,
    quantop integer,
    quantor integer,
    textocomomedir character varying
);


ALTER TABLE public.planoacao OWNER TO postgres;

--
-- Name: planogestao; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE planogestao (
    id integer NOT NULL,
    descricao text,
    anoexercicio integer NOT NULL,
    limitecriacaometasindicadores date NOT NULL,
    lembretecriacaometasindicadores boolean,
    limitecriacaomapanegocio date NOT NULL,
    limitecriacaomapaestrategico date NOT NULL,
    dtlimlancres1t date NOT NULL,
    dtlimlancres2t date NOT NULL,
    dtlimlancres3t date NOT NULL,
    dtlimlancres4t date NOT NULL,
    dttravlancres1t date NOT NULL,
    dttravlancres2t date NOT NULL,
    dttravlancres3t date NOT NULL,
    dttravlancres4t date NOT NULL,
    limitecriacaomapacompetencia date NOT NULL,
    limitecriacaomatrizfcs date NOT NULL
);


ALTER TABLE public.planogestao OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: requisitonorma; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE requisitonorma (
    id integer NOT NULL,
    descricao character varying(500),
    norma_id integer NOT NULL,
    indice character varying(20) NOT NULL
);


ALTER TABLE public.requisitonorma OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: solicitacaocancelamentoindicador; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE solicitacaocancelamentoindicador (
    id integer NOT NULL,
    status integer NOT NULL,
    indicador_id integer NOT NULL,
    solicitante_id integer,
    justificativasol character varying(500),
    justificativares character varying(500),
    dtsolicitacao date NOT NULL,
    comentario_id integer
);


ALTER TABLE public.solicitacaocancelamentoindicador OWNER TO postgres;

--
-- Name: solicitacaorepactuacaoindicador; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE solicitacaorepactuacaoindicador (
    id integer NOT NULL,
    status integer NOT NULL,
    indicador_id integer NOT NULL,
    solicitante_id integer,
    justificativasol character varying(500),
    justificativares character varying(500),
    dtsolicitacao date NOT NULL,
    comentario_id integer
);


ALTER TABLE public.solicitacaorepactuacaoindicador OWNER TO postgres;

--
-- Name: sq_acaopreventiva; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_acaopreventiva
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_acaopreventiva OWNER TO postgres;

--
-- Name: sq_acaopreventiva; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_acaopreventiva', 1, false);


--
-- Name: sq_acompanhamentoindicador; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_acompanhamentoindicador
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_acompanhamentoindicador OWNER TO postgres;

--
-- Name: sq_acompanhamentoindicador; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_acompanhamentoindicador', 1, false);


--
-- Name: sq_anexoanomalia; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_anexoanomalia
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_anexoanomalia OWNER TO postgres;

--
-- Name: sq_anexoanomalia; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_anexoanomalia', 1, false);


--
-- Name: sq_anexoindicador; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_anexoindicador
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_anexoindicador OWNER TO postgres;

--
-- Name: sq_anexoindicador; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_anexoindicador', 1, false);


--
-- Name: sq_anomalia; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_anomalia
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_anomalia OWNER TO postgres;

--
-- Name: sq_anomalia; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_anomalia', 1, false);


--
-- Name: sq_arquivo; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_arquivo
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_arquivo OWNER TO postgres;

--
-- Name: sq_arquivo; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_arquivo', 1, false);


--
-- Name: sq_atividade; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_atividade
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_atividade OWNER TO postgres;

--
-- Name: sq_atividade; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_atividade', 1, false);


--
-- Name: sq_auditoriagestao; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_auditoriagestao
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_auditoriagestao OWNER TO postgres;

--
-- Name: sq_auditoriagestao; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_auditoriagestao', 1, false);


--
-- Name: sq_auditoriagestaoindicador; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_auditoriagestaoindicador
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_auditoriagestaoindicador OWNER TO postgres;

--
-- Name: sq_auditoriagestaoindicador; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_auditoriagestaoindicador', 1, false);


--
-- Name: sq_auditoriagestaoindicadoritem; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_auditoriagestaoindicadoritem
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_auditoriagestaoindicadoritem OWNER TO postgres;

--
-- Name: sq_auditoriagestaoindicadoritem; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_auditoriagestaoindicadoritem', 1, false);


--
-- Name: sq_auditoriainterna; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_auditoriainterna
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_auditoriainterna OWNER TO postgres;

--
-- Name: sq_auditoriainterna; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_auditoriainterna', 1, false);


--
-- Name: sq_causaefeito; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_causaefeito
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_causaefeito OWNER TO postgres;

--
-- Name: sq_causaefeito; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_causaefeito', 1, false);


--
-- Name: sq_comentario; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_comentario
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_comentario OWNER TO postgres;

--
-- Name: sq_comentario; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_comentario', 1, false);


--
-- Name: sq_comentarioitem; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_comentarioitem
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_comentarioitem OWNER TO postgres;

--
-- Name: sq_comentarioitem; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_comentarioitem', 1, false);


--
-- Name: sq_competencia; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_competencia
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_competencia OWNER TO postgres;

--
-- Name: sq_competencia; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_competencia', 1, false);


--
-- Name: sq_competenciaorganizacional; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_competenciaorganizacional
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_competenciaorganizacional OWNER TO postgres;

--
-- Name: sq_competenciaorganizacional; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_competenciaorganizacional', 1, false);


--
-- Name: sq_emailhistorico; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_emailhistorico
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_emailhistorico OWNER TO postgres;

--
-- Name: sq_emailhistorico; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_emailhistorico', 1, false);


--
-- Name: sq_emailhistoricousuario; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_emailhistoricousuario
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_emailhistoricousuario OWNER TO postgres;

--
-- Name: sq_emailhistoricousuario; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_emailhistoricousuario', 1, false);


--
-- Name: sq_fatoravaliacao; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_fatoravaliacao
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_fatoravaliacao OWNER TO postgres;

--
-- Name: sq_fatoravaliacao; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_fatoravaliacao', 1, false);


--
-- Name: sq_indicador; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_indicador
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_indicador OWNER TO postgres;

--
-- Name: sq_indicador; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_indicador', 1, false);


--
-- Name: sq_indicadoralerta; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_indicadoralerta
    START WITH 50
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_indicadoralerta OWNER TO postgres;

--
-- Name: sq_indicadoralerta; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_indicadoralerta', 50, false);


--
-- Name: sq_indicadorsincronizacaodashboard; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_indicadorsincronizacaodashboard
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_indicadorsincronizacaodashboard OWNER TO postgres;

--
-- Name: sq_indicadorsincronizacaodashboard; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_indicadorsincronizacaodashboard', 1, false);


--
-- Name: sq_iniciativa; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_iniciativa
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_iniciativa OWNER TO postgres;

--
-- Name: sq_iniciativa; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_iniciativa', 1, false);


--
-- Name: sq_itemauditoriainterna; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_itemauditoriainterna
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_itemauditoriainterna OWNER TO postgres;

--
-- Name: sq_itemauditoriainterna; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_itemauditoriainterna', 1, false);


--
-- Name: sq_itemfatoravaliacao; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_itemfatoravaliacao
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_itemfatoravaliacao OWNER TO postgres;

--
-- Name: sq_itemfatoravaliacao; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_itemfatoravaliacao', 1, false);


--
-- Name: sq_itemmodeloauditoriagestao; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_itemmodeloauditoriagestao
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_itemmodeloauditoriagestao OWNER TO postgres;

--
-- Name: sq_itemmodeloauditoriagestao; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_itemmodeloauditoriagestao', 1, false);


--
-- Name: sq_logprocesso; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_logprocesso
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_logprocesso OWNER TO postgres;

--
-- Name: sq_logprocesso; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_logprocesso', 1, false);


--
-- Name: sq_mapacompetencia; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_mapacompetencia
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_mapacompetencia OWNER TO postgres;

--
-- Name: sq_mapacompetencia; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_mapacompetencia', 1, false);


--
-- Name: sq_mapaestrategico; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_mapaestrategico
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_mapaestrategico OWNER TO postgres;

--
-- Name: sq_mapaestrategico; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_mapaestrategico', 1, false);


--
-- Name: sq_mapanegocio; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_mapanegocio
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_mapanegocio OWNER TO postgres;

--
-- Name: sq_mapanegocio; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_mapanegocio', 1, false);


--
-- Name: sq_matrizfcs; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_matrizfcs
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_matrizfcs OWNER TO postgres;

--
-- Name: sq_matrizfcs; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_matrizfcs', 1, false);


--
-- Name: sq_matrizfcsfator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_matrizfcsfator
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_matrizfcsfator OWNER TO postgres;

--
-- Name: sq_matrizfcsfator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_matrizfcsfator', 1, false);


--
-- Name: sq_matrizfcsiniciativa; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_matrizfcsiniciativa
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_matrizfcsiniciativa OWNER TO postgres;

--
-- Name: sq_matrizfcsiniciativa; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_matrizfcsiniciativa', 1, false);


--
-- Name: sq_matrizfcsiniciativafator; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_matrizfcsiniciativafator
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_matrizfcsiniciativafator OWNER TO postgres;

--
-- Name: sq_matrizfcsiniciativafator; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_matrizfcsiniciativafator', 1, false);


--
-- Name: sq_mensagem; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_mensagem
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_mensagem OWNER TO postgres;

--
-- Name: sq_mensagem; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_mensagem', 1, false);


--
-- Name: sq_modeloauditoriagestao; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_modeloauditoriagestao
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_modeloauditoriagestao OWNER TO postgres;

--
-- Name: sq_modeloauditoriagestao; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_modeloauditoriagestao', 1, false);


--
-- Name: sq_nivelhierarquico; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_nivelhierarquico
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_nivelhierarquico OWNER TO postgres;

--
-- Name: sq_nivelhierarquico; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_nivelhierarquico', 1, false);


--
-- Name: sq_norma; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_norma
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_norma OWNER TO postgres;

--
-- Name: sq_norma; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_norma', 1, false);


--
-- Name: sq_objetivoestrategico; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_objetivoestrategico
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_objetivoestrategico OWNER TO postgres;

--
-- Name: sq_objetivoestrategico; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_objetivoestrategico', 1, false);


--
-- Name: sq_objetivomapaestrategico; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_objetivomapaestrategico
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_objetivomapaestrategico OWNER TO postgres;

--
-- Name: sq_objetivomapaestrategico; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_objetivomapaestrategico', 1, false);


--
-- Name: sq_ocorrencia; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_ocorrencia
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_ocorrencia OWNER TO postgres;

--
-- Name: sq_ocorrencia; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_ocorrencia', 1, false);


--
-- Name: sq_painelindicadorfiltro; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_painelindicadorfiltro
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_painelindicadorfiltro OWNER TO postgres;

--
-- Name: sq_painelindicadorfiltro; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_painelindicadorfiltro', 1, false);


--
-- Name: sq_papel; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_papel
    START WITH 3
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_papel OWNER TO postgres;

--
-- Name: sq_papel; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_papel', 3, false);


--
-- Name: sq_parametrossistema; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_parametrossistema
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_parametrossistema OWNER TO postgres;

--
-- Name: sq_parametrossistema; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_parametrossistema', 1, false);


--
-- Name: sq_permissao; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_permissao
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_permissao OWNER TO postgres;

--
-- Name: sq_permissao; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_permissao', 1, false);


--
-- Name: sq_perspectiva; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_perspectiva
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_perspectiva OWNER TO postgres;

--
-- Name: sq_perspectiva; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_perspectiva', 1, false);


--
-- Name: sq_perspectivamapaestrategico; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_perspectivamapaestrategico
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_perspectivamapaestrategico OWNER TO postgres;

--
-- Name: sq_perspectivamapaestrategico; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_perspectivamapaestrategico', 1, false);


--
-- Name: sq_planoacao; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_planoacao
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_planoacao OWNER TO postgres;

--
-- Name: sq_planoacao; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_planoacao', 1, false);


--
-- Name: sq_planogestao; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_planogestao
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_planogestao OWNER TO postgres;

--
-- Name: sq_planogestao; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_planogestao', 1, false);


--
-- Name: sq_requisitonorma; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_requisitonorma
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_requisitonorma OWNER TO postgres;

--
-- Name: sq_requisitonorma; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_requisitonorma', 1, false);


--
-- Name: sq_solicitacaocancelamentoindicador; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_solicitacaocancelamentoindicador
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_solicitacaocancelamentoindicador OWNER TO postgres;

--
-- Name: sq_solicitacaocancelamentoindicador; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_solicitacaocancelamentoindicador', 1, false);


--
-- Name: sq_solicitacaorepactuacaoindicador; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_solicitacaorepactuacaoindicador
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_solicitacaorepactuacaoindicador OWNER TO postgres;

--
-- Name: sq_solicitacaorepactuacaoindicador; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_solicitacaorepactuacaoindicador', 1, false);


--
-- Name: sq_tela; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_tela
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_tela OWNER TO postgres;

--
-- Name: sq_tela; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_tela', 65, true);


--
-- Name: sq_unidadegerencial; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_unidadegerencial
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_unidadegerencial OWNER TO postgres;

--
-- Name: sq_unidadegerencial; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_unidadegerencial', 1, false);


--
-- Name: sq_unidademedida; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_unidademedida
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_unidademedida OWNER TO postgres;

--
-- Name: sq_unidademedida; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_unidademedida', 1, false);


--
-- Name: sq_usuario; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_usuario
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_usuario OWNER TO postgres;

--
-- Name: sq_usuario; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_usuario', 2, true);


--
-- Name: sq_usuarioauditoriainterna; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_usuarioauditoriainterna
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_usuarioauditoriainterna OWNER TO postgres;

--
-- Name: sq_usuarioauditoriainterna; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_usuarioauditoriainterna', 1, false);


--
-- Name: sq_usuariopapel; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_usuariopapel
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_usuariopapel OWNER TO postgres;

--
-- Name: sq_usuariopapel; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_usuariopapel', 2, true);


--
-- Name: sq_usuariounidadegerencial; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sq_usuariounidadegerencial
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sq_usuariounidadegerencial OWNER TO postgres;

--
-- Name: sq_usuariounidadegerencial; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sq_usuariounidadegerencial', 1, false);


--
-- Name: tela; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tela (
    id integer NOT NULL,
    nome character varying(60) NOT NULL,
    path character varying(100) NOT NULL
);


ALTER TABLE public.tela OWNER TO postgres;

--
-- Name: unidadegerencial; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE unidadegerencial (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    sigla character varying(20) NOT NULL,
    subordinacao_id integer,
    planogestao_id integer NOT NULL,
    nivelhierarquico_id integer,
    areaqualidade boolean NOT NULL,
    seqocorrencia integer DEFAULT 1,
    seqanomalia integer DEFAULT 1,
    seqacaopreventiva integer DEFAULT 1,
    permitirmapaestrategico boolean,
    permitirmapanegocio boolean,
    permitirmapacompetencia boolean,
    permitirmatrizfcs boolean,
    nivelnum integer NOT NULL,
    areaauditoriainterna boolean NOT NULL
);


ALTER TABLE public.unidadegerencial OWNER TO postgres;

--
-- Name: unidademedida; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE unidademedida (
    id integer NOT NULL,
    nome character varying(30) NOT NULL,
    sigla character varying(10) NOT NULL
);


ALTER TABLE public.unidademedida OWNER TO postgres;

--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuario (
    id integer NOT NULL,
    nome character varying(60) NOT NULL,
    cargo character varying(60),
    infcomplementar text,
    "login" character varying(50) NOT NULL,
    senha character varying(64) NOT NULL,
    email character varying(50) NOT NULL,
    foto_id integer,
    funcao integer,
    ramal character varying(20),
    bloqueado boolean NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

SET default_with_oids = true;

--
-- Name: usuarioauditoriainterna; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuarioauditoriainterna (
    id integer NOT NULL,
    auditoriainterna_id integer NOT NULL,
    nome character varying(60) NOT NULL,
    tipo integer NOT NULL,
    funcao character varying(50) NOT NULL
);


ALTER TABLE public.usuarioauditoriainterna OWNER TO postgres;

SET default_with_oids = false;

--
-- Name: usuariopapel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuariopapel (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    papel_id integer NOT NULL
);


ALTER TABLE public.usuariopapel OWNER TO postgres;

--
-- Name: usuariounidadegerencial; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usuariounidadegerencial (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    unidadegerencial_id integer NOT NULL,
    funcao integer NOT NULL
);


ALTER TABLE public.usuariounidadegerencial OWNER TO postgres;

--
-- Data for Name: acaopreventiva; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY acaopreventiva (id, sequencial, ugregistro_id, dataabertura, dataencerramento, origem, descricao, observacoes, conclusao, avaleficaciaacao, evidenciaeficaciaacao, tipo, status) FROM stdin;
\.


--
-- Data for Name: acompanhamentoindicador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY acompanhamentoindicador (id, indice, datainicial, datafinal, valorlimitesuperior, valorreal, valorlimiteinferior, valorbaseok, valorrealok, indicador_id, anomalia_id, dtlemblancres, acaopreventiva_id, naoaplicavel) FROM stdin;
\.


--
-- Data for Name: anexoanomalia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY anexoanomalia (id, nome, descricao, arquivo_id, anomalia_id) FROM stdin;
\.


--
-- Data for Name: anexoindicador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY anexoindicador (id, nome, descricao, arquivo_id, indicador_id) FROM stdin;
\.


--
-- Data for Name: anomalia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY anomalia (id, conclusao, dataabertura, dataencerramento, descricao, "local", contramedidasimediatas, ugresponsavel_id, ugregistro_id, sequencial, observacoes, classificacao, responsavel, verificacao, padronizacao, ocorrencia_id, analisecausas, datadestravamento, lembreteenviado, status, statustratamento, tipo, origem, datasolicitacaoencerramento, subordinacao_id, tipoauditoria, itemauditoriainterna_id) FROM stdin;
\.


--
-- Data for Name: arquivo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY arquivo (id, nome, contenttype, size, content, conteudo) FROM stdin;
\.


--
-- Data for Name: atividade; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY atividade (id, mapacompetencia_id, descricao) FROM stdin;
\.


--
-- Data for Name: auditoriagestao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auditoriagestao (id, descricao, unidadegerencial_id, modeloauditoriagestao_id, responsavel, dataauditoria) FROM stdin;
\.


--
-- Data for Name: auditoriagestaoindicador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auditoriagestaoindicador (id, auditoriagestao_id, indicador_id) FROM stdin;
\.


--
-- Data for Name: auditoriagestaoindicadoritem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auditoriagestaoindicadoritem (id, auditoriagestaoindicador_id, itemmodeloauditoriagestao_id, itemfatoravaliacao_id, texto) FROM stdin;
\.


--
-- Data for Name: auditoriainterna; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auditoriainterna (id, ugregistro_id, ugresponsavel_id, dataauditoria, observacoes, norma_id, status, dataencerramento) FROM stdin;
\.


--
-- Data for Name: causaefeito; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY causaefeito (id, descricao, efeito_id, anomalia_id) FROM stdin;
\.


--
-- Data for Name: comentario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY comentario (id) FROM stdin;
\.


--
-- Data for Name: comentarioitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY comentarioitem (id, comentario_id, usuario_id, texto, data) FROM stdin;
\.


--
-- Data for Name: competencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY competencia (id, mapacompetencia_id, competenciaorganizacional_id) FROM stdin;
\.


--
-- Data for Name: competenciaorganizacional; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY competenciaorganizacional (id, nome, descricao) FROM stdin;
\.


--
-- Data for Name: emailhistorico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY emailhistorico (id, remetente, assunto, mensagem, data) FROM stdin;
\.


--
-- Data for Name: emailhistoricousuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY emailhistoricousuario (id, emailhistorico_id, usuarioemail, tipousuarioemail) FROM stdin;
\.


--
-- Data for Name: fatoravaliacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fatoravaliacao (id, nome, utilizarmatrizfcs) FROM stdin;
\.


--
-- Data for Name: indicador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY indicador (id, nome, descricao, peso, precisao, tolerancia, frequencia, melhor, unidademedida_id, status, responsavel, relevancia, frequenciaacompanhamento, mecanismocontrole, fontedados, formulacalculo, unidadegerencial_id, objetivomapaestrategico_id) FROM stdin;
\.


--
-- Data for Name: indicadoralerta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY indicadoralerta (id, idacompanhamentoindicador, idalerta, idindicador) FROM stdin;
\.


--
-- Data for Name: indicadorsincronizacaodashboard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY indicadorsincronizacaodashboard (idindicador, dtsincronizacao, codigoerro, mensagemerro, criar, deletar) FROM stdin;
\.


--
-- Data for Name: iniciativa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY iniciativa (id, unidadegerencial_id, objetivomapaestrategico_id, descricao) FROM stdin;
\.


--
-- Data for Name: itemauditoriainterna; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY itemauditoriainterna (id, auditoriainterna_id, requisitonorma_id, descricao, ugexterna_id) FROM stdin;
\.


--
-- Data for Name: itemfatoravaliacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY itemfatoravaliacao (id, fatoravaliacao_id, valor, descricao) FROM stdin;
\.


--
-- Data for Name: itemmodeloauditoriagestao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY itemmodeloauditoriagestao (id, modeloauditoriagestao_id, nome, descricao, fatoravaliacao_id, ordem) FROM stdin;
\.


--
-- Data for Name: logprocesso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY logprocesso (id, dtlemblancresultado, dtatualizastatusanomalia, dtlembtratanomalia, dtlembcriacaoindicador, dtatualizalancamentoresultados) FROM stdin;
1	\N	\N	\N	\N	\N
\.


--
-- Data for Name: mapacompetencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY mapacompetencia (id, unidadegerencial_id) FROM stdin;
\.


--
-- Data for Name: mapaestrategico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY mapaestrategico (id, unidadegerencial_id, visao) FROM stdin;
\.


--
-- Data for Name: mapanegocio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY mapanegocio (id, unidadegerencial_id, missao, fornecedores, insumos, negocio, pessoal, equipamentos, produtos, clientes, produto, cliente, descqualidade, indqualidade, exprqualidade, freqqualidade, metaqualidade, desccusto, indcusto, exprcusto, freqcusto, metacusto, descentrega, indentrega, exprentrega, freqentrega, metaentrega, descseguranca, indseguranca, exprseguranca, freqseguranca, metaseguranca) FROM stdin;
\.


--
-- Data for Name: matrizfcs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY matrizfcs (id, unidadegerencial_id, objetivomapaestrategico_id, fatoravaliacao_id) FROM stdin;
\.


--
-- Data for Name: matrizfcsfator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY matrizfcsfator (id, matrizfcs_id, descfator) FROM stdin;
\.


--
-- Data for Name: matrizfcsiniciativa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY matrizfcsiniciativa (id, matrizfcs_id, desciniciativa, prioritaria) FROM stdin;
\.


--
-- Data for Name: matrizfcsiniciativafator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY matrizfcsiniciativafator (id, matrizfcsiniciativa_id, matrizfcsfator_id, itemfatoravaliacao_id) FROM stdin;
\.


--
-- Data for Name: mensagem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY mensagem (id, conteudo, datalancamento, visivel) FROM stdin;
\.


--
-- Data for Name: modeloauditoriagestao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY modeloauditoriagestao (id, nome) FROM stdin;
\.


--
-- Data for Name: nivelhierarquico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nivelhierarquico (id, descricao) FROM stdin;
\.


--
-- Data for Name: norma; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY norma (id, nome, descricao) FROM stdin;
\.


--
-- Data for Name: objetivoestrategico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY objetivoestrategico (id, descricao) FROM stdin;
\.


--
-- Data for Name: objetivomapaestrategico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY objetivomapaestrategico (id, perspectivamapaestrategico_id, objetivoestrategico_id) FROM stdin;
\.


--
-- Data for Name: ocorrencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ocorrencia (id, descricao, datalancamento, situacao, unidadegerencial_id, relator_id, reincidente, contramedidasimediatas, numero) FROM stdin;
\.


--
-- Data for Name: painelindicadorfiltro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY painelindicadorfiltro (id, unidadegerencial_id, objetivomapaestrategico_id) FROM stdin;
\.


--
-- Data for Name: papel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY papel (id, nome, administrador) FROM stdin;
1	Administrador	t
2	Usuário	f
\.


--
-- Data for Name: parametrossistema; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY parametrossistema (id, diaslembretecriacaometasindicadores, diaslembretelancamentovaloresreais, notificarenvolvidosanomalia, emailneedauth, emailservidorsmtp, emailusuariodominio, emailsenha, emailremetente, diastravtratanomalia, diaslembtratanomalia, diasencerramentoanomalia, imgempresa_id, imgempresarelatorio_id, emailportasmtp, emailservidorusassl, urldashboard, urlservidor) FROM stdin;
1	10	15	f	f	smtp			geplanes@suaempresa.com.br	15	5	15	\N	\N	25	f	http://localhost:8080/dashboard/rest	http://localhost:8080/geplanes_bsc/rest
\.


--
-- Data for Name: permissao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY permissao (id, papel_id, tela_id, permissionstring) FROM stdin;
\.


--
-- Data for Name: perspectiva; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY perspectiva (id, descricao) FROM stdin;
\.


--
-- Data for Name: perspectivamapaestrategico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY perspectivamapaestrategico (id, mapaestrategico_id, perspectiva_id, ordem) FROM stdin;
\.


--
-- Data for Name: planoacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY planoacao (id, texto, textocomo, textoporque, textoquem, anomalia_id, dtplano, status, dtatualizacaostatus, acaopreventiva_id, unidadegerencial_id, iniciativa_id, usuario_id, quantop, quantor, textocomomedir) FROM stdin;
\.


--
-- Data for Name: planogestao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY planogestao (id, descricao, anoexercicio, limitecriacaometasindicadores, lembretecriacaometasindicadores, limitecriacaomapanegocio, limitecriacaomapaestrategico, dtlimlancres1t, dtlimlancres2t, dtlimlancres3t, dtlimlancres4t, dttravlancres1t, dttravlancres2t, dttravlancres3t, dttravlancres4t, limitecriacaomapacompetencia, limitecriacaomatrizfcs) FROM stdin;
\.


--
-- Data for Name: requisitonorma; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requisitonorma (id, descricao, norma_id, indice) FROM stdin;
\.


--
-- Data for Name: solicitacaocancelamentoindicador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY solicitacaocancelamentoindicador (id, status, indicador_id, solicitante_id, justificativasol, justificativares, dtsolicitacao, comentario_id) FROM stdin;
\.


--
-- Data for Name: solicitacaorepactuacaoindicador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY solicitacaorepactuacaoindicador (id, status, indicador_id, solicitante_id, justificativasol, justificativares, dtsolicitacao, comentario_id) FROM stdin;
\.


--
-- Data for Name: tela; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tela (id, nome, path) FROM stdin;
55	Anomalia	/sgm/report/Anomalia
1	Cadastrar perspectivas	/sgm/crud/Perspectiva
2	Cadastrar objetivos estratégicos	/sgm/crud/ObjetivoEstrategico
3	Competência organizacional	/sgm/crud/CompetenciaOrganizacional
4	Sistema de pontuação	/sgm/crud/FatorAvaliacao
5	Unidades de medida	/sgm/crud/UnidadeMedida
6	Ano da gestão	/sgm/crud/PlanoGestao
7	Unidades gerenciais	/sgm/crud/UnidadeGerencial
25	Alcance de metas institucionais	/sgm/report/AlcanceMetaInstitucional
8	Painel de indicadores	/sgm/process/DistribuicaoPesosIndicadores
9	Definição do negócio	/sgm/process/DefinicaoNegocio
26	Auditoria de gestão	/sgm/report/AuditoriaGestao
10	Elaborar mapa estratégico	/sgm/process/DefinicaoEstrategia
11	Definição de competências	/sgm/process/DefinicaoCompetencia
12	Definição de prioridades	/sgm/process/DefinicaoPrioridade
13	Modelo de auditoria	/sgm/crud/ModeloAuditoriaGestao
14	Realizar auditoria	/sgm/crud/AuditoriaGestao
15	Matriz de iniciativas x FCS	/sgm/process/MatrizFCS
16	Lançamento de resultados	/sgm/process/LancamentoValorReal
17	Diário de bordo	/sgm/crud/Ocorrencia
19	Solicitação de cancelamento do indicador	/sgm/process/SolicitacaoCancelamentoIndicador
20	Solicitação de repactuação do indicador	/sgm/process/SolicitacaoRepactuacaoIndicador
27	Matriz de iniciativas x FCS	/sgm/report/MatrizFCS
22	Apresentação de resultados	/sgm/process/ApresentacaoResultados
21	Painel de controle / gestão à vista	/sgm/process/PainelControle
23	Listagem de indicadores por objetivo estratégico	/sgm/report/IndicadoresEstrategico
24	Listagem de indicadores por tipo de indicador	/sgm/report/IndicadoresTipoIndicador
28	Mapa do negócio	/sgm/report/MapaNegocio
29	Mapa estratégico	/sgm/report/MapaEstrategico
30	Mapa de competências	/sgm/report/MapaCompetencia
31	Mapa de prioridades	/sgm/report/MapaPrioridade
32	Pendência no cadastro	/sgm/report/PendenciaCadastro
33	Pendência no cadastro de anomalia	/sgm/report/PendenciaAnomalia
34	Anomalias	/sgm/report/AnomaliaListagem
35	Sintético de anomalias por status	/sgm/report/AnomaliaSinteticoPorStatus
37	Quadro de gestão	/sgm/report/QuadroGestao
38	Planos de ação das iniciativas	/sgm/report/IniciativaPlanoAcao
39	Alterar senha	/sgm/process/AlterarSenha
41	Nível de acesso	/sgm/crud/Papel
42	Usuário	/sgm/crud/Usuario
46	Mensagens	/sgm/crud/Mensagem
45	Histórico de e-mail enviado	/sgm/crud/EmailHistorico
47	Parâmetros	/sgm/crud/ParametrosSistema
48	Sobre a LinkCom	/sgm/process/SobreLinkCom
49	Processos de notificação / atualização	/sgm/process/LogProcesso
52	Valores a serem alcançados	/sgm/process/LancamentoValorBase
53	Ações preventivas	/sgm/report/AcaoPreventiva
54	Diagrama de espinha de peixe - Anomalia	/sgm/report/AnomaliaDiagrama
56	Apresentação de resultados	/sgm/report/ApresentacaoResultados
57	Diário de bordo	/sgm/report/DiarioBordo
58	Ações preventivas	/sgm/crud/AcaoPreventiva
59	Planos de ação das iniciativas	/sgm/process/IniciativaPlanoAcao
60	Executar planos de ação	/sgm/process/ExecutarIniciativaPlanoAcao
18	Tratamento de anomalias	/sgm/crud/Anomalia
36	Desempenho	/sgm/report/Desempenho
50	Cópia de indicador	/util/crud/Indicador
51	Seleção de usuários para envio de e-mail	/util/crud/Usuario
44	Envio de e-mail	/sgm/process/EnvioEmail
61	Nível hierárquico	/sgm/crud/NivelHierarquico
62	Sobre o Geplanes	/sgm/process/SobreGeplanes
63	Normas	/sgm/crud/Norma
64	Auditoria interna	/sgm/crud/AuditoriaInterna
65	Auditoria interna	/sgm/report/AuditoriaInterna
\.


--
-- Data for Name: unidadegerencial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY unidadegerencial (id, nome, sigla, subordinacao_id, planogestao_id, nivelhierarquico_id, areaqualidade, seqocorrencia, seqanomalia, seqacaopreventiva, permitirmapaestrategico, permitirmapanegocio, permitirmapacompetencia, permitirmatrizfcs, nivelnum, areaauditoriainterna) FROM stdin;
\.


--
-- Data for Name: unidademedida; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY unidademedida (id, nome, sigla) FROM stdin;
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuario (id, nome, cargo, infcomplementar, "login", senha, email, foto_id, funcao, ramal, bloqueado) FROM stdin;
1	Administrador do Geplanes			admin	$2a$12$lmklEIOeVPl6ENm5.V03nO6Lznk85aUGxmnouPjOImn7XZwUbahQa	geplanes@suaempresa.com.br	\N	\N		f
\.


--
-- Data for Name: usuarioauditoriainterna; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuarioauditoriainterna (id, auditoriainterna_id, nome, tipo, funcao) FROM stdin;
\.


--
-- Data for Name: usuariopapel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuariopapel (id, usuario_id, papel_id) FROM stdin;
2	1	1
\.


--
-- Data for Name: usuariounidadegerencial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY usuariounidadegerencial (id, usuario_id, unidadegerencial_id, funcao) FROM stdin;
\.


--
-- Name: Iniciativa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY iniciativa
    ADD CONSTRAINT "Iniciativa_pkey" PRIMARY KEY (id);


--
-- Name: acaopreventiva_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acaopreventiva
    ADD CONSTRAINT acaopreventiva_pkey PRIMARY KEY (id);


--
-- Name: acompanhamentoindicador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acompanhamentoindicador
    ADD CONSTRAINT acompanhamentoindicador_pkey PRIMARY KEY (id);


--
-- Name: anexoanomalia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY anexoanomalia
    ADD CONSTRAINT anexoanomalia_pkey PRIMARY KEY (id);


--
-- Name: anexoindicador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY anexoindicador
    ADD CONSTRAINT anexoindicador_pkey PRIMARY KEY (id);


--
-- Name: anomalia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY anomalia
    ADD CONSTRAINT anomalia_pkey PRIMARY KEY (id);


--
-- Name: arquivo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY arquivo
    ADD CONSTRAINT arquivo_pkey PRIMARY KEY (id);


--
-- Name: auditoriagestao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auditoriagestao
    ADD CONSTRAINT auditoriagestao_pkey PRIMARY KEY (id);


--
-- Name: auditoriagestaoindicador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auditoriagestaoindicador
    ADD CONSTRAINT auditoriagestaoindicador_pkey PRIMARY KEY (id);


--
-- Name: auditoriagestaoindicadoritem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auditoriagestaoindicadoritem
    ADD CONSTRAINT auditoriagestaoindicadoritem_pkey PRIMARY KEY (id);


--
-- Name: auditoriainterna_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auditoriainterna
    ADD CONSTRAINT auditoriainterna_pkey PRIMARY KEY (id);


--
-- Name: causaefeito_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY causaefeito
    ADD CONSTRAINT causaefeito_pkey PRIMARY KEY (id);


--
-- Name: comentario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comentario
    ADD CONSTRAINT comentario_pkey PRIMARY KEY (id);


--
-- Name: comentarioitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comentarioitem
    ADD CONSTRAINT comentarioitem_pkey PRIMARY KEY (id);


--
-- Name: competencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY competencia
    ADD CONSTRAINT competencia_pkey PRIMARY KEY (id);


--
-- Name: competenciaorganizacional_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY competenciaorganizacional
    ADD CONSTRAINT competenciaorganizacional_pkey PRIMARY KEY (id);


--
-- Name: emailhistorico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY emailhistorico
    ADD CONSTRAINT emailhistorico_pkey PRIMARY KEY (id);


--
-- Name: emailhistoricousuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY emailhistoricousuario
    ADD CONSTRAINT emailhistoricousuario_pkey PRIMARY KEY (id);


--
-- Name: estrategia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY objetivoestrategico
    ADD CONSTRAINT estrategia_pkey PRIMARY KEY (id);


--
-- Name: estrategiablocoestrategico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY objetivomapaestrategico
    ADD CONSTRAINT estrategiablocoestrategico_pkey PRIMARY KEY (id);


--
-- Name: fatoravaliacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fatoravaliacao
    ADD CONSTRAINT fatoravaliacao_pkey PRIMARY KEY (id);


--
-- Name: idx_acompanhamentoindicador; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY acompanhamentoindicador
    ADD CONSTRAINT idx_acompanhamentoindicador UNIQUE (indicador_id, indice, datainicial, datafinal);


--
-- Name: idx_unidadegerencial_1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unidadegerencial
    ADD CONSTRAINT idx_unidadegerencial_1 UNIQUE (nome, planogestao_id);


--
-- Name: indicador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY indicador
    ADD CONSTRAINT indicador_pkey PRIMARY KEY (id);


--
-- Name: indicadoralerta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY indicadoralerta
    ADD CONSTRAINT indicadoralerta_pkey PRIMARY KEY (id);


--
-- Name: indicadorsincronizacaodashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY indicadorsincronizacaodashboard
    ADD CONSTRAINT indicadorsincronizacaodashboard_pkey PRIMARY KEY (idindicador);


--
-- Name: itemauditoriainterna_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY itemauditoriainterna
    ADD CONSTRAINT itemauditoriainterna_pkey PRIMARY KEY (id);


--
-- Name: itemfatoravaliacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY itemfatoravaliacao
    ADD CONSTRAINT itemfatoravaliacao_pkey PRIMARY KEY (id);


--
-- Name: itemmodeloauditoriagestao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY itemmodeloauditoriagestao
    ADD CONSTRAINT itemmodeloauditoriagestao_pkey PRIMARY KEY (id);


--
-- Name: logprocesso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY logprocesso
    ADD CONSTRAINT logprocesso_pkey PRIMARY KEY (id);


--
-- Name: mapacompetencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mapacompetencia
    ADD CONSTRAINT mapacompetencia_pkey PRIMARY KEY (id);


--
-- Name: mapaestrategico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mapaestrategico
    ADD CONSTRAINT mapaestrategico_pkey PRIMARY KEY (id);


--
-- Name: mapanegocio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mapanegocio
    ADD CONSTRAINT mapanegocio_pkey PRIMARY KEY (id);


--
-- Name: mensagem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mensagem
    ADD CONSTRAINT mensagem_pkey PRIMARY KEY (id);


--
-- Name: modeloauditoriagestao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY modeloauditoriagestao
    ADD CONSTRAINT modeloauditoriagestao_pkey PRIMARY KEY (id);


--
-- Name: norma_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY norma
    ADD CONSTRAINT norma_pkey PRIMARY KEY (id);


--
-- Name: ocorrencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ocorrencia
    ADD CONSTRAINT ocorrencia_pkey PRIMARY KEY (id);


--
-- Name: painelindicadorfiltro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY painelindicadorfiltro
    ADD CONSTRAINT painelindicadorfiltro_pkey PRIMARY KEY (id);


--
-- Name: papel_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY papel
    ADD CONSTRAINT papel_nome_key UNIQUE (nome);


--
-- Name: papel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY papel
    ADD CONSTRAINT papel_pkey PRIMARY KEY (id);


--
-- Name: parametrossistema_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY parametrossistema
    ADD CONSTRAINT parametrossistema_pkey PRIMARY KEY (id);


--
-- Name: permissao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY permissao
    ADD CONSTRAINT permissao_pkey PRIMARY KEY (id);


--
-- Name: perspectiva_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY perspectivamapaestrategico
    ADD CONSTRAINT perspectiva_pkey PRIMARY KEY (id);


--
-- Name: perspectiva_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY perspectiva
    ADD CONSTRAINT perspectiva_pkey1 PRIMARY KEY (id);


--
-- Name: pk_matrizfcs; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY matrizfcs
    ADD CONSTRAINT pk_matrizfcs PRIMARY KEY (id);


--
-- Name: pk_matrizfcsfator; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY matrizfcsfator
    ADD CONSTRAINT pk_matrizfcsfator PRIMARY KEY (id);


--
-- Name: pk_matrizfcsiniciativa; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY matrizfcsiniciativa
    ADD CONSTRAINT pk_matrizfcsiniciativa PRIMARY KEY (id);


--
-- Name: pk_matrizfcsiniciativafator; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY matrizfcsiniciativafator
    ADD CONSTRAINT pk_matrizfcsiniciativafator PRIMARY KEY (id);


--
-- Name: pk_nivelhierarquico; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nivelhierarquico
    ADD CONSTRAINT pk_nivelhierarquico PRIMARY KEY (id);


--
-- Name: planoacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY planoacao
    ADD CONSTRAINT planoacao_pkey PRIMARY KEY (id);


--
-- Name: planogestao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY planogestao
    ADD CONSTRAINT planogestao_pkey PRIMARY KEY (id);


--
-- Name: requisitonorma_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY requisitonorma
    ADD CONSTRAINT requisitonorma_pkey PRIMARY KEY (id);


--
-- Name: solicitacaocancelamentoindicador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY solicitacaocancelamentoindicador
    ADD CONSTRAINT solicitacaocancelamentoindicador_pkey PRIMARY KEY (id);


--
-- Name: solicitacaorepactuacaoindicador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY solicitacaorepactuacaoindicador
    ADD CONSTRAINT solicitacaorepactuacaoindicador_pkey PRIMARY KEY (id);


--
-- Name: tela_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tela
    ADD CONSTRAINT tela_pkey PRIMARY KEY (id);


--
-- Name: uk_matrizfcs; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY matrizfcs
    ADD CONSTRAINT uk_matrizfcs UNIQUE (unidadegerencial_id, objetivomapaestrategico_id);


--
-- Name: unidadegerencial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unidadegerencial
    ADD CONSTRAINT unidadegerencial_pkey PRIMARY KEY (id);


--
-- Name: unidademedida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unidademedida
    ADD CONSTRAINT unidademedida_pkey PRIMARY KEY (id);


--
-- Name: usuario_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_login_key UNIQUE ("login");


--
-- Name: usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- Name: usuarioauditoriainterna_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuarioauditoriainterna
    ADD CONSTRAINT usuarioauditoriainterna_pkey PRIMARY KEY (id);


--
-- Name: usuariopapel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuariopapel
    ADD CONSTRAINT usuariopapel_pkey PRIMARY KEY (id);


--
-- Name: usuariounidadegerencial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usuariounidadegerencial
    ADD CONSTRAINT usuariounidadegerencial_pkey PRIMARY KEY (id);


--
-- Name: idx_FK_objetivomapaestrategico_objetivoestrategico; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "idx_FK_objetivomapaestrategico_objetivoestrategico" ON objetivomapaestrategico USING btree (objetivoestrategico_id);


--
-- Name: idx_FK_objetivomapaestrategico_perspectiva; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "idx_FK_objetivomapaestrategico_perspectiva" ON objetivomapaestrategico USING btree (perspectivamapaestrategico_id);


--
-- Name: idx_anomalia_ugregistro; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_anomalia_ugregistro ON anomalia USING btree (ugregistro_id);


--
-- Name: idx_fk__soliccancind_indicador; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk__soliccancind_indicador ON solicitacaocancelamentoindicador USING btree (indicador_id);


--
-- Name: idx_fk_acaopreventiva_ugregistro; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_acaopreventiva_ugregistro ON acaopreventiva USING btree (ugregistro_id);


--
-- Name: idx_fk_acompanhamentoindicador_1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_acompanhamentoindicador_1 ON acompanhamentoindicador USING btree (anomalia_id);


--
-- Name: idx_fk_acompanhamentoindicador_2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_acompanhamentoindicador_2 ON acompanhamentoindicador USING btree (indicador_id);


--
-- Name: idx_fk_acompanhamentoindicador_acaopreventiva; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_acompanhamentoindicador_acaopreventiva ON acompanhamentoindicador USING btree (acaopreventiva_id);


--
-- Name: idx_fk_anexoanomalia_anomalia; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_anexoanomalia_anomalia ON anexoanomalia USING btree (anomalia_id);


--
-- Name: idx_fk_anexoanomalia_arquivo; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_anexoanomalia_arquivo ON anexoanomalia USING btree (arquivo_id);


--
-- Name: idx_fk_anexoindicador_arquivo; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_anexoindicador_arquivo ON anexoindicador USING btree (arquivo_id);


--
-- Name: idx_fk_anexoindicador_indicador; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_anexoindicador_indicador ON anexoindicador USING btree (indicador_id);


--
-- Name: idx_fk_anomalia_itemauditoriainterna; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_anomalia_itemauditoriainterna ON anomalia USING btree (itemauditoriainterna_id);


--
-- Name: idx_fk_anomalia_ocorrencia; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_anomalia_ocorrencia ON anomalia USING btree (ocorrencia_id);


--
-- Name: idx_fk_anomalia_subordinacao; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_anomalia_subordinacao ON anomalia USING btree (subordinacao_id);


--
-- Name: idx_fk_anomalia_ugresponsavel; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_anomalia_ugresponsavel ON anomalia USING btree (ugresponsavel_id);


--
-- Name: idx_fk_atividade_mapacompetencia; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_atividade_mapacompetencia ON atividade USING btree (mapacompetencia_id);


--
-- Name: idx_fk_auditoriagestao_modeloauditoriagestao; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_auditoriagestao_modeloauditoriagestao ON auditoriagestao USING btree (modeloauditoriagestao_id);


--
-- Name: idx_fk_auditoriagestao_unidadegerencial; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_auditoriagestao_unidadegerencial ON auditoriagestao USING btree (unidadegerencial_id);


--
-- Name: idx_fk_auditoriagestaoindicador_auditoriagestao; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_auditoriagestaoindicador_auditoriagestao ON auditoriagestaoindicador USING btree (auditoriagestao_id);


--
-- Name: idx_fk_auditoriagestaoindicador_indicador; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_auditoriagestaoindicador_indicador ON auditoriagestaoindicador USING btree (indicador_id);


--
-- Name: idx_fk_auditoriagestaoindicadoritem_auditoriagestaoindicador; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_auditoriagestaoindicadoritem_auditoriagestaoindicador ON auditoriagestaoindicadoritem USING btree (auditoriagestaoindicador_id);


--
-- Name: idx_fk_auditoriagestaoindicadoritem_itemfatoravaliacao; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_auditoriagestaoindicadoritem_itemfatoravaliacao ON auditoriagestaoindicadoritem USING btree (itemfatoravaliacao_id);


--
-- Name: idx_fk_auditoriagestaoindicadoritem_itemmodeloauditoriagestao; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_auditoriagestaoindicadoritem_itemmodeloauditoriagestao ON auditoriagestaoindicadoritem USING btree (itemmodeloauditoriagestao_id);


--
-- Name: idx_fk_auditoriainterna_norma; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_auditoriainterna_norma ON auditoriainterna USING btree (norma_id);


--
-- Name: idx_fk_auditoriainterna_ugregistro; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_auditoriainterna_ugregistro ON auditoriainterna USING btree (ugregistro_id);


--
-- Name: idx_fk_auditoriainterna_ugresponsavel; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_auditoriainterna_ugresponsavel ON auditoriainterna USING btree (ugresponsavel_id);


--
-- Name: idx_fk_causaefeito_anomalia; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_causaefeito_anomalia ON causaefeito USING btree (anomalia_id);


--
-- Name: idx_fk_causaefeito_efeito; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_causaefeito_efeito ON causaefeito USING btree (efeito_id);


--
-- Name: idx_fk_comentarioitem_comentario; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_comentarioitem_comentario ON comentarioitem USING btree (comentario_id);


--
-- Name: idx_fk_comentarioitem_usuario; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_comentarioitem_usuario ON comentarioitem USING btree (usuario_id);


--
-- Name: idx_fk_competencia_competenciaorganizacional; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_competencia_competenciaorganizacional ON competencia USING btree (competenciaorganizacional_id);


--
-- Name: idx_fk_competencia_mapacompetencia; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_competencia_mapacompetencia ON competencia USING btree (mapacompetencia_id);


--
-- Name: idx_fk_emailhistoricousuario_emailhistorico; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_emailhistoricousuario_emailhistorico ON emailhistoricousuario USING btree (emailhistorico_id);


--
-- Name: idx_fk_indicador_objetivomapaestrategico; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_indicador_objetivomapaestrategico ON indicador USING btree (objetivomapaestrategico_id);


--
-- Name: idx_fk_indicador_unidadegerencial; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_indicador_unidadegerencial ON indicador USING btree (unidadegerencial_id);


--
-- Name: idx_fk_indicador_unidademedida; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_indicador_unidademedida ON indicador USING btree (unidademedida_id);


--
-- Name: idx_fk_iniciativa_objetivomapaestrategico; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_iniciativa_objetivomapaestrategico ON iniciativa USING btree (objetivomapaestrategico_id);


--
-- Name: idx_fk_iniciativa_unidadegerencial; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_iniciativa_unidadegerencial ON iniciativa USING btree (unidadegerencial_id);


--
-- Name: idx_fk_itemauditoriainterna_auditoriainterna; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_itemauditoriainterna_auditoriainterna ON itemauditoriainterna USING btree (auditoriainterna_id);


--
-- Name: idx_fk_itemauditoriainterna_requisitonorma; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_itemauditoriainterna_requisitonorma ON itemauditoriainterna USING btree (requisitonorma_id);


--
-- Name: idx_fk_itemauditoriainterna_ugexterna; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_itemauditoriainterna_ugexterna ON itemauditoriainterna USING btree (ugexterna_id);


--
-- Name: idx_fk_itemfatoravaliacao_fatoravaliacao; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_itemfatoravaliacao_fatoravaliacao ON itemfatoravaliacao USING btree (fatoravaliacao_id);


--
-- Name: idx_fk_itemmodeloauditoriagestao_fatoravaliacao; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_itemmodeloauditoriagestao_fatoravaliacao ON itemmodeloauditoriagestao USING btree (fatoravaliacao_id);


--
-- Name: idx_fk_itemmodeloauditoriagestao_modeloauditoriagestao; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_itemmodeloauditoriagestao_modeloauditoriagestao ON itemmodeloauditoriagestao USING btree (modeloauditoriagestao_id);


--
-- Name: idx_fk_mapacompetencia_unidadegerencial; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_mapacompetencia_unidadegerencial ON mapacompetencia USING btree (unidadegerencial_id);


--
-- Name: idx_fk_mapaestrategico_unidadegerencial; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_mapaestrategico_unidadegerencial ON mapaestrategico USING btree (unidadegerencial_id);


--
-- Name: idx_fk_mapanegocio_unidadegerencial; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_mapanegocio_unidadegerencial ON mapanegocio USING btree (unidadegerencial_id);


--
-- Name: idx_fk_matrizfcs_fatoravaliacao; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_matrizfcs_fatoravaliacao ON matrizfcs USING btree (fatoravaliacao_id);


--
-- Name: idx_fk_matrizfcs_objetivomapaestrategico; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_matrizfcs_objetivomapaestrategico ON matrizfcs USING btree (objetivomapaestrategico_id);


--
-- Name: idx_fk_matrizfcs_ug; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_matrizfcs_ug ON matrizfcs USING btree (unidadegerencial_id);


--
-- Name: idx_fk_matrizfcsfator_matrizfcs; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_matrizfcsfator_matrizfcs ON matrizfcsfator USING btree (matrizfcs_id);


--
-- Name: idx_fk_matrizfcsinicfator_itemfatorav; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_matrizfcsinicfator_itemfatorav ON matrizfcsiniciativafator USING btree (itemfatoravaliacao_id);


--
-- Name: idx_fk_matrizfcsinicfator_matrizfcsfator; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_matrizfcsinicfator_matrizfcsfator ON matrizfcsiniciativafator USING btree (matrizfcsfator_id);


--
-- Name: idx_fk_matrizfcsinicfator_matrizfcsinic; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_matrizfcsinicfator_matrizfcsinic ON matrizfcsiniciativafator USING btree (matrizfcsiniciativa_id);


--
-- Name: idx_fk_matrizfcsiniciativa_matrizfcs; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_matrizfcsiniciativa_matrizfcs ON matrizfcsiniciativa USING btree (matrizfcs_id);


--
-- Name: idx_fk_ocorrencia_unidadegerencial; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_ocorrencia_unidadegerencial ON ocorrencia USING btree (unidadegerencial_id);


--
-- Name: idx_fk_ocorrencia_usuario; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_ocorrencia_usuario ON ocorrencia USING btree (relator_id);


--
-- Name: idx_fk_painelindicadorfiltro_objetivomapaestrategico; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_painelindicadorfiltro_objetivomapaestrategico ON painelindicadorfiltro USING btree (objetivomapaestrategico_id);


--
-- Name: idx_fk_painelindicadorfiltro_unidadegerencial; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_painelindicadorfiltro_unidadegerencial ON painelindicadorfiltro USING btree (unidadegerencial_id);


--
-- Name: idx_fk_parametrossistema_arquivo1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_parametrossistema_arquivo1 ON parametrossistema USING btree (imgempresa_id);


--
-- Name: idx_fk_parametrossistema_arquivo2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_parametrossistema_arquivo2 ON parametrossistema USING btree (imgempresarelatorio_id);


--
-- Name: idx_fk_permissao_papel; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_permissao_papel ON permissao USING btree (papel_id);


--
-- Name: idx_fk_permissao_tela; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_permissao_tela ON permissao USING btree (tela_id);


--
-- Name: idx_fk_perspectivamapaestrategico_mapaestrategico; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_perspectivamapaestrategico_mapaestrategico ON perspectivamapaestrategico USING btree (mapaestrategico_id);


--
-- Name: idx_fk_perspectivamapaestrategico_perspectiva; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_perspectivamapaestrategico_perspectiva ON perspectivamapaestrategico USING btree (perspectiva_id);


--
-- Name: idx_fk_planoacao_acaopreventiva; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_planoacao_acaopreventiva ON planoacao USING btree (acaopreventiva_id);


--
-- Name: idx_fk_planoacao_anomalia; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_planoacao_anomalia ON planoacao USING btree (anomalia_id);


--
-- Name: idx_fk_planoacao_iniciativa; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_planoacao_iniciativa ON planoacao USING btree (iniciativa_id);


--
-- Name: idx_fk_planoacao_unidadegerencial; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_planoacao_unidadegerencial ON planoacao USING btree (unidadegerencial_id);


--
-- Name: idx_fk_planoacao_usuario; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_planoacao_usuario ON planoacao USING btree (usuario_id);


--
-- Name: idx_fk_requisitonorma_norma; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_requisitonorma_norma ON requisitonorma USING btree (norma_id);


--
-- Name: idx_fk_sci_comentario; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_sci_comentario ON solicitacaocancelamentoindicador USING btree (comentario_id);


--
-- Name: idx_fk_solicitacaocancelamentoindicador_1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_solicitacaocancelamentoindicador_1 ON solicitacaocancelamentoindicador USING btree (solicitante_id);


--
-- Name: idx_fk_sri_comentario; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_sri_comentario ON solicitacaorepactuacaoindicador USING btree (comentario_id);


--
-- Name: idx_fk_sri_indicador; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_sri_indicador ON solicitacaorepactuacaoindicador USING btree (indicador_id);


--
-- Name: idx_fk_sri_usuario; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_sri_usuario ON solicitacaorepactuacaoindicador USING btree (solicitante_id);


--
-- Name: idx_fk_unidadegerencial_1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_unidadegerencial_1 ON unidadegerencial USING btree (subordinacao_id);


--
-- Name: idx_fk_unidadegerencial_nivelhierarquico; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_unidadegerencial_nivelhierarquico ON unidadegerencial USING btree (nivelhierarquico_id);


--
-- Name: idx_fk_usuario_arquivo; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_usuario_arquivo ON usuario USING btree (foto_id);


--
-- Name: idx_fk_usuarioauditoriainterna_auditoriainterna; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_usuarioauditoriainterna_auditoriainterna ON usuarioauditoriainterna USING btree (auditoriainterna_id);


--
-- Name: idx_fk_usuariopapel_papel; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_usuariopapel_papel ON usuariopapel USING btree (papel_id);


--
-- Name: idx_fk_usuariopapel_usuario; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_usuariopapel_usuario ON usuariopapel USING btree (usuario_id);


--
-- Name: idx_fk_usuariounidadegerencial_unidadegerencial; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_usuariounidadegerencial_unidadegerencial ON usuariounidadegerencial USING btree (unidadegerencial_id);


--
-- Name: idx_fk_usuariounidadegerencial_usuario; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_usuariounidadegerencial_usuario ON usuariounidadegerencial USING btree (usuario_id);


--
-- Name: idx_unidadegerencial_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_unidadegerencial_fk ON unidadegerencial USING btree (planogestao_id);


--
-- Name: uk_mapacompetencia; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX uk_mapacompetencia ON mapacompetencia USING btree (unidadegerencial_id);


--
-- Name: uk_mapaestrategico; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX uk_mapaestrategico ON mapaestrategico USING btree (unidadegerencial_id);


--
-- Name: uk_mapanegocio; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX uk_mapanegocio ON mapanegocio USING btree (unidadegerencial_id);


--
-- Name: trg_anexoanomalia_exclusao_arquivo; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_anexoanomalia_exclusao_arquivo
    AFTER DELETE ON anexoanomalia
    FOR EACH ROW
    EXECUTE PROCEDURE fc_anexoanomalia_exclusao_arquivo();


--
-- Name: trg_anexoindicador_exclusao_arquivo; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_anexoindicador_exclusao_arquivo
    AFTER DELETE ON anexoindicador
    FOR EACH ROW
    EXECUTE PROCEDURE fc_anexoindicador_exclusao_arquivo();


--
-- Name: trg_indicador_ins; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_indicador_ins
    AFTER INSERT OR DELETE OR UPDATE ON indicador
    FOR EACH ROW
    EXECUTE PROCEDURE tg_indicador_ins();


--
-- Name: FK_objetivomapaestrategico_objetivoestrategico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY objetivomapaestrategico
    ADD CONSTRAINT "FK_objetivomapaestrategico_objetivoestrategico" FOREIGN KEY (objetivoestrategico_id) REFERENCES objetivoestrategico(id);


--
-- Name: FK_objetivomapaestrategico_perspectiva; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY objetivomapaestrategico
    ADD CONSTRAINT "FK_objetivomapaestrategico_perspectiva" FOREIGN KEY (perspectivamapaestrategico_id) REFERENCES perspectivamapaestrategico(id) ON DELETE CASCADE;


--
-- Name: anomalia_ugregistro; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY anomalia
    ADD CONSTRAINT anomalia_ugregistro FOREIGN KEY (ugregistro_id) REFERENCES unidadegerencial(id);


--
-- Name: fk__soliccancind_indicador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solicitacaocancelamentoindicador
    ADD CONSTRAINT fk__soliccancind_indicador FOREIGN KEY (indicador_id) REFERENCES indicador(id) ON DELETE CASCADE;


--
-- Name: fk_acaopreventiva_ugregistro; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY acaopreventiva
    ADD CONSTRAINT fk_acaopreventiva_ugregistro FOREIGN KEY (ugregistro_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_acompanhamentoindicador_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY acompanhamentoindicador
    ADD CONSTRAINT fk_acompanhamentoindicador_1 FOREIGN KEY (anomalia_id) REFERENCES anomalia(id);


--
-- Name: fk_acompanhamentoindicador_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY acompanhamentoindicador
    ADD CONSTRAINT fk_acompanhamentoindicador_2 FOREIGN KEY (indicador_id) REFERENCES indicador(id) ON DELETE CASCADE;


--
-- Name: fk_acompanhamentoindicador_acaopreventiva; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY acompanhamentoindicador
    ADD CONSTRAINT fk_acompanhamentoindicador_acaopreventiva FOREIGN KEY (acaopreventiva_id) REFERENCES acaopreventiva(id);


--
-- Name: fk_anexoanomalia_anomalia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY anexoanomalia
    ADD CONSTRAINT fk_anexoanomalia_anomalia FOREIGN KEY (anomalia_id) REFERENCES anomalia(id) ON DELETE CASCADE;


--
-- Name: fk_anexoanomalia_arquivo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY anexoanomalia
    ADD CONSTRAINT fk_anexoanomalia_arquivo FOREIGN KEY (arquivo_id) REFERENCES arquivo(id);


--
-- Name: fk_anexoindicador_arquivo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY anexoindicador
    ADD CONSTRAINT fk_anexoindicador_arquivo FOREIGN KEY (arquivo_id) REFERENCES arquivo(id);


--
-- Name: fk_anexoindicador_indicador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY anexoindicador
    ADD CONSTRAINT fk_anexoindicador_indicador FOREIGN KEY (indicador_id) REFERENCES indicador(id) ON DELETE CASCADE;


--
-- Name: fk_anomalia_itemauditoriainterna; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY anomalia
    ADD CONSTRAINT fk_anomalia_itemauditoriainterna FOREIGN KEY (itemauditoriainterna_id) REFERENCES itemauditoriainterna(id);


--
-- Name: fk_anomalia_ocorrencia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY anomalia
    ADD CONSTRAINT fk_anomalia_ocorrencia FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id);


--
-- Name: fk_anomalia_subordinacao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY anomalia
    ADD CONSTRAINT fk_anomalia_subordinacao FOREIGN KEY (subordinacao_id) REFERENCES anomalia(id) ON DELETE CASCADE;


--
-- Name: fk_anomalia_ugresponsavel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY anomalia
    ADD CONSTRAINT fk_anomalia_ugresponsavel FOREIGN KEY (ugresponsavel_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_atividade_mapacompetencia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY atividade
    ADD CONSTRAINT fk_atividade_mapacompetencia FOREIGN KEY (mapacompetencia_id) REFERENCES mapacompetencia(id) ON DELETE CASCADE;


--
-- Name: fk_auditoriagestao_modeloauditoriagestao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auditoriagestao
    ADD CONSTRAINT fk_auditoriagestao_modeloauditoriagestao FOREIGN KEY (modeloauditoriagestao_id) REFERENCES modeloauditoriagestao(id);


--
-- Name: fk_auditoriagestao_unidadegerencial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auditoriagestao
    ADD CONSTRAINT fk_auditoriagestao_unidadegerencial FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_auditoriagestaoindicador_auditoriagestao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auditoriagestaoindicador
    ADD CONSTRAINT fk_auditoriagestaoindicador_auditoriagestao FOREIGN KEY (auditoriagestao_id) REFERENCES auditoriagestao(id) ON DELETE CASCADE;


--
-- Name: fk_auditoriagestaoindicador_indicador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auditoriagestaoindicador
    ADD CONSTRAINT fk_auditoriagestaoindicador_indicador FOREIGN KEY (indicador_id) REFERENCES indicador(id) ON DELETE CASCADE;


--
-- Name: fk_auditoriagestaoindicadoritem_auditoriagestaoindicador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auditoriagestaoindicadoritem
    ADD CONSTRAINT fk_auditoriagestaoindicadoritem_auditoriagestaoindicador FOREIGN KEY (auditoriagestaoindicador_id) REFERENCES auditoriagestaoindicador(id) ON DELETE CASCADE;


--
-- Name: fk_auditoriagestaoindicadoritem_itemfatoravaliacao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auditoriagestaoindicadoritem
    ADD CONSTRAINT fk_auditoriagestaoindicadoritem_itemfatoravaliacao FOREIGN KEY (itemfatoravaliacao_id) REFERENCES itemfatoravaliacao(id);


--
-- Name: fk_auditoriagestaoindicadoritem_itemmodeloauditoriagestao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auditoriagestaoindicadoritem
    ADD CONSTRAINT fk_auditoriagestaoindicadoritem_itemmodeloauditoriagestao FOREIGN KEY (itemmodeloauditoriagestao_id) REFERENCES itemmodeloauditoriagestao(id);


--
-- Name: fk_auditoriainterna_norma; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auditoriainterna
    ADD CONSTRAINT fk_auditoriainterna_norma FOREIGN KEY (norma_id) REFERENCES norma(id);


--
-- Name: fk_auditoriainterna_ugregistro; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auditoriainterna
    ADD CONSTRAINT fk_auditoriainterna_ugregistro FOREIGN KEY (ugregistro_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_auditoriainterna_ugresponsavel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auditoriainterna
    ADD CONSTRAINT fk_auditoriainterna_ugresponsavel FOREIGN KEY (ugresponsavel_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_causaefeito_anomalia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY causaefeito
    ADD CONSTRAINT fk_causaefeito_anomalia FOREIGN KEY (anomalia_id) REFERENCES anomalia(id);


--
-- Name: fk_causaefeito_efeito; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY causaefeito
    ADD CONSTRAINT fk_causaefeito_efeito FOREIGN KEY (efeito_id) REFERENCES causaefeito(id);


--
-- Name: fk_comentarioitem_comentario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comentarioitem
    ADD CONSTRAINT fk_comentarioitem_comentario FOREIGN KEY (comentario_id) REFERENCES comentario(id) ON DELETE CASCADE;


--
-- Name: fk_comentarioitem_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comentarioitem
    ADD CONSTRAINT fk_comentarioitem_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id);


--
-- Name: fk_competencia_competenciaorganizacional; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY competencia
    ADD CONSTRAINT fk_competencia_competenciaorganizacional FOREIGN KEY (competenciaorganizacional_id) REFERENCES competenciaorganizacional(id);


--
-- Name: fk_competencia_mapacompetencia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY competencia
    ADD CONSTRAINT fk_competencia_mapacompetencia FOREIGN KEY (mapacompetencia_id) REFERENCES mapacompetencia(id) ON DELETE CASCADE;


--
-- Name: fk_emailhistoricousuario_emailhistorico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY emailhistoricousuario
    ADD CONSTRAINT fk_emailhistoricousuario_emailhistorico FOREIGN KEY (emailhistorico_id) REFERENCES emailhistorico(id) ON DELETE CASCADE;


--
-- Name: fk_indicador_objetivomapaestrategico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY indicador
    ADD CONSTRAINT fk_indicador_objetivomapaestrategico FOREIGN KEY (objetivomapaestrategico_id) REFERENCES objetivomapaestrategico(id);


--
-- Name: fk_indicador_unidadegerencial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY indicador
    ADD CONSTRAINT fk_indicador_unidadegerencial FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_indicador_unidademedida; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY indicador
    ADD CONSTRAINT fk_indicador_unidademedida FOREIGN KEY (unidademedida_id) REFERENCES unidademedida(id);


--
-- Name: fk_iniciativa_objetivomapaestrategico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY iniciativa
    ADD CONSTRAINT fk_iniciativa_objetivomapaestrategico FOREIGN KEY (objetivomapaestrategico_id) REFERENCES objetivomapaestrategico(id);


--
-- Name: fk_iniciativa_unidadegerencial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY iniciativa
    ADD CONSTRAINT fk_iniciativa_unidadegerencial FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_itemauditoriainterna_auditoriainterna; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY itemauditoriainterna
    ADD CONSTRAINT fk_itemauditoriainterna_auditoriainterna FOREIGN KEY (auditoriainterna_id) REFERENCES auditoriainterna(id) ON DELETE CASCADE;


--
-- Name: fk_itemauditoriainterna_requisitonorma; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY itemauditoriainterna
    ADD CONSTRAINT fk_itemauditoriainterna_requisitonorma FOREIGN KEY (requisitonorma_id) REFERENCES requisitonorma(id);


--
-- Name: fk_itemauditoriainterna_ugexterna; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY itemauditoriainterna
    ADD CONSTRAINT fk_itemauditoriainterna_ugexterna FOREIGN KEY (ugexterna_id) REFERENCES unidadegerencial(id) ON DELETE CASCADE;


--
-- Name: fk_itemfatoravaliacao_fatoravaliacao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY itemfatoravaliacao
    ADD CONSTRAINT fk_itemfatoravaliacao_fatoravaliacao FOREIGN KEY (fatoravaliacao_id) REFERENCES fatoravaliacao(id) ON DELETE CASCADE;


--
-- Name: fk_itemmodeloauditoriagestao_fatoravaliacao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY itemmodeloauditoriagestao
    ADD CONSTRAINT fk_itemmodeloauditoriagestao_fatoravaliacao FOREIGN KEY (fatoravaliacao_id) REFERENCES fatoravaliacao(id);


--
-- Name: fk_itemmodeloauditoriagestao_modeloauditoriagestao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY itemmodeloauditoriagestao
    ADD CONSTRAINT fk_itemmodeloauditoriagestao_modeloauditoriagestao FOREIGN KEY (modeloauditoriagestao_id) REFERENCES modeloauditoriagestao(id) ON DELETE CASCADE;


--
-- Name: fk_mapacompetencia_unidadegerencial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mapacompetencia
    ADD CONSTRAINT fk_mapacompetencia_unidadegerencial FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id) ON DELETE CASCADE;


--
-- Name: fk_mapaestrategico_unidadegerencial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mapaestrategico
    ADD CONSTRAINT fk_mapaestrategico_unidadegerencial FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id) ON DELETE CASCADE;


--
-- Name: fk_mapanegocio_unidadegerencial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mapanegocio
    ADD CONSTRAINT fk_mapanegocio_unidadegerencial FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id) ON DELETE CASCADE;


--
-- Name: fk_matrizfcs_fatoravaliacao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matrizfcs
    ADD CONSTRAINT fk_matrizfcs_fatoravaliacao FOREIGN KEY (fatoravaliacao_id) REFERENCES fatoravaliacao(id);


--
-- Name: fk_matrizfcs_objetivomapaestrategico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matrizfcs
    ADD CONSTRAINT fk_matrizfcs_objetivomapaestrategico FOREIGN KEY (objetivomapaestrategico_id) REFERENCES objetivomapaestrategico(id);


--
-- Name: fk_matrizfcs_ug; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matrizfcs
    ADD CONSTRAINT fk_matrizfcs_ug FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_matrizfcsfator_matrizfcs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matrizfcsfator
    ADD CONSTRAINT fk_matrizfcsfator_matrizfcs FOREIGN KEY (matrizfcs_id) REFERENCES matrizfcs(id) ON DELETE CASCADE;


--
-- Name: fk_matrizfcsinicfator_itemfatorav; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matrizfcsiniciativafator
    ADD CONSTRAINT fk_matrizfcsinicfator_itemfatorav FOREIGN KEY (itemfatoravaliacao_id) REFERENCES itemfatoravaliacao(id);


--
-- Name: fk_matrizfcsinicfator_matrizfcsfator; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matrizfcsiniciativafator
    ADD CONSTRAINT fk_matrizfcsinicfator_matrizfcsfator FOREIGN KEY (matrizfcsfator_id) REFERENCES matrizfcsfator(id) ON DELETE CASCADE;


--
-- Name: fk_matrizfcsinicfator_matrizfcsinic; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matrizfcsiniciativafator
    ADD CONSTRAINT fk_matrizfcsinicfator_matrizfcsinic FOREIGN KEY (matrizfcsiniciativa_id) REFERENCES matrizfcsiniciativa(id) ON DELETE CASCADE;


--
-- Name: fk_matrizfcsiniciativa_matrizfcs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY matrizfcsiniciativa
    ADD CONSTRAINT fk_matrizfcsiniciativa_matrizfcs FOREIGN KEY (matrizfcs_id) REFERENCES matrizfcs(id) ON DELETE CASCADE;


--
-- Name: fk_ocorrencia_unidadegerencial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ocorrencia
    ADD CONSTRAINT fk_ocorrencia_unidadegerencial FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id) ON DELETE CASCADE;


--
-- Name: fk_ocorrencia_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ocorrencia
    ADD CONSTRAINT fk_ocorrencia_usuario FOREIGN KEY (relator_id) REFERENCES usuario(id);


--
-- Name: fk_painelindicadorfiltro_objetivomapaestrategico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY painelindicadorfiltro
    ADD CONSTRAINT fk_painelindicadorfiltro_objetivomapaestrategico FOREIGN KEY (objetivomapaestrategico_id) REFERENCES objetivomapaestrategico(id) ON DELETE CASCADE;


--
-- Name: fk_painelindicadorfiltro_unidadegerencial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY painelindicadorfiltro
    ADD CONSTRAINT fk_painelindicadorfiltro_unidadegerencial FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_parametrossistema_arquivo1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY parametrossistema
    ADD CONSTRAINT fk_parametrossistema_arquivo1 FOREIGN KEY (imgempresa_id) REFERENCES arquivo(id) ON DELETE SET NULL;


--
-- Name: fk_parametrossistema_arquivo2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY parametrossistema
    ADD CONSTRAINT fk_parametrossistema_arquivo2 FOREIGN KEY (imgempresarelatorio_id) REFERENCES arquivo(id) ON DELETE SET NULL;


--
-- Name: fk_permissao_papel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permissao
    ADD CONSTRAINT fk_permissao_papel FOREIGN KEY (papel_id) REFERENCES papel(id) ON DELETE CASCADE;


--
-- Name: fk_permissao_tela; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permissao
    ADD CONSTRAINT fk_permissao_tela FOREIGN KEY (tela_id) REFERENCES tela(id) ON DELETE CASCADE;


--
-- Name: fk_perspectivamapaestrategico_mapaestrategico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY perspectivamapaestrategico
    ADD CONSTRAINT fk_perspectivamapaestrategico_mapaestrategico FOREIGN KEY (mapaestrategico_id) REFERENCES mapaestrategico(id) ON DELETE CASCADE;


--
-- Name: fk_perspectivamapaestrategico_perspectiva; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY perspectivamapaestrategico
    ADD CONSTRAINT fk_perspectivamapaestrategico_perspectiva FOREIGN KEY (perspectiva_id) REFERENCES perspectiva(id);


--
-- Name: fk_planoacao_acaopreventiva; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY planoacao
    ADD CONSTRAINT fk_planoacao_acaopreventiva FOREIGN KEY (acaopreventiva_id) REFERENCES acaopreventiva(id) ON DELETE CASCADE;


--
-- Name: fk_planoacao_anomalia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY planoacao
    ADD CONSTRAINT fk_planoacao_anomalia FOREIGN KEY (anomalia_id) REFERENCES anomalia(id) ON DELETE CASCADE;


--
-- Name: fk_planoacao_iniciativa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY planoacao
    ADD CONSTRAINT fk_planoacao_iniciativa FOREIGN KEY (iniciativa_id) REFERENCES iniciativa(id) ON DELETE CASCADE;


--
-- Name: fk_planoacao_unidadegerencial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY planoacao
    ADD CONSTRAINT fk_planoacao_unidadegerencial FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_planoacao_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY planoacao
    ADD CONSTRAINT fk_planoacao_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id);


--
-- Name: fk_requisitonorma_norma; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requisitonorma
    ADD CONSTRAINT fk_requisitonorma_norma FOREIGN KEY (norma_id) REFERENCES norma(id) ON DELETE CASCADE;


--
-- Name: fk_sci_comentario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solicitacaocancelamentoindicador
    ADD CONSTRAINT fk_sci_comentario FOREIGN KEY (comentario_id) REFERENCES comentario(id);


--
-- Name: fk_solicitacaocancelamentoindicador_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solicitacaocancelamentoindicador
    ADD CONSTRAINT fk_solicitacaocancelamentoindicador_1 FOREIGN KEY (solicitante_id) REFERENCES usuario(id);


--
-- Name: fk_sri_comentario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solicitacaorepactuacaoindicador
    ADD CONSTRAINT fk_sri_comentario FOREIGN KEY (comentario_id) REFERENCES comentario(id);


--
-- Name: fk_sri_indicador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solicitacaorepactuacaoindicador
    ADD CONSTRAINT fk_sri_indicador FOREIGN KEY (indicador_id) REFERENCES indicador(id) ON DELETE CASCADE;


--
-- Name: fk_sri_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solicitacaorepactuacaoindicador
    ADD CONSTRAINT fk_sri_usuario FOREIGN KEY (solicitante_id) REFERENCES usuario(id);


--
-- Name: fk_unidadegerencial_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unidadegerencial
    ADD CONSTRAINT fk_unidadegerencial_1 FOREIGN KEY (subordinacao_id) REFERENCES unidadegerencial(id);


--
-- Name: fk_unidadegerencial_nivelhierarquico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unidadegerencial
    ADD CONSTRAINT fk_unidadegerencial_nivelhierarquico FOREIGN KEY (nivelhierarquico_id) REFERENCES nivelhierarquico(id);


--
-- Name: fk_usuario_arquivo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT fk_usuario_arquivo FOREIGN KEY (foto_id) REFERENCES arquivo(id) ON DELETE SET NULL;


--
-- Name: fk_usuarioauditoriainterna_auditoriainterna; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarioauditoriainterna
    ADD CONSTRAINT fk_usuarioauditoriainterna_auditoriainterna FOREIGN KEY (auditoriainterna_id) REFERENCES auditoriainterna(id) ON DELETE CASCADE;


--
-- Name: fk_usuariopapel_papel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuariopapel
    ADD CONSTRAINT fk_usuariopapel_papel FOREIGN KEY (papel_id) REFERENCES papel(id);


--
-- Name: fk_usuariopapel_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuariopapel
    ADD CONSTRAINT fk_usuariopapel_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE;


--
-- Name: fk_usuariounidadegerencial_unidadegerencial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuariounidadegerencial
    ADD CONSTRAINT fk_usuariounidadegerencial_unidadegerencial FOREIGN KEY (unidadegerencial_id) REFERENCES unidadegerencial(id) ON DELETE CASCADE;


--
-- Name: fk_usuariounidadegerencial_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuariounidadegerencial
    ADD CONSTRAINT fk_usuariounidadegerencial_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE;


--
-- Name: indicadoralerta_idacompanhamentoindicador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY indicadoralerta
    ADD CONSTRAINT indicadoralerta_idacompanhamentoindicador_fkey FOREIGN KEY (idacompanhamentoindicador) REFERENCES acompanhamentoindicador(id) ON DELETE SET NULL;


--
-- Name: indicadoralerta_idindicador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY indicadoralerta
    ADD CONSTRAINT indicadoralerta_idindicador_fkey FOREIGN KEY (idindicador) REFERENCES indicadorsincronizacaodashboard(idindicador);


--
-- Name: unidadegerencial_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unidadegerencial
    ADD CONSTRAINT unidadegerencial_fk FOREIGN KEY (planogestao_id) REFERENCES planogestao(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

