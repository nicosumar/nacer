class AgregarColumnaConeAEfectores < ActiveRecord::Migration
  def change
    add_column :efectores, :categorizado_cone, :boolean, :default => false
    execute "
        ALTER TABLE IF EXISTS ONLY auditorias.auditoria_efectores
          ADD COLUMN categorizado_cone boolean DEFAULT 'f'::boolean;
      "
    load 'vendor/data/efectores_cone.rb'
  end
end
