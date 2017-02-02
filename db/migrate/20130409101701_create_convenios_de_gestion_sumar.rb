# -*- encoding : utf-8 -*-
class CreateConveniosDeGestionSumar < ActiveRecord::Migration
  def change
    create_table :convenios_de_gestion_sumar do |t|
      t.string :numero, :null => false, :unique => true
      t.references :efector, :null => false, :unique => true
      t.string :firmante
      t.string :email
      t.date :fecha_de_suscripcion, :null => false
      t.date :fecha_de_inicio, :null => false
      t.date :fecha_de_finalizacion
      t.text :observaciones
      t.integer :creator_id
      t.integer :updater_id
      t.timestamps
    end
  end
end
