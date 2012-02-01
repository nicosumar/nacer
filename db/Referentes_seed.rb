# Crear las restricciones adicionales en la base de datos
class ModificarReferente < ActiveRecord::Migration
  execute "
    ALTER TABLE referentes
      ADD CONSTRAINT fk_referentes_efectores
      FOREIGN KEY (efector_id) REFERENCES efectores (id);
  "
  execute "
    ALTER TABLE referentes
      ADD CONSTRAINT fk_referentes_contactos
      FOREIGN KEY (contacto_id) REFERENCES contactos (id);
  "
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#Referente.create([
#  { #:id => 1,
#    :efector_id => 1,
#    :contacto_id => 1 },
#  { #:id => 2,
#    ...
#
#    y así sucesivamente
#
#    ...
#    }])
