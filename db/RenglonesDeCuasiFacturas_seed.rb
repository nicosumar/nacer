# Crear las restricciones adicionales en la base de datos
class ModificarRenglonesDeCuasiFacturas < ActiveRecord::Migration
  execute "
    ALTER TABLE renglones_de_cuasi_facturas
      ADD CONSTRAINT fk_renglones_de_cc_ff_cuasi_facturas
      FOREIGN KEY (cuasi_factura_id) REFERENCES cuasi_facturas (id);
  "
  execute "
    ALTER TABLE renglones_de_cuasi_facturas
      ADD CONSTRAINT fk_renglones_de_cc_ff_prestaciones
      FOREIGN KEY (prestacion_id) REFERENCES prestaciones (id);
  "
end
