class CreatePrestaciones < ActiveRecord::Migration
  def change
    create_table :prestaciones do |t|
      t.references :area_de_prestacion, :null => false
      t.references :grupo_de_prestaciones, :null => false
      t.references :subgrupo_de_prestaciones
      t.string :codigo, :null => false
      t.string :nombre, :null => false
      t.references :unidad_de_medida, :null => false

      t.timestamps
    end
  end
end
