# Crear las restricciones adicionales en la base de datos
class ModificarEstadosDeLasNovedades < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
EstadoDeLaNovedad.create([
  { #:id => 1,
    :nombre => "Registrada, pero faltan datos esenciales" },
  { #:id => 2,
    :nombre => "Registrada, sin notificar" },
  { #:id => 3,
    :nombre => "Notificada" },
  { #:id => 4,
    :nombre => "Aceptada" },
  { #:id => 5,
    :nombre => "Rechazada" },
  { #:id => 6,
    :nombre => "Anulada" }
])
