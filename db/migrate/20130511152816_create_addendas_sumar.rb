# -*- encoding : utf-8 -*-
class CreateAddendasSumar < ActiveRecord::Migration
  def change
    create_table :addendas_sumar do |t|
      t.string :numero, :null => false, :unique => true
      t.references :convenio_de_gestion_sumar, :null => false
      t.string :firmante
      t.date :fecha_de_suscripcion
      t.date :fecha_de_inicio, :null => false
      t.text :observaciones
      t.integer :creator_id
      t.integer :updater_id
      t.timestamps
    end
  end
end
