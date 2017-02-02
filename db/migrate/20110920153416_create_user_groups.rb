# -*- encoding : utf-8 -*-
class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.string :user_group_name
      t.timestamps
    end
  end
end
