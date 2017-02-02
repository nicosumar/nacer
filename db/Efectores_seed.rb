# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarEfector < ActiveRecord::Migration
  # Claves foráneas para asegurar la integridad referencial en el motor de la base de datos
  execute "
    ALTER TABLE efectores
      ADD CONSTRAINT fk_efectores_departamentos
      FOREIGN KEY (departamento_id) REFERENCES departamentos (id);
  "
  execute "
    ALTER TABLE efectores
      ADD CONSTRAINT fk_efectores_distritos
      FOREIGN KEY (distrito_id) REFERENCES distritos (id);
  "
  execute "
    ALTER TABLE efectores
      ADD CONSTRAINT fk_efectores_grupos
      FOREIGN KEY (grupo_de_efectores_id) REFERENCES grupos_de_efectores (id);
  "
  execute "
    ALTER TABLE efectores
      ADD CONSTRAINT fk_efectores_areas_de_prestacion
      FOREIGN KEY (area_de_prestacion_id) REFERENCES areas_de_prestacion (id);
  "
  execute "
    ALTER TABLE efectores
      ADD CONSTRAINT fk_efectores_dependencias_administrativas
      FOREIGN KEY (dependencia_administrativa_id) REFERENCES dependencias_administrativas (id);
  "

  # Funciones y disparadores para mantener los datos para las búsquedas de texto completo (FTS)
  execute "
    CREATE OR REPLACE FUNCTION efectores_fts_trigger() RETURNS trigger AS $$
      DECLARE
        departamento text;
        distrito text;
        area_de_prestacion text;
        convenio_de_gestion text;
        convenio_de_administracion text;
        administrador text;
      BEGIN
        -- Actualizar la tabla de búsquedas con los datos insertados, actualizados o eliminados.
        IF (TG_OP = 'DELETE') THEN
          -- Eliminar el registro asociado en la tabla de búsquedas
          DELETE FROM busquedas WHERE modelo_type = 'Efector' AND modelo_id = OLD.id;
          RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
          -- Actualizar el registro asociado en la tabla de búsquedas
          SELECT nombre INTO departamento FROM departamentos WHERE id = NEW.departamento_id;
          SELECT nombre INTO distrito FROM distritos WHERE id = NEW.distrito_id;
          SELECT LOWER(nombre) INTO area_de_prestacion FROM areas_de_prestacion WHERE id = NEW.area_de_prestacion_id;
          SELECT numero INTO convenio_de_gestion FROM convenios_de_gestion WHERE efector_id = NEW.id;
          SELECT numero INTO convenio_de_administracion FROM convenios_de_administracion WHERE efector_id = NEW.id;
          SELECT efectores.nombre INTO administrador FROM efectores LEFT JOIN convenios_de_administracion
            ON efectores.id = convenios_de_administracion.administrador_id WHERE convenios_de_administracion.efector_id = NEW.id;
          UPDATE busquedas SET
            titulo = NEW.nombre,
            texto =
              'Efector: ' ||
              COALESCE(NEW.nombre, '') ||
              ', CUIE: ' ||
              COALESCE(NEW.cuie, '') ||
              ', código SISSA: ' ||
              COALESCE(NEW.codigo_de_efector_sissa, '') ||
              ', convenio de gestión: ' ||
              COALESCE(convenio_de_gestion, '') ||
              ', convenio de administración: ' ||
              COALESCE(convenio_de_administracion, '') ||
              ', administrador: ' ||
              COALESCE(administrador, '') ||
              ', domicilio: ' ||
              COALESCE(NEW.domicilio || ', ', '') ||
              COALESCE(distrito || ' - ', '') ||
              COALESCE(departamento, '') ||
              ', teléfonos: ' ||
              COALESCE(NEW.telefonos, '') ||
              ', e-mail: ' ||
              COALESCE(NEW.email, '') ||
              ', área: ' ||
              COALESCE(area_de_prestacion, '') ||
              ', ' ||
              COALESCE(NEW.observaciones, '') ||
              '.',
            vector_fts =
              setweight(to_tsvector('public.indices_fts', 'Efector: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombre, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', CUIE: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.cuie, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', código SISSA: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.codigo_de_efector_sissa, '')), 'A') ||
              setweight(to_tsvector('public.indices_fts', ', convenio de gestión: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(convenio_de_gestion, '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', ', convenio de administración: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(convenio_de_administracion, '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', ', administrador: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(administrador, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', domicilio: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.domicilio || ', ', '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(distrito || ' - ', '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(departamento, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', teléfonos: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.telefonos, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', e-mail: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.email, '')), 'B') ||
              setweight(to_tsvector('public.indices_fts', ', área: '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(area_de_prestacion, '')), 'C') ||
              setweight(to_tsvector('public.indices_fts', ', '), 'D') ||
              setweight(to_tsvector('public.indices_fts', COALESCE(NEW.observaciones, '')), 'A')
            WHERE modelo_type = 'Efector' AND modelo_id = NEW.id;
          RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          SELECT nombre INTO departamento FROM departamentos WHERE id = NEW.departamento_id;
          SELECT nombre INTO distrito FROM distritos WHERE id = NEW.distrito_id;
          SELECT LOWER(nombre) INTO area_de_prestacion FROM areas_de_prestacion WHERE id = NEW.area_de_prestacion_id;
          SELECT numero INTO convenio_de_gestion FROM convenios_de_gestion WHERE efector_id = NEW.id;
          SELECT numero INTO convenio_de_administracion FROM convenios_de_administracion WHERE efector_id = NEW.id;
          SELECT efectores.nombre INTO administrador FROM efectores LEFT JOIN convenios_de_administracion
            ON efectores.id = convenios_de_administracion.administrador_id WHERE convenios_de_administracion.efector_id = NEW.id;
          INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
            'Efector',
            NEW.id,
            NEW.nombre,
            'Efector: ' ||
            COALESCE(NEW.nombre, '') ||
            ', CUIE: ' ||
            COALESCE(NEW.cuie, '') ||
            ', código SISSA: ' ||
            COALESCE(NEW.codigo_de_efector_sissa, '') ||
            ', convenio de gestión: ' ||
            COALESCE(convenio_de_gestion, '') ||
            ', convenio de administración: ' ||
            COALESCE(convenio_de_administracion, '') ||
            ', administrador: ' ||
            COALESCE(administrador, '') ||
            ', domicilio: ' ||
            COALESCE(NEW.domicilio || ', ', '') ||
            COALESCE(distrito || ' - ', '') ||
            COALESCE(departamento, '') ||
            ', teléfonos: ' ||
            COALESCE(NEW.telefonos, '') ||
            ', e-mail: ' ||
            COALESCE(NEW.email, '') ||
            ', área: ' ||
            COALESCE(area_de_prestacion, '') ||
            ', ' ||
            COALESCE(NEW.observaciones, '') ||
            '.',
            setweight(to_tsvector('public.indices_fts', 'Efector: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.nombre, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', CUIE: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.cuie, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', código SISSA: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.codigo_de_efector_sissa, '')), 'A') ||
            setweight(to_tsvector('public.indices_fts', ', convenio de gestión: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(convenio_de_gestion, '')), 'B') ||
            setweight(to_tsvector('public.indices_fts', ', convenio de administración: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(convenio_de_administracion, '')), 'B') ||
            setweight(to_tsvector('public.indices_fts', ', administrador: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(administrador, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', domicilio: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.domicilio || ', ', '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(distrito || ' - ', '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(departamento, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', teléfonos: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.telefonos, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', e-mail: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.email, '')), 'B') ||
            setweight(to_tsvector('public.indices_fts', ', área: '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(area_de_prestacion, '')), 'C') ||
            setweight(to_tsvector('public.indices_fts', ', '), 'D') ||
            setweight(to_tsvector('public.indices_fts', COALESCE(NEW.observaciones, '')), 'A'));
        END IF;
        RETURN NULL;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_efectores
      AFTER INSERT OR UPDATE OR DELETE ON efectores
      FOR EACH ROW EXECUTE PROCEDURE efectores_fts_trigger();
  "

  # Funciones y disparadores para modificar los datos que se insertan/modifican en la tabla
  execute "
    CREATE OR REPLACE FUNCTION modificar_efector() RETURNS trigger AS $$
      DECLARE
        new_cuie varchar;
        new_codigo_postal varchar;
      BEGIN
        -- Modificar todos los campos tipo varchar del registro
        SELECT UPPER(NEW.cuie) INTO new_cuie;
        SELECT UPPER(NEW.codigo_postal) INTO new_codigo_postal;
        NEW.cuie = new_cuie;
        NEW.codigo_postal = new_codigo_postal;

        -- Devolver el registro modificado
        RETURN NEW;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_modificar_efector
      BEFORE INSERT OR UPDATE ON efector
      FOR EACH ROW EXECUTE PROCEDURE modificar_efector();
  "

  # Crear las funciones y disparadores que se encargan de modificar la estructura de la BB.DD.
  # cada vez que se agrega una nueva unidad de alta de datos
  execute "
    -- FUNCTION: crear_secuencia_de_cuasifacturas
    -- La función se encarga de crear las secuencias para generar los números correlativos de
    -- cuasifacturas.
    CREATE OR REPLACE FUNCTION crear_secuencia_de_cuasifacturas() RETURNS trigger AS $$
      DECLARE
        existe bool;
      BEGIN
        SELECT COUNT(*) > 0
          FROM information_schema.sequences
          WHERE
            sequence_schema = 'public'
            AND sequence_name = ('cuasifactura_sumar_seq_efector_id_' || NEW.id::text)
          INTO existe;

        IF (NEW.unidad_de_alta_de_datos_id IS NOT NULL AND NOT existe) THEN
          EXECUTE 'CREATE SEQUENCE public.cuasifactura_sumar_seq_efector_id_' || NEW.id::text;
        END IF;
        RETURN NEW;
      END;
    $$ LANGUAGE plpgsql;
  "

  execute "
    CREATE TRIGGER cambio_de_uad_en_efectores
      AFTER INSERT OR UPDATE OF unidad_de_alta_de_datos_id ON efectores
      FOR EACH ROW EXECUTE PROCEDURE crear_secuencia_de_cuasifacturas();
  "

end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#Efector.create([
#  { #:id => 1,
#    :cuie => '?00001',
#    :codigo_de_efector_sissa => '??????????????',
#    :codigo_de_efector_bio => nil,
#    :nombre => 'Centro de Salud Nº xx «XXXXXXXXX»',
#    :domicilio => 'Ignorado',
#    :departamento_id => 99,
#    :distrito_id => 99,
#    :codigo_postal => '0000',
#    :latitud => '-00° 00\' 00.00"',
#    :longitud => '-00° 00\' 00.00"',
#    :telefonos => '555-555',
#    :grupo_de_efectores_id => 2,
#    :area_de_prestacion_id => 1,
#    :dependencia_administrativa_id => 1,
#    :integrante => true },
#  { #:id => 2,
#    ...
#
#    y así sucesivamente
#
#    ...
#    }])
