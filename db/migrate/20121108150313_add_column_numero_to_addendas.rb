# -*- encoding : utf-8 -*-
class AddColumnNumeroToAddendas < ActiveRecord::Migration
  def change
    add_column :addendas, :numero, :string
  end
end
