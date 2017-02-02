# -*- encoding : utf-8 -*-
class CreatePrestacionesSexosJoinTable < ActiveRecord::Migration
  def change
    create_table :prestaciones_sexos, :id => false do |t|
      t.references :prestacion
      t.references :sexo
    end
  end
end
