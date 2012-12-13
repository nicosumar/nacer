# -*- encoding : utf-8 -*-
class CreateProvincias < ActiveRecord::Migration
  def change
    create_table :provincias do |t|
      t.string :nombre, :null => false
      t.integer :provincia_bio_id
    end
  end
end
