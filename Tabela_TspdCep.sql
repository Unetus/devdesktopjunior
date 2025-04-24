-- Table: public.tspdcep

-- DROP TABLE IF EXISTS public.tspdcep;

CREATE TABLE IF NOT EXISTS public.tspdcep
(
    cep character varying(10) COLLATE pg_catalog."default" NOT NULL,
    logradouro character varying(255) COLLATE pg_catalog."default",
    complemento character varying(255) COLLATE pg_catalog."default",
    bairro character varying(255) COLLATE pg_catalog."default",
    localidade character varying(100) COLLATE pg_catalog."default",
    uf character varying(2) COLLATE pg_catalog."default",
    ibge character varying(20) COLLATE pg_catalog."default",
    ddd character varying(5) COLLATE pg_catalog."default",
    CONSTRAINT tspdcep_pkey PRIMARY KEY (cep)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tspdcep
    OWNER to postgres;