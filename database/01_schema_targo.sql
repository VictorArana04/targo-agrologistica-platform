-- PostgreSQL database dump
--

\restrict VPcIkqPxE6KeGbcMMNU6ANsUId3omQwOjGvC54QmAgiveh3N3KkHm77su4tauk3

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg12+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg12+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: targo; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA targo;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: calificaciones; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.calificaciones (
    id integer NOT NULL,
    match_id integer,
    calificador character varying(12),
    puntaje smallint,
    comentario text,
    fecha timestamp without time zone DEFAULT now(),
    CONSTRAINT calificaciones_puntaje_check CHECK (((puntaje >= 1) AND (puntaje <= 5)))
);


--
-- Name: calificaciones_id_seq; Type: SEQUENCE; Schema: targo; Owner: -
--

CREATE SEQUENCE targo.calificaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calificaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: targo; Owner: -
--

ALTER SEQUENCE targo.calificaciones_id_seq OWNED BY targo.calificaciones.id;


--
-- Name: configuracion; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.configuracion (
    clave character varying(50) NOT NULL,
    valor text
);


--
-- Name: conversaciones_estado; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.conversaciones_estado (
    telefono character varying(20) NOT NULL,
    tipo_usuario character varying(12),
    estado_actual character varying(40),
    solicitud_activa_id integer,
    contexto jsonb,
    ultima_interaccion timestamp without time zone DEFAULT now()
);


--
-- Name: matches; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.matches (
    id integer NOT NULL,
    solicitud_id integer,
    conductor_id uuid,
    precio_acordado numeric(12,0) NOT NULL,
    fee_calculado numeric(12,0) NOT NULL,
    estado character varying(30) DEFAULT 'precio_acordado'::character varying,
    motivo_cancelacion character varying(60),
    fecha_acuerdo timestamp without time zone DEFAULT now(),
    fecha_liberacion_contacto timestamp without time zone
);


--
-- Name: matches_id_seq; Type: SEQUENCE; Schema: targo; Owner: -
--

CREATE SEQUENCE targo.matches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: matches_id_seq; Type: SEQUENCE OWNED BY; Schema: targo; Owner: -
--

ALTER SEQUENCE targo.matches_id_seq OWNED BY targo.matches.id;


--
-- Name: numeros_bloqueados; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.numeros_bloqueados (
    telefono character varying(20) NOT NULL,
    motivo text,
    bloqueado_en timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: ofertas; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.ofertas (
    id integer NOT NULL,
    solicitud_id integer,
    conductor_id uuid,
    propuesto_por character varying(12) NOT NULL,
    precio_propuesto numeric(12,0) NOT NULL,
    estado character varying(20) DEFAULT 'pendiente'::character varying,
    expira_en timestamp without time zone,
    fecha_creacion timestamp without time zone DEFAULT now()
);


--
-- Name: ofertas_id_seq; Type: SEQUENCE; Schema: targo; Owner: -
--

CREATE SEQUENCE targo.ofertas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ofertas_id_seq; Type: SEQUENCE OWNED BY; Schema: targo; Owner: -
--

ALTER SEQUENCE targo.ofertas_id_seq OWNED BY targo.ofertas.id;


--
-- Name: pagos; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.pagos (
    id integer NOT NULL,
    match_id integer,
    monto numeric(12,0) NOT NULL,
    referencia_bold character varying(80),
    link_pago_url text,
    estado character varying(20) DEFAULT 'pendiente'::character varying,
    reembolsado boolean DEFAULT false,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_confirmacion timestamp without time zone,
    codigo_referencia character varying(20),
    numero_comprobante character varying(100),
    datos_extraidos_ia jsonb
);


--
-- Name: pagos_comprobantes; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.pagos_comprobantes (
    id integer NOT NULL,
    pago_id integer,
    monto_leido numeric(12,0),
    numero_comprobante character varying(100),
    fecha_leida date,
    confianza character varying(10),
    valido boolean,
    motivos_rechazo text,
    datos_extraidos_ia jsonb,
    fecha_creacion timestamp without time zone DEFAULT now()
);


--
-- Name: pagos_comprobantes_id_seq; Type: SEQUENCE; Schema: targo; Owner: -
--

CREATE SEQUENCE targo.pagos_comprobantes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pagos_comprobantes_id_seq; Type: SEQUENCE OWNED BY; Schema: targo; Owner: -
--

ALTER SEQUENCE targo.pagos_comprobantes_id_seq OWNED BY targo.pagos_comprobantes.id;


--
-- Name: pagos_id_seq; Type: SEQUENCE; Schema: targo; Owner: -
--

CREATE SEQUENCE targo.pagos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pagos_id_seq; Type: SEQUENCE OWNED BY; Schema: targo; Owner: -
--

ALTER SEQUENCE targo.pagos_id_seq OWNED BY targo.pagos.id;


--
-- Name: productores; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.productores (
    id integer NOT NULL,
    telefono character varying(20) NOT NULL,
    nombre character varying(120) NOT NULL,
    finca_empresa character varying(150),
    municipio character varying(100),
    cotizaciones_totales integer DEFAULT 0,
    matches_pagados integer DEFAULT 0,
    fecha_registro timestamp without time zone DEFAULT now(),
    estado character varying(20) DEFAULT 'activo'::character varying
);


--
-- Name: productores_id_seq; Type: SEQUENCE; Schema: targo; Owner: -
--

CREATE SEQUENCE targo.productores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: productores_id_seq; Type: SEQUENCE OWNED BY; Schema: targo; Owner: -
--

ALTER SEQUENCE targo.productores_id_seq OWNED BY targo.productores.id;


--
-- Name: rate_limit; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.rate_limit (
    telefono character varying(20) NOT NULL,
    contador integer DEFAULT 1 NOT NULL,
    ventana_inicio timestamp without time zone DEFAULT now() NOT NULL,
    bloqueado_hasta timestamp without time zone,
    alerta_enviada boolean DEFAULT false NOT NULL
);


--
-- Name: solicitudes_carga; Type: TABLE; Schema: targo; Owner: -
--

CREATE TABLE targo.solicitudes_carga (
    id integer NOT NULL,
    productor_id integer,
    tipo_carga character varying(80),
    peso_toneladas numeric(6,2),
    vereda character varying(150),
    punto_referencia character varying(200),
    tipo_via character varying(30),
    origen_lat numeric(9,6),
    origen_lng numeric(9,6),
    destino character varying(150),
    fecha_requerida date,
    estado character varying(30) DEFAULT 'abierta'::character varying,
    fecha_creacion timestamp without time zone DEFAULT now(),
    conductor_candidato_id uuid,
    departamento_origen character varying(50),
    cantidad_camiones integer DEFAULT 1,
    camiones_confirmados integer DEFAULT 0
);


--
-- Name: solicitudes_carga_id_seq; Type: SEQUENCE; Schema: targo; Owner: -
--

CREATE SEQUENCE targo.solicitudes_carga_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solicitudes_carga_id_seq; Type: SEQUENCE OWNED BY; Schema: targo; Owner: -
--

ALTER SEQUENCE targo.solicitudes_carga_id_seq OWNED BY targo.solicitudes_carga.id;


--
-- Name: calificaciones id; Type: DEFAULT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.calificaciones ALTER COLUMN id SET DEFAULT nextval('targo.calificaciones_id_seq'::regclass);


--
-- Name: matches id; Type: DEFAULT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.matches ALTER COLUMN id SET DEFAULT nextval('targo.matches_id_seq'::regclass);


--
-- Name: ofertas id; Type: DEFAULT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.ofertas ALTER COLUMN id SET DEFAULT nextval('targo.ofertas_id_seq'::regclass);


--
-- Name: pagos id; Type: DEFAULT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.pagos ALTER COLUMN id SET DEFAULT nextval('targo.pagos_id_seq'::regclass);


--
-- Name: pagos_comprobantes id; Type: DEFAULT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.pagos_comprobantes ALTER COLUMN id SET DEFAULT nextval('targo.pagos_comprobantes_id_seq'::regclass);


--
-- Name: productores id; Type: DEFAULT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.productores ALTER COLUMN id SET DEFAULT nextval('targo.productores_id_seq'::regclass);


--
-- Name: solicitudes_carga id; Type: DEFAULT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.solicitudes_carga ALTER COLUMN id SET DEFAULT nextval('targo.solicitudes_carga_id_seq'::regclass);


--
-- Name: calificaciones calificaciones_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.calificaciones
    ADD CONSTRAINT calificaciones_pkey PRIMARY KEY (id);


--
-- Name: configuracion configuracion_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.configuracion
    ADD CONSTRAINT configuracion_pkey PRIMARY KEY (clave);


--
-- Name: conversaciones_estado conversaciones_estado_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.conversaciones_estado
    ADD CONSTRAINT conversaciones_estado_pkey PRIMARY KEY (telefono);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- Name: matches matches_solicitud_id_key; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.matches
    ADD CONSTRAINT matches_solicitud_id_key UNIQUE (solicitud_id);


--
-- Name: numeros_bloqueados numeros_bloqueados_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.numeros_bloqueados
    ADD CONSTRAINT numeros_bloqueados_pkey PRIMARY KEY (telefono);


--
-- Name: ofertas ofertas_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.ofertas
    ADD CONSTRAINT ofertas_pkey PRIMARY KEY (id);


--
-- Name: pagos pagos_codigo_referencia_key; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.pagos
    ADD CONSTRAINT pagos_codigo_referencia_key UNIQUE (codigo_referencia);


--
-- Name: pagos_comprobantes pagos_comprobantes_numero_comprobante_key; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.pagos_comprobantes
    ADD CONSTRAINT pagos_comprobantes_numero_comprobante_key UNIQUE (numero_comprobante);


--
-- Name: pagos_comprobantes pagos_comprobantes_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.pagos_comprobantes
    ADD CONSTRAINT pagos_comprobantes_pkey PRIMARY KEY (id);


--
-- Name: pagos pagos_match_id_key; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.pagos
    ADD CONSTRAINT pagos_match_id_key UNIQUE (match_id);


--
-- Name: pagos pagos_numero_comprobante_key; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.pagos
    ADD CONSTRAINT pagos_numero_comprobante_key UNIQUE (numero_comprobante);


--
-- Name: pagos pagos_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id);


--
-- Name: productores productores_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.productores
    ADD CONSTRAINT productores_pkey PRIMARY KEY (id);


--
-- Name: productores productores_telefono_key; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.productores
    ADD CONSTRAINT productores_telefono_key UNIQUE (telefono);


--
-- Name: rate_limit rate_limit_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.rate_limit
    ADD CONSTRAINT rate_limit_pkey PRIMARY KEY (telefono);


--
-- Name: solicitudes_carga solicitudes_carga_pkey; Type: CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.solicitudes_carga
    ADD CONSTRAINT solicitudes_carga_pkey PRIMARY KEY (id);


--
-- Name: idx_ofertas_solicitud; Type: INDEX; Schema: targo; Owner: -
--

CREATE INDEX idx_ofertas_solicitud ON targo.ofertas USING btree (solicitud_id);


--
-- Name: idx_solicitudes_estado; Type: INDEX; Schema: targo; Owner: -
--

CREATE INDEX idx_solicitudes_estado ON targo.solicitudes_carga USING btree (estado);


--
-- Name: idx_solicitudes_productor; Type: INDEX; Schema: targo; Owner: -
--

CREATE INDEX idx_solicitudes_productor ON targo.solicitudes_carga USING btree (productor_id);


--
-- Name: calificaciones calificaciones_match_id_fkey; Type: FK CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.calificaciones
    ADD CONSTRAINT calificaciones_match_id_fkey FOREIGN KEY (match_id) REFERENCES targo.matches(id);


--
-- Name: conversaciones_estado conversaciones_estado_solicitud_activa_id_fkey; Type: FK CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.conversaciones_estado
    ADD CONSTRAINT conversaciones_estado_solicitud_activa_id_fkey FOREIGN KEY (solicitud_activa_id) REFERENCES targo.solicitudes_carga(id);


--
-- Name: matches matches_conductor_id_fkey; Type: FK CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.matches
    ADD CONSTRAINT matches_conductor_id_fkey FOREIGN KEY (conductor_id) REFERENCES public.conductores(id);


--
-- Name: matches matches_solicitud_id_fkey; Type: FK CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.matches
    ADD CONSTRAINT matches_solicitud_id_fkey FOREIGN KEY (solicitud_id) REFERENCES targo.solicitudes_carga(id);


--
-- Name: ofertas ofertas_conductor_id_fkey; Type: FK CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.ofertas
    ADD CONSTRAINT ofertas_conductor_id_fkey FOREIGN KEY (conductor_id) REFERENCES public.conductores(id);


--
-- Name: ofertas ofertas_solicitud_id_fkey; Type: FK CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.ofertas
    ADD CONSTRAINT ofertas_solicitud_id_fkey FOREIGN KEY (solicitud_id) REFERENCES targo.solicitudes_carga(id);


--
-- Name: pagos_comprobantes pagos_comprobantes_pago_id_fkey; Type: FK CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.pagos_comprobantes
    ADD CONSTRAINT pagos_comprobantes_pago_id_fkey FOREIGN KEY (pago_id) REFERENCES targo.pagos(id);


--
-- Name: pagos pagos_match_id_fkey; Type: FK CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.pagos
    ADD CONSTRAINT pagos_match_id_fkey FOREIGN KEY (match_id) REFERENCES targo.matches(id);


--
-- Name: solicitudes_carga solicitudes_carga_conductor_candidato_id_fkey; Type: FK CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.solicitudes_carga
    ADD CONSTRAINT solicitudes_carga_conductor_candidato_id_fkey FOREIGN KEY (conductor_candidato_id) REFERENCES public.conductores(id);


--
-- Name: solicitudes_carga solicitudes_carga_productor_id_fkey; Type: FK CONSTRAINT; Schema: targo; Owner: -
--

ALTER TABLE ONLY targo.solicitudes_carga
    ADD CONSTRAINT solicitudes_carga_productor_id_fkey FOREIGN KEY (productor_id) REFERENCES targo.productores(id);


--
-- PostgreSQL database dump complete
--

\unrestrict VPcIkqPxE6KeGbcMMNU6ANsUId3omQwOjGvC54QmAgiveh3N3KkHm77su4tauk3

--
-- PostgreSQL database dump
--

\restrict DURchZyo6KtkbbRET1CpUcfug4t7STR8DP29Tmdl5Py5YG6eACBMMhNaC4f8bbv

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg12+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg12+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: conductores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conductores (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cedula text NOT NULL,
    telefono text NOT NULL,
    nombre text,
    tel_alterno text,
    municipio text,
    departamento text,
    tipo_vehiculo text,
    placa text,
    anio_vehiculo integer,
    marca text,
    capacidad_ton numeric,
    estado_vehiculo text,
    carroceria text,
    tipos_carga text[],
    departamentos_operacion text[],
    tipo_vias text,
    viaje_largo text,
    disponibilidad text,
    fecha_disponible date,
    dias_semana text[],
    urgencias text,
    ayudante text,
    experiencia_anios text,
    viajes_mes text,
    notas text,
    tipo_usuario text,
    fuente text,
    fecha_registro timestamp with time zone DEFAULT now(),
    estado character varying(20) DEFAULT 'disponible'::character varying,
    calificacion_promedio numeric(2,1),
    viajes_completados integer DEFAULT 0,
    color_vehiculo character varying(40),
    especies_carga_viva text[]
);


--
-- Name: conductores conductores_cedula_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conductores
    ADD CONSTRAINT conductores_cedula_key UNIQUE (cedula);


--
-- Name: conductores conductores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conductores
    ADD CONSTRAINT conductores_pkey PRIMARY KEY (id);


--
-- Name: idx_conductores_telefono; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conductores_telefono ON public.conductores USING btree (telefono);


--
-- PostgreSQL database dump complete
--

\unrestrict DURchZyo6KtkbbRET1CpUcfug4t7STR8DP29Tmdl5Py5YG6eACBMMhNaC4f8bbv
