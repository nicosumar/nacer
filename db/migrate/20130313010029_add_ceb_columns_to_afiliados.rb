class AddCebColumnsToAfiliados < ActiveRecord::Migration
  def change
    # Añadir las columnas agregadas en la versión 4.8 del sistema
    add_column :afiliados, :cobertura_efectiva_basica, :boolean
    add_column :afiliados, :efector_ceb_id, :integer
    add_column :afiliados, :fecha_de_la_ultima_prestacion, :date
    add_column :afiliados, :prestacion_ceb_id, :integer
    add_column :afiliados, :grupo_poblacional_id, :integer

    # Claves foráneas para asegurar la integridad referencial en el motor de la base de datos
    execute "
      ALTER TABLE afiliados
        ADD CONSTRAINT fk_afiliados_efectores_ceb
        FOREIGN KEY (efector_ceb) REFERENCES efectores (id);
    "
    execute "
      ALTER TABLE afiliados
        ADD CONSTRAINT fk_afiliados_prestaciones_ceb
        FOREIGN KEY (prestacion_ceb) REFERENCES prestaciones (id);
    "
    execute "
      ALTER TABLE afiliados
        ADD CONSTRAINT fk_afiliados_grupos_poblacionales
        FOREIGN KEY (grupo_poblacional_id) REFERENCES grupos_poblacionales (id);
    "
  end
end
