# -*- encoding : utf-8 -*-
class CreateGruposDeEfectores < ActiveRecord::Migration
  def change
    create_table :grupos_de_efectores do |t|
      t.string :nombre, :null => false
      t.string :tipo_de_efector, :null => false
      t.integer :grupo_bio_id
      t.boolean :centro_integrador_comunitario
    end
  end
end
