class ActualizarConceptosDeFacturacion < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE conceptos_de_facturacion
      SET tipo_de_expediente_id = 1,
      formula_id = 1
      where id = 1;

      UPDATE conceptos_de_facturacion
      SET tipo_de_expediente_id = 3
      where id in (2,3);

      UPDATE conceptos_de_facturacion
      SET tipo_de_expediente_id = 2
      where id not in (1, 2,3);

    SQL


    execute <<-SQL
      CREATE OR REPLACE FUNCTION "public"."formula_1"(prestacion int4)
        RETURNS "pg_catalog"."numeric" AS $BODY$
        DECLARE
          v_unidades prestaciones_liquidadas.cantidad_de_unidades%type;
          dato_adicional prestaciones_liquidadas_datos%ROWTYPE;
        BEGIN
          select *  into dato_adicional  from prestaciones_liquidadas_datos where prestacion_liquidada_id = prestacion;
        select cantidad_de_unidades  into v_unidades from prestaciones_liquidadas where id = prestacion;

        return v_unidades * dato_adicional.precio_por_unidad + dato_adicional.adicional_por_prestacion;
        END;
        $BODY$
        LANGUAGE 'plpgsql' VOLATILE COST 100
      ;
    SQL
  end
  
end
