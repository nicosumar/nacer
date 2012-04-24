class CreatePercentilesTallaEdad < ActiveRecord::Migration
  def change
    create_table :percentiles_talla_edad do |t|
      t.string :nombre
      t.string :codigo_para_prestaciones
    end
  end
end
