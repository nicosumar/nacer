# Crear las restricciones adicionales en la base de datos
class ModificarDatosAdicionalesPorPrestacion < ActiveRecord::Migration
  execute "
    ALTER TABLE datos_adicionales_por_prestacion
      ADD CONSTRAINT fk_ddaapp_datos_adicionales
      FOREIGN KEY (dato_adicional_id) REFERENCES datos_adicionales (id);
  "
  execute "
    ALTER TABLE datos_adicionales_por_prestacion
      ADD CONSTRAINT fk_ddaapp_prestaciones
      FOREIGN KEY (prestacion_id) REFERENCES prestaciones (id);
  "
end

# Datos precargados al inicializar el sistema
#DatoAdicionalPorPrestacion.create([
#  { #:id => 1,
#    :dato_adicional => 1,
#    :prestacion => 1,
#    :obligatorio => true,
#    :metodo_de_validacion => "validar_da" },
#  { # ... }
#])
