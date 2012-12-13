# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarNivelesDeInstruccion < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
NivelDeInstruccion.create([
        { #:id => 1,
          :nombre => "No alfabetizado",
          :codigo => "NA" },
        { #:id => 2,
          :nombre => "Alfabetizado (se ignora nivel)",
          :codigo => "SA" },
        { #:id => 3,
          :nombre => "Nivel inicial incompleto",
          :codigo => "II" },
        { #:id => 4,
          :nombre => "Nivel inicial completo",
          :codigo => "IC" },
        { #:id => 5,
          :nombre => "Primario incompleto",
          :codigo => "PI" },
        { #:id => 6,
          :nombre => "Primario completo",
          :codigo => "PC" },
        { #:id => 7,
          :nombre => "Secundario incompleto",
          :codigo => "SI" },
        { #:id => 8,
          :nombre => "Secundario completo",
          :codigo => "SC" },
        { #:id => 9,
          :nombre => "Terciario incompleto",
          :codigo => "TI" },
        { #:id => 10,
          :nombre => "Terciario completo",
          :codigo => "TC" },
        { #:id => 11,
          :nombre => "Universitario incompleto",
          :codigo => "UI" },
        { #:id => 10,
          :nombre => "Universitario completo",
          :codigo => "UC" }
])
