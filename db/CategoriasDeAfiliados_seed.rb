# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
CategoriaDeAfiliado.create([
  { #:id => 1,
    :nombre => "Embarazada",
    :codigo => "E" },
  { #:id => 2,
    :nombre => "Puérpera (hasta los 45 días posparto)",
    :codigo => "P" },
  { #:id => 3,
    :nombre => "Niño o niña menor de 1 año",
    :codigo => "N0" },
  { #:id => 4,
    :nombre => "Niño o niña de 1 a 5 años",
    :codigo => "N5"},
  { #:id => 5,
    :nombre => "Menor de 20 años",
    :codigo => "<20" },
  { #:id => 6,
    :nombre => "Mujer de 20 a 64 años",
    :codigo => "M64" }
])
