# Crear las restricciones adicionales en la base de datos
class ModificarCuasiFacturas < ActiveRecord::Migration
  execute "
    ALTER TABLE cuasi_facturas
      ADD CONSTRAINT fk_cuasi_facturas_liquidaciones
      FOREIGN KEY (liquidacion_id) REFERENCES liquidaciones (id);
  "
  execute "
    ALTER TABLE cuasi_facturas
      ADD CONSTRAINT fk_cuasi_facturas_efectores
      FOREIGN KEY (efector_id) REFERENCES efectores (id);
  "
  execute "
    ALTER TABLE cuasi_facturas
      ADD CONSTRAINT fk_cuasi_facturas_nomencladores
      FOREIGN KEY (nomenclador_id) REFERENCES nomencladores (id);
  "
end
