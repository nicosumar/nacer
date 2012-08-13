# Crear las restricciones adicionales en la base de datos
class ModificarAfiliados < ActiveRecord::Migration
  # Funciones y disparadores para mantener los datos para las búsquedas de texto completo (FTS)
  execute "
    CREATE OR REPLACE FUNCTION afiliados_fts_trigger() RETURNS trigger AS $$
      BEGIN
        -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
        IF (TG_OP = 'DELETE') THEN
          -- Eliminar el registro asociado en la tabla de búsquedas
          DELETE FROM busquedas WHERE modelo_type = 'Afiliado' AND modelo_id = OLD.afiliado_id;
          RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
          -- Actualizar el registro asociado en la tabla de búsquedas
          UPDATE busquedas SET
            titulo = NEW.apellido || ', '::text || NEW.nombre || ' ('::text || NEW.numero_de_documento || ')'::text,
            texto =
              'Beneficiario: '::text || NEW.clave_de_beneficiario || '. ' ||
              COALESCE('Apellido: '::text || NEW.apellido || '. ', '') ||
              COALESCE('Nombre: '::text || NEW.nombre || '. ', '') ||
              COALESCE('Número de documento: '::text || NEW.numero_de_documento || '. ', '') ||
              COALESCE('Fecha de nacimiento: '::text || NEW.fecha_de_nacimiento || '. ', '') ||
              COALESCE('Número de documento de la madre: '::text || NEW.numero_de_documento_de_la_madre || '. ', '') ||
              COALESCE('Apellido de la madre: '::text || NEW.apellido_de_la_madre || '. ', '') ||
              COALESCE('Nombre de la madre: '::text || NEW.nombre_de_la_madre || '. ', '') ||
              COALESCE('Número de documento del padre: '::text || NEW.numero_de_documento_del_padre || '. ', '') ||
              COALESCE('Apellido del padre: '::text || NEW.apellido_del_padre || '. ', '') ||
              COALESCE('Nombre del padre: '::text || NEW.nombre_del_padre || '. ', '') ||
              COALESCE('Número de documento del tutor: '::text || NEW.numero_de_documento_del_tutor || '. ', '') ||
              COALESCE('Apellido del tutor: '::text || NEW.apellido_del_tutor || '. ', '') ||
              COALESCE('Nombre del tutor: '::text || NEW.nombre_del_tutor || '. ', ''),
            vector_fts =
              setweight(to_tsvector('public.es_ar', 'Beneficiario: '::text || NEW.clave_de_beneficiario || '. '), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Apellido: '::text || NEW.apellido || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Nombre: '::text || NEW.nombre || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Número de documento: '::text || NEW.numero_de_documento || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Fecha de nacimiento: '::text || NEW.fecha_de_nacimiento || '. ', '')), 'D') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Número de documento de la madre: '::text || NEW.numero_de_documento_de_la_madre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Apellido de la madre: '::text || NEW.apellido_de_la_madre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Nombre de la madre: '::text || NEW.nombre_de_la_madre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Número de documento del padre: '::text || NEW.numero_de_documento_del_padre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Apellido del padre: '::text || NEW.apellido_del_padre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Nombre del padre: '::text || NEW.nombre_del_padre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Número de documento del tutor: '::text || NEW.numero_de_documento_del_tutor || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Apellido del tutor: '::text || NEW.apellido_del_tutor || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Nombre del tutor: '::text || NEW.nombre_del_tutor || '. ', '')), 'B')
            WHERE modelo_type = 'Afiliado' AND modelo_id = NEW.afiliado_id;
          RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
            'Afiliado',
            NEW.afiliado_id,
            NEW.apellido || ', '::text || NEW.nombre || ' ('::text || NEW.numero_de_documento || ')'::text,
            'Beneficiario: '::text || NEW.clave_de_beneficiario || '. ' ||
              COALESCE('Apellido: '::text || NEW.apellido || '. ', '') ||
              COALESCE('Nombre: '::text || NEW.nombre || '. ', '') ||
              COALESCE('Número de documento: '::text || NEW.numero_de_documento || '. ', '') ||
              COALESCE('Fecha de nacimiento: '::text || NEW.fecha_de_nacimiento || '. ', '') ||
              COALESCE('Número de documento de la madre: '::text || NEW.numero_de_documento_de_la_madre || '. ', '') ||
              COALESCE('Apellido de la madre: '::text || NEW.apellido_de_la_madre || '. ', '') ||
              COALESCE('Nombre de la madre: '::text || NEW.nombre_de_la_madre || '. ', '') ||
              COALESCE('Número de documento del padre: '::text || NEW.numero_de_documento_del_padre || '. ', '') ||
              COALESCE('Apellido del padre: '::text || NEW.apellido_del_padre || '. ', '') ||
              COALESCE('Nombre del padre: '::text || NEW.nombre_del_padre || '. ', '') ||
              COALESCE('Número de documento del tutor: '::text || NEW.numero_de_documento_del_tutor || '. ', '') ||
              COALESCE('Apellido del tutor: '::text || NEW.apellido_del_tutor || '. ', '') ||
              COALESCE('Nombre del tutor: '::text || NEW.nombre_del_tutor || '. ', ''),
            setweight(to_tsvector('public.es_ar', 'Beneficiario: '::text || NEW.clave_de_beneficiario || '. '), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Apellido: '::text || NEW.apellido || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Nombre: '::text || NEW.nombre || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Número de documento: '::text || NEW.numero_de_documento || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Fecha de nacimiento: '::text || NEW.fecha_de_nacimiento || '. ', '')), 'D') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Número de documento de la madre: '::text || NEW.numero_de_documento_de_la_madre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Apellido de la madre: '::text || NEW.apellido_de_la_madre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Nombre de la madre: '::text || NEW.nombre_de_la_madre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Número de documento del padre: '::text || NEW.numero_de_documento_del_padre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Apellido del padre: '::text || NEW.apellido_del_padre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Nombre del padre: '::text || NEW.nombre_del_padre || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Número de documento del tutor: '::text || NEW.numero_de_documento_del_tutor || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Apellido del tutor: '::text || NEW.apellido_del_tutor || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Nombre del tutor: '::text || NEW.nombre_del_tutor || '. ', '')), 'B'));
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
