# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarDiscapacidades < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
Discapacidad.create([
        { #:id => 1,
          :nombre => "Visual",
          :codigo => "V" },
        { #:id => 2,
          :nombre => "Auditiva",
          :codigo => "A" },
        { #:id => 3,
          :nombre => "Motriz",
          :codigo => "Z" },
        { #:id => 4,
          :nombre => "Mental",
          :codigo => "M" },
        { #:id => 5,
          :nombre => "Otra",
          :codigo => "O" }
])
