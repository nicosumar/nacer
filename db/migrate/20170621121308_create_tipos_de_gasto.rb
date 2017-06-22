class CreateTiposDeGasto < ActiveRecord::Migration
  def change
    create_table :tipos_de_gasto do |t|
      t.string :nombre
      t.string :numero
      t.string :descripcion
      t.references :clase_de_gasto

      t.timestamps
    end
    add_index :tipos_de_gasto, :clase_de_gasto_id
  end
end
