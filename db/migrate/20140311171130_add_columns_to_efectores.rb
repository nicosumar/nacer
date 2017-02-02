class AddColumnsToEfectores < ActiveRecord::Migration
  def change
    add_column :efectores, :categoria_obstetrica, :string
    add_column :efectores, :categoria_neonatal, :string
    add_column :efectores, :internet, :boolean, :default => false
  end
end
