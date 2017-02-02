# -*- encoding : utf-8 -*-
class CreateConveniosDeAdministracionSumar < ActiveRecord::Migration
  def change
    create_table :convenios_de_administracion_sumar do |t|
      t.string :numero, :null => false
      t.references :administrador, :null => false
      t.references :efector, :null => false
      t.string :firmante
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
