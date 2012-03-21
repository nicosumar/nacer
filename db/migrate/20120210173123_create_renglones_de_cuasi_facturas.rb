class CreateRenglonesDeCuasiFacturas < ActiveRecord::Migration
  def change
    create_table :renglones_de_cuasi_facturas do |t|
      t.references :cuasi_factura, :null => false
      t.string :codigo_de_prestacion_informado
      t.references :prestacion
      t.integer :cantidad_informada
      t.decimal :monto_informado, :precision => 15, :scale => 4
      t.decimal :subtotal_informado, :precision => 15, :scale => 4
      t.integer :cantidad_digitalizada
      t.integer :cantidad_aceptada
      t.text :observaciones

      t.timestamps
    end
  end
end
