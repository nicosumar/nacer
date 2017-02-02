# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarAsignacionDeNomenclador < ActiveRecord::Migration
  execute "
    ALTER TABLE asignaciones_de_nomenclador
      ADD CONSTRAINT fk_asignaciones_de_nom_nomencladores
      FOREIGN KEY (nomenclador_id) REFERENCES nomencladores (id);
  "
  execute "
    ALTER TABLE asignaciones_de_nomenclador
      ADD CONSTRAINT fk_asignaciones_de_nom_efectores
      FOREIGN KEY (efector_id) REFERENCES efectores (id);
  "
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#AsignacionDeNomenclador.create([
#  { :efector_id => 1,
#    :nomenclador_id => 1,
#    :fecha_de_inicio => '2001-01-01' },
#  { :efector_id => 2,
#    ...
#
#    y así sucesivamente
#
#    ...
#    }])
