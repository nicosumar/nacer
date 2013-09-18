class Formula < ActiveRecord::Base
  has_many :parametros_liquidaciones_sumar
  attr_accessible :descripcion, :formula, :observaciones, :activa

  def crear_formula
    
    begin
      ActiveRecord::Base.connection.execute "CREATE OR REPLACE FUNCTION public.FORMULA_#{self.id} (PRESTACION  prestaciones_liquidadas.id%TYPE)\n"+
                  "  RETURNS prestaciones_liquidadas.monto%TYPE AS  $$\n"+
                  "  DECLARE\n"+
                  "    v_total prestaciones_liquidadas.monto%type;\n"+
                  "    v_valor prestaciones_liquidadas.monto%type;\n"+
                  "    v_unidades prestaciones_liquidadas.cantidad_de_unidades%type;\n"+
                  "    dato_adicional prestaciones_liquidadas_datos%ROWTYPE;\n"+
                  "  BEGIN\n"+
                  "  v_total := 0;\n"+
                  "  FOR dato_adicional IN (select *\n"+
                  "                             from prestaciones_liquidadas_datos pld \n"+
                  "                             where pld.prestacion_liquidada_id = prestacion)\n"+
                  "  LOOP\n"+
                  self.formula +
                  "  END LOOP;\n"+
                  "  return v_total;\n"+
                  "  END;\n"+
                  "  $$ \n"+
                  "  LANGUAGE PLPGSQL;"

    rescue Exception => e
      return "Se produjo un error al compilar la formula: #{e.message}" ;
    end
    return 'La formula se compilo con exito';
  end

end
