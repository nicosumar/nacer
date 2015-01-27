# -*- encoding : utf-8 -*-
class AddEstadoDeAplicacionToAplicacionesDeDebitos < ActiveRecord::Migration
  def change
    add_column :aplicaciones_de_notas_de_debito, :estado_de_aplicacion_de_debito_id, :integer, null: false, default: 2
  end
end
