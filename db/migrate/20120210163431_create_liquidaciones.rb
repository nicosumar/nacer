# -*- encoding : utf-8 -*-
class CreateLiquidaciones < ActiveRecord::Migration
  def change
    create_table :liquidaciones do |t|
      t.references :efector, :null => false
      t.integer :mes_de_prestaciones, :null => false
      t.integer :año_de_prestaciones, :null => false
      t.date :fecha_de_recepcion, :null => false
      t.string :numero_de_expediente, :null => false, :unique => true
      t.date :fecha_de_notificacion
      t.date :fecha_de_transferencia
      t.date :fecha_de_orden_de_pago
      t.decimal :total_facturado, :precision => 15, :scale => 4
      t.decimal :total_de_bajas_algebraicas, :precision => 15, :scale => 4
      t.decimal :total_de_bajas_formales, :precision => 15, :scale => 4
      t.decimal :total_de_bajas_tecnicas, :precision => 15, :scale => 4
      t.decimal :total_a_procesar, :precision => 15, :scale => 4
      t.decimal :total_de_rechazos, :precision => 15, :scale => 4
      t.decimal :total_de_aceptaciones, :precision => 15, :scale => 4
      t.decimal :debitos_ugsp, :precision => 15, :scale => 4
      t.decimal :debitos_ace, :precision => 15, :scale => 4
      t.decimal :total_a_liquidar, :precision => 15, :scale => 4
      t.text :observaciones

      t.timestamps
    end
  end
end
