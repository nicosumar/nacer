# -*- encoding : utf-8 -*-
class CreateEstadosDeLasPrestaciones < ActiveRecord::Migration
  def change
    create_table :estados_de_las_prestaciones do |t|
      t.string :nombre
    end
  end
end
