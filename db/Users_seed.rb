# Crear las restricciones adicionales en la base de datos
class CrearTriggerModificarUsuario < ActiveRecord::Migration
  # Funciones y disparadores para modificar los datos que se insertan/modifican en la tabla
  execute "
    CREATE OR REPLACE FUNCTION modificar_usuario() RETURNS trigger AS $$
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
    CREATE TRIGGER trg_modificar_usuario
      BEFORE INSERT OR UPDATE ON usuario
      FOR EACH ROW EXECUTE PROCEDURE modificar_usuario();
  "
end
