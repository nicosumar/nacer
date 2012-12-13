# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarPrestacionAutorizada < ActiveRecord::Migration
  execute "
    ALTER TABLE prestaciones_autorizadas
      ADD CONSTRAINT fk_prestaciones_autorizadas_efectores
      FOREIGN KEY (efector_id) REFERENCES efectores (id);
  "
  execute "
    ALTER TABLE prestaciones_autorizadas
      ADD CONSTRAINT fk_prestaciones_autorizadas_prestaciones
      FOREIGN KEY (prestacion_id) REFERENCES prestaciones (id);
  "
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#PrestacionAutorizada.create([
#  { #:id => 1,
#    :efector_id => 1,
#    :prestacion_id => 1,
#    :fecha_de_inicio => '2001-01-01',
#    :autorizante_al_alta_id => 1,
#    :autorizante_al_alta_type => 'ConvenioDeGestion',
#    :fecha_de_finalizacion => nil,
#    :autorizante_de_la_baja_id => nil,
#    :autorizante_de_la_baja_type => nil },
#  { #:id => 2,
#    ...
#
#    y así sucesivamente
#
#    ...
#    }])
