# -*- encoding : utf-8 -*-
class AddColumnDescripcionToUserGroups < ActiveRecord::Migration
  def change
    add_column :user_groups, :user_group_description, :string
  end
end
