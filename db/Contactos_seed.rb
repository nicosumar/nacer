# Crear las restricciones adicionales en la base de datos
class ModificarContactos < ActiveRecord::Migration
  # Funciones y disparadores para mantener los datos para las búsquedas de texto completo (FTS)
  execute "
    CREATE OR REPLACE FUNCTION contactos_fts_trigger() RETURNS trigger AS $$
      BEGIN
        -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
        IF (TG_OP = 'DELETE') THEN
          -- Eliminar el registro asociado en la tabla de búsquedas
          DELETE FROM busquedas WHERE modelo_type = 'Contacto' AND modelo_id = OLD.id;
          RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
          -- Actualizar el registro asociado en la tabla de búsquedas
          UPDATE busquedas SET
            titulo = NEW.mostrado,
            texto =
              'Contacto: '::text ||
              COALESCE(NEW.nombres || ' ', '') ||
              COALESCE(NEW.apellidos, '') ||
              ' (' ||
              COALESCE(NEW.mostrado, '') ||
              '), documento: ' ||
              COALESCE(NEW.dni, '') ||
              ', teléfono: ' ||
              COALESCE(NEW.telefono, '') ||
              ', celular: ' ||
              COALESCE(NEW.telefono_movil, '') ||
              ', e-mail: ' ||
              COALESCE(NEW.email, '') ||
              ', domicilio: ' ||
              COALESCE(NEW.domicilio, '') ||
              ', ' ||
              COALESCE(NEW.observaciones, '') ||
              '.',
            vector_fts =
              setweight(to_tsvector('public.indices_fts', 'Contacto: '::text), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombres || ' ', '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.apellidos, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ' ('), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.mostrado, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', '), documento: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.dni, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', teléfono: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.telefono, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', celular: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.telefono_movil, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', e-mail: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.email, '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', ', domicilio: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.domicilio, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.observaciones, '')), 'B')
            WHERE modelo_type = 'Contacto' AND modelo_id = NEW.id;
          RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
            'Contacto',
            NEW.id,
            NEW.mostrado,
            'Contacto: '::text ||
            COALESCE(NEW.nombres || ' ', '') ||
            COALESCE(NEW.apellidos, '') ||
            ' (' ||
            COALESCE(NEW.mostrado, '') ||
            '), documento: ' ||
            COALESCE(NEW.dni, '') ||
            ', teléfono: ' ||
            COALESCE(NEW.telefono, '') ||
            ', celular: ' ||
            COALESCE(NEW.telefono_movil, '') ||
            ', e-mail: ' ||
            COALESCE(NEW.email, '') ||
            ', domicilio: ' ||
            COALESCE(NEW.domicilio, '') ||
            ', ' ||
            COALESCE(NEW.observaciones, '') ||
            '.',
            setweight(to_tsvector('public.indices_fts', 'Contacto: '::text), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombres || ' ', '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.apellidos, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ' ('), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.mostrado, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', '), documento: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.dni, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', teléfono: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.telefono, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', celular: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.telefono_movil, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', e-mail: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.email, '')), 'B') ||
            setweight(to_tsvector('public.indices_fts', ', domicilio: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.domicilio, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.observaciones, '')), 'B'));
        END IF;
        RETURN NULL;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_contactos
      AFTER INSERT OR UPDATE OR DELETE ON contactos
      FOR EACH ROW EXECUTE PROCEDURE contactos_fts_trigger();
  "
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#Contacto.create([
#  { #:id => 1,
#    :nombres => 'MM',
#    :apellidos => 'NN',
#    :mostrado => 'Dr. MM NN' },
#  { #:id => 2,
#    ...
#
#    y así sucesivamente
#
#    ...
#    }])
