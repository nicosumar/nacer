class CreatePrestacionesPrincipales < ActiveRecord::Migration
  def change
    create_table :prestaciones_principales do |t|
      t.string :nombre
      t.string :codigo
      t.boolean :activa
      t.datetime :deleted_at

      t.timestamps
    end

    add_column :prestaciones, :prestacion_principal_id, :integer
    add_index :prestaciones, :prestacion_principal_id
  end
end
