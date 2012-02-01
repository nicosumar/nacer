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
              'Datos de contacto para '::text || COALESCE(NEW.nombres || ' '::text || NEW.apellidos || ' ('::text || NEW.mostrado || ')'::text,
                NEW.mostrado, '') ||
              COALESCE('DNI: '::text || NEW.dni || '. ', '') ||
              COALESCE('Teléfono: '::text || NEW.telefono || '. ', '') ||
              COALESCE('E-mail: '::text || NEW.email || '. ', '') ||
              COALESCE('Domicilio: '::text || NEW.domicilio || '. ', '') ||
              COALESCE('Celular: '::text || NEW.telefono_movil || '. ', '') ||
              COALESCE('Observaciones: '::text || NEW.observaciones, ''),
            vector_fts =
              setweight(to_tsvector('public.es_ar',
                'Datos de contacto para '::text || COALESCE(NEW.nombres || ' '::text ||  NEW.apellidos || ' ('::text || NEW.mostrado || ')'::text,
                NEW.mostrado, '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('DNI: '::text || NEW.dni || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Teléfono: '::text || NEW.telefono || '. ', '')), 'D') ||
              setweight(to_tsvector('public.es_ar', COALESCE('E-mail: '::text || NEW.email || '. ', '')), 'D') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Domicilio: '::text || NEW.domicilio || '. ', '')), 'D') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Celular: '::text || NEW.telefono_movil || '. ', '')), 'D') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Observaciones: '::text || NEW.observaciones, '')), 'D')
            WHERE modelo_type = 'Contacto' AND modelo_id = NEW.id;
          RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
            'Contacto',
            NEW.id,
            NEW.mostrado,
            'Datos de contacto para '::text || COALESCE(NEW.nombres || ' '::text || NEW.apellidos || ' ('::text || NEW.mostrado || ')'::text,
              NEW.mostrado, '') ||
              COALESCE('Teléfono: '::text || NEW.telefono || '. ', '') ||
              COALESCE('E-mail: '::text || NEW.email || '. ', '') ||
              COALESCE('Domicilio: '::text || NEW.domicilio || '. ', '') ||
              COALESCE('Celular: '::text || NEW.telefono_movil || '. ', '') ||
              COALESCE('Observaciones: '::text || NEW.observaciones, ''),
            setweight(to_tsvector('public.es_ar',
              'Datos de contacto para '::text || COALESCE(NEW.nombres || ' '::text || NEW.apellidos || ' ('::text || NEW.mostrado || ')'::text,
              NEW.mostrado, '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Teléfono: '::text || NEW.telefono || '. ', '')), 'D') ||
              setweight(to_tsvector('public.es_ar', COALESCE('E-mail: '::text || NEW.email || '. ', '')), 'D') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Domicilio: '::text || NEW.domicilio || '. ', '')), 'D') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Celular: '::text || NEW.telefono_movil || '. ', '')), 'D') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Observaciones: '::text || NEW.observaciones, '')), 'D'));
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
