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
    :codigo_para_gestion => "60001",
    :created_by => "sbosio",
    :efector_id => 391 },
  { #:id => 2,
    :nombre => "Hospital Luis C. Lagomaggiore",
    :codigo_para_gestion => "60002",
    :created_by => "sbosio",
    :efector_id => 45 },
  { #:id => 3,
    :nombre => "Municipalidad de la Capital - Dirección de Salud",
    :codigo_para_gestion => "60003",
    :created_by => "sbosio",
    :efector_id => 358 },
  { #:id => 4,
    :nombre => "Hospital Dr. Alfredo Italo Perrupato",
    :codigo_para_gestion => "60004",
    :created_by => "sbosio",
    :efector_id => 263 },
  { #:id => 5,
    :nombre => "Hospital Diego Paroissien"
    :codigo_para_gestion => "60005",
    :created_by => "sbosio",
    :efector_id => 42 },
  { #:id => 6,
    :nombre => "Coordinación Departamental de San Carlos",
    :codigo_para_gestion => "60006",
    :created_by => "sbosio",
    :efector_id => 348 },
  { #:id => 7,
    :nombre => "Coordinación Departamental de San Rafael",
    :codigo_para_gestion => "60007",
    :created_by => "sbosio",
    :efector_id => 350 },
  { #:id => 8,
    :nombre => "Hospital Domingo Sícoli",
    :codigo_para_gestion => "60008",
    :created_by => "sbosio",
    :efector_id => 148 },
  { #:id => 9,
    :nombre => "Coordinación Departamental de Lavalle",
    :codigo_para_gestion => "60009",
    :created_by => "sbosio",
    :efector_id => 344 },
  { #:id => 10,
    :nombre => "Dirección de Salud - Municipalidad de San Rafael",
    :codigo_para_gestion => "60010",
    :created_by => "sbosio",
    :efector_id => 362 },
  { #:id => 11,
    :nombre => "Hospital Dr. Teodoro Schestakow",
    :codigo_para_gestion => "60011",
    :created_by => "sbosio",
    :efector_id => 53 },
  { #:id => 12,
    :nombre => "Microhospital Puente de Hierro",
    :codigo_para_gestion => "60012",
    :created_by => "sbosio",
    :efector_id => 2 }
])
