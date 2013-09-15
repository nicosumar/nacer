class AddParametrosLiquidacion < ActiveRecord::Migration
  def up
  	add_column :parametros_liquidaciones_sumar, :rechazar_estado_de_la_prestacion_id, :integer, default: 6
  	add_column :parametros_liquidaciones_sumar, :aceptar_estado_de_la_prestacion_id, :integer, default: 5
  	add_column :parametros_liquidaciones_sumar, :excepcion_estado_de_la_prestacion_id, :integer, default: 5

  end

  def down
  	remove_column :parametros_liquidaciones_sumar, :rechazar_estado_de_la_prestacion_id
  	remove_column :parametros_liquidaciones_sumar, :aceptar_estado_de_la_prestacion_id
  	remove_column :parametros_liquidaciones_sumar, :excepcion_estado_de_la_prestacion_id
  end
end
