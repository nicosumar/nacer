# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarLiquidaciones < ActiveRecord::Migration
  execute "
    ALTER TABLE liquidaciones
      ADD CONSTRAINT fk_liquidaciones_efectores
      FOREIGN KEY (efector_id) REFERENCES efectores (id);
  "
end
