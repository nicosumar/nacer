class CreateEstadosDeRendiciones < ActiveRecord::Migration
  def change
    change_table :estados_de_rendicion do |t|
      t.column :nombre, "varchar(100)"
      t.timestamps
    end
  end
end
