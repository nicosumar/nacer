# -*- encoding : utf-8 -*-
class ModifyPrestaciones < ActiveRecord::Migration
  def change
    # Añadir columnas necesarias para el nuevo nomenclador del programa SUMAR
    add_column :prestaciones, :objeto_de_la_prestacion_id, :integer
    add_column :prestaciones, :otorga_cobertura, :boolean, :default => false
    add_column :prestaciones, :comunitaria, :boolean, :default => false

    # Eliminar restricciones que ya no son necesarias
    execute "
      ALTER TABLE prestaciones
        ALTER COLUMN area_de_prestacion_id DROP NOT NULL;
      ALTER TABLE prestaciones
        ALTER COLUMN grupo_de_prestaciones_id DROP NOT NULL;
    "
  end
end
