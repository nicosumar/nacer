class AddEliminadaToPrestaciones < ActiveRecord::Migration
  def change
    add_column :prestaciones, :eliminada, :boolean
  end
end
