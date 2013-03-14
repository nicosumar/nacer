# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarPrestacion < ActiveRecord::Migration
  execute "
    ALTER TABLE prestaciones
      ADD CONSTRAINT fk_prestaciones_areas
      FOREIGN KEY (area_de_prestacion_id) REFERENCES areas_de_prestacion (id);
  "
  execute "
    ALTER TABLE prestaciones
      ADD CONSTRAINT fk_prestaciones_grupos
      FOREIGN KEY (grupo_de_prestaciones_id) REFERENCES grupos_de_prestaciones (id);
  "
  execute "
    ALTER TABLE prestaciones
      ADD CONSTRAINT fk_prestaciones_subgrupos
      FOREIGN KEY (subgrupo_de_prestaciones_id) REFERENCES subgrupos_de_prestaciones (id);
  "
  execute "
    ALTER TABLE prestaciones
      ADD CONSTRAINT fk_prestaciones_unidades_de_medida
      FOREIGN KEY (unidad_de_medida_id) REFERENCES unidades_de_medida (id);
  "
  execute "
    ALTER TABLE prestaciones
      ADD CONSTRAINT fk_prestaciones_tipos_de_prestaciones
      FOREIGN KEY (tipo_de_prestacion_id) REFERENCES tipos_de_prestaciones (id);
  "
  execute "
    ALTER TABLE prestaciones
      ADD CONSTRAINT fk_prestaciones_agrupacion_de_beneficiarios
      FOREIGN KEY (agrupacion_de_beneficiarios_id) REFERENCES agrupaciones_de_beneficiarios (id);
  "
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#Prestacion.create([
#  { #:id => 1,
#    :area_de_prestacion_id => 1,
#    :grupo_de_prestaciones_id => 1,
#    :subgrupo_de_prestaciones_id => 1,
#    :codigo => 'NNN 99',
#    :nombre => 'Consulta veterinaria',
#    :unidad_de_medida_id => 1 },
#  { #:id => 2,
#    ...
#
#    y así sucesivamente
#
#    ...
#    }])
