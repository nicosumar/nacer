# -*- encoding : utf-8 -*-
class CreatePercentilesPcEdad < ActiveRecord::Migration
  def change
    create_table :percentiles_pc_edad do |t|
      t.string :nombre
      t.string :codigo_para_prestaciones
    end
  end
end
