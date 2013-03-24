# -*- encoding : utf-8 -*-
class ModifyNovedadesDeLosAfiliadosFtsTrigger < ActiveRecord::Migration
  def change
    execute "
      CREATE OR REPLACE FUNCTION novedades_de_los_afiliados_fts_trigger() RETURNS trigger AS $$
        DECLARE
          clase_de_documento text;
          tipo_de_documento text;
          tipo_de_documento_de_la_madre text;
          tipo_de_documento_del_padre text;
          tipo_de_documento_del_tutor text;
          old_indexable boolean;
          new_indexable boolean;
        BEGIN
          SELECT indexable INTO old_indexable FROM estados_de_las_novedades WHERE id = OLD.estado_de_la_novedad_id;
          SELECT indexable INTO new_indexable FROM estados_de_las_novedades WHERE id = NEW.estado_de_la_novedad_id;
          -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
          IF (TG_OP = 'DELETE') THEN
            -- Eliminar el registro asociado en la tabla de búsquedas
            DELETE FROM busquedas_locales WHERE modelo_type = 'NovedadDelAfiliado' AND modelo_id = OLD.id;
            RETURN OLD;
          ELSIF (TG_OP = 'UPDATE' AND NOT new_indexable AND old_indexable) THEN
            -- Eliminar el registro si es una actualización y la novedad ya no debe indexarse en las búsquedas
            DELETE FROM busquedas_locales WHERE modelo_type = 'NovedadDelAfiliado' AND modelo_id = NEW.id;
            RETURN NEW;
          ELSIF (TG_OP = 'UPDATE' AND new_indexable AND old_indexable) THEN
            -- Actualizar el registro asociado en la tabla de búsquedas locales si el registro estaba indexado
            SELECT LOWER(nombre) INTO clase_de_documento FROM clases_de_documentos WHERE id = NEW.clase_de_documento_id;
            SELECT codigo INTO tipo_de_documento FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_id;
            SELECT codigo INTO tipo_de_documento_de_la_madre FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_de_la_madre_id;
            SELECT codigo INTO tipo_de_documento_del_padre FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_del_padre_id;
            SELECT codigo INTO tipo_de_documento_del_tutor FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_del_tutor_id;
            UPDATE busquedas_locales SET
              titulo =
                'Novedad pendiente: ' ||
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
                ', fecha de la novedad: ' ||
                COALESCE(to_char(NEW.fecha_de_la_novedad, 'DD/MM/YYYY'), '') ||
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
                setweight(to_tsvector('public.indices_fts', ', fecha de la novedad: '), 'D') ||
                setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_la_novedad, 'DD/MM/YYYY'), '')), 'B') ||
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
              WHERE modelo_type = 'NovedadDelAfiliado' AND modelo_id = NEW.id;
            RETURN NEW;
          ELSIF (new_indexable AND (TG_OP = 'INSERT' OR TG_OP = 'UPDATE' AND NOT old_indexable)) THEN
            -- Insertar el registro asociado en la tabla de búsquedas locales
            SELECT LOWER(nombre) INTO clase_de_documento FROM clases_de_documentos WHERE id = NEW.clase_de_documento_id;
            SELECT codigo INTO tipo_de_documento FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_id;
            SELECT codigo INTO tipo_de_documento_de_la_madre FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_de_la_madre_id;
            SELECT codigo INTO tipo_de_documento_del_padre FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_del_padre_id;
            SELECT codigo INTO tipo_de_documento_del_tutor FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_del_tutor_id;
            INSERT INTO busquedas_locales (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
              'NovedadDelAfiliado',
              NEW.id,
              'Novedad pendiente: ' ||
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
              ', fecha de la novedad: ' ||
              COALESCE(to_char(NEW.fecha_de_la_novedad, 'DD/MM/YYYY'), '') ||
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
              setweight(to_tsvector('public.indices_fts', ', fecha de la novedad: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_la_novedad, 'DD/MM/YYYY'), '')), 'B') ||
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
  end
end
