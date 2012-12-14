# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarEstadosDeLasNovedades < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
EstadoDeLaNovedad.create([
  { #:id => 1,
    :nombre => "Registrada, pero no se puede notificar porque faltan datos esenciales",
    :codigo => "I",
    :pendiente => true },
  { #:id => 2,
    :nombre => "Registrada, aún no se ha notificado",
    :codigo => "R",
    :pendiente => true },
  { #:id => 3,
    :nombre => "Notificada, esperando aprobación",
    :codigo => "N",
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
    :codigo => "U"
    :pendiente => false },
  { #:id => 7,
    :nombre => "Anulada por el sistema",
    :codigo => "S",
    :pendiente => false }
])
