class AddSexoIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :sexo_id, :integer
  end
end
