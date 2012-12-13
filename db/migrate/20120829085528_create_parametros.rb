# -*- encoding : utf-8 -*-
class CreateParametros < ActiveRecord::Migration
  def change
    create_table :parametros do |t|
      t.string :nombre
      t.string :tipo_postgres
      t.string :tipo_ruby
      t.text :valor
      t.timestamps
      t.integer :creator_id
      t.integer :updater_id
    end
  end
end
