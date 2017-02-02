# -*- encoding : utf-8 -*-
class CreateConveniosDeAdministracion < ActiveRecord::Migration
  def change
    create_table :convenios_de_administracion do |t|
      t.string :numero, :null => false
      t.references :administrador, :null => false
      t.references :efector, :null => false
      t.string :firmante
      t.date :fecha_de_suscripcion
      t.date :fecha_de_inicio, :null => false
      t.date :fecha_de_finalizacion, :null => false
      t.text :observaciones

      t.timestamps
    end
  end
end
