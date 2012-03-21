class CreateDatosAdicionalesPorPrestacion < ActiveRecord::Migration
  def change
    create_table :datos_adicionales_por_prestacion do |t|
      t.references :dato_adicional
      t.references :prestacion
      t.boolean :obligatorio
      t.string :metodo_de_validacion

      t.timestamps
    end
  end
end
