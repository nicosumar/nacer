# Crear las restricciones adicionales en la base de datos
class ModificarAfiliados < ActiveRecord::Migration
  # Funciones y disparadores para mantener los datos para las búsquedas de texto completo (FTS)
  execute "
    CREATE OR REPLACE FUNCTION afiliados_fts_trigger() RETURNS trigger AS $$
      DECLARE
        clase_de_documento text;
        tipo_de_documento text;
        tipo_de_documento_de_la_madre text;
        tipo_de_documento_del_padre text;
        tipo_de_documento_del_tutor text;
      BEGIN
        -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
        IF (TG_OP = 'DELETE') THEN
          -- Eliminar el registro asociado en la tabla de búsquedas
          DELETE FROM busquedas WHERE modelo_type = 'Afiliado' AND modelo_id = OLD.afiliado_id;
          RETURN OLD;
        ELSIF (TG_OP = 'UPDATE' AND (NEW.motivo_de_la_baja_id IN (14, 81, 82, 83, 203) 
               OLD.motivo_de_la_baja_id != 14 AND OLD.motivo_de_la_baja_id != 81 AND OLD.motivo_de_la_baja_id != 82 AND
               OLD.motivo_de_la_baja_id != 83 AND OLD.motivo_de_la_baja_id != 203) THEN
          -- Eliminar el registro si es una actualización y el motivo de la baja se cambia a uno de los códigos de duplicado
          -- o de otro motivo que requiera que el afiliado no sea indexado para búsquedas
          DELETE FROM busquedas WHERE modelo_type = 'Afiliado' AND modelo_id = NEW.afiliado_id;
          RETURN NULL;
        ELSIF (TG_OP = 'UPDATE' AND NEW.motivo_de_la_baja_id != 14 AND NEW.motivo_de_la_baja_id != 81 AND
               NEW.motivo_de_la_baja_id != 82 AND NEW.motivo_de_la_baja_id != 83 AND NEW.motivo_de_la_baja_id != 203 AND
               OLD.motivo_de_la_baja_id != 14 AND OLD.motivo_de_la_baja_id != 81 AND OLD.motivo_de_la_baja_id != 82 AND
               OLD.motivo_de_la_baja_id != 83 AND OLD.motivo_de_la_baja_id != 203) THEN
          -- Actualizar el registro asociado en la tabla de búsquedas
          SELECT LOWER(nombre) INTO clase_de_documento FROM clases_de_documentos WHERE id = NEW.clase_de_documento_id;
          SELECT codigo INTO tipo_de_documento FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_id;
          SELECT codigo INTO tipo_de_documento_de_la_madre FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_de_la_madre_id;
          SELECT codigo INTO tipo_de_documento_del_padre FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_del_padre_id;
          SELECT codigo INTO tipo_de_documento_del_tutor FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_del_tutor_id;
          UPDATE busquedas SET
            titulo =
              COALESCE(NEW.apellido || ', ', '') ||
              COALESCE(NEW.nombre, '') ||
              ' (' || COALESCE(NEW.numero_de_documento, '') || ')',
            texto =
              'Beneficiario: ' ||
              COALESCE(NEW.nombre || ' ', '') ||
              COALESCE(NEW.apellido, '') ||
              ', clave ''' ||
              COALESCE(NEW.clave_de_beneficiario, '') ||
              ''', documento ' ||
              COALESCE(clase_de_documento || ' ', '') ||
              COALESCE(tipo_de_documento || ' ', '') ||
              COALESCE(NEW.numero_de_documento, '') ||
              ', fecha de nacimiento: ' ||
              COALESCE(to_char(NEW.fecha_de_nacimiento, 'DD/MM/YYYY'), '') ||
              ', fecha de inscripción: ' ||
              COALESCE(to_char(NEW.fecha_de_inscripcion, 'DD/MM/YYYY'), '') ||
              '. Madre: ' ||
              COALESCE(NEW.nombre_de_la_madre || ' ', '') ||
              COALESCE(NEW.apellido_de_la_madre, '') ||
              ', documento ' ||
              COALESCE(tipo_de_documento_de_la_madre || ' ', '') ||
              COALESCE(NEW.numero_de_documento_de_la_madre, '') ||
              '. Padre: ' ||
              COALESCE(NEW.nombre_del_padre || ' ', '') ||
              COALESCE(NEW.apellido_del_padre, '') ||
              ', documento ' ||
              COALESCE(tipo_de_documento_del_padre || ' ', '') ||
              COALESCE(NEW.numero_de_documento_del_padre, '') ||
              '. Tutor: ' ||
              COALESCE(NEW.nombre_del_tutor || ' ', '') ||
              COALESCE(NEW.apellido_del_tutor, '') ||
              ', documento ' ||
              COALESCE(tipo_de_documento_del_tutor || ' ', '') ||
              COALESCE(NEW.numero_de_documento_del_tutor, '') || '.',
            vector_fts =
              setweight(to_tsvector('public.indices_fts', 'Beneficiario: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombre || ' ', '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.apellido, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', clave '''), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.clave_de_beneficiario, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ''', documento '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(clase_de_documento || ' ', '')), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(tipo_de_documento || ' ', '')), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero_de_documento, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', fecha de nacimiento: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_nacimiento, 'DD/MM/YYYY'), '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', fecha de inscripción: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_inscripcion, 'DD/MM/YYYY'), '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', '. Madre: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombre_de_la_madre || ' ', '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.apellido_de_la_madre, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', documento '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(tipo_de_documento_de_la_madre || ' ', '')), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero_de_documento_de_la_madre, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', '. Padre: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombre_del_padre || ' ', '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.apellido_del_padre, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', documento '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(tipo_de_documento_del_padre || ' ', '')), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero_de_documento_del_padre, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', '. Tutor: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombre_del_tutor || ' ', '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.apellido_del_tutor, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', documento '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(tipo_de_documento_del_tutor || ' ', '')), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero_de_documento_del_tutor, '')), 'C')
            WHERE modelo_type = 'Afiliado' AND modelo_id = NEW.afiliado_id;
          RETURN NEW;
        ELSIF (TG_OP = 'UPDATE' AND NEW.motivo_de_la_baja_id != 14 AND NEW.motivo_de_la_baja_id != 81 AND
               NEW.motivo_de_la_baja_id != 82 AND NEW.motivo_de_la_baja_id != 83 AND NEW.motivo_de_la_baja_id != 203 AND (
               OLD.motivo_de_la_baja_id = 14 OR OLD.motivo_de_la_baja_id = 81 OR OLD.motivo_de_la_baja_id = 82 OR
               OLD.motivo_de_la_baja_id = 83 OR OLD.motivo_de_la_baja_id = 203) OR (
               TG_OP = 'INSERT' AND NEW.motivo_de_la_baja_id != 14 AND NEW.motivo_de_la_baja_id != 81 AND
               NEW.motivo_de_la_baja_id != 82 AND NEW.motivo_de_la_baja_id != 83 AND NEW.motivo_de_la_baja_id != 203)) THEN
          -- Insertar el registro asociado en la tabla de búsquedas
          SELECT LOWER(nombre) INTO clase_de_documento FROM clases_de_documentos WHERE id = NEW.clase_de_documento_id;
          SELECT codigo INTO tipo_de_documento FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_id;
          SELECT codigo INTO tipo_de_documento_de_la_madre FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_de_la_madre_id;
          SELECT codigo INTO tipo_de_documento_del_padre FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_del_padre_id;
          SELECT codigo INTO tipo_de_documento_del_tutor FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_del_tutor_id;
          INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
            'Afiliado',
            NEW.afiliado_id,
            COALESCE(NEW.apellido || ', ', '') ||
            COALESCE(NEW.nombre, '') ||
            ' (' || COALESCE(NEW.numero_de_documento, '') || ')',
            'Beneficiario: ' ||
            COALESCE(NEW.nombre || ' ', '') ||
            COALESCE(NEW.apellido, '') ||
            ', clave ''' ||
            COALESCE(NEW.clave_de_beneficiario, '') ||
            ''', documento ' ||
            COALESCE(clase_de_documento || ' ', '') ||
            COALESCE(tipo_de_documento || ' ', '') ||
            COALESCE(NEW.numero_de_documento, '') ||
            ', fecha de nacimiento: ' ||
            COALESCE(to_char(NEW.fecha_de_nacimiento, 'DD/MM/YYYY'), '') ||
            ', fecha de inscripción: ' ||
            COALESCE(to_char(NEW.fecha_de_inscripcion, 'DD/MM/YYYY'), '') ||
            '. Madre: ' ||
            COALESCE(NEW.nombre_de_la_madre || ' ', '') ||
            COALESCE(NEW.apellido_de_la_madre, '') ||
            ', documento ' ||
            COALESCE(tipo_de_documento_de_la_madre || ' ', '') ||
            COALESCE(NEW.numero_de_documento_de_la_madre, '') ||
            '. Padre: ' ||
            COALESCE(NEW.nombre_del_padre || ' ', '') ||
            COALESCE(NEW.apellido_del_padre, '') ||
            ', documento ' ||
            COALESCE(tipo_de_documento_del_padre || ' ', '') ||
            COALESCE(NEW.numero_de_documento_del_padre, '') ||
            '. Tutor: ' ||
            COALESCE(NEW.nombre_del_tutor || ' ', '') ||
            COALESCE(NEW.apellido_del_tutor, '') ||
            ', documento ' ||
            COALESCE(tipo_de_documento_del_tutor || ' ', '') ||
            COALESCE(NEW.numero_de_documento_del_tutor, '') || '.',
            setweight(to_tsvector('public.indices_fts', 'Beneficiario: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombre || ' ', '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.apellido, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', clave '''), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.clave_de_beneficiario, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ''', documento '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(clase_de_documento || ' ', '')), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(tipo_de_documento || ' ', '')), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero_de_documento, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', fecha de nacimiento: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_nacimiento, 'DD/MM/YYYY'), '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', fecha de inscripción: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_inscripcion, 'DD/MM/YYYY'), '')), 'B') ||
            setweight(to_tsvector('public.indices_fts', '. Madre: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombre_de_la_madre || ' ', '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.apellido_de_la_madre, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', documento '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(tipo_de_documento_de_la_madre || ' ', '')), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero_de_documento_de_la_madre, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', '. Padre: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombre_del_padre || ' ', '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.apellido_del_padre, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', documento '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(tipo_de_documento_del_padre || ' ', '')), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero_de_documento_del_padre, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', '. Tutor: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombre_del_tutor || ' ', '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.apellido_del_tutor, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', documento '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(tipo_de_documento_del_tutor || ' ', '')), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero_de_documento_del_tutor, '')), 'C'));
          RETURN NEW;
        END IF;
        RETURN NULL;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_afiliados
      AFTER INSERT OR UPDATE OR DELETE ON afiliados
      FOR EACH ROW EXECUTE PROCEDURE afiliados_fts_trigger();
  "
  execute "
    CREATE UNIQUE INDEX ON afiliados (afiliado_id);
  "
end
