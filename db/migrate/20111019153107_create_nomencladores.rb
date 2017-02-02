# -*- encoding : utf-8 -*-
class CreateNomencladores < ActiveRecord::Migration
  def change
    create_table :nomencladores do |t|
      t.string :nombre, :null => false
      t.date :fecha_de_inicio, :null => false
      t.boolean :activo, :null => false, :default => false
      t.text :observaciones

      t.timestamps
    end
  end
end
