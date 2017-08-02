class CreateClasesDeGasto < ActiveRecord::Migration
  def change
    create_table :clases_de_gasto do |t|
      t.string :nombre
      t.string :numero

      t.timestamps
    end
  end
end
