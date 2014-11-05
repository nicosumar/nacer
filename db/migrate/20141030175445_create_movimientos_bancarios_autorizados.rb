# -*- encoding : utf-8 -*-
class CreateMovimientosBancariosAutorizados < ActiveRecord::Migration
  def change
    create_table :movimientos_bancarios_autorizados do |t|
      t.integer :cuenta_bancaria_origen_id
      t.integer :cuenta_bancaria_destino_id
      t.references :concepto_de_facturacion

      t.timestamps
    end
    add_index :movimientos_bancarios_autorizados, :cuenta_bancaria_origen_id, name:  'index_movimientos_banc_autorizado_on_cuenta_bancaria_origen_id'
    add_index :movimientos_bancarios_autorizados, :cuenta_bancaria_destino_id, name: 'index_movimientos_banc_autorizado_on_cuenta_bancaria_destino_id'
    add_index :movimientos_bancarios_autorizados, :concepto_de_facturacion_id, name: 'index_movimientos_banc_autorizado_on_concepto_de_facturacion_id'
  end
end
