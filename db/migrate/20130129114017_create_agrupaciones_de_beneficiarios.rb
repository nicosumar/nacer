class CreateAgrupacionesDeBeneficiarios < ActiveRecord::Migration
  def change
    create_table :agrupaciones_de_beneficiarios do |t|
      t.string :nombre, :null => false
      t.string :codigo, :null => false, :unique => true
      t.string :condicion_ruby, :null => false
      t.string :descripcion_de_la_condicion
    end
  end
end
