# Crear las restricciones adicionales en la base de datos
class ModificarCentrosDeInscripcion < ActiveRecord::Migration
  execute "
    ALTER TABLE centros_de_inscripcion
      ADD CONSTRAINT fk_centros_de_inscripcion_efectores
      FOREIGN KEY (efector_id) REFERENCES efectores (id);
  "
end

# Datos precargados al inicializar el sistema
#CentroDeInscripcion.create([
#  { #:id => 1,
#    :nombre => "Unidad de gestión del seguro provincial",
#    :codigo => "__codigo_CI__",
#    :created_by => "__usuario__",
#    :efector_id => __id_de_efector__ },
#  { #:id => 2,
#    ...
#])
