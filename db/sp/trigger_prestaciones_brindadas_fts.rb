# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: prestaciones_brindadas_fts_trigger()
  -- DROP FUNCTION prestaciones_brindadas_fts_trigger();
  CREATE OR REPLACE FUNCTION prestaciones_brindadas_fts_trigger()
    RETURNS trigger AS
      $BODY$
        DECLARE
          afiliado RECORD;
          novedad RECORD;
          apellido text;
          nombre text;
          clase_de_documento text;
          tipo_de_documento text;
          numero_de_documento text;
          fecha_de_nacimiento date;
          codigo_de_prestacion text;
          codigo_de_diagnostico text;
          prestacion text;
          diagnostico text;
          old_indexable boolean;
          new_indexable boolean;
        BEGIN
          -- Establecer el estado de 'indexabilidad' de los registros OLD y NEW
          IF (TG_OP = 'UPDATE') THEN
            SELECT indexable INTO old_indexable FROM estados_de_las_prestaciones WHERE id = OLD.estado_de_la_prestacion_id;
          ELSE
            old_indexable := 'f'::boolean;
          END IF;
          IF (TG_OP != 'DELETE') THEN
            SELECT indexable INTO new_indexable FROM estados_de_las_prestaciones WHERE id = NEW.estado_de_la_prestacion_id;
          ELSE
            new_indexable := 'f'::boolean;
          END IF;

          -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
          IF (TG_OP = 'DELETE') THEN
            -- Eliminar el registro asociado en la tabla de búsquedas
            EXECUTE '
              DELETE
                FROM ' || quote_ident(TG_TABLE_SCHEMA) || '.busquedas_locales
                WHERE modelo_type = ' || quote_literal('PrestacionBrindada') || ' AND modelo_id = ' || OLD.id || ';';
            RETURN OLD;
          ELSIF (TG_OP = 'UPDATE' AND NOT new_indexable AND old_indexable) THEN
            -- Eliminar el registro si es una actualización y la novedad ya no debe indexarse en las búsquedas
            EXECUTE '
              DELETE
                FROM ' || quote_ident(TG_TABLE_SCHEMA) || '.busquedas_locales
                WHERE modelo_type = ' || quote_literal('PrestacionBrindada') || ' AND modelo_id = ' || NEW.id || ';';
            RETURN NEW;
          ELSIF (TG_OP = 'UPDATE' AND new_indexable AND old_indexable) THEN
            -- Extraemos los datos del afiliado de la tabla de novedades (si encontramos una pendiente), o de la de afiliados
            SELECT * INTO afiliado
              FROM afiliados
              WHERE clave_de_beneficiario = NEW.clave_de_beneficiario;
            EXECUTE '
              SELECT *
                FROM ' || quote_ident(TG_TABLE_SCHEMA) || '.novedades_de_los_afiliados novedades
                LEFT JOIN estados_de_las_novedades estados
                  ON (estados.id = novedades.estado_de_la_novedad_id)
                WHERE
                  clave_de_beneficiario = ' || quote_literal(COALESCE(NEW.clave_de_beneficiario, '')) ||
                  ' AND estados.pendiente' INTO novedad;
            IF novedad.clave_de_beneficiario IS NOT NULL THEN
              apellido := novedad.apellido;
              nombre := novedad.nombre;
              numero_de_documento := novedad.numero_de_documento;
              fecha_de_nacimiento := novedad.fecha_de_nacimiento;
              SELECT LOWER(clases_de_documentos.nombre) INTO clase_de_documento FROM clases_de_documentos WHERE id = novedad.clase_de_documento_id;
              SELECT codigo INTO tipo_de_documento FROM tipos_de_documentos WHERE id = novedad.tipo_de_documento_id;
            ELSE
              apellido := afiliado.apellido;
              nombre := afiliado.nombre;
              numero_de_documento := afiliado.numero_de_documento;
              fecha_de_nacimiento := afiliado.fecha_de_nacimiento;
              SELECT LOWER(clases_de_documentos.nombre) INTO clase_de_documento FROM clases_de_documentos WHERE id = afiliado.clase_de_documento_id;
              SELECT codigo INTO tipo_de_documento FROM tipos_de_documentos WHERE id = afiliado.tipo_de_documento_id;
            END IF;
            SELECT codigo INTO codigo_de_prestacion FROM prestaciones WHERE id = NEW.prestacion_id;
            SELECT codigo INTO codigo_de_diagnostico FROM diagnosticos WHERE id = NEW.diagnostico_id;
            SELECT prestaciones.nombre INTO prestacion FROM prestaciones WHERE id = NEW.prestacion_id;
            SELECT diagnosticos.nombre INTO diagnostico FROM diagnosticos WHERE id = NEW.diagnostico_id;

            -- Actualizar el registro asociado en la tabla de búsquedas locales si el registro estaba indexado
            EXECUTE '
              UPDATE ' || quote_ident(TG_TABLE_SCHEMA) || '.busquedas_locales SET
                titulo = ' ||
                  quote_nullable('Prestación pendiente: ' ||
                    COALESCE(apellido || ', ', '') ||
                    COALESCE(nombre, '') ||
                    ' (' || codigo_de_prestacion || COALESCE(codigo_de_diagnostico, '') || ' - ' ||
                    COALESCE(to_char(NEW.fecha_de_la_prestacion, 'DD/MM/YYYY'), '') || ')') || ',
                texto = ' ||
                  quote_nullable('Código: ' ||
                    codigo_de_prestacion || COALESCE(codigo_de_diagnostico, '') ||
                    ', prestación: ' ||
                    prestacion ||
                    ', diagnóstico: ' ||
                    COALESCE(diagnostico, '') ||
                    ', fecha de la prestación: ' ||
                    COALESCE(to_char(NEW.fecha_de_la_prestacion, 'DD/MM/YYYY'), '') ||
                    ', beneficiario: ' ||
                    COALESCE(apellido || ', ', '') || COALESCE(nombre, '') ||
                    ', clave ''' ||
                    COALESCE(NEW.clave_de_beneficiario, '') ||
                    ''', documento ' ||
                    COALESCE(clase_de_documento || ' ', '') ||
                    COALESCE(tipo_de_documento || ' ', '') ||
                    COALESCE(numero_de_documento, '') ||
                    ', fecha de nacimiento: ' ||
                    COALESCE(to_char(fecha_de_nacimiento, 'DD/MM/YYYY'), '') ||
                    '.') || ',
                vector_fts = ' ||
                  quote_nullable((setweight(to_tsvector('public.indices_fts', 'Código: '), 'D') ||
                    setweight(to_tsvector('public.indices_fts', codigo_de_prestacion || COALESCE(codigo_de_diagnostico, '')), 'A') ||
                    setweight(to_tsvector('public.indices_fts', ', prestación: '), 'D') ||
                    setweight(to_tsvector('public.indices_fts', prestacion), 'A') ||
                    setweight(to_tsvector('public.indices_fts', ', diagnóstico: '), 'D') ||
                    setweight(to_tsvector('public.indices_fts', COALESCE(diagnostico, '')), 'A') ||
                    setweight(to_tsvector('public.indices_fts', ', fecha de la prestación: '), 'D') ||
                    setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_la_prestacion, 'DD/MM/YYYY'), '')), 'A') ||
                    setweight(to_tsvector('public.indices_fts', ', beneficiario: '), 'D') ||
                    setweight(to_tsvector('public.indices_fts', COALESCE(apellido || ', ', '') || COALESCE(nombre, '')), 'B') ||
                    setweight(to_tsvector('public.indices_fts', ', clave '''''), 'D') ||
                    setweight(to_tsvector('public.indices_fts', COALESCE(NEW.clave_de_beneficiario, '')), 'B') ||
                    setweight(to_tsvector('public.indices_fts', ''''', documento '), 'D') ||
                    setweight(to_tsvector('public.indices_fts', COALESCE(clase_de_documento || ' ', '')), 'C') ||
                    setweight(to_tsvector('public.indices_fts', COALESCE(tipo_de_documento || ' ', '')), 'C') ||
                    setweight(to_tsvector('public.indices_fts', COALESCE(numero_de_documento, '')), 'B') ||
                    setweight(to_tsvector('public.indices_fts', ', fecha de nacimiento: '), 'D') ||
                    setweight(to_tsvector('public.indices_fts', COALESCE(to_char(fecha_de_nacimiento, 'DD/MM/YYYY'), '')), 'C'))::text) || '::tsvector
                WHERE modelo_type = ' || quote_literal('PrestacionBrindada') || ' AND modelo_id = ' || NEW.id || ';';
            RETURN NEW;
          ELSIF (new_indexable AND (TG_OP = 'INSERT' OR TG_OP = 'UPDATE' AND NOT old_indexable)) THEN
            -- Extraemos los datos del afiliado de la tabla de novedades (si encontramos una pendiente), o de la de afiliados
            SELECT * INTO afiliado
              FROM afiliados
              WHERE clave_de_beneficiario = NEW.clave_de_beneficiario;
            EXECUTE '
              SELECT *
                FROM ' || quote_ident(TG_TABLE_SCHEMA) || '.novedades_de_los_afiliados novedades
                LEFT JOIN estados_de_las_novedades estados
                  ON (estados.id = novedades.estado_de_la_novedad_id)
                WHERE
                  clave_de_beneficiario = ' || quote_literal(COALESCE(NEW.clave_de_beneficiario, '')) ||
                  ' AND estados.pendiente' INTO novedad;
            IF novedad.clave_de_beneficiario IS NOT NULL THEN
              apellido := novedad.apellido;
              nombre := novedad.nombre;
              numero_de_documento := novedad.numero_de_documento;
              fecha_de_nacimiento := novedad.fecha_de_nacimiento;
              SELECT LOWER(clases_de_documentos.nombre) INTO clase_de_documento FROM clases_de_documentos WHERE id = novedad.clase_de_documento_id;
              SELECT codigo INTO tipo_de_documento FROM tipos_de_documentos WHERE id = novedad.tipo_de_documento_id;
            ELSE
              apellido := afiliado.apellido;
              nombre := afiliado.nombre;
              numero_de_documento := afiliado.numero_de_documento;
              fecha_de_nacimiento := afiliado.fecha_de_nacimiento;
              SELECT LOWER(clases_de_documentos.nombre) INTO clase_de_documento FROM clases_de_documentos WHERE id = afiliado.clase_de_documento_id;
              SELECT codigo INTO tipo_de_documento FROM tipos_de_documentos WHERE id = afiliado.tipo_de_documento_id;
            END IF;
            SELECT codigo INTO codigo_de_prestacion FROM prestaciones WHERE id = NEW.prestacion_id;
            SELECT codigo INTO codigo_de_diagnostico FROM diagnosticos WHERE id = NEW.diagnostico_id;
            SELECT prestaciones.nombre INTO prestacion FROM prestaciones WHERE id = NEW.prestacion_id;
            SELECT diagnosticos.nombre INTO diagnostico FROM diagnosticos WHERE id = NEW.diagnostico_id;

            -- Insertar el registro asociado en la tabla de búsquedas locales
            EXECUTE '
              INSERT INTO ' || quote_ident(TG_TABLE_SCHEMA) || '.busquedas_locales (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES ( ' ||
                quote_literal('PrestacionBrindada') || ', ' ||
                NEW.id || ', ' ||
                quote_nullable('Prestación pendiente: ' ||
                  COALESCE(apellido || ', ', '') ||
                  COALESCE(nombre, '') ||
                  ' (' || codigo_de_prestacion || COALESCE(codigo_de_diagnostico, '') || ' - ' ||
                  COALESCE(to_char(NEW.fecha_de_la_prestacion, 'DD/MM/YYYY'), '') || ')') || ', ' ||
                quote_nullable('Código: ' ||
                  codigo_de_prestacion || COALESCE(codigo_de_diagnostico, '') ||
                  ', prestación: ' ||
                  prestacion ||
                  ', diagnóstico: ' ||
                  COALESCE(diagnostico, '') ||
                  ', fecha de la prestación: ' ||
                  COALESCE(to_char(NEW.fecha_de_la_prestacion, 'DD/MM/YYYY'), '') ||
                  ', beneficiario: ' ||
                  COALESCE(apellido || ', ', '') || COALESCE(nombre, '') ||
                  ', clave ''' ||
                  COALESCE(NEW.clave_de_beneficiario, '') ||
                  ''', documento ' ||
                  COALESCE(clase_de_documento || ' ', '') ||
                  COALESCE(tipo_de_documento || ' ', '') ||
                  COALESCE(numero_de_documento, '') ||
                  ', fecha de nacimiento: ' ||
                  COALESCE(to_char(fecha_de_nacimiento, 'DD/MM/YYYY'), '') ||
                  '.') || ', ' ||
                quote_nullable((setweight(to_tsvector('public.indices_fts', 'Código: '), 'D') ||
                  setweight(to_tsvector('public.indices_fts', codigo_de_prestacion || COALESCE(codigo_de_diagnostico, '')), 'A') ||
                  setweight(to_tsvector('public.indices_fts', ', prestación: '), 'D') ||
                  setweight(to_tsvector('public.indices_fts', prestacion), 'A') ||
                  setweight(to_tsvector('public.indices_fts', ', diagnóstico: '), 'D') ||
                  setweight(to_tsvector('public.indices_fts', COALESCE(diagnostico, '')), 'A') ||
                  setweight(to_tsvector('public.indices_fts', ', fecha de la prestación: '), 'D') ||
                  setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_la_prestacion, 'DD/MM/YYYY'), '')), 'A') ||
                  setweight(to_tsvector('public.indices_fts', ', beneficiario: '), 'D') ||
                  setweight(to_tsvector('public.indices_fts', COALESCE(apellido || ', ', '') || COALESCE(nombre, '')), 'B') ||
                  setweight(to_tsvector('public.indices_fts', ', clave '''''), 'D') ||
                  setweight(to_tsvector('public.indices_fts', COALESCE(NEW.clave_de_beneficiario, '')), 'B') ||
                  setweight(to_tsvector('public.indices_fts', ''''', documento '), 'D') ||
                  setweight(to_tsvector('public.indices_fts', COALESCE(clase_de_documento || ' ', '')), 'C') ||
                  setweight(to_tsvector('public.indices_fts', COALESCE(tipo_de_documento || ' ', '')), 'C') ||
                  setweight(to_tsvector('public.indices_fts', COALESCE(numero_de_documento, '')), 'B') ||
                  setweight(to_tsvector('public.indices_fts', ', fecha de nacimiento: '), 'D') ||
                  setweight(to_tsvector('public.indices_fts', COALESCE(to_char(fecha_de_nacimiento, 'DD/MM/YYYY'), '')), 'C'))::text) || '::tsvector);';
            RETURN NEW;
          END IF;
          RETURN NULL;
        END;
      $BODY$
    LANGUAGE plpgsql VOLATILE
    COST 100;
SQL