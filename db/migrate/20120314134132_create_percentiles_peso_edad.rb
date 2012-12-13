# -*- encoding : utf-8 -*-
class CreatePercentilesPesoEdad < ActiveRecord::Migration
  def change
    create_table :percentiles_peso_edad do |t|
      t.string :nombre, :null => false
      t.string :codigo_para_prestaciones, :null => false
    end
  end
end
