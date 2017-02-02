class CreateInformesFiltrosValidadoresUis < ActiveRecord::Migration
  def self.up
  	create_table :informes_filtros_validadores_uis do |t|
  		t.string "tipo"
  		t.timestamps
  	end
  end

  def self.down
  	drop_table :informes_filtros_validadores_uis

  end
end
