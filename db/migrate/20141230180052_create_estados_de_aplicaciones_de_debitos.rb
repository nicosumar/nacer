# -*- encoding : utf-8 -*-
class CreateEstadosDeAplicacionesDeDebitos < ActiveRecord::Migration
  def up
    create_table :estados_de_aplicaciones_de_debitos do |t|
      t.column :codigo, "char(3)"
      t.column :nombre, "varchar(25)"
      t.timestamps
    end

    load 'db/Estados_de_aplicaciones_de_debitos_seed.rb'

  end

  def down
    drop_table :estados_de_aplicaciones_de_debitos
  end
end
