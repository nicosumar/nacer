class ActualizarTriggerAgregarOModificarUad < ActiveRecord::Migration
  def up
    load 'db/sp/trigger_agregar_o_modificar_uad.rb'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
