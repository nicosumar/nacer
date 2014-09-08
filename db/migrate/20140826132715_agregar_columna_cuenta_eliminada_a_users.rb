class AgregarColumnaCuentaEliminadaAUsers < ActiveRecord::Migration
  def change
    add_column :users, :cuenta_eliminada, :boolean, :default => false
  end
end
