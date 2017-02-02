# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarTiposDeNovedades < ActiveRecord::Migration
end

# Datos precargados al inicializar el sistema
TipoDeNovedad.create([
        { #:id => 1,
          :nombre => "Alta",
          :codigo => "A" },
        { #:id => 2,
          :nombre => "Baja",
          :codigo => "B" },
        { #:id => 3,
          :nombre => "Modificación",
          :codigo => "M" }
])
