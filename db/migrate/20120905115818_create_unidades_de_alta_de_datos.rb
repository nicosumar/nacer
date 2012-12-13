# -*- encoding : utf-8 -*-
class CreateUnidadesDeAltaDeDatos < ActiveRecord::Migration
  def change
    create_table :unidades_de_alta_de_datos do |t|
      t.string :nombre, :null => false
      t.string :codigo, :null => false
      t.boolean :inscripcion, :default => false
      t.boolean :facturacion, :default => false
      t.boolean :activa, :default => true
      t.text :observaciones
      t.timestamps
      t.integer :creator_id
      t.integer :updater_id
    end

    add_index :unidades_de_alta_de_datos, :codigo, :unique => true
  end
end
