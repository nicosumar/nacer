# Crear las restricciones adicionales en la base de datos
class ModificarCentrosDeInscripcion < ActiveRecord::Migration
  execute "
    ALTER TABLE centros_de_inscripcion
      ADD CONSTRAINT fk_centros_de_inscripcion_efectores
      FOREIGN KEY (efector_id) REFERENCES efectores (id);
  "
end

# Datos precargados al inicializar el sistema
CentroDeInscripcion.create([
  { #:id => 1,
    :nombre => "UGSP",
    :codigo_para_gestion => "00000",
    :created_by => "sbosio",
    :efector_id => 391 }
])
