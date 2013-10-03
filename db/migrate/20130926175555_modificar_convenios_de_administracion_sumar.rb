# -*- encoding : utf-8 -*-
class ModificarConveniosDeAdministracionSumar < ActiveRecord::Migration
  def up
    remove_column :convenios_de_administracion_sumar, :firmante
    add_column :convenios_de_administracion_sumar, :firmante_id, :integer

    # Actualizar la función que mantiene el índice para las búsquedas de texto completo
    execute "
      CREATE OR REPLACE FUNCTION conv_administracion_sumar_fts_trigger() RETURNS trigger AS $$
        DECLARE
          nombre_administrador text;
          nombre_efector text;
          referente_firmante text;
        BEGIN
          -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
          IF (TG_OP = 'DELETE') THEN
            -- Eliminar el registro asociado en la tabla de búsquedas
            DELETE FROM busquedas WHERE modelo_type = 'ConvenioDeAdministracionSumar' AND modelo_id = OLD.id;
            RETURN OLD;
          ELSIF (TG_OP = 'UPDATE') THEN
            -- Actualizar el registro asociado en la tabla de búsquedas
            SELECT nombre INTO nombre_efector FROM efectores WHERE id = NEW.efector_id;
            SELECT nombre INTO nombre_administrador FROM efectores WHERE id = NEW.administrador_id;
            IF (NEW.firmante_id IS NOT NULL) THEN
              SELECT c.mostrado INTO referente_firmante
                FROM contactos c
                  JOIN referentes r ON (r.contacto_id = c.id)
                WHERE r.id = NEW.firmante_id
                LIMIT 1;
            END IF;

            UPDATE busquedas SET
              titulo = 'Convenio de administración Sumar' || NEW.numero,
              texto =
                'Convenio de administración número ' ||
                COALESCE(NEW.numero, '') ||
                ', efector administrado: ' ||
                COALESCE(nombre_efector, '') ||
                ', administrador: ' ||
                COALESCE(nombre_administrador, '') ||
                ', firmante: ' ||
                COALESCE(referente_firmante, '') ||
                ', ' ||
                COALESCE(NEW.observaciones, '') ||
                '.',
              vector_fts =
                setweight(to_tsvector('public.indices_fts', 'Convenio de administración número '), 'D') ||
                setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero, '')), 'A') ||
                setweight(to_tsvector('public.indices_fts', ', efector administrado: '), 'D') ||
                setweight(to_tsvector('public.indices_fts', COALESCE(nombre_efector, '')), 'B') ||
                setweight(to_tsvector('public.indices_fts', ', administrador: '), 'D') ||
                setweight(to_tsvector('public.indices_fts', COALESCE(nombre_administrador, '')), 'B') ||
                setweight(to_tsvector('public.indices_fts', ', firmante: '), 'D') ||
                setweight(to_tsvector('public.indices_fts', COALESCE(referente_firmante, '')), 'C') ||
                setweight(to_tsvector('public.indices_fts', ', '), 'D') ||
                setweight(to_tsvector('public.indices_fts', COALESCE(NEW.observaciones, '')), 'B')
              WHERE modelo_type = 'ConvenioDeAdministracionSumar' AND modelo_id = NEW.id;
            RETURN NEW;
          ELSIF (TG_OP = 'INSERT') THEN
            SELECT nombre INTO nombre_efector FROM efectores WHERE id = NEW.efector_id;
            SELECT nombre INTO nombre_administrador FROM efectores WHERE id = NEW.administrador_id;
            IF (NEW.firmante_id IS NOT NULL) THEN
              SELECT c.mostrado INTO referente_firmante
                FROM contactos c
                  JOIN referentes r ON (r.contacto_id = c.id)
                WHERE r.id = NEW.firmante_id
                LIMIT 1;
            END IF;

            INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
              'ConvenioDeAdministracionSumar',
              NEW.id,
              'Convenio de administración Sumar' || NEW.numero,
              'Convenio de administración número ' ||
              COALESCE(NEW.numero, '') ||
              ', efector administrado: ' ||
              COALESCE(nombre_efector, '') ||
              ', administrador: ' ||
              COALESCE(nombre_administrador, '') ||
              ', firmante: ' ||
              COALESCE(referente_firmante, '') ||
              ', ' ||
              COALESCE(NEW.observaciones, '') ||
              '.',
              setweight(to_tsvector('public.indices_fts', 'Convenio de administración número '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', efector administrado: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(nombre_efector, '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', ', administrador: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(nombre_administrador, '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', ', firmante: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(referente_firmante, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.observaciones, '')), 'B'));
            RETURN NEW;
          END IF;
          RETURN NULL;
        END;
      $$ LANGUAGE plpgsql;
    "
  end

  def down
    remove_column :convenios_de_administracion_sumar, :firmante_id
    add_column :convenios_de_administracion_sumar, :firmante, :string
  end
end
