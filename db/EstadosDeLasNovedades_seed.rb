# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarEstadosDeLasNovedades < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
EstadoDeLaNovedad.create([
  { #:id => 1,
    :nombre => "Registrada, pero incompleta",
    :codigo => "I",
    :pendiente => true },
  { #:id => 2,
    :nombre => "Registrada, aún no se ha procesado",
    :codigo => "R",
    :pendiente => true },
  { #:id => 3,
    :nombre => "En procesamiento, esperando aprobación",
    :codigo => "P",
    :pendiente => true },
  { #:id => 4,
    :nombre => "Aprobada",
    :codigo => "A",
    :pendiente => false },
  { #:id => 5,
    :nombre => "Rechazada",
    :codigo => "Z",
    :pendiente => false },
  { #:id => 6,
    :nombre => "Anulada por el usuario",
    :codigo => "U",
    :pendiente => false },
  { #:id => 7,
    :nombre => "Anulada por el sistema",
    :codigo => "S",
    :pendiente => false }
])
