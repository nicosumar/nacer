# -*- encoding : utf-8 -*-
class CreateReferentes < ActiveRecord::Migration
  def change
    create_table :referentes do |t|
      t.references :efector, :null => false
      t.references :contacto, :null => false
      t.text :observaciones
      t.date :fecha_de_inicio
      t.date :fecha_de_finalizacion

      t.timestamps
    end
  end
end
