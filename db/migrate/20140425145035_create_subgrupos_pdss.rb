# -*- encoding : utf-8 -*-
class CreateSubgruposPdss < ActiveRecord::Migration
  def change
    create_table :subgrupos_pdss do |t|
      t.string :nombre
      t.references :grupo_pdss
      t.string :codigo
      t.integer :orden

      t.timestamps
    end
    add_index :subgrupos_pdss, :grupo_pdss_id
  end
end
