# Crear las restricciones adicionales en la base de datos
class CrearTriggerModificarUsuario < ActiveRecord::Migration
  # Funciones y disparadores para mantener los datos para las búsquedas de texto completo (FTS)
  execute "
    CREATE OR REPLACE FUNCTION users_fts_trigger() RETURNS trigger AS $$
      BEGIN
        -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
        IF (TG_OP = 'DELETE') THEN
          -- Eliminar el registro asociado en la tabla de búsquedas
          DELETE FROM busquedas WHERE modelo_type = 'User' AND modelo_id = OLD.id;
          RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
          -- Actualizar el registro asociado en la tabla de búsquedas
          UPDATE busquedas SET
            titulo = NEW.nombre || ' ' || NEW.apellido,
            texto =
              'Usuario: ' ||
              NEW.nombre || ' ' || NEW.apellido ||
              ', e-mail: ' ||
              NEW.email ||
              ', fecha de nacimiento: ' ||
              COALESCE(to_char(NEW.fecha_de_nacimiento, 'DD/MM/YYYY'), '') ||
              COALESCE(', ' || NEW.observaciones, '') || '.',
            vector_fts =
              setweight(to_tsvector('public.indices_fts', 'Usuario: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', NEW.nombre || ' ' || NEW.apellido), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', e-mail: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', NEW.email), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', fecha de nacimiento: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_nacimiento, 'DD/MM/YYYY'), '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(', ' || NEW.observaciones, '')), 'D')
            WHERE modelo_type = 'User' AND modelo_id = NEW.id;
          RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
            'User',
            NEW.id,
            NEW.nombre || ' ' || NEW.apellido,
            'Usuario: ' ||
            NEW.nombre || ' ' || NEW.apellido ||
            ', e-mail: ' ||
            NEW.email ||
            ', fecha de nacimiento: ' ||
            COALESCE(to_char(NEW.fecha_de_nacimiento, 'DD/MM/YYYY'), '') ||
            COALESCE(', ' || NEW.observaciones, '') || '.',
            setweight(to_tsvector('public.indices_fts', 'Usuario: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', NEW.nombre || ' ' || NEW.apellido), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', e-mail: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', NEW.email), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', fecha de nacimiento: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_nacimiento, 'DD/MM/YYYY'), '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(', ' || NEW.observaciones, '')), 'D');
        END IF;
        RETURN NULL;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_users
      AFTER INSERT OR UPDATE OR DELETE ON users
      FOR EACH ROW EXECUTE PROCEDURE users_fts_trigger();
  "

  # Funciones y disparadores para modificar los datos que se insertan/modifican en la tabla
  execute "
    CREATE OR REPLACE FUNCTION modificar_user() RETURNS trigger AS $$
      DECLARE
        new_apellido varchar;
        new_nombre varchar;
      BEGIN
        -- Modificar todos los campos tipo varchar del registro
        SELECT UPPER(NEW.apellido) INTO new_apellido;
        SELECT UPPER(NEW.nombre) INTO new_nombre;
        NEW.apellido = new_apellido;
        NEW.nombre = new_nombre;

        -- Devolver el registro modificado
        RETURN NEW;
      END;
    $$ LANGUAGE plpgsql;
  "

  execute "
    CREATE TRIGGER trg_modificar_user
      BEFORE INSERT OR UPDATE ON users
      FOR EACH ROW EXECUTE PROCEDURE modificar_user
  "
end
