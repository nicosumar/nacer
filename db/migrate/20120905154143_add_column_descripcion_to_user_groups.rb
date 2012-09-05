class AddColumnDescripcionToUserGroups < ActiveRecord::Migration
  def change
    add_column :user_groups, :user_group_description, :string
  end
end
