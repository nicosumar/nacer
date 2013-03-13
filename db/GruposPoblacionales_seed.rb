# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarGruposPoblacionales < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
GrupoPoblacional.create([
  { #:id => 1,
    :nombre => "Menores de 6 años",
    :codigo => "A" },
  { #:id => 2,
    :nombre => "De 6 a 9 años",
    :codigo => "B" },
  { #:id => 3,
    :nombre => "Adolescentes de 10 a 19 años",
    :codigo => "C" },
  { #:id => 4,
    :nombre => "Mujeres de 20 a 64 años",
    :codigo => "D" }
])
