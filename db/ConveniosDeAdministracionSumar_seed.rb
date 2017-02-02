# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarConveniosDeAdministracionSumar < ActiveRecord::Migration
  # Claves foráneas para asegurar la integridad referencial en el motor de la base de datos
  execute "
    ALTER TABLE convenios_de_administracion_sumar
      ADD CONSTRAINT fk_convenios_de_administracion_sumar_administrador
      FOREIGN KEY (administrador_id) REFERENCES efectores (id);
  "
  execute "
    ALTER TABLE convenios_de_administracion_sumar
      ADD CONSTRAINT fk_convenios_de_administracion_sumar_efectores
      FOREIGN KEY (efector_id) REFERENCES efectores (id);
  "
  execute "
    ALTER TABLE convenios_de_administracion_sumar
      ADD CONSTRAINT unq_convenios_de_administracion_sumar_efector_id
      UNIQUE (efector_id);
  "
  execute "
    ALTER TABLE convenios_de_administracion_sumar
      ADD CONSTRAINT unq_convenios_de_administracion_sumar_numero
      UNIQUE (numero);
  "

  # Funciones y disparadores para mantener los datos para las búsquedas de texto completo (FTS)
  execute "
    CREATE OR REPLACE FUNCTION conv_administracion_sumar_fts_trigger() RETURNS trigger AS $$
      DECLARE
        nombre_administrador text;
        nombre_efector text;
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
              COALESCE(NEW.firmante, '') ||
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
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.firmante, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.observaciones, '')), 'B')
            WHERE modelo_type = 'ConvenioDeAdministracionSumar' AND modelo_id = NEW.id;
          RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          SELECT nombre INTO nombre_efector FROM efectores WHERE id = NEW.efector_id;
          SELECT nombre INTO nombre_administrador FROM efectores WHERE id = NEW.administrador_id;
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
            COALESCE(NEW.firmante, '') ||
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
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.firmante, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.observaciones, '')), 'B'));
          RETURN NEW;
        END IF;
        RETURN NULL;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_convenios_de_administracion_sumar
      AFTER INSERT OR UPDATE OR DELETE ON convenios_de_administracion_sumar
      FOR EACH ROW EXECUTE PROCEDURE conv_administracion_sumar_fts_trigger();
  "

  execute "
    CREATE TRIGGER trg_cas_efectores
      AFTER INSERT OR UPDATE OF numero ON convenios_de_administracion_sumar
      FOR EACH ROW EXECUTE PROCEDURE ca_efectores_fts_trigger();
  "

  # Funciones y disparadores para modificar los datos que se insertan/modifican en la tabla
  execute "
    CREATE OR REPLACE FUNCTION modificar_convenio_de_administracion_sumar() RETURNS trigger AS $$
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
    CREATE TRIGGER trg_modificar_convenio_de_administracion_sumar
      BEFORE INSERT OR UPDATE ON convenios_de_administracion_sumar
      FOR EACH ROW EXECUTE PROCEDURE modificar_convenio_de_administracion_sumar();
  "
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#ConvenioDeAdministracionSumar.create([
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
