# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
AgrupacionDeBeneficiarios.create([
  {
    #:id => 1,
    :nombre => "Grupo materno-infantil (Plan Nacer)",
    :codigo => "MI",
    :condicion_ruby => "esta_embarazada || edad_en_anios < 6"
    :descripcion_de_la_condicion => "mujer embarazada o puérpera hasta los 45 días posparto, o niño/niña menor de 6 años"
  },
])
