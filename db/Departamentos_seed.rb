# Crear las restricciones adicionales en la base de datos
class ModificarDepartamento < ActiveRecord::Migration
  execute "
    ALTER TABLE departamentos
      ADD CONSTRAINT fk_departamentos_provincias
      FOREIGN KEY (provincia_id) REFERENCES provincias (id);
  "
end

# Datos precargados al inicializar el sistema
Departamento.create([
        { #:id => 1,
          :nombre => "Ignorado",
          :provincia_id => 1,
          :departamento_bio_id => 999 },
        { #:id => 2,
          :nombre => "Ignorado",
          :provincia_id => 2,
          :departamento_bio_id => 999 },
        { #:id => 3,
          :nombre => "Ignorado",
          :provincia_id => 3,
          :departamento_bio_id => 999 },
        { #:id => 4,
          :nombre => "Ignorado",
          :provincia_id => 4,
          :departamento_bio_id => 999 },
        { #:id => 5,
          :nombre => "Ignorado",
          :provincia_id => 5,
          :departamento_bio_id => 999 },
        { #:id => 6,
          :nombre => "Ignorado",
          :provincia_id => 6,
          :departamento_bio_id => 999 },
        { #:id => 7,
          :nombre => "Ignorado",
          :provincia_id => 7,
          :departamento_bio_id => 999 },
        { #:id => 8,
          :nombre => "Ignorado",
          :provincia_id => 8,
          :departamento_bio_id => 999 },
        { #:id => 9,
          :nombre => "Capital",
          :provincia_id => 9,
          :departamento_bio_id => 7,
          :departamento_indec_id => "007",
          :departamento_insc_id => 24 },
        { #:id => 10,
          :nombre => "General Alvear",
          :provincia_id => 9,
          :departamento_bio_id => 14,
          :departamento_indec_id => "014",
          :departamento_insc_id => 25 },
        { #:id => 11,
          :nombre => "Godoy Cruz",
          :provincia_id => 9,
          :departamento_bio_id => 21,
          :departamento_indec_id => "021",
          :departamento_insc_id => 26 },
        { #:id => 12,
          :nombre => "Guaymallén",
          :provincia_id => 9,
          :departamento_bio_id => 28,
          :departamento_indec_id => "028",
          :departamento_insc_id => 27 },
        { #:id => 13,
          :nombre => "Ignorado",
          :provincia_id => 9,
          :departamento_bio_id => 999 },
        { #:id => 14,
          :nombre => "Junín",
          :provincia_id => 9,
          :departamento_bio_id => 35,
          :departamento_indec_id => "035",
          :departamento_insc_id => 28 },
        { #:id => 15,
          :nombre => "La Paz",
          :provincia_id => 9,
          :departamento_bio_id => 42,
          :departamento_indec_id => "042",
          :departamento_insc_id => 29 },
        { #:id => 16,
          :nombre => "Las Heras",
          :provincia_id => 9,
          :departamento_bio_id => 49,
          :departamento_indec_id => "049",
          :departamento_insc_id => 30 },
        { #:id => 17,
          :nombre => "Lavalle",
          :provincia_id => 9,
          :departamento_bio_id => 56,
          :departamento_indec_id => "056",
          :departamento_insc_id => 31 },
        { #:id => 18,
          :nombre => "Luján de Cuyo",
          :provincia_id => 9,
          :departamento_bio_id => 63,
          :departamento_indec_id => "063",
          :departamento_insc_id => 32 },
        { #:id => 19,
          :nombre => "Maipú",
          :provincia_id => 9,
          :departamento_bio_id => 70,
          :departamento_indec_id => "070",
          :departamento_insc_id => 33 },
        { #:id => 20,
          :nombre => "Malargüe",
          :provincia_id => 9,
          :departamento_bio_id => 77,
          :departamento_indec_id => "077",
          :departamento_insc_id => 34 },
        { #:id => 21,
          :nombre => "Rivadavia",
          :provincia_id => 9,
          :departamento_bio_id => 84,
          :departamento_indec_id => "084",
          :departamento_insc_id => 35 },
        { #:id => 22,
          :nombre => "San Carlos",
          :provincia_id => 9,
          :departamento_bio_id => 91,
          :departamento_indec_id => "091",
          :departamento_insc_id => 36 },
        { #:id => 23,
          :nombre => "San Martín",
          :provincia_id => 9,
          :departamento_bio_id => 98,
          :departamento_indec_id => "098",
          :departamento_insc_id => 37 },
        { #:id => 24,
          :nombre => "San Rafael",
          :provincia_id => 9,
          :departamento_bio_id => 105,
          :departamento_indec_id => "105",
          :departamento_insc_id => 38 },
        { #:id => 25,
          :nombre => "Santa Rosa",
          :provincia_id => 9,
          :departamento_bio_id => 112,
          :departamento_indec_id => "112",
          :departamento_insc_id => 39 },
        { #:id => 26,
          :nombre => "Tunuyán",
          :provincia_id => 9,
          :departamento_bio_id => 119,
          :departamento_indec_id => "119",
          :departamento_insc_id => 40 },
        { #:id => 27,
          :nombre => "Tupungato",
          :provincia_id => 9,
          :departamento_bio_id => 126,
          :departamento_indec_id => "126",
          :departamento_insc_id => 41 },
        { #:id => 28,
          :nombre => "Ignorado",
          :provincia_id => 10,
          :departamento_bio_id => 999 },
        { #:id => 29,
          :nombre => "Ignorado",
          :provincia_id => 11,
          :departamento_bio_id => 999 },
        { #:id => 30,
          :nombre => "Ignorado",
          :provincia_id => 12,
          :departamento_bio_id => 999 },
        { #:id => 31,
          :nombre => "Ignorado",
          :provincia_id => 13,
          :departamento_bio_id => 999 },
        { #:id => 32,
          :nombre => "Ignorado",
          :provincia_id => 14,
          :departamento_bio_id => 999 },
        { #:id => 33,
          :nombre => "Ignorado",
          :provincia_id => 15,
          :departamento_bio_id => 999 },
        { #:id => 34,
          :nombre => "Ignorado",
          :provincia_id => 16,
          :departamento_bio_id => 999 },
        { #:id => 35,
          :nombre => "Ignorado",
          :provincia_id => 17,
          :departamento_bio_id => 999 },
        { #:id => 36,
          :nombre => "Ignorado",
          :provincia_id => 18,
          :departamento_bio_id => 999 },
        { #:id => 37,
          :nombre => "Ignorado",
          :provincia_id => 19,
          :departamento_bio_id => 999 },
        { #:id => 38,
          :nombre => "Ignorado",
          :provincia_id => 20,
          :departamento_bio_id => 999 },
        { #:id => 39,
          :nombre => "Ignorado",
          :provincia_id => 21,
          :departamento_bio_id => 999 },
        { #:id => 40,
          :nombre => "Ignorado",
          :provincia_id => 22,
          :departamento_bio_id => 999 },
        { #:id => 41,
          :nombre => "Ignorado",
          :provincia_id => 23,
          :departamento_bio_id => 999 },
        { #:id => 42,
          :nombre => "Ignorado",
          :provincia_id => 24,
          :departamento_bio_id => 999 },
        { #:id => 43,
          :nombre => "Ignorado",
          :provincia_id => 25,
          :departamento_bio_id => 999 }
])
