class ModifyColumnsFromEfectores < ActiveRecord::Migration
  def change
    remove_column :efectores, :evaluacion_de_impacto
    rename_column :efectores, :efector_sissa_id, :codigo_de_efector_sissa
    rename_column :efectores, :efector_bio_id, :codigo_de_efector_bio
    add_column :efectores, :alto_impacto, :boolean, :default => false
    add_column :efectores, :perinatal_de_alta_complejidad, :boolean, :default => false
    add_column :efectores, :addenda_perinatal, :boolean, :default => false
    add_column :efectores, :fecha_de_addenda_perinatal, :date
    add_index :efectores, :cuie, :unique => true
    add_index :efectores, :efector_sissa_id, :unique => true

    execute "
      ALTER TABLE efectores ALTER COLUMN integrante SET DEFAULT 't';
    "
  end
end
