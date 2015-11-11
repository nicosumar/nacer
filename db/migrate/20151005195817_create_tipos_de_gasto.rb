class CreateTiposDeGasto < ActiveRecord::Migration
  def change
    create_table :tipos_de_gasto do |t|
      t.string :nombre
      t.string :tipo

      t.timestamps
    end
  end
end
