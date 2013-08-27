class CreateLiquidacionesSumar < ActiveRecord::Migration
  def change
    create_table :liquidaciones_sumar do |t|
      t.references :formula
      t.references :concepto_de_facturacion
      t.timestamps
    end
  end
end
