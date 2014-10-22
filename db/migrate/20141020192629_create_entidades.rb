# -*- encoding : utf-8 -*-
class CreateEntidades < ActiveRecord::Migration
  def change
    create_table :entidades do |t|
      t.references :entidad, polymorphic: true
      t.timestamps
    end
  end
end
