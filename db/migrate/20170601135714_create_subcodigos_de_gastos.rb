class CreateSubcodigosDeGastos < ActiveRecord::Migration
  def change
    create_table :subcodigos_de_gastos do |t|
      t.string :nombre
      t.string :numero
      t.references :codigo_de_gasto

      t.timestamps
    end
    add_index :subcodigos_de_gastos, :codigo_de_gasto_id
  end
end
