# -*- encoding : utf-8 -*-
class AddSexoIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :sexo_id, :integer
  end
end
