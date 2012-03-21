class CreateRegistrosDeDatosAdicionales < ActiveRecord::Migration
  def change
    create_table :registros_de_datos_adicionales do |t|
      t.references :registro_de_prestacion, :null => false
      t.references :dato_adicional, :null => false
      t.text :valor
      t.text :observaciones

      t.timestamps
    end
  end
end
