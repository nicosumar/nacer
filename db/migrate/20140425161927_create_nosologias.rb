# -*- encoding : utf-8 -*-
class CreateNosologias < ActiveRecord::Migration
  def change
    create_table :nosologias do |t|
      t.string :nombre
      t.string :codigo

      t.timestamps
    end
  end
end
