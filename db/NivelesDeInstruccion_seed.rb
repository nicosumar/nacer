# Crear las restricciones adicionales en la base de datos
class ModificarNivelesDeInstruccion < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
NivelDeInstruccion.create([
        { #:id => 1,
          :nombre => "No alfabetizado",
          :codigo_para_gestion => "NA" },
        { #:id => 2,
          :nombre => "Alfabetizado (se ignora nivel)",
          :codigo_para_gestion => "SA" },
        { #:id => 3,
          :nombre => "Nivel inicial incompleto",
          :codigo_para_gestion => "II" },
        { #:id => 4,
          :nombre => "Nivel inicial completo",
          :codigo_para_gestion => "IC" },
        { #:id => 5,
          :nombre => "Primario incompleto",
          :codigo_para_gestion => "PI" },
        { #:id => 6,
          :nombre => "Primario completo",
          :codigo_para_gestion => "PC" },
        { #:id => 7,
          :nombre => "Secundario incompleto",
          :codigo_para_gestion => "SI" },
        { #:id => 8,
          :nombre => "Secundario completo",
          :codigo_para_gestion => "SC" },
        { #:id => 9,
          :nombre => "Terciario incompleto",
          :codigo_para_gestion => "TI" },
        { #:id => 10,
          :nombre => "Terciario completo",
          :codigo_para_gestion => "TC" },
        { #:id => 11,
          :nombre => "Universitario incompleto",
          :codigo_para_gestion => "UI" },
        { #:id => 10,
          :nombre => "Universitario completo",
          :codigo_para_gestion => "UC" }
])
