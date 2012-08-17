# Crear las restricciones adicionales en la base de datos
class ModificarConveniosDeAdministracion < ActiveRecord::Migration
  # Claves foráneas para asegurar la integridad referencial en el motor de la base de datos
  execute "
    ALTER TABLE convenios_de_administracion
      ADD CONSTRAINT fk_convenios_de_administracion_administrador
      FOREIGN KEY (administrador_id) REFERENCES efectores (id);
  "
  execute "
    ALTER TABLE convenios_de_administracion
      ADD CONSTRAINT fk_convenios_de_administracion_efectores
      FOREIGN KEY (efector_id) REFERENCES efectores (id);
  "
  execute "
    ALTER TABLE convenios_de_administracion
      ADD CONSTRAINT unq_convenios_de_administracion_efector_id
      UNIQUE (efector_id);
  "
  execute "
    ALTER TABLE convenios_de_administracion
      ADD CONSTRAINT unq_convenios_de_administracion_numero
      UNIQUE (numero);
  "

  # Funciones y disparadores para mantener los datos para las búsquedas de texto completo (FTS)
  execute "
    CREATE OR REPLACE FUNCTION conv_administracion_fts_trigger() RETURNS trigger AS $$
      DECLARE
        nombre_administrador text;
        nombre_efector text;
      BEGIN
        -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
        IF (TG_OP = 'DELETE') THEN
          -- Eliminar el registro asociado en la tabla de búsquedas
          DELETE FROM busquedas WHERE modelo_type = 'ConvenioDeAdministracion' AND modelo_id = OLD.id;
          RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
          -- Actualizar el registro asociado en la tabla de búsquedas
          SELECT nombre INTO nombre_efector FROM efectores WHERE id = NEW.efector_id;
          SELECT nombre INTO nombre_administrador FROM efectores WHERE id = NEW.administrador_id;
          UPDATE busquedas SET
            titulo = 'Convenio de administración ' || NEW.numero,
            texto =
              COALESCE('Convenio de administración número '::text || NEW.numero || '. ', '') ||
              COALESCE('Efector: '::text || nombre_efector || '. ', '') ||
              COALESCE('Administrador: '::text || nombre_administrador || '. ', '') ||
              COALESCE('Firmante: '::text || NEW.firmante || '. ', '') ||
              COALESCE('Observaciones: '::text || NEW.observaciones, ''),
            vector_fts =
              setweight(to_tsvector('public.indices_fts', COALESCE('Convenio de administración número '::text || NEW.numero || '. ', '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', COALESCE('Efector: '::text || nombre_efector || '. ', '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', COALESCE('Administrador: '::text || nombre_administrador || '. ', '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', COALESCE('Firmante: '::text || NEW.firmante || '. ', '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', COALESCE('Observaciones: '::text || NEW.observaciones, '')), 'D')
            WHERE modelo_type = 'ConvenioDeAdministracion' AND modelo_id = NEW.id;
          RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          SELECT nombre INTO nombre_efector FROM efectores WHERE id = NEW.efector_id;
          SELECT nombre INTO nombre_administrador FROM efectores WHERE id = NEW.administrador_id;
          INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
            'ConvenioDeAdministracion',
            NEW.id,
            'Convenio de administración ' || NEW.numero,
            COALESCE('Convenio de administración número '::text || NEW.numero || '. ', '') ||
              COALESCE('Efector: '::text || nombre_efector || '. ', '') ||
              COALESCE('Administrador: '::text || nombre_administrador || '. ', '') ||
              COALESCE('Firmante: '::text || NEW.firmante || '. ', '') ||
              COALESCE('Observaciones: '::text || NEW.observaciones, ''),
            setweight(to_tsvector('public.indices_fts', COALESCE('Convenio de administración número '::text || NEW.numero || '. ', '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', COALESCE('Efector: '::text || nombre_efector || '. ', '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', COALESCE('Administrador: '::text || nombre_administrador || '. ', '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', COALESCE('Firmante: '::text || NEW.firmante || '. ', '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', COALESCE('Observaciones: '::text || NEW.observaciones, '')), 'D'));
        END IF;
        RETURN NULL;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_convenios_de_administracion
      AFTER INSERT OR UPDATE OR DELETE ON convenios_de_administracion
      FOR EACH ROW EXECUTE PROCEDURE conv_administracion_fts_trigger();
  "
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#ConvenioDeAdministracion.create([
#  { #:id => 1',
#    :numero => 'A1',
#    :administrador_id => 1,
#    :efector_id => 1,
#    :firmante => 'Dr. MM NN',
#    :fecha_de_suscripcion => '2001-01-01',
#    :fecha_de_inicio => '2001-01-01',
#    :fecha_de_finalizacion => '2002-01-01' },
#  { #:id => 2',
#    ...
#
#    y así sucesivamente
#
#    ...
#    }])
