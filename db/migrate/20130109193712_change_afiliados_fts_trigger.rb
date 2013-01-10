class ChangeAfiliadosFtsTrigger < ActiveRecord::Migration
  def up
    execute "
      BEGIN TRANSACTION;

      -- Modificamos el trigger para añadir un nuevo motivo (51 - Error de DNI) que invalida el registro para las búsquedas
      -- y procesos, al igual que con los códigos de duplicado (14, 81, 82 y 83)
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
          ELSIF (TG_OP = 'UPDATE' AND NEW.motivo_de_la_baja_id IN (14, 51, 81, 82, 83) AND
                (OLD.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83) OR OLD.motivo_de_la_baja_id IS NULL)) THEN
            -- Eliminar el registro si es una actualización y el motivo de la baja se cambia a uno de los códigos de duplicado
            DELETE FROM busquedas WHERE modelo_type = 'Afiliado' AND modelo_id = NEW.afiliado_id;
            RETURN NEW;
          ELSIF (TG_OP = 'UPDATE' AND (NEW.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83) OR NEW.motivo_de_la_baja_id IS NULL)
                AND (OLD.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83) OR OLD.motivo_de_la_baja_id IS NULL)) THEN
            -- Actualizar el registro asociado en la tabla de búsquedas si el registro estaba indexado y debe seguir indexado
            SELECT LOWER(nombre) INTO clase_de_documento FROM clases_de_documentos WHERE id = NEW.clase_de_documento_id;
            SELECT codigo INTO tipo_de_documento FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_id;
            SELECT codigo INTO tipo_de_documento_de_la_madre FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_de_la_madre_id;
            SELECT codigo INTO tipo_de_documento_del_padre FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_del_padre_id;
            SELECT codigo INTO tipo_de_documento_del_tutor FROM tipos_de_documentos WHERE id = NEW.tipo_de_documento_del_tutor_id;
            UPDATE busquedas SET
              titulo =
                COALESCE(NEW.apellido || ', ', '') ||
                COALESCE(NEW.nombre, '') ||
                ' (' || COALESCE(tipo_de_documento || ' ', '') || COALESCE(NEW.numero_de_documento, '') || '), registro ' ||
                (CASE WHEN NEW.activo THEN 'ACTIVO' ELSE 'INACTIVO' END),
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
          ELSIF (TG_OP = 'UPDATE' AND (NEW.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83) OR NEW.motivo_de_la_baja_id IS NULL)
                AND OLD.motivo_de_la_baja_id IN (14, 51, 81, 82, 83)
                OR TG_OP = 'INSERT' AND (NEW.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83) OR
                NEW.motivo_de_la_baja_id IS NULL)) THEN
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
              ' (' || COALESCE(tipo_de_documento || ' ', '') || COALESCE(NEW.numero_de_documento, '') || '), registro ' ||
              (CASE WHEN NEW.activo THEN 'ACTIVO' ELSE 'INACTIVO' END),
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

      -- Eliminamos de la tabla de búsquedas los registros que se hubieran indexado con un código de motivo de baja 51
      DELETE
        FROM busquedas
        WHERE
          modelo_type = 'Afiliado'
          AND modelo_id IN (
            SELECT afiliado_id
              FROM afiliados a2
              WHERE a2.motivo_de_la_baja_id = '51'
          );

      -- Actualizamos todos los registros de la tabla de búsquedas correspondientes a Afiliados para modificar la redacción
      -- ya que cambiamos la redacción del título para incorporar el estado ACTIVO o INACTIVO
      UPDATE busquedas SET id = id WHERE modelo_type = 'Afiliado';

      -- Finalizamos la transacción
      COMMIT TRANSACTION;

      -- Corremos un VACUUM ANALYZE para mejorar la performance de la base luego de esta actualización masiva
      VACUUM ANALYZE;

    "
  end
end
