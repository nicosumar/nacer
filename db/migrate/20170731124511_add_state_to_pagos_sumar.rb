class AddStateToPagosSumar < ActiveRecord::Migration
  def change
    add_column :pagos_sumar, :state, :string
  end
end
