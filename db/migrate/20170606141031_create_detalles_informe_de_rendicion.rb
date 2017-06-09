class CreateDetallesInformeDeRendicion < ActiveRecord::Migration
  def change
    create_table :detalles_informe_de_rendicion do |t|
      t.integer :numero
      t.date :fecha_factura
      t.integer :numero_factura
      t.string :detalle
      t.integer :cantidad
      t.integer :numero_cheque
      t.references :informe_de_rendicion
      t.references :tipo_de_importe

      t.timestamps
    end
    add_index :detalles_informe_de_rendicion, :informe_de_rendicion_id
    add_index :detalles_informe_de_rendicion, :tipo_de_importe_id
  end
end
