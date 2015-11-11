class CreateTiposDesGastos < ActiveRecord::Migration
  def change
    create_table :tipos_des_gastos do |t|
      t.string :nombre
      t.string :tipo

      t.timestamps
    end
  end
end
