# -*- encoding : utf-8 -*-
class AddColumnNomencladorToCuasiFacturasAgain < ActiveRecord::Migration
  def change
    add_column :cuasi_facturas, :nomenclador_id, :integer
  end
end
