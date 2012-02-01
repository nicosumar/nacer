class CreateAsignacionesDeNomenclador < ActiveRecord::Migration
  def change
    create_table :asignaciones_de_nomenclador do |t|
      t.references :efector, :null => false
      t.references :nomenclador, :null => false
      t.date :fecha_de_inicio, :null => false
      t.date :fecha_de_finalizacion
      t.text :observaciones

      t.timestamps
    end
  end
end
