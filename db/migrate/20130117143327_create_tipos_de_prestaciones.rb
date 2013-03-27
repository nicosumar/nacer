class CreateTiposDePrestaciones < ActiveRecord::Migration
  def change
    create_table :tipos_de_prestaciones do |t|
      t.string :codigo, :null => false, :unique => true
      t.string :nombre, :null => false
    end
  end
end
