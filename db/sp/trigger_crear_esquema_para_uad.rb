# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema

# Crear nuevas restricciones de claves foráneas
ActiveRecord::Base.connection.execute "
  DROP FUNCTION crear_esquema_para_uad();
  CREATE FUNCTION crear_esquema_para_uad()
    RETURNS trigger AS
  $BODY$
          DECLARE
            existe_uad bool;
            existe_novedades bool;
            existe_prestaciones bool;
          BEGIN
            SELECT COUNT(*) > 0
              FROM information_schema.schemata
              WHERE
                schema_name = ('uad_' || NEW.codigo)
            INTO existe_uad;

            IF NOT existe_uad THEN
              existe_novedades := 'f'::bool;
              existe_prestaciones := 'f'::bool;
              EXECUTE '
                -- Creamos el esquema para la nueva UAD
                CREATE SCHEMA uad_' || NEW.codigo || ';

                -- Crear la tabla local de indexación de términos para búsquedas FTS
                CREATE TABLE uad_' || NEW.codigo || '.busquedas_locales (
                  id integer NOT NULL,
                  modelo_id integer NOT NULL,
                  modelo_type character varying(255) NOT NULL,
                  titulo character varying(255) NOT NULL,
                  texto text NOT NULL,
                  vector_fts tsvector NOT NULL
                );

                -- Crear la secuencia que genera los identificadores de la tabla de búsquedas locales
                CREATE SEQUENCE uad_' || NEW.codigo || '.busquedas_locales_id_seq;
                ALTER SEQUENCE uad_' || NEW.codigo || '.busquedas_locales_id_seq
                  OWNED BY uad_' || NEW.codigo || '.busquedas_locales.id;
                ALTER TABLE ONLY uad_' || NEW.codigo || '.busquedas_locales
                  ALTER COLUMN id
                    SET DEFAULT nextval(''uad_' || NEW.codigo || '.busquedas_locales_id_seq''::regclass);

                -- Clave primaria para la tabla de búsquedas locales
                ALTER TABLE ONLY uad_' || NEW.codigo || '.busquedas_locales
                  ADD CONSTRAINT uad_' || NEW.codigo || '_busquedas_locales_pkey PRIMARY KEY (id);

                -- Crear índices en la tabla de búsquedas locales
                CREATE INDEX uad_' || NEW.codigo || '_idx_gin_on_vector_fts
                  ON uad_' || NEW.codigo || '.busquedas_locales USING gin (vector_fts);
                CREATE UNIQUE INDEX uad_' || NEW.codigo || '_idx_unq_modelo
                  ON uad_' || NEW.codigo || '.busquedas_locales USING btree (modelo_type, modelo_id);';

            ELSE
              -- La UAD ya existe, verificar si existen las tablas para los módulos de inscripción y facturación.
              SELECT COUNT(*) > 0
                FROM information_schema.tables
                WHERE
                  table_schema = ('uad_' || NEW.codigo)
                  AND table_name = 'novedades_de_los_afiliados'
              INTO existe_novedades;
              SELECT COUNT(*) > 0
                FROM information_schema.tables
                WHERE
                  table_schema = ('uad_' || NEW.codigo)
                  AND table_name = 'prestaciones_brindadas'
              INTO existe_prestaciones;
            END IF;

            IF NEW.inscripcion AND NOT existe_novedades THEN
              EXECUTE '

                -- Crear la tabla para almacenar las novedades del padrón
                CREATE TABLE uad_' || NEW.codigo || '.novedades_de_los_afiliados (
                  id integer NOT NULL,
                  tipo_de_novedad_id integer NOT NULL,
                  estado_de_la_novedad_id integer NOT NULL,
                  clave_de_beneficiario character varying(255) NOT NULL,
                  apellido character varying(255),
                  nombre character varying(255),
                  clase_de_documento_id integer,
                  tipo_de_documento_id integer,
                  numero_de_documento character varying(255),
                  numero_de_celular character varying(255),
                  e_mail character varying(255),
                  categoria_de_afiliado_id integer,
                  sexo_id integer,
                  fecha_de_nacimiento date,
                  es_menor boolean,
                  pais_de_nacimiento_id integer,
                  se_declara_indigena boolean,
                  lengua_originaria_id integer,
                  tribu_originaria_id integer,
                  alfabetizacion_del_beneficiario_id integer,
                  alfab_beneficiario_anios_ultimo_nivel integer,
                  domicilio_calle character varying(255),
                  domicilio_numero character varying(255),
                  domicilio_piso character varying(255),
                  domicilio_depto character varying(255),
                  domicilio_manzana character varying(255),
                  domicilio_entre_calle_1 character varying(255),
                  domicilio_entre_calle_2 character varying(255),
                  telefono character varying(255),
                  otro_telefono character varying(255),
                  domicilio_departamento_id integer,
                  domicilio_distrito_id integer,
                  domicilio_barrio_o_paraje character varying(255),
                  domicilio_codigo_postal character varying(255),
                  observaciones text,
                  lugar_de_atencion_habitual_id integer,
                  apellido_de_la_madre character varying(255),
                  nombre_de_la_madre character varying(255),
                  tipo_de_documento_de_la_madre_id integer,
                  numero_de_documento_de_la_madre character varying(255),
                  alfabetizacion_de_la_madre_id integer,
                  alfab_madre_anios_ultimo_nivel integer,
                  apellido_del_padre character varying(255),
                  nombre_del_padre character varying(255),
                  tipo_de_documento_del_padre_id integer,
                  numero_de_documento_del_padre character varying(255),
                  alfabetizacion_del_padre_id integer,
                  alfab_padre_anios_ultimo_nivel integer,
                  apellido_del_tutor character varying(255),
                  nombre_del_tutor character varying(255),
                  tipo_de_documento_del_tutor_id integer,
                  numero_de_documento_del_tutor character varying(255),
                  alfabetizacion_del_tutor_id integer,
                  alfab_tutor_anios_ultimo_nivel integer,
                  esta_embarazada boolean,
                  fecha_de_la_ultima_menstruacion date,
                  fecha_de_diagnostico_del_embarazo date,
                  semanas_de_embarazo integer,
                  fecha_probable_de_parto date,
                  fecha_efectiva_de_parto date,
                  score_de_riesgo integer,
                  discapacidad_id integer,
                  fecha_de_la_novedad date,
                  centro_de_inscripcion_id integer,
                  nombre_del_agente_inscriptor character varying(255),
                  observaciones_generales text,
                  created_at timestamp without time zone,
                  updated_at timestamp without time zone,
                  creator_id integer,
                  updater_id integer,
                  mes_y_anio_de_proceso date,
                  mensaje_de_la_baja text
                );

                -- Crear la secuencia que genera los identificadores de la tabla de novedades
                CREATE SEQUENCE uad_' || NEW.codigo || '.novedades_de_los_afiliados_id_seq;
                ALTER SEQUENCE uad_' || NEW.codigo || '.novedades_de_los_afiliados_id_seq
                  OWNED BY uad_' || NEW.codigo || '.novedades_de_los_afiliados.id;
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ALTER COLUMN id
                    SET DEFAULT nextval(''uad_' || NEW.codigo || '.novedades_de_los_afiliados_id_seq''::regclass);

                -- Clave primaria para la tabla de novedades
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT uad_' || NEW.codigo || '_novedades_de_los_afiliados_pkey PRIMARY KEY (id);

                -- Crear triggers para actualizaciones de datos relacionadas con las novedades
                CREATE TRIGGER trg_uad_' || NEW.codigo || '_modificar_novedad
                  BEFORE INSERT OR UPDATE ON uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  FOR EACH ROW EXECUTE PROCEDURE modificar_novedad();
                CREATE TRIGGER trg_uad_' || NEW.codigo || '_novedades_fts
                  AFTER INSERT OR DELETE OR UPDATE ON uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  FOR EACH ROW EXECUTE PROCEDURE novedades_de_los_afiliados_fts_trigger();

                -- Restricciones de clave foránea para la tabla de novedades
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_categorias_de_afiliados
                  FOREIGN KEY (categoria_de_afiliado_id) REFERENCES categorias_de_afiliados(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_cc_dd_beneficiario
                  FOREIGN KEY (clase_de_documento_id) REFERENCES clases_de_documentos(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_centros_de_inscripcion
                  FOREIGN KEY (centro_de_inscripcion_id) REFERENCES centros_de_inscripcion(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_departamentos_domicilio
                  FOREIGN KEY (domicilio_departamento_id) REFERENCES departamentos(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_discapacidades
                  FOREIGN KEY (discapacidad_id) REFERENCES discapacidades(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_distritos_domicilio
                  FOREIGN KEY (domicilio_distrito_id) REFERENCES distritos(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_estados_de_las_novedades
                  FOREIGN KEY (estado_de_la_novedad_id) REFERENCES estados_de_las_novedades(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_lenguas_originarias
                  FOREIGN KEY (lengua_originaria_id) REFERENCES lenguas_originarias(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_nn_ii_afiliado
                  FOREIGN KEY (alfabetizacion_del_beneficiario_id) REFERENCES niveles_de_instruccion(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_nn_ii_madre
                  FOREIGN KEY (alfabetizacion_de_la_madre_id) REFERENCES niveles_de_instruccion(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_nn_ii_padre
                  FOREIGN KEY (alfabetizacion_del_padre_id) REFERENCES niveles_de_instruccion(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_nn_ii_tutor
                  FOREIGN KEY (alfabetizacion_del_tutor_id) REFERENCES niveles_de_instruccion(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_paises
                  FOREIGN KEY (pais_de_nacimiento_id) REFERENCES paises(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_sexo
                  FOREIGN KEY (sexo_id) REFERENCES sexos(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_tipos_de_novedad
                  FOREIGN KEY (tipo_de_novedad_id) REFERENCES tipos_de_novedades(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_tribus_originarias
                  FOREIGN KEY (tribu_originaria_id) REFERENCES tribus_originarias(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_tt_dd_beneficiario
                  FOREIGN KEY (tipo_de_documento_id) REFERENCES tipos_de_documentos(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_tt_dd_madre
                  FOREIGN KEY (tipo_de_documento_de_la_madre_id) REFERENCES tipos_de_documentos(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_tt_dd_padre
                  FOREIGN KEY (tipo_de_documento_del_padre_id) REFERENCES tipos_de_documentos(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.novedades_de_los_afiliados
                ADD CONSTRAINT fk_uad_' || NEW.codigo || '_novedades_tt_dd_tutor
                  FOREIGN KEY (tipo_de_documento_del_tutor_id) REFERENCES tipos_de_documentos(id);';
            END IF;

            IF NEW.facturacion AND NOT existe_prestaciones THEN
              EXECUTE '

                -- Crear la tabla para almacenar las prestaciones brindadas
                CREATE TABLE uad_' || NEW.codigo || '.prestaciones_brindadas (
                  id integer NOT NULL,
                  estado_de_la_prestacion_id integer NOT NULL,
                  clave_de_beneficiario character varying(255),
                  historia_clinica character varying(255),
                  fecha_de_la_prestacion date,
                  efector_id integer NOT NULL,
                  prestacion_id integer NOT NULL,
                  es_catastrofica boolean DEFAULT ''f'',
                  diagnostico_id integer,
                  cantidad_de_unidades numeric(15,4) DEFAULT 1.0000,
                  observaciones text,
                  cuasi_factura_id integer,
                  nomenclador_id integer,
                  monto_facturado numeric(15,4) DEFAULT 0.0000,
                  monto_liquidado numeric(15,4) DEFAULT 0.0000,
                  mensaje_de_la_baja character varying(255),
                  fecha_del_debito date,
                  created_at timestamp without time zone,
                  updated_at timestamp without time zone,
                  creator_id integer,
                  updater_id integer
                );

                -- Crear la secuencia que genera los identificadores de la tabla de prestaciones
                CREATE SEQUENCE uad_' || NEW.codigo || '.prestaciones_brindadas_id_seq;
                ALTER SEQUENCE uad_' || NEW.codigo || '.prestaciones_brindadas_id_seq
                  OWNED BY uad_' || NEW.codigo || '.prestaciones_brindadas.id;
                ALTER TABLE ONLY uad_' || NEW.codigo || '.prestaciones_brindadas
                  ALTER COLUMN id
                    SET DEFAULT nextval(''uad_' || NEW.codigo || '.prestaciones_brindadas_id_seq''::regclass);

                -- Clave primaria para la tabla de prestaciones
                ALTER TABLE ONLY uad_' || NEW.codigo || '.prestaciones_brindadas
                  ADD CONSTRAINT uad_' || NEW.codigo || '_prestaciones_brindadas_pkey PRIMARY KEY (id);

                -- Crear triggers para actualizaciones de datos relacionadas con las prestaciones
                CREATE TRIGGER trg_uad_' || NEW.codigo || '_prestaciones_fts
                  AFTER INSERT OR DELETE OR UPDATE ON uad_' || NEW.codigo || '.prestaciones_brindadas
                  FOR EACH ROW EXECUTE PROCEDURE prestaciones_brindadas_fts_trigger();

                -- Restricciones de clave foránea para la tabla de prestaciones
                ALTER TABLE ONLY uad_' || NEW.codigo || '.prestaciones_brindadas
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_pp_bb_estados
                  FOREIGN KEY (estado_de_la_prestacion_id) REFERENCES estados_de_las_prestaciones(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.prestaciones_brindadas
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_pp_bb_efectores
                  FOREIGN KEY (efector_id) REFERENCES efectores(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.prestaciones_brindadas
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_pp_bb_prestaciones
                  FOREIGN KEY (prestacion_id) REFERENCES prestaciones(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.prestaciones_brindadas
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_pp_bb_diagnosticos
                  FOREIGN KEY (diagnostico_id) REFERENCES diagnosticos(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.prestaciones_brindadas
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_pp_bb_nomencladores
                  FOREIGN KEY (nomenclador_id) REFERENCES nomencladores(id);

                -- Crear la tabla para almacenar los atributos adicionales (datos reportables)
                CREATE TABLE uad_' || NEW.codigo || '.datos_reportables_asociados (
                  id integer NOT NULL,
                  prestacion_brindada_id integer NOT NULL,
                  dato_reportable_requerido_id integer NOT NULL,
                  valor_integer integer,
                  valor_big_decimal numeric(15,4),
                  valor_date date,
                  valor_string text,
                  created_at timestamp without time zone,
                  updated_at timestamp without time zone,
                  creator_id integer,
                  updater_id integer
                );

                -- Crear la secuencia que genera los identificadores de la tabla de datos reportables asociados
                CREATE SEQUENCE uad_' || NEW.codigo || '.datos_reportables_asociados_id_seq;
                ALTER SEQUENCE uad_' || NEW.codigo || '.datos_reportables_asociados_id_seq
                  OWNED BY uad_' || NEW.codigo || '.datos_reportables_asociados.id;
                ALTER TABLE ONLY uad_' || NEW.codigo || '.datos_reportables_asociados
                  ALTER COLUMN id
                    SET DEFAULT nextval(''uad_' || NEW.codigo || '.datos_reportables_asociados_id_seq''::regclass);

                -- Clave primaria para la tabla de datos reportables asociados
                ALTER TABLE ONLY uad_' || NEW.codigo || '.datos_reportables_asociados
                  ADD CONSTRAINT uad_' || NEW.codigo || '_datos_reportables_asociados_pkey PRIMARY KEY (id);

                -- Restricciones de clave foránea para la tabla de datos reportables asociados
                ALTER TABLE ONLY uad_' || NEW.codigo || '.datos_reportables_asociados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_dd_rr_aa_prestaciones_brindadas
                  FOREIGN KEY (prestacion_brindada_id) REFERENCES uad_' || NEW.codigo || '.prestaciones_brindadas(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.datos_reportables_asociados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_dd_rr_aa_datos_reportables_requeridos
                  FOREIGN KEY (dato_reportable_requerido_id) REFERENCES datos_reportables_requeridos(id);

                -- Crear la tabla para almacenar los métodos de validación fallados por las prestaciones brindadas
                CREATE TABLE uad_' || NEW.codigo || '.metodos_de_validacion_fallados (
                  prestacion_brindada_id integer NOT NULL,
                  metodo_de_validacion_id integer NOT NULL
                );

                -- Restricciones de clave foránea para la tabla de métodos de validación fallados
                ALTER TABLE ONLY uad_' || NEW.codigo || '.metodos_de_validacion_fallados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_mm_vv_pp_bb_prestaciones_brindadas
                  FOREIGN KEY (prestacion_brindada_id) REFERENCES uad_' || NEW.codigo || '.prestaciones_brindadas(id);
                ALTER TABLE ONLY uad_' || NEW.codigo || '.metodos_de_validacion_fallados
                  ADD CONSTRAINT fk_uad_' || NEW.codigo || '_mm_vv_pp_bb_metodos_de_validacion
                  FOREIGN KEY (metodo_de_validacion_id) REFERENCES public.metodos_de_validacion(id);

                -- Trigger para evitar duplicaciones en la tabla de prestaciones brindadas
                CREATE TRIGGER trg_uad_' || NEW.codigo || '_antes_de_cambiar_prestacion_brindada
                  BEFORE INSERT OR UPDATE ON uad_' || NEW.codigo || '.prestaciones_brindadas
                  FOR EACH ROW EXECUTE PROCEDURE verificar_duplicacion_de_prestaciones();';

            END IF;
            RETURN NEW;
          END;
        $BODY$
    LANGUAGE plpgsql VOLATILE
    COST 100;

  ALTER FUNCTION crear_esquema_para_uad()
    OWNER TO nacer_adm;
"
