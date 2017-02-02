# -*- encoding : utf-8 -*-
class CreateTribusOriginarias < ActiveRecord::Migration
  def change
    create_table :tribus_originarias do |t|
      t.string :nombre
    end
  end
end
