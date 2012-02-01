class CreateAsignacionesDePrecios < ActiveRecord::Migration
  def change
    create_table :asignaciones_de_precios do |t|
      t.references :nomenclador, :null => false
      t.references :prestacion, :null => false
      t.decimal :precio_por_unidad, :precision => 15, :scale => 4, :null => false
      t.decimal :adicional_por_prestacion, :precision => 15, :scale => 4, :default => 0
      t.integer :unidades_maximas
      t.text :observaciones

      t.timestamps
    end
  end
end
