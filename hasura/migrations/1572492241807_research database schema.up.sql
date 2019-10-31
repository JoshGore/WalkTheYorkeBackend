CREATE FUNCTION public.asbinary(public.geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.5', 'LWGEOM_asBinary';
CREATE FUNCTION public.asbinary(public.geometry, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.5', 'LWGEOM_asBinary';
CREATE FUNCTION public.astext(public.geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.5', 'LWGEOM_asText';
CREATE FUNCTION public.estimated_extent(text, text) RETURNS public.box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-2.5', 'geometry_estimated_extent';
CREATE FUNCTION public.estimated_extent(text, text, text) RETURNS public.box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-2.5', 'geometry_estimated_extent';
CREATE FUNCTION public.geomfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1)$_$;
CREATE FUNCTION public.geomfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1, $2)$_$;
CREATE FUNCTION public.ndims(public.geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.5', 'LWGEOM_ndims';
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE FUNCTION public.setsrid(public.geometry, integer) RETURNS public.geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.5', 'LWGEOM_set_srid';
CREATE FUNCTION public.srid(public.geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.5', 'LWGEOM_get_srid';
CREATE FUNCTION public.st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);$_$;
CREATE FUNCTION public.st_astext(bytea) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsText($1::geometry);$_$;
CREATE OPERATOR FAMILY public.gist_geometry_ops USING gist;
CREATE OPERATOR CLASS public.gist_geometry_ops
    FOR TYPE public.geometry USING gist FAMILY public.gist_geometry_ops AS
    STORAGE public.box2df ,
    OPERATOR 1 public.<<(public.geometry,public.geometry) ,
    OPERATOR 2 public.&<(public.geometry,public.geometry) ,
    OPERATOR 3 public.&&(public.geometry,public.geometry) ,
    OPERATOR 4 public.&>(public.geometry,public.geometry) ,
    OPERATOR 5 public.>>(public.geometry,public.geometry) ,
    OPERATOR 6 public.~=(public.geometry,public.geometry) ,
    OPERATOR 7 public.~(public.geometry,public.geometry) ,
    OPERATOR 8 public.@(public.geometry,public.geometry) ,
    OPERATOR 9 public.&<|(public.geometry,public.geometry) ,
    OPERATOR 10 public.<<|(public.geometry,public.geometry) ,
    OPERATOR 11 public.|>>(public.geometry,public.geometry) ,
    OPERATOR 12 public.|&>(public.geometry,public.geometry) ,
    OPERATOR 13 public.<->(public.geometry,public.geometry) FOR ORDER BY pg_catalog.float_ops ,
    OPERATOR 14 public.<#>(public.geometry,public.geometry) FOR ORDER BY pg_catalog.float_ops ,
    FUNCTION 1 (public.geometry, public.geometry) public.geometry_gist_consistent_2d(internal,public.geometry,integer) ,
    FUNCTION 2 (public.geometry, public.geometry) public.geometry_gist_union_2d(bytea,internal) ,
    FUNCTION 3 (public.geometry, public.geometry) public.geometry_gist_compress_2d(internal) ,
    FUNCTION 4 (public.geometry, public.geometry) public.geometry_gist_decompress_2d(internal) ,
    FUNCTION 5 (public.geometry, public.geometry) public.geometry_gist_penalty_2d(internal,internal,internal) ,
    FUNCTION 6 (public.geometry, public.geometry) public.geometry_gist_picksplit_2d(internal,internal) ,
    FUNCTION 7 (public.geometry, public.geometry) public.geometry_gist_same_2d(public.geometry,public.geometry,internal) ,
    FUNCTION 8 (public.geometry, public.geometry) public.geometry_gist_distance_2d(internal,public.geometry,integer);
CREATE TABLE public.comments (
    id integer NOT NULL,
    body text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    user_id integer NOT NULL,
    comment_id integer,
    type_id integer
);
CREATE TABLE public.point_comment (
    point_id integer NOT NULL,
    comment_id integer NOT NULL
);
CREATE TABLE public.point_review (
    point_id integer NOT NULL,
    review_id integer NOT NULL
);
CREATE TABLE public.reviews (
    id integer NOT NULL,
    body text NOT NULL,
    rating integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    user_id integer NOT NULL
);
CREATE TABLE public.route_comment (
    route_id integer NOT NULL,
    comment_id integer NOT NULL
);
CREATE TABLE public.route_review (
    review_id integer NOT NULL,
    route_id integer NOT NULL
);
CREATE TABLE public.user_point_comment (
    user_point_id integer NOT NULL,
    comment_id integer NOT NULL
);
CREATE TABLE public.user_point_review (
    user_point_id integer NOT NULL,
    review_id integer NOT NULL
);
CREATE TABLE public.user_points (
    id integer NOT NULL,
    user_id integer NOT NULL,
    type_id integer NOT NULL,
    name text,
    description text,
    geom public.geography(Point,4326) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;
CREATE TABLE public.files (
    id integer NOT NULL,
    name text NOT NULL,
    link text NOT NULL
);
CREATE SEQUENCE public.files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.files_id_seq OWNED BY public.files.id;
CREATE TABLE public.point_route (
    point_id integer NOT NULL,
    route_id integer NOT NULL
);
CREATE TABLE public.point_type (
    point_id integer NOT NULL,
    type_id integer NOT NULL
);
CREATE TABLE public.points (
    id integer NOT NULL,
    name text,
    description text,
    geom public.geography(Point,4326) NOT NULL
);
CREATE TABLE public.routes (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    short_name text,
    type integer NOT NULL,
    route_id integer DEFAULT 18
);
CREATE TABLE public.types (
    id integer NOT NULL,
    name text,
    type_id integer
);
CREATE VIEW public.information_sign_map_layer AS
 SELECT points.id,
    (points.geom)::public.geometry AS geom,
    points.name,
    routes.id AS trail_id
   FROM ((((public.points
     JOIN public.point_type ON ((point_type.point_id = points.id)))
     JOIN public.types ON ((point_type.type_id = types.id)))
     JOIN public.point_route ON ((point_route.point_id = points.id)))
     JOIN public.routes ON ((point_route.route_id = routes.id)))
  WHERE ((types.id = 11) AND (routes.type = 5));
CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);
CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;
CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer
);
CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;
CREATE TABLE public.line_route (
    line_id integer NOT NULL,
    route_id integer NOT NULL
);
CREATE TABLE public.line_type (
    line_id integer NOT NULL,
    type_id integer NOT NULL
);
CREATE TABLE public.lines (
    id integer NOT NULL,
    title text,
    body text,
    geom public.geography(LineString,4326) NOT NULL
);
CREATE SEQUENCE public.lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.lines_id_seq OWNED BY public.lines.id;
CREATE TABLE public.multimedia (
    id integer NOT NULL,
    name text NOT NULL,
    link text NOT NULL
);
CREATE SEQUENCE public.multimedia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.multimedia_id_seq OWNED BY public.multimedia.id;
CREATE TABLE public.point_multimedia (
    point_id integer NOT NULL,
    multimedia_id integer NOT NULL
);
CREATE SEQUENCE public.points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.points_id_seq OWNED BY public.points.id;
CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;
CREATE TABLE public.roles (
    id integer NOT NULL,
    name text NOT NULL
);
CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
CREATE TABLE public.route_file (
    route_id integer NOT NULL,
    file_id integer NOT NULL
);
CREATE SEQUENCE public.route_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.route_id_seq OWNED BY public.routes.id;
CREATE TABLE public.route_multimedia (
    route_id integer NOT NULL,
    multimedia_id integer NOT NULL
);
CREATE VIEW public.routes_extent AS
 SELECT routes.id,
    (public.st_asgeojson((public.st_extent((lines.geom)::public.geometry))::public.geometry))::json AS extent
   FROM ((public.lines
     JOIN public.line_route ON ((line_route.line_id = lines.id)))
     JOIN public.routes ON ((line_route.route_id = routes.id)))
  GROUP BY routes.id;
CREATE VIEW public.seat_map_layer AS
 SELECT points.id,
    (points.geom)::public.geometry AS geom,
    points.name,
    routes.id AS trail_id
   FROM ((((public.points
     JOIN public.point_type ON ((point_type.point_id = points.id)))
     JOIN public.types ON ((point_type.type_id = types.id)))
     JOIN public.point_route ON ((point_route.point_id = points.id)))
     JOIN public.routes ON ((point_route.route_id = routes.id)))
  WHERE ((types.id = 9) AND (routes.type = 5));
CREATE VIEW public.toilet_map_layer AS
 SELECT points.id,
    (points.geom)::public.geometry AS geom,
    points.name,
    routes.id AS trail_id
   FROM ((((public.points
     JOIN public.point_type ON ((point_type.point_id = points.id)))
     JOIN public.types ON ((point_type.type_id = types.id)))
     JOIN public.point_route ON ((point_route.point_id = points.id)))
     JOIN public.routes ON ((point_route.route_id = routes.id)))
  WHERE ((types.id = 8) AND (routes.type = 5));
CREATE VIEW public.trail_marker_map_layer AS
 SELECT points.id,
    (points.geom)::public.geometry AS geom,
    points.name,
    routes.id AS trail_id
   FROM ((((public.points
     JOIN public.point_type ON ((point_type.point_id = points.id)))
     JOIN public.types ON ((point_type.type_id = types.id)))
     JOIN public.point_route ON ((point_route.point_id = points.id)))
     JOIN public.routes ON ((point_route.route_id = routes.id)))
  WHERE ((types.id = 7) AND (routes.type = 5));
CREATE VIEW public.trail_shelter_map_layer AS
 SELECT points.id,
    (points.geom)::public.geometry AS geom,
    points.name,
    routes.id AS trail_id
   FROM ((((public.points
     JOIN public.point_type ON ((point_type.point_id = points.id)))
     JOIN public.types ON ((point_type.type_id = types.id)))
     JOIN public.point_route ON ((point_route.point_id = points.id)))
     JOIN public.routes ON ((point_route.route_id = routes.id)))
  WHERE ((types.id = 6) AND (routes.type = 5));
CREATE VIEW public.trail_stage_map_layer AS
 SELECT lines.id,
    (lines.geom)::public.geometry AS geom,
    types.name AS use,
    routes.id AS route_id,
    routes.route_id AS trail_id
   FROM ((((public.lines
     JOIN public.line_type ON ((line_type.line_id = lines.id)))
     JOIN public.types ON ((types.id = line_type.type_id)))
     JOIN public.line_route ON ((line_route.line_id = lines.id)))
     JOIN public.routes ON ((line_route.route_id = routes.id)))
  WHERE (routes.type = 1);
CREATE SEQUENCE public.types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;
CREATE VIEW public.user_point_map_layer AS
 SELECT user_points.id,
    (user_points.geom)::public.geometry AS geom,
    types.type_id AS parent_type_id,
    types.id AS type_id,
    types.name AS type,
    user_points.user_id,
    user_points.name,
    user_points.updated_at
   FROM (public.user_points
     JOIN public.types ON ((types.id = user_points.type_id)));
CREATE SEQUENCE public.user_points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.user_points_id_seq OWNED BY public.user_points.id;
CREATE TABLE public.user_role (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);
CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL,
    token character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    firstname character varying NOT NULL,
    lastname character varying NOT NULL
);
CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);
ALTER TABLE ONLY public.files ALTER COLUMN id SET DEFAULT nextval('public.files_id_seq'::regclass);
ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);
ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);
ALTER TABLE ONLY public.lines ALTER COLUMN id SET DEFAULT nextval('public.lines_id_seq'::regclass);
ALTER TABLE ONLY public.multimedia ALTER COLUMN id SET DEFAULT nextval('public.multimedia_id_seq'::regclass);
ALTER TABLE ONLY public.points ALTER COLUMN id SET DEFAULT nextval('public.points_id_seq'::regclass);
ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);
ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
ALTER TABLE ONLY public.routes ALTER COLUMN id SET DEFAULT nextval('public.route_id_seq'::regclass);
ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);
ALTER TABLE ONLY public.user_points ALTER COLUMN id SET DEFAULT nextval('public.user_points_id_seq'::regclass);
ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);
ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.line_route
    ADD CONSTRAINT line_route_pkey PRIMARY KEY (line_id, route_id);
ALTER TABLE ONLY public.line_type
    ADD CONSTRAINT line_type_pkey PRIMARY KEY (line_id, type_id);
ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_id_key UNIQUE (id);
ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.multimedia
    ADD CONSTRAINT multimedia_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.point_comment
    ADD CONSTRAINT point_comment_pkey PRIMARY KEY (point_id, comment_id);
ALTER TABLE ONLY public.point_multimedia
    ADD CONSTRAINT point_multimedia_pkey PRIMARY KEY (point_id, multimedia_id);
ALTER TABLE ONLY public.point_review
    ADD CONSTRAINT point_review_pkey PRIMARY KEY (point_id, review_id);
ALTER TABLE ONLY public.point_route
    ADD CONSTRAINT point_route_pkey PRIMARY KEY (point_id, route_id);
ALTER TABLE ONLY public.point_type
    ADD CONSTRAINT point_type_pkey PRIMARY KEY (point_id, type_id);
ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.route_comment
    ADD CONSTRAINT route_comment_comment_id_key UNIQUE (comment_id);
ALTER TABLE ONLY public.route_comment
    ADD CONSTRAINT route_comment_pkey PRIMARY KEY (route_id, comment_id);
ALTER TABLE ONLY public.route_file
    ADD CONSTRAINT route_file_pkey PRIMARY KEY (route_id, file_id);
ALTER TABLE ONLY public.route_multimedia
    ADD CONSTRAINT route_multimedia_pkey PRIMARY KEY (route_id, multimedia_id);
ALTER TABLE ONLY public.routes
    ADD CONSTRAINT route_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.route_review
    ADD CONSTRAINT route_review_pkey PRIMARY KEY (review_id, route_id);
ALTER TABLE ONLY public.route_review
    ADD CONSTRAINT route_review_review_id_key UNIQUE (review_id);
ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_id_key UNIQUE (id);
ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_point_comment
    ADD CONSTRAINT user_point_comment_pkey PRIMARY KEY (user_point_id, comment_id);
ALTER TABLE ONLY public.user_point_review
    ADD CONSTRAINT user_point_review_pkey PRIMARY KEY (user_point_id, review_id);
ALTER TABLE ONLY public.user_points
    ADD CONSTRAINT user_points_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (user_id, role_id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
CREATE TRIGGER set_public_user_points_updated_at BEFORE UPDATE ON public.user_points FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_user_points_updated_at ON public.user_points IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.line_route
    ADD CONSTRAINT line_route_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.line_route
    ADD CONSTRAINT line_route_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.line_type
    ADD CONSTRAINT line_type_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.line_type
    ADD CONSTRAINT line_type_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.point_comment
    ADD CONSTRAINT point_comment_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.point_comment
    ADD CONSTRAINT point_comment_point_id_fkey FOREIGN KEY (point_id) REFERENCES public.points(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.point_multimedia
    ADD CONSTRAINT point_multimedia_multimedia_id_fkey FOREIGN KEY (multimedia_id) REFERENCES public.multimedia(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.point_multimedia
    ADD CONSTRAINT point_multimedia_point_id_fkey FOREIGN KEY (point_id) REFERENCES public.points(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.point_review
    ADD CONSTRAINT point_review_point_id_fkey FOREIGN KEY (point_id) REFERENCES public.points(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.point_review
    ADD CONSTRAINT point_review_review_id_fkey FOREIGN KEY (review_id) REFERENCES public.reviews(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.point_route
    ADD CONSTRAINT point_route_point_id_fkey FOREIGN KEY (point_id) REFERENCES public.points(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.point_route
    ADD CONSTRAINT point_route_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.point_type
    ADD CONSTRAINT point_type_point_id_fkey FOREIGN KEY (point_id) REFERENCES public.points(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.point_type
    ADD CONSTRAINT point_type_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.route_comment
    ADD CONSTRAINT route_comment_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.route_comment
    ADD CONSTRAINT route_comment_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.route_file
    ADD CONSTRAINT route_file_file_id_fkey FOREIGN KEY (file_id) REFERENCES public.files(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.route_file
    ADD CONSTRAINT route_file_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.route_multimedia
    ADD CONSTRAINT route_multimedia_multimedia_id_fkey FOREIGN KEY (multimedia_id) REFERENCES public.multimedia(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.route_multimedia
    ADD CONSTRAINT route_multimedia_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.route_review
    ADD CONSTRAINT route_review_review_id_fkey FOREIGN KEY (review_id) REFERENCES public.reviews(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.route_review
    ADD CONSTRAINT route_review_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_type_fkey FOREIGN KEY (type) REFERENCES public.types(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.user_point_comment
    ADD CONSTRAINT user_point_comment_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.user_point_comment
    ADD CONSTRAINT user_point_comment_user_point_id_fkey FOREIGN KEY (user_point_id) REFERENCES public.user_points(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.user_point_review
    ADD CONSTRAINT user_point_review_review_id_fkey FOREIGN KEY (review_id) REFERENCES public.reviews(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.user_point_review
    ADD CONSTRAINT user_point_review_user_point_id_fkey FOREIGN KEY (user_point_id) REFERENCES public.user_points(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.user_points
    ADD CONSTRAINT user_points_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.types(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.user_points
    ADD CONSTRAINT user_points_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
