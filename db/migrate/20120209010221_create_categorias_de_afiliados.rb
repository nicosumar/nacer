# -*- encoding : utf-8 -*-
class CreateCategoriasDeAfiliados < ActiveRecord::Migration
  def change
    create_table :categorias_de_afiliados do |t|
      t.string :nombre
    end
  end
end
