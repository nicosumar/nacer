class CrearFormulaCccYPpac < ActiveRecord::Migration
  def up
  	f = Formula.create!({
        formula:  "DECLARE\n"+
                  "    v_total prestaciones_liquidadas.monto%type;\n"+
                  "    v_valor prestaciones_liquidadas.monto%type;\n"+
                  "    v_unidades prestaciones_liquidadas.cantidad_de_unidades%type;\n"+
                  "    dato_adicional prestaciones_liquidadas_datos%ROWTYPE;\n"+
                  "   v_adicional_por_prestacion prestaciones_liquidadas_datos.adicional_por_prestacion%type;\n"+
                  "  BEGIN\n"+
                  "  v_total := 0;\n"+
                  "  v_adicional_por_prestacion = 0;\n"+
                  " SELECT into v_unidades pl.cantidad_de_unidades from prestaciones_liquidadas pl where pl.id = prestacion;\n"+
                  "  FOR dato_adicional IN (select *\n"+
                  "                             from prestaciones_liquidadas_datos pld \n"+
                  "                             where pld.prestacion_liquidada_id = prestacion)\n"+
                  "  LOOP\n"+
                  "  select COALESCE( CAST( dato_adicional.valor_integer as NUMERIC(15,4)),  CAST( dato_adicional.valor_big_decimal as NUMERIC(15,4)),  CAST( 1 as NUMERIC(15,4))) into v_valor;\n"+
                  " v_adicional_por_prestacion = dato_adicional.adicional_por_prestacion;\n"+
                  " v_total := v_total + v_valor * dato_adicional.precio_por_unidad ;\n"+
                  " \n"+
                  "END LOOP;\n"+
                  " v_total = v_total + v_adicional_por_prestacion;\n"+
                  "  return v_total;\n"+
                  "END;",
        descripcion: "Formula CCC y PPAC",
        observaciones: "Formula para liquidar cardiopatias y ppac",
        activa: true
  		})
    execute <<-SQL
      UPDATE conceptos_de_facturacion
      set formula_id = (select id from formulas order by created_at desc  limit 1 )
      where formula_id is null;
    SQL
  end

  def down
  end
end
