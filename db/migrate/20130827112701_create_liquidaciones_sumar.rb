class CreateLiquidacionesSumar < ActiveRecord::Migration
  def change
    create_table :liquidaciones_sumar do |t|
      t.string :descripcion
      t.references :formula
      t.references :concepto_de_facturacion
      t.references :periodo
      t.timestamps
    end
  end
end
