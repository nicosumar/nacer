# -*- encoding : utf-8 -*-
class CreateCentrosDeInscripcion < ActiveRecord::Migration
  def change
    create_table :centros_de_inscripcion do |t|
      t.string :nombre, :null => false
      t.string :codigo, :null => false
      t.timestamps
      t.integer :creator_id
      t.integer :updater_id
    end
  end
end
