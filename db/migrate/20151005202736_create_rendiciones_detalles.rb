class CreateRendicionesDetalles < ActiveRecord::Migration
  def change
    create_table :rendiciones_detalles do |t|
      t.references :rendicion_id
      t.date :fecha
      t.string :nro_factura
      t.string :detalle
      t.integer :cant
      t.integer :nro_cheque
      t.references :tipo_de_gasto_id
      t.integer :importe_gasto

      t.timestamps
    end
    add_index :rendiciones_detalles, :rendicion_id_id
    add_index :rendiciones_detalles, :tipo_de_gasto_id_id
  end
end
