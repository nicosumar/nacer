# -*- encoding : utf-8 -*-
class CreateMetodosDeValidacion < ActiveRecord::Migration
  def change
    create_table :metodos_de_validacion do |t|
      t.string :nombre
      t.string :metodo
      t.string :mensaje
      t.boolean :genera_error, :default => false

      t.timestamps
    end
  end
end
