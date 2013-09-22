class CreateFormulas < ActiveRecord::Migration
  def up
    create_table :formulas do |t|
      t.string :descripcion
      t.text :formula
      t.text :observaciones
      t.boolean :activa, default: true

      t.timestamps
    end

    Formula.create! {
    	descripcion: "Formula Basica",
    	observaciones: "Formula basica - Creada durante la migración",
    	activa: true,
    	formula: "select COALESCE( CAST( dato_adicional.valor_integer as NUMERIC(15,4)), \n"+
                 "       CAST( dato_adicional.valor_Big_decimal as NUMERIC(15,4)), \n"+
     	         "       CAST( 0 as NUMERIC(15,4))) into v_valor; \n"+
                 "\n"+
			     "IF v_valor <> 0 THEN \n"+
                 "  v_total := v_total + v_valor * dato_adicional.precio_por_unidad ; \n"+
                 "ELSE \n"+
                 "  SELECT into v_unidades pl.cantidad_de_unidades from prestaciones_liquidadas pl where pl.id = prestacion; \n "+
                 "  v_total := v_total + v_unidades * dato_adicional.precio_por_unidad + dato_adicional.adicional_por_prestacion; \n"+
                 "END IF; \n"
    }
  end

  def down
  	drop_table :formulas
  end

end
