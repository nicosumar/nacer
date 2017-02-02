# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarNovedadesDeLosAfiliados < ActiveRecord::Migration
  # Funciones y disparadores para mantener los datos para las búsquedas de texto completo (FTS)
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

  # Funciones y disparadores para modificar los datos que se insertan/modifican en la tabla
  execute "
    CREATE OR REPLACE FUNCTION modificar_novedad() RETURNS trigger AS $$
      DECLARE
        new_apellido varchar;
        new_nombre varchar;
        new_numero_de_documento varchar;
        new_domicilio_calle varchar;
        new_domicilio_numero varchar;
        new_domicilio_piso varchar;
        new_domicilio_depto varchar;
        new_domicilio_manzana varchar;
        new_domicilio_entre_calle_1 varchar;
        new_domicilio_entre_calle_2 varchar;
        new_domicilio_barrio_o_paraje varchar;
        new_domicilio_codigo_postal varchar;
        new_apellido_de_la_madre varchar;
        new_nombre_de_la_madre varchar;
        new_apellido_del_padre varchar;
        new_nombre_del_padre varchar;
        new_apellido_del_tutor varchar;
        new_nombre_del_tutor varchar;
        new_nombre_del_agente_inscriptor varchar;
      BEGIN
        -- Modificar todos los campos tipo varchar del registro
        SELECT UPPER(NEW.apellido) INTO new_apellido;
        SELECT UPPER(NEW.nombre) INTO new_nombre;
        SELECT UPPER(NEW.numero_de_documento) INTO new_numero_de_documento;
        SELECT UPPER(NEW.domicilio_calle) INTO new_domicilio_calle;
        SELECT UPPER(NEW.domicilio_numero) INTO new_domicilio_numero;
        SELECT UPPER(NEW.domicilio_piso) INTO new_domicilio_piso;
        SELECT UPPER(NEW.domicilio_depto) INTO new_domicilio_depto;
        SELECT UPPER(NEW.domicilio_manzana) INTO new_domicilio_manzana;
        SELECT UPPER(NEW.domicilio_entre_calle_1) INTO new_domicilio_entre_calle_1;
        SELECT UPPER(NEW.domicilio_entre_calle_2) INTO new_domicilio_entre_calle_2;
        SELECT UPPER(NEW.domicilio_barrio_o_paraje) INTO new_domicilio_barrio_o_paraje;
        SELECT UPPER(NEW.domicilio_codigo_postal) INTO new_domicilio_codigo_postal;
        SELECT UPPER(NEW.apellido_de_la_madre) INTO new_apellido_de_la_madre;
        SELECT UPPER(NEW.nombre_de_la_madre) INTO new_nombre_de_la_madre;
        SELECT UPPER(NEW.apellido_del_padre) INTO new_apellido_del_padre;
        SELECT UPPER(NEW.nombre_del_padre) INTO new_nombre_del_padre;
        SELECT UPPER(NEW.apellido_del_tutor) INTO new_apellido_del_tutor;
        SELECT UPPER(NEW.nombre_del_tutor) INTO new_nombre_del_tutor;
        SELECT UPPER(NEW.nombre_del_agente_inscriptor) INTO new_nombre_del_agente_inscriptor;
        NEW.apellido = new_apellido;
        NEW.nombre = new_nombre;
        NEW.numero_de_documento = new_numero_de_documento;
        NEW.domicilio_calle = new_domicilio_calle;
        NEW.domicilio_numero = new_domicilio_numero;
        NEW.domicilio_piso = new_domicilio_piso;
        NEW.domicilio_depto = new_domicilio_depto;
        NEW.domicilio_manzana = new_domicilio_manzana;
        NEW.domicilio_entre_calle_1 = new_domicilio_entre_calle_1;
        NEW.domicilio_entre_calle_2 = new_domicilio_entre_calle_2;
        NEW.domicilio_barrio_o_paraje = new_domicilio_barrio_o_paraje;
        NEW.domicilio_codigo_postal = new_domicilio_codigo_postal;
        NEW.apellido_de_la_madre = new_apellido_de_la_madre;
        NEW.nombre_de_la_madre = new_nombre_de_la_madre;
        NEW.apellido_del_padre = new_apellido_del_padre;
        NEW.nombre_del_padre = new_nombre_del_padre;
        NEW.apellido_del_tutor = new_apellido_del_tutor;
        NEW.nombre_del_tutor = new_nombre_del_tutor;
        NEW.nombre_del_agente_inscriptor = new_nombre_del_agente_inscriptor;

        -- Devolver el registro modificado
        RETURN NEW;
      END;
    $$ LANGUAGE plpgsql;
  "

end
