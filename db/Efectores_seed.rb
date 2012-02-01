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
          SELECT nombre INTO area_de_prestacion FROM areas_de_prestacion WHERE id = NEW.area_de_prestacion_id;
          SELECT numero INTO convenio_de_gestion FROM convenios_de_gestion WHERE efector_id = NEW.id;
          SELECT numero INTO convenio_de_administracion FROM convenios_de_administracion WHERE efector_id = NEW.id;
          SELECT efectores.nombre INTO administrador FROM efectores LEFT JOIN convenios_de_administracion
            ON efectores.id = convenios_de_administracion.administrador_id WHERE convenios_de_administracion.efector_id = NEW.id;
          UPDATE busquedas SET
            titulo = NEW.nombre,
            texto =
              COALESCE('Efector: '::text || NEW.nombre || '. ', '') ||
              COALESCE('CUIE: '::text || NEW.cuie || '. ', '') ||
              COALESCE('Convenio de gestión '::text || convenio_de_gestion || '. ', '') ||
              COALESCE('Convenio de administración '::text || convenio_de_administracion || '. ', '') ||
              COALESCE('Administrador: '::text || administrador || '. ', '') ||
              COALESCE('Domicilio: '::text || NEW.domicilio || ', ' || distrito || ' - ' || departamento || '. ', '') ||
              COALESCE('Teléfonos: '::text || NEW.telefonos || '. ', '') ||
              COALESCE('E-mail: '::text || NEW.email || '. ', '') ||
              COALESCE('Área de prestación: '::text || area_de_prestacion || '. ', '') ||
              COALESCE('Código SISSA: '::text || NEW.efector_sissa_id || '. ', '') ||
              COALESCE('Observaciones: '::text || NEW.observaciones, ''),
            vector_fts =
              setweight(to_tsvector('public.es_ar', COALESCE('Efector: '::text || NEW.nombre || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('CUIE: '::text || NEW.cuie || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Convenio de gestión '::text || convenio_de_gestion || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Convenio de administración '::text || 
                convenio_de_administracion || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Administrador: '::text || administrador || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Domicilio: '::text || NEW.domicilio || ', ' || distrito || ' - ' ||
                departamento || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Teléfonos: '::text || NEW.telefonos || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('E-mail: '::text || NEW.email || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Área de prestación: '::text || area_de_prestacion || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Código SISSA: '::text || NEW.efector_sissa_id || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Observaciones: '::text || NEW.observaciones, '')), 'D')
            WHERE modelo_type = 'Efector' AND modelo_id = NEW.id;
          RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
          SELECT nombre INTO departamento FROM departamentos WHERE id = NEW.departamento_id;
          SELECT nombre INTO distrito FROM distritos WHERE id = NEW.distrito_id;
          SELECT nombre INTO area_de_prestacion FROM areas_de_prestacion WHERE id = NEW.area_de_prestacion_id;
          SELECT numero INTO convenio_de_gestion FROM convenios_de_gestion WHERE efector_id = NEW.id;
          SELECT numero INTO convenio_de_administracion FROM convenios_de_administracion WHERE efector_id = NEW.id;
          SELECT efectores.nombre INTO administrador FROM efectores LEFT JOIN convenios_de_administracion
            ON efectores.id = convenios_de_administracion.administrador_id WHERE convenios_de_administracion.efector_id = NEW.id;
          INSERT INTO busquedas (modelo_type, modelo_id, titulo, texto, vector_fts) VALUES (
            'Efector',
            NEW.id,
            NEW.nombre,
            COALESCE('Efector: '::text || NEW.nombre || '. ', '') ||
              COALESCE('CUIE: '::text || NEW.cuie || '. ', '') ||
              COALESCE('Convenio de gestión '::text || convenio_de_gestion || '. ', '') ||
              COALESCE('Convenio de administración '::text || convenio_de_administracion || '. ', '') ||
              COALESCE('Administrador: '::text || administrador || '. ', '') ||
              COALESCE('Domicilio: '::text || NEW.domicilio || ', ' || distrito || ' - ' || departamento || '. ', '') ||
              COALESCE('Teléfonos: '::text || NEW.telefonos || '. ', '') ||
              COALESCE('E-mail: '::text || NEW.email || '. ', '') ||
              COALESCE('Área de prestación: '::text || area_de_prestacion || '. ', '') ||
              COALESCE('Código SISSA: '::text || NEW.efector_sissa_id || '. ', '') ||
              COALESCE('Observaciones: '::text || NEW.observaciones, ''),
            setweight(to_tsvector('public.es_ar', COALESCE('Efector: '::text || NEW.nombre || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('CUIE: '::text || NEW.cuie || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Convenio de gestión '::text || convenio_de_gestion || '. ', '')), 'B') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Convenio de administración '::text || 
                convenio_de_administracion || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Administrador: '::text || administrador || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Domicilio: '::text || NEW.domicilio || ', ' || distrito || ' - ' ||
                departamento || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Teléfonos: '::text || NEW.telefonos || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('E-mail: '::text || NEW.email || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Área de prestación: '::text || area_de_prestacion || '. ', '')), 'C') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Código SISSA: '::text || NEW.efector_sissa_id || '. ', '')), 'A') ||
              setweight(to_tsvector('public.es_ar', COALESCE('Observaciones: '::text || NEW.observaciones, '')), 'D'));
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
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#Efector.create([
#  { #:id => 1,
#    :cuie => '?00001',
#    :efector_sissa_id => '??????????????',
#    :efector_bio_id => nil,
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
