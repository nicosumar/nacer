class AddColumnCodigoToSexos < ActiveRecord::Migration
  def change
    add_column :sexos, :codigo, :string
  end
end
