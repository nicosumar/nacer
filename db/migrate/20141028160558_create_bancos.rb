# -*- encoding : utf-8 -*-
class CreateBancos < ActiveRecord::Migration
  def up
    create_table :bancos do |t|
      t.string :nombre
      t.timestamps
    end

    load 'db/Bancos_seed.rb'

  end

  def down
    drop_table :bancos
  end
end
