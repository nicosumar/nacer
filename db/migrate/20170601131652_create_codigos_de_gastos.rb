class CreateCodigosDeGastos < ActiveRecord::Migration
  def change
    create_table :codigos_de_gastos do |t|
      t.string :nombre
      t.string :numero

      t.timestamps
    end
  end
end
