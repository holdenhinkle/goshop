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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: product_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.product_type AS ENUM (
    'simple',
    'composite',
    'configured_composite'
);


--
-- Name: product_unit; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.product_unit AS ENUM (
    'piece',
    'gallon',
    'quart',
    'pint',
    'cup',
    'fluid_once',
    'tablespoon',
    'teaspoon',
    'pound',
    'ounce'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    tenant_id character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    id uuid DEFAULT public.gen_random_uuid() NOT NULL
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: available_tenant_ids; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.available_tenant_ids (
    tenant_id character varying NOT NULL,
    id uuid DEFAULT public.gen_random_uuid() NOT NULL
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    name character varying NOT NULL,
    description text NOT NULL,
    image character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL
);


--
-- Name: component_product_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.component_product_options (
    component_id uuid NOT NULL,
    product_id uuid NOT NULL
);


--
-- Name: components; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.components (
    name character varying NOT NULL,
    description character varying NOT NULL,
    slug character varying,
    image character varying,
    min_quantity integer DEFAULT 1 NOT NULL,
    max_quantity integer,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL
);


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendly_id_slugs (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friendly_id_slugs_id_seq OWNED BY public.friendly_id_slugs.id;


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_categories (
    product_id uuid NOT NULL,
    category_id uuid NOT NULL
);


--
-- Name: product_components; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_components (
    composite_id uuid NOT NULL,
    component_id uuid NOT NULL
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    name character varying NOT NULL,
    description text NOT NULL,
    image character varying,
    inventory_amount integer,
    is_visible boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    regular_price_cents integer DEFAULT 0 NOT NULL,
    regular_price_currency character varying DEFAULT 'USD'::character varying NOT NULL,
    sales_price_currency character varying DEFAULT 'USD'::character varying NOT NULL,
    sale_price_cents integer,
    sale_price_currency character varying DEFAULT 'USD'::character varying NOT NULL,
    type character varying NOT NULL,
    unit_of_measure public.product_unit NOT NULL,
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: friendly_id_slugs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('public.friendly_id_slugs_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: available_tenant_ids available_tenant_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.available_tenant_ids
    ADD CONSTRAINT available_tenant_ids_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: components components_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: idx_component_product_options_on_component_id_and_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_component_product_options_on_component_id_and_product_id ON public.component_product_options USING btree (component_id, product_id);


--
-- Name: idx_product_categories_on_product_id_and_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_product_categories_on_product_id_and_category_id ON public.product_categories USING btree (product_id, category_id);


--
-- Name: idx_product_components_on_composite_id_and_component_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_product_components_on_composite_id_and_component_id ON public.product_components USING btree (composite_id, component_id);


--
-- Name: index_accounts_on_tenant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_tenant_id ON public.accounts USING btree (tenant_id);


--
-- Name: index_categories_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_account_id ON public.categories USING btree (account_id);


--
-- Name: index_categories_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_name ON public.categories USING btree (name);


--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_slug ON public.categories USING btree (slug);


--
-- Name: index_component_product_options_on_component_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_component_product_options_on_component_id ON public.component_product_options USING btree (component_id);


--
-- Name: index_component_product_options_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_component_product_options_on_product_id ON public.component_product_options USING btree (product_id);


--
-- Name: index_components_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_components_on_account_id ON public.components USING btree (account_id);


--
-- Name: index_components_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_components_on_name ON public.components USING btree (name);


--
-- Name: index_components_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_components_on_slug ON public.components USING btree (slug);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON public.friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON public.friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_type_and_sluggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type_and_sluggable_id ON public.friendly_id_slugs USING btree (sluggable_type, sluggable_id);


--
-- Name: index_product_categories_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_categories_on_category_id ON public.product_categories USING btree (category_id);


--
-- Name: index_product_categories_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_categories_on_product_id ON public.product_categories USING btree (product_id);


--
-- Name: index_product_components_on_component_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_components_on_component_id ON public.product_components USING btree (component_id);


--
-- Name: index_product_components_on_composite_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_components_on_composite_id ON public.product_components USING btree (composite_id);


--
-- Name: index_products_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_account_id ON public.products USING btree (account_id);


--
-- Name: index_products_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_name ON public.products USING btree (name);


--
-- Name: index_products_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_slug ON public.products USING btree (slug);


--
-- Name: index_products_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_type ON public.products USING btree (type);


--
-- Name: product_categories fk_rails_005b71ca83; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT fk_rails_005b71ca83 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: component_product_options fk_rails_47b8bb0341; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component_product_options
    ADD CONSTRAINT fk_rails_47b8bb0341 FOREIGN KEY (component_id) REFERENCES public.products(id);


--
-- Name: categories fk_rails_4fd3bba7e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_rails_4fd3bba7e8 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: component_product_options fk_rails_5169cfcbe6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.component_product_options
    ADD CONSTRAINT fk_rails_5169cfcbe6 FOREIGN KEY (product_id) REFERENCES public.categories(id);


--
-- Name: products fk_rails_6dc06b37ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_rails_6dc06b37ef FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: product_categories fk_rails_98a9a32a41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT fk_rails_98a9a32a41 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_components fk_rails_bbf1586c23; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_components
    ADD CONSTRAINT fk_rails_bbf1586c23 FOREIGN KEY (composite_id) REFERENCES public.products(id);


--
-- Name: components fk_rails_e780d8f3f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT fk_rails_e780d8f3f0 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: product_components fk_rails_fbcdf8b6ea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_components
    ADD CONSTRAINT fk_rails_fbcdf8b6ea FOREIGN KEY (component_id) REFERENCES public.categories(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20201203033012'),
('20201203033741'),
('20201203040851'),
('20201204024628'),
('20201204024946'),
('20201204031736'),
('20201204032533'),
('20201204033554'),
('20201215005655'),
('20201215012657'),
('20201215012808'),
('20201215012859'),
('20201215015500'),
('20201215015737'),
('20201215020034'),
('20201216024849'),
('20201216035151'),
('20201229021931'),
('20201229040211'),
('20201231160700'),
('20201231161541'),
('20210101145652'),
('20210103210857'),
('20210105110536'),
('20210105111016'),
('20210105111440'),
('20210222155725'),
('20210222162348'),
('20210222165641'),
('20210222165823'),
('20210222222650'),
('20210410145521'),
('20210410150312'),
('20210410164854'),
('20210430010855'),
('20210430012340'),
('20210430014033'),
('20210430020459'),
('20210430022017'),
('20210430025138'),
('20210430030241'),
('20210501021804'),
('20210501022943'),
('20210501023302'),
('20210501023456'),
('20210501023741'),
('20210501030345'),
('20210501030719'),
('20210501030827'),
('20210501031015'),
('20210523204433'),
('20210523204816'),
('20210523205924'),
('20210523212350'),
('20210523213140'),
('20210523213709'),
('20210523214116'),
('20210523215049'),
('20210523215559'),
('20210523220223'),
('20210523221936'),
('20210524102727'),
('20210524103750');


