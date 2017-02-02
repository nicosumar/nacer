# -*- encoding : utf-8 -*-
class ModifyAreasDePrestacion < ActiveRecord::Migration
  def change
    add_column :areas_de_prestacion, :codigo, :string
    add_index :areas_de_prestacion, :codigo, :unique => true
  end
end
