# -*- encoding : utf-8 -*-
class CreateTiposDeTratamientos < ActiveRecord::Migration

  def up
    create_table :tipos_de_tratamientos do |t|
      t.string :nombre
      t.string :codigo
    end

    load 'db/TiposDeTratamientos_seed.rb'
  end

  def down
    drop_table :tipos_de_tratamientos
  end

end
