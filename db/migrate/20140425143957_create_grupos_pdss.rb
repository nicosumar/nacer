# -*- encoding : utf-8 -*-
class CreateGruposPdss < ActiveRecord::Migration
  def change
    create_table :grupos_pdss do |t|
      t.string :nombre
      t.string :codigo
      t.integer :orden

      t.timestamps
    end
  end
end
