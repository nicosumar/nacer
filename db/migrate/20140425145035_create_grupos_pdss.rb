# -*- encoding : utf-8 -*-
class CreateGruposPdss < ActiveRecord::Migration
  def change

    create_table :grupos_pdss do |t|
      t.string :nombre
      t.string :codigo
      t.references :seccion_pdss
      t.boolean :prestaciones_modularizadas, :default => :false
      t.integer :orden
    end

    add_index :grupos_pdss, :seccion_pdss_id
  end
end
