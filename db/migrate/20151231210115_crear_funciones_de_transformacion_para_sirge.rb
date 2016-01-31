class CrearFuncionesDeTransformacionParaSirge < ActiveRecord::Migration
  def up
    load 'db/sp/function_sirge_dr_peso.rb'
    load 'db/sp/function_sirge_dr_talla.rb'
    load 'db/sp/function_sirge_dr_toma_tension_arterial.rb'
    load 'db/sp/function_sirge_dr_registro_edad_gestacional.rb'
    load 'db/sp/function_sirge_dr_resultado_oea_od.rb'
    load 'db/sp/function_sirge_dr_resultado_oea_oi.rb'
#    load 'db/sp/function_sirge_dr_perimetro_cefalico.rb'
  end

  def down
    # NO es necesario hacer nada ya que las funciones se reescriben al remigrarlas
    true
  end
end
