class CreateUnidadesDeMedida < ActiveRecord::Migration
  def change
    create_table :unidades_de_medida do |t|
      t.string :nombre, :null => false
    end
  end
end
