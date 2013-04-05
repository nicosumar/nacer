# -*- encoding : utf-8 -*-
class ModifyCuasiFacturas < ActiveRecord::Migration
  def change
    # A partir de ahora, las prestaciones se pagan a valor de nomenclador vigente en el momento en que se efectuó la prestación
    remove_column :cuasi_facturas, :nomenclador_id
    add_column :cuasi_facturas, :fecha_de_emision, :date   # Registrar la fecha en que se emite la cuasi-factura
    rename_column :cuasi_facturas, :numero_de_liquidacion, :numero

  end
end
