# -*- encoding : utf-8 -*-

# Trigger que se activa cuando se modifica o agrega una UAD para disparar la función que modifica la estructura del esquema asociado a la UAD,
# incorporando las tablas necesarias
ActiveRecord::Base.connection.execute <<-SQL
  DROP TRIGGER IF EXISTS agregar_o_modificar_uad ON "public"."unidades_de_alta_de_datos";
  CREATE TRIGGER agregar_o_modificar_uad
    AFTER INSERT OR UPDATE OF inscripcion, facturacion, proceso_de_datos
    ON unidades_de_alta_de_datos
    FOR EACH ROW
    EXECUTE PROCEDURE crear_esquema_para_uad();
SQL
