class ActualizarConceptosDeFacturacion < ActiveRecord::Migration
  def up
      ConceptoDeFacturacion.all.each do |c|
      case c.id
      when 1
        c.tipo_de_expediente = TipoDeExpediente.find 1
        c.formula = Formula.find 1
        c.save
      when 2..3
        c.tipo_de_expediente = TipoDeExpediente.find 3
        c.formula = Formula.find 1
        c.save
      else 
        c.tipo_de_expediente = TipoDeExpediente.find 2
        c.formula = Formula.find 1
        c.save
      end
    end

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
