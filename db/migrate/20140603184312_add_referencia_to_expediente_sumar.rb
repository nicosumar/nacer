class AddReferenciaToExpedienteSumar < ActiveRecord::Migration
  def up
    remove_column :expedientes_sumar, :liquidacion_sumar_cuasifactura_id
    remove_column :expedientes_sumar, :consolidado_sumar_id
    remove_column :expedientes_sumar, :periodo_id
  end

  def down
    
  end

end
