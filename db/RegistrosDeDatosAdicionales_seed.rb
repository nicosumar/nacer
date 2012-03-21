# Crear las restricciones adicionales en la base de datos
class ModificarRegistrosDeDatosAdicionales < ActiveRecord::Migration
  execute "
    ALTER TABLE registros_de_datos_adicionales
      ADD CONSTRAINT fk_regddaa_registros_de_prestaciones
      FOREIGN KEY (registro_de_prestacion_id) REFERENCES registros_de_prestaciones (id);
  "
  execute "
    ALTER TABLE registros_de_datos_adicionales
      ADD CONSTRAINT fk_regddaa_datos_adicionales
      FOREIGN KEY (dato_adicional_id) REFERENCES datos_adicionales (id);
  "
end
