# Crear las restricciones adicionales en la base de datos
class ModificarDiscapacidades < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
Discapacidad.create([
        { #:id => 1,
          :nombre => "Visual",
          :codigo_para_gestion => "V" },
        { #:id => 2,
          :nombre => "Auditiva",
          :codigo_para_gestion => "A" },
        { #:id => 3,
          :nombre => "Motriz",
          :codigo_para_gestion => "Z" },
        { #:id => 4,
          :nombre => "Mental",
          :codigo_para_gestion => "M" },
        { #:id => 5,
          :nombre => "Otra",
          :codigo_para_gestion => "O" }
])
