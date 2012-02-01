# Crear las restricciones adicionales en la base de datos
class ModificarAddenda < ActiveRecord::Migration
  # Claves foráneas para asegurar la integridad referencial
  execute "
    ALTER TABLE addendas
      ADD CONSTRAINT fk_addendas_convenios_de_gestion
      FOREIGN KEY (convenio_de_gestion_id) REFERENCES convenios_de_gestion (id);
  "

  # Estructuras para la implementación de FTS en este modelo
end

# Puede ingresar aquí datos para que sean cargados al hacer el deploy
# inicial del sistema, cuando ejecute la tarea 'rake db:seed'
#
# Ejemplo:
#Addenda.create([
#  { #:id => 1,
#    :convenio_de_gestion_id => 1,
#    :firmante => 'Dr. NN',
#    :fecha_de_suscripcion => '2001-01-01',
#    :fecha_de_inicio => '2001-01-01' },
#  { #:id => 2,
#    :convenio_de_gestion_id => 2,
#    ...
#
#    y así sucesivamente
#
#    ...
#  }])
