class UpdateTriggerVerificarDuplicacionDePrestaciones < ActiveRecord::Migration
  def up
  	load 'db/sp/trigger_verificar_duplicacion_de_prestaciones.rb'
  end

  def down
  end
end
