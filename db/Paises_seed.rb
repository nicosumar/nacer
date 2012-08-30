# Crear las restricciones adicionales en la base de datos
class ModificarPaises < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
Pais.create([
        { #:id => 1,
          :nombre => "Ignorado",
          :pais_bio_id => 999 }
])
