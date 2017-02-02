# -*- encoding : utf-8 -*-
class ModifyAsignacionesDePrecios < ActiveRecord::Migration
  def change
    remove_column :asignaciones_de_precios, :unidades_maximas
    add_column :asignaciones_de_precios, :area_de_prestacion_id, :integer, :default => 1
    add_column :asignaciones_de_precios, :dato_reportable_id, :integer
    add_index :asignaciones_de_precios, [:nomenclador_id, :prestacion_id, :area_de_prestacion_id, :dato_reportable_id], :unique => true, :name => 'index_unique_on_nomenclador_prestacion_area_ddrr'

    execute "
      ALTER TABLE asignaciones_de_precios
        ADD CONSTRAINT fk_asignaciones_datos_reportables
        FOREIGN KEY (dato_reportable_id) REFERENCES datos_reportables (id);
    "
    execute "
      ALTER TABLE asignaciones_de_precios
        ADD CONSTRAINT fk_asignaciones_areas_de_prestacion
        FOREIGN KEY (area_de_prestacion_id) REFERENCES areas_de_prestacion (id);
    "
  end
end
