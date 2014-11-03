# -*- encoding : utf-8 -*-
class CreateApartadosPdss < ActiveRecord::Migration
  def change
    create_table :apartados_pdss do |t|
      t.string :nombre
      t.references :subgrupo_pdss
      t.string :codigo
      t.integer :orden

      t.timestamps
    end
    add_index :apartados_pdss, :subgrupo_pdss_id
  end
end
