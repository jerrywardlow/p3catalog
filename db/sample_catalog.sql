--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    photo character varying,
    created timestamp without time zone,
    user_id integer
);


ALTER TABLE public.categories OWNER TO vagrant;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO vagrant;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE items (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    photo character varying,
    created timestamp without time zone,
    category_id integer,
    user_id integer
);


ALTER TABLE public.items OWNER TO vagrant;

--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_id_seq OWNER TO vagrant;

--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE items_id_seq OWNED BY items.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying,
    picture character varying
);


ALTER TABLE public.users OWNER TO vagrant;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO vagrant;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY items ALTER COLUMN id SET DEFAULT nextval('items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY categories (id, name, description, photo, created, user_id) FROM stdin;
1	Bicycles	Bicycles are the most efficient human powered means of transportation.	http://i.imgur.com/tPHRk6r.jpg	2016-08-04 20:47:20.123735	1
2	Knives	Knives are the LEAST efficient means of human powered transportation.	http://i.imgur.com/9vnMa4h.jpg	2016-08-04 20:47:20.125232	1
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('categories_id_seq', 2, true);


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY items (id, name, description, photo, created, category_id, user_id) FROM stdin;
1	Giant TCR Composite	Built with many of the same design philosophies as bikes ridden by Giant pros, TCR Composite delivers sharp handling and snappy acceleration with just enough compliance for racing and long training days. The PowerCore bottom bracket area and asymmetrical chainstays produce maximum pedaling efficiency. The OverDrive steerer tube technology, which features a tapered, oversized design, adds front-end stiffness and steering precision.	http://i.imgur.com/XLQT0UH.jpg	2016-08-04 20:47:20.126891	1	1
2	Bianchi XL Evolution EV4	This is the lightest frame and complete bike, for lighter riders and serious climbers. The frame is an ultra high performance, triple-butted, foam reinforced 7000 series aluminum hyperalloy with wall thickness that varies from 1.15mm to 0.6mm and gives an ultimate tensile strength of 650 N/mm2. MegaTube Evolution down tube. Bianchi patented structural foam injection. The fork is the Bianchi Reparto Corse XL full carbon.	http://i.imgur.com/a7pkVc3.jpg	2016-08-04 20:47:20.128026	1	1
3	Kershaw Blur	Like all Blurs it is equipped with a big, slightly recurved blade that is ideal for multitasking. The blade shape offers both excellent slicing and piercing capabilities and the high-performance Sandvik 14C28N stainless blade steel offers corrosion resistance and hardness. The black Blur has a DLC (Diamond-Like Carbon) coated blade for extra corrosion resistance and enhanced looks.	http://i.imgur.com/kNRowVk.png	2016-08-04 20:47:20.128762	2	1
4	CRKT Squid	This Lucas Burnley-designed everyday carry knife is compact in stature but packs some heat in the features department. It comes with a frame lock for safety, and friction grooves on the drop-point blade for a secure grip. Be careful where you point it.	http://i.imgur.com/ZyXfqOV.jpg	2016-08-04 20:47:20.129493	2	1
\.


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('items_id_seq', 4, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY users (id, name, email, picture) FROM stdin;
1	Jan Ullrich	info@janullrich.de	http://i.imgur.com/M8kYwF4.jpg
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('users_id_seq', 1, true);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: items_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace: 
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: categories_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_category_id_fkey FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;


--
-- Name: items_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


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

