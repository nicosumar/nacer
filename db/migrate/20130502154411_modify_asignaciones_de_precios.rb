class ModifyAsignacionesDePrecios < ActiveRecord::Migration
  def change
    add_column :asignaciones_de_precios, :dato_reportable_id, :string
    add_index :asignaciones_de_precios, [:nomenclador_id, :prestacion_id, :dato_reportable_id], :unique => true

    execute "
      ALTER TABLE asignaciones_de_precios
        ADD CONSTRAINT fk_asignaciones_datos_reportables
        FOREIGN KEY (dato_reportable_id) REFERENCES datos_reportables (id);
    "
  end
end
