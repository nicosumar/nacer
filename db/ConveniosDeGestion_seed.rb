# Crear las restricciones adicionales en la base de datos
class ModificarConveniosDeGestion < ActiveRecord::Migration
  # Claves foráneas para asegurar la integridad referencial en el motor de la base de datos
  execute "
    ALTER TABLE convenios_de_gestion
      ADD CONSTRAINT fk_convenios_de_gestion_efectores
      FOREIGN KEY (efector_id) REFERENCES efectores (id);
  "
  execute "
    ALTER TABLE convenios_de_gestion
      ADD CONSTRAINT unq_convenios_de_gestion_efector_id
      UNIQUE (efector_id);
  "
  execute "
    ALTER TABLE convenios_de_gestion
      ADD CONSTRAINT unq_convenios_de_gestion_numero
      UNIQUE (numero);
  "

  # Funciones y disparadores para mantener los datos para las búsquedas de texto completo (FTS)
  execute "
    CREATE OR REPLACE FUNCTION conv_gestion_fts_trigger() RETURNS trigger AS $$
      DECLARE
        nombre_efector text;
      BEGIN
        -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
        IF (TG_OP = 'DELETE') THEN
          -- Eliminar el registro asociado en la tabla de búsquedas
          DELETE FROM busquedas WHERE modelo_type = 'ConvenioDeGestion' AND modelo_id = OLD.id;
          RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
          -- Actualizar el registro asociado en la tabla de búsquedas
          SELECT nombre INTO nombre_efector FROM efectores WHERE id = NEW.efector_id;
          UPDATE busquedas SET
            titulo = 'Convenio de gestión ' || NEW.numero,
            texto =
              'Convenio de gestión número ' ||
              COALESCE(NEW.numero, '') ||
              ', efector: ' ||
              COALESCE(nombre_efector, '') ||
              ', firmante: ' ||
              COALESCE(NEW.firmante, '') ||
              ', ' ||
              COALESCE(NEW.observaciones, '') ||
              '.',
            vector_fts =
              setweight(to_tsvector('public.indices_fts', 'Convenio de gestión número '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', efector: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(nombre_efector, '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', ', firmante: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.firmante, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.observaciones, '')), 'B')
            WHERE modelo_type = 'ConvenioDeGestion' AND modelo_id = NEW.id;
          RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          SELECT nombre INTO nombre_efector FROM efectores WHERE id = NEW.efector_id;
          INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
            'ConvenioDeGestion',
            NEW.id,
            'Convenio de gestión ' || NEW.numero,
            'Convenio de gestión número ' ||
            COALESCE(NEW.numero, '') ||
            ', efector: ' ||
            COALESCE(nombre_efector, '') ||
            ', firmante: ' ||
            COALESCE(NEW.firmante, '') ||
            ', ' ||
            COALESCE(NEW.observaciones, '') ||
            '.',
            setweight(to_tsvector('public.indices_fts', 'Convenio de gestión número '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', efector: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(nombre_efector, '')), 'B') ||
            setweight(to_tsvector('public.indices_fts', ', firmante: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.firmante, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.observaciones, '')), 'B'));
        END IF;
        RETURN NULL;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_convenios_de_gestion
      AFTER INSERT OR UPDATE OR DELETE ON convenios_de_gestion
      FOR EACH ROW EXECUTE PROCEDURE conv_gestion_fts_trigger();
  "
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#ConvenioDeGestion.create([
#  { #:id => 1,
#    :numero => 'G1',
#    :efector_id => 1,
#    :firmante => 'Dr. MM NN',
#    :fecha_de_suscripcion => '2001-01-01',
#    :fecha_de_inicio => '2001-01-01',
#    :fecha_de_finalizacion => '2001-01-01' },
#  { #:id => 2,
#    ...
#
#    y así sucesivamente
#
#    ...
#    }])
