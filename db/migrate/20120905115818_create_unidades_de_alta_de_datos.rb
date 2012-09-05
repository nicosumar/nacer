class CreateUnidadesDeAltaDeDatos < ActiveRecord::Migration
  def change
    create_table :unidades_de_alta_de_datos do |t|
      t.string :nombre
      t.boolean :inscripcion
      t.boolean :facturacion
      t.boolean :activa
      t.string :schema_search_path
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
