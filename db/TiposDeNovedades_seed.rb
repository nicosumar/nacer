# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarTiposDeNovedades < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
TipoDeNovedad.create([
        { #:id => 1,
          :nombre => "Alta",
          :codigo_para_gestion => "A" },
        { #:id => 2,
          :nombre => "Baja",
          :codigo_para_gestion => "B" },
        { #:id => 3,
          :nombre => "Modificación",
          :codigo_para_gestion => "M" },
        { #:id => 4,
          :nombre => "Reinscripción",
          :codigo_para_gestion => "R" }
])
