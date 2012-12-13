# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarEstadosDeLasNovedades < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
EstadoDeLaNovedad.create([
  { #:id => 1,
    :nombre => "Registrada, pero no se puede notificar porque faltan datos esenciales" },
  { #:id => 2,
    :nombre => "Registrada, aún no se ha notificado" },
  { #:id => 3,
    :nombre => "Notificada, esperando aprobación" },
  { #:id => 4,
    :nombre => "Aprobada" },
  { #:id => 5,
    :nombre => "Rechazada" },
  { #:id => 6,
    :nombre => "Anulada por el usuario" },
  { #:id => 7,
    :nombre => "Anulada por un administrador" }
])
