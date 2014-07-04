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

    execute <<-SQL
      /*Funcion de generación de cuasifacturas*/
      CREATE OR REPLACE FUNCTION generar_numero_consolidado(arg_consolidado_id consolidados_sumar.id%TYPE ) 
        RETURNS consolidados_sumar.numero_de_consolidado%TYPE AS $$
      DECLARE 
        v_secuencia INT;
        v_secuencia_nombre VARCHAR;
        v_consolidado consolidados_sumar%ROWTYPE;
      BEGIN

        SELECT * INTO v_consolidado FROM consolidados_sumar WHERE id = arg_consolidado_id;
        
        v_secuencia_nombre = 'consolidado_sumar_seq_efector_id_'||CAST(v_consolidado.efector_id  as varchar);
        v_secuencia =  nextval(v_secuencia_nombre::text);

        RETURN trim(to_char(v_consolidado.efector_id, '0000')) ||'-A-'|| trim(to_char(v_secuencia, '00000000'));

      END;
      $$ LANGUAGE plpgsql;

      /*Dropeo el trigger que genera la numeración*/
      DROP TRIGGER "generar_numero_consolidado" ON "public"."consolidados_sumar";
    SQL

    execute <<-SQL
      /*Funcion de generación de numeros de consolidados*/
      CREATE OR REPLACE FUNCTION "public"."generar_numero_de_expediente"(arg_expediente_id int4)
      RETURNS "pg_catalog"."varchar" AS $BODY$
          DECLARE 
            v_tipo_de_exp INT ; 
            v_secuencia_nombre VARCHAR ; 
            v_prefijo tipos_de_expedientes.codigo%TYPE; 
            v_mascara tipos_de_expedientes.mascara%TYPE; 
            v_secuencia BIGINT;
            v_expediente expedientes_sumar%ROWTYPE;
          BEGIN
      SELECT * INTO v_expediente FROM expedientes_sumar WHERE id = arg_expediente_id;

            EXECUTE 'select  nombre_de_secuencia, codigo, mascara from tipos_de_expedientes where id = $1'
               INTO v_secuencia_nombre,  v_prefijo,  v_mascara
               USING v_expediente.tipo_de_expediente_id ; 

            v_secuencia = nextval(v_secuencia_nombre::TEXT); 
            RETURN (v_prefijo || TRIM(to_char(v_secuencia, v_mascara))); 

          END;
          $BODY$
      LANGUAGE 'plpgsql' VOLATILE COST 100;

      ALTER FUNCTION "public"."generar_numero_cuasifactura"(arg_cuasifactura_id int4) OWNER TO "nacer_adm";

      /*Dropeo el trigger que genera la numeración*/
      DROP TRIGGER "generar_numero_de_expediente" ON "public"."expedientes_sumar";
    SQL
  end

  def down
  end
end
