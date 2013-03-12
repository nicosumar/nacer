# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
AgrupacionDeBeneficiariosPrestacion.create([
  {
    #:id => 1,
    :nombre => "Grupo materno-infantil (Plan Nacer)",
    :codigo => "MI",
    :condicion_ruby => "esta_embarazada || edad_en_anios < 6"
    :descripcion_de_la_condicion => "mujeres embarazadas o puérperas hasta los 45 días posparto, niños o niñas menores de 6 años"
  }
])
