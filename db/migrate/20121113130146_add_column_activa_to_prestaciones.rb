# -*- encoding : utf-8 -*-
class AddColumnActivaToPrestaciones < ActiveRecord::Migration
  def change
    add_column :prestaciones, :activa, :boolean, :default => true
  end
end
