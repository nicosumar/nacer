class UpdateNovedadesAfiliados < ActiveRecord::Migration
  def up
  	    #Creo la tabla
  		execute <<-SQL
		  	CREATE TABLE novedades_motivos_de_baja
			(
			  id integer NOT NULL,
			  descripcion text NOT NULL,
			  comentarios text,
			  CONSTRAINT novedades_motivos_de_baja_pkey PRIMARY KEY (id)
			)
			WITH (
			  OIDS=FALSE
			);
			COMMENT ON TABLE novedades_motivos_de_baja
			  IS 'Importada de SMICodMotivosBaja';
		SQL
	    
		execute <<-SQL
		INSERT INTO novedades_motivos_de_baja(
            id, descripcion)
			VALUES (10,'MOTIVOS VARIOS')
			, (11,'Ausente en Padron Provincial')
			, (12,'Faltan datos Imprescindibles')
			, (13,'Faltan datos necesarios')
			, (14,'Benficiario duplicado por: @1')
			, (15,'La categoria del beneficiario no es valida: (Tipo categoría: @1)')
			, (16,'Para esta categoria, el sexo debe ser femenino')
			, (18,'Fecha de inscripción (@1) anterior a 01/08/2004')
			, (19,'Se mudó a otra provincia')
			, (20,'EMBARAZADAS')
			, (21,'No puedo calcular la fecha de parto')
			, (22,'Embarazada que supero los 45 dias de la Fecha Probable de Parto')
			, (23,'Embarazada menor a 10 años')
			, (24,'Mujer embarazada con datos incosistentes')
			, (27,'Clave del Beneficiario NO tiene 16 dígitos')
			, (30,'PUERPERAS')
			, (31,'Puérpera que superó los 45 días')
			, (33,'Puérpera menor a 10 años')
			, (40,'MENORES')
			, (41,'La edad del beneficiario no está contemplada en el programa')
			, (42,'Menor con fecha de nacimiento futura')
			, (43,'El beneficiario es menor y no tengo los datos completos de ninguno de sus adultos responsables')
			, (44,'El beneficiario es niño con documento ajeno y el mismo no coincide con ninguno de sus adultos resp.')
			, (45,'Beneficiario con DNI ajeno que supera edad permitida. @1')
			, (46,'El beneficiario es niño y los documentos de al menos dos de sus adultos responsables son iguales')
			, (47,'Benef. niño con doc ajeno sin datos completos del resp. cuyo documento coincide con el del benef.')
			, (48,'Benef. niño con documento propio igual al documento de alguno de sus adultos responsables')
			, (50,'DOCUMENTOS')
			, (51,'Documento de beneficiario no valido')
			, (52,'Documento de madre no valido')
			, (53,'Documento de padre no valido')
			, (54,'Documento de tutor no valido')
			, (55,'Documento de beneficiario excede los digitos permitidos')
			, (56,'Documento de madre excede los digitos permitidos')
			, (57,'Documento de padre excede los digitos permitidos')
			, (58,'Documento de tutor excede los digitos permitidos')
			, (59,'Documento de beneficiario menor a 50.000')
			, (60,'Documento de madre menor a 50.000')
			, (61,'Documento de padre menor a 50.000')
			, (62,'Documento de tutor menor a 50.000')
			, (70,'P.U.C.O.')
			, (71,'Beneficiario se encuentra en el PUCO (En O.S.@1)')
			, (72,'Madre se encuentra en el PUCO (En O.S.@1)')
			, (73,'Padre se encuentra en el PUCO (En O.S. @1)')
			, (74,'Tutor se encuentra en el PUCO (En O.S.@1)')
			, (80,'REGISTROS DUPLICADOS')
			, (81,'Benef. dupl. x Tipo y Nro. doc. benef.: @1')
			, (82,'Benef. dupl. x Nombre, Apellido y F.Nac.: @1')
			, (83,'Benef. dupl. x Nombre y F.Nac., y Doc. Madre: @1')
			, (90,'BAJAS')
			, (91,'Fallecimiento')
			, (92,'Renuncia')
			, (93,'Baja registrada en U.A.D.')
			, (100,'BENEFICIARIO PERTENECIENTE A OTRO PLAN NACER')
			, (101,'Beneficiario perteneciente al Plan Nacer Ciudad Aut. de Buenos Aires')
			, (102,'Beneficiario perteneciente al Plan Nacer Buenos Aires')
			, (103,'Beneficiario perteneciente al Plan Nacer Catamarca')
			, (104,'Beneficiario perteneciente al Plan Nacer Cordoba')
			, (105,'Beneficiario perteneciente al Plan Nacer Corrientes')
			, (106,'Beneficiario perteneciente al Plan Nacer Entre Rios')
			, (107,'Beneficiario perteneciente al Plan Nacer Jujuy')
			, (108,'Beneficiario perteneciente al Plan Nacer La Rioja')
			, (109,'Beneficiario perteneciente al Plan Nacer Mendoza')
			, (110,'Beneficiario perteneciente al Plan Nacer Salta')
			, (111,'Beneficiario perteneciente al Plan Nacer San Juan')
			, (112,'Beneficiario perteneciente al Plan Nacer San Luis')
			, (113,'Beneficiario perteneciente al Plan Nacer Santa Fe')
			, (114,'Beneficiario perteneciente al Plan Nacer Santiago del Estero')
			, (115,'Beneficiario perteneciente al Plan Nacer Tucumán')
			, (116,'Beneficiario perteneciente al Plan Nacer Chaco')
			, (117,'Beneficiario perteneciente al Plan Nacer Chubut')
			, (118,'Beneficiario perteneciente al Plan Nacer Formosa')
			, (119,'Beneficiario perteneciente al Plan Nacer La Pampa')
			, (120,'Beneficiario perteneciente al Plan Nacer Misiones')
			, (121,'Beneficiario perteneciente al Plan Nacer Neuquen')
			, (122,'Beneficiario perteneciente al Plan Nacer Rio Negro')
			, (123,'Beneficiario perteneciente al Plan Nacer Santa Cruz')
			, (124,'Beneficiario perteneciente al Plan Nacer Tierra del Fuego')
			, (200,'AUDITORIA INTERNA / CONCURRENTE')
			, (201,'No existe Planilla de Inscripción')
			, (202,'Faltan datos indispensables')
			, (203,'No evidencia atención en los ultimos 6 meses')
			, (204,'No cumple con agenda sanitaria en el ultimo año')
			, (205,'Falsear información en IPOs o FC')
			, (206,'No vive en domicilio declarado')
			, (207,'Domicilio inexistente')
			, (208,'Datos falsos')
			, (209,'Fallecimiento')
			, (210,'Se mudó de Provincia')
			, (211,'Fecha de inscripción alterada')
			, (215,'Baja por cambio de Programa')
		SQL

		
  end

  def down
  	
  	execute <<-SQL
  		-- Function: crear_esquema_para_uad()

	CREATE OR REPLACE FUNCTION crear_esquema_para_uad()
	  RETURNS trigger AS
	$BODY$
	      DECLARE
	        existe_uad bool;
	        existe_novedades bool;
	      BEGIN
	        SELECT COUNT(*) > 0
	          FROM information_schema.schemata
	          WHERE
	            schema_name = ('uad_' || NEW.codigo)
	        INTO existe_uad;

	        IF NOT existe_uad THEN
	          existe_novedades := 'f'::bool;
	          EXECUTE '
	            -- Creamos el esquema para la nueva UAD
	            CREATE SCHEMA "uad_' || NEW.codigo || '";

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
	          -- La UAD ya existe, verificar si existe la tabla de novedades para el módulo de inscripción.
	          SELECT COUNT(*) > 0
	            FROM information_schema.tables
	            WHERE
	              table_schema = ('uad_' || NEW.codigo)
	              AND table_name = 'novedades_de_los_afiliados'
	          INTO existe_novedades;
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
	        IF NEW.facturacion THEN
	          -- TODO: Acá poner las sentencias de creación de las estructuras de la BB.DD. necesarias
	          -- para el módulo de facturación cuando esté en desarrollo.
	        END IF;
	        RETURN NEW;
	      END;
	    $BODY$
	  LANGUAGE plpgsql VOLATILE
	  COST 100;
	ALTER FUNCTION crear_esquema_para_uad()
	  OWNER TO nacer_adm;


  	SQL
  	
  end
end
