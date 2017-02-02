# -*- encoding : utf-8 -*-
class CreateSubgruposDePrestaciones < ActiveRecord::Migration
  def change
    create_table :subgrupos_de_prestaciones do |t|
      t.references :grupo_de_prestaciones, :null => false
      t.string :nombre, :null => false
    end
  end
end
