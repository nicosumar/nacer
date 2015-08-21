# -*- encoding : utf-8 -*-
class CreateLineasDeCuidado < ActiveRecord::Migration
  def change
    create_table :lineas_de_cuidado do |t|
      t.string :nombre
      t.string :codigo
    end
  end
end
