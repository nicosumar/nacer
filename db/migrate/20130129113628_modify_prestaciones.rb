class ModifyPrestaciones < ActiveRecord::Migration
  def change
    # Añadir columnas necesarias para el nuevo nomenclador del programa SUMAR
    add_column :prestaciones, :tipo_de_prestacion_id, :integer
  end
end
