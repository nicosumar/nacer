class AddPagoSumarToExpedientesSumar < ActiveRecord::Migration
  def change
    add_column :expedientes_sumar, :pago_sumar_id, :integer
  end
end
