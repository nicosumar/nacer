class CreateConceptosDeFacturacion < ActiveRecord::Migration
  def change
    create_table :conceptos_de_facturacion do |t|
      t.string :concepto
      t.string :descripcion
      t.timestamps

    end
  end
end
