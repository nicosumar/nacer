class CreatePercentilesPesoTalla < ActiveRecord::Migration
  def change
    create_table :percentiles_peso_talla do |t|
      t.string :nombre
      t.string :codigo_para_prestaciones

      t.timestamps
    end
  end
end
