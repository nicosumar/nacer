# -*- encoding : utf-8 -*-
class AddNuevasFuncionesNumeracionDocumentos < ActiveRecord::Migration
  
  def up
    execute <<-SQL
      /*Funcion de generación de cuasifacturas*/
      CREATE OR REPLACE FUNCTION generar_numero_cuasifactura(arg_cuasifactura_id liquidaciones_sumar_cuasifacturas.id%TYPE ) 
        RETURNS liquidaciones_sumar_cuasifacturas.numero_cuasifactura%TYPE AS $$
      DECLARE 
        v_secuencia INT;
        v_secuencia_nombre VARCHAR;
        v_query varchar;
        v_cuasifactura liquidaciones_sumar_cuasifacturas%ROWTYPE;
      BEGIN
        SELECT * INTO v_cuasifactura FROM liquidaciones_sumar_cuasifacturas WHERE id = arg_cuasifactura_id;

        v_secuencia_nombre = 'cuasi_factura_sumar_seq_efector_id_'||CAST(v_cuasifactura.efector_id  as varchar);
        v_query = 'SELECT ' ||
              '(CASE ' ||
              'WHEN is_called THEN last_value + 1 '||
              'ELSE last_value ' ||
              'END)  FROM ' || v_secuencia_nombre ;

        EXECUTE v_query INTO v_secuencia;

        v_secuencia =  nextval(v_secuencia_nombre::text);
        RETURN to_char(v_cuasifactura.efector_id, '0000') ||'-'|| to_char(v_secuencia, '00000000');

      END;
      $$ LANGUAGE plpgsql;
      /*Dropeo el trigger que genera la numeración*/
      DROP TRIGGER IF EXISTS "generar_Cuasifactura" ON "public"."liquidaciones_sumar_cuasifacturas";
    SQL
  end

  def down
  end
end
