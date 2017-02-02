# -*- encoding : utf-8 -*-
class CreateSeccionesPdss < ActiveRecord::Migration
  def change

    create_table :secciones_pdss do |t|
      t.string :nombre
      t.string :codigo
      t.integer :orden
    end

  end
end
