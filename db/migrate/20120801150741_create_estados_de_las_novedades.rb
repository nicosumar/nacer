# -*- encoding : utf-8 -*-
class CreateEstadosDeLasNovedades < ActiveRecord::Migration
  def change
    create_table :estados_de_las_novedades do |t|
      t.string :nombre
    end
  end
end
