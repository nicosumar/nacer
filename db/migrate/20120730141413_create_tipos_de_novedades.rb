# -*- encoding : utf-8 -*-
class CreateTiposDeNovedades < ActiveRecord::Migration
  def change
    create_table :tipos_de_novedades do |t|
      t.string :nombre
      t.string :codigo
    end
  end
end
