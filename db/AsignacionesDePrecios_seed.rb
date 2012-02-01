class ModificarAsignacionDePrecios < ActiveRecord::Migration
  execute "
    ALTER TABLE asignaciones_de_precios
      ADD CONSTRAINT fk_asignaciones_nomencladores
      FOREIGN KEY (nomenclador_id) REFERENCES nomencladores (id);
  "
  execute "
    ALTER TABLE asignaciones_de_precios
      ADD CONSTRAINT fk_asignaciones_prestaciones
      FOREIGN KEY (prestacion_id) REFERENCES prestaciones (id);
  "
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#AsignacionDePrecios.create([
#  { :nomenclador_id => 1,
#    :prestacion_id => 1,
#    :precio_por_unidad => 70.0000,
#    :adicional_por_prestacion => 0.0000,
#    :unidades_maximas => 1 },
#  { :nomenclador_id => 1,
#    ...
#
#    y así sucesivamente
#
#    ...
#    }])
