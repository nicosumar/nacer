# -*- encoding : utf-8 -*-
class CreatePrestacionesPdss < ActiveRecord::Migration

  def change

    create_table :prestaciones_pdss do |t|
      t.string :nombre, :null => false
      t.string :codigo, :null => false
      t.integer :orden, :null => false
      t.references :grupo_pdss, :null => false
      t.references :subgrupo_pdss
      t.references :apartado_pdss
      t.references :nosologia
      t.references :tipo_de_prestacion
      t.boolean :rural, :default => false
      t.timestamps
    end

    add_index :prestaciones_pdss, :grupo_pdss_id
    add_index :prestaciones_pdss, :subgrupo_pdss_id
    add_index :prestaciones_pdss, :apartado_pdss_id
    add_index :prestaciones_pdss, :nosologia_id
    add_index :prestaciones_pdss, :tipo_de_prestacion_id

  end

end
