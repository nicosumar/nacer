# Crear las restricciones adicionales en la base de datos
class ModificarAddenda < ActiveRecord::Migration
  # Claves foráneas para asegurar la integridad referencial
  execute "
    ALTER TABLE addendas
      ADD CONSTRAINT fk_addendas_convenios_de_gestion
      FOREIGN KEY (convenio_de_gestion_id) REFERENCES convenios_de_gestion (id);
  "
  execute "
    ALTER TABLE addendas
      ADD CONSTRAINT unq_addendas_numero
      UNIQUE (numero);
  "

  # Funciones y disparadores para mantener los datos para las búsquedas de texto completo (FTS)
  execute "
    CREATE OR REPLACE FUNCTION addendas_fts_trigger() RETURNS trigger AS $$
      DECLARE
        convenio_de_gestion text;
      BEGIN
        -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
        IF (TG_OP = 'DELETE') THEN
          -- Eliminar el registro asociado en la tabla de búsquedas
          DELETE FROM busquedas WHERE modelo_type = 'Addenda' AND modelo_id = OLD.id;
          RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
          -- Actualizar el registro asociado en la tabla de búsquedas
          SELECT numero INTO convenio_de_gestion FROM convenios_de_gestion WHERE id = NEW.convenio_de_gestion_id;
          UPDATE busquedas SET
            titulo = 'Adenda ' || COALESCE(NEW.numero || ' ', '') || 'al convenio de gestión ' || COALESCE(convenio_de_gestion, ''),
            texto =
              'Adenda número: ' ||
              COALESCE(NEW.numero, '') ||
              ', convenio de gestión: ' ||
              COALESCE(convenio_de_gestion, '') ||
              ', fecha de suscripción: ' ||
              COALESCE(to_char(NEW.fecha_de_suscripcion, 'DD/MM/YYYY'), '') ||
              ', fecha de inicio: ' ||
              COALESCE(to_char(NEW.fecha_de_inicio, 'DD/MM/YYYY'), '') ||
              '.',
            vector_fts =
              setweight(to_tsvector('public.indices_fts', 'Adenda número: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', convenio de gestión: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(convenio_de_gestion, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', fecha de suscripción: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_suscripcion, 'DD/MM/YYYY'), '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', ', fecha de inicio: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_inicio, 'DD/MM/YYYY'), '')), 'B')
            WHERE modelo_type = 'Addenda' AND modelo_id = NEW.id;
          RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          -- Insertar un registro asociado en la tabla de búsquedas
          SELECT numero INTO convenio_de_gestion FROM convenios_de_gestion WHERE id = NEW.convenio_de_gestion_id;
          INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
            'Addenda',
            NEW.id,
            'Adenda ' || COALESCE(NEW.numero || ' ', '') || 'al convenio de gestión ' || COALESCE(convenio_de_gestion, ''),
            'Adenda número: ' ||
            COALESCE(NEW.numero, '') ||
            ', convenio de gestión: ' ||
            COALESCE(convenio_de_gestion, '') ||
            ', fecha de suscripción: ' ||
            COALESCE(to_char(NEW.fecha_de_suscripcion, 'DD/MM/YYYY'), '') ||
            ', fecha de inicio: ' ||
            COALESCE(to_char(NEW.fecha_de_inicio, 'DD/MM/YYYY'), '') ||
            '.',
            setweight(to_tsvector('public.indices_fts', 'Adenda número: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.numero, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', convenio de gestión: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(convenio_de_gestion, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', fecha de suscripción: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_suscripcion, 'DD/MM/YYYY'), '')), 'B') ||
            setweight(to_tsvector('public.indices_fts', ', fecha de inicio: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(to_char(NEW.fecha_de_inicio, 'DD/MM/YYYY'), '')), 'B');
          RETURN NEW;
        END IF;
        RETURN NULL;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_addendas
      AFTER INSERT OR UPDATE OR DELETE ON addendas
      FOR EACH ROW EXECUTE PROCEDURE addendas_fts_trigger();
  "

  # Funciones y disparadores para modificar los datos que se insertan/modifican en la tabla
  execute "
    CREATE OR REPLACE FUNCTION modificar_addenda() RETURNS trigger AS $$
      DECLARE
        new_numero varchar;
      BEGIN
        -- Modificar todos los campos tipo varchar del registro
        SELECT UPPER(NEW.numero) INTO new_numero;
        NEW.numero = new_numero;

        -- Devolver el registro modificado
        RETURN NEW;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_modificar_addenda
      BEFORE INSERT OR UPDATE ON addendas
      FOR EACH ROW EXECUTE PROCEDURE modificar_addenda();
  "
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#Addenda.create([
#  { #:id => 1,
#    :numero => 1,
#    :convenio_de_gestion_id => 1,
#    :firmante => 'Dr. NN',
#    :fecha_de_suscripcion => '2001-01-01',
#    :fecha_de_inicio => '2001-01-01' },
#  { #:id => 2,
#    :numero => 2,
#    :convenio_de_gestion_id => 1,
#    ...
#
#    y así sucesivamente
#
#    ...
#  }])
