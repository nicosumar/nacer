class UserUserGroupJoinTable < ActiveRecord::Migration
  def change
    create_table :user_groups_users, :id => false do |t|
      t.references :user
      t.references :user_group
    end
  end
end
