# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarSexo < ActiveRecord::Migration
  execute "
    ALTER TABLE contactos
      ADD CONSTRAINT fk_contactos_sexos
      FOREIGN KEY (sexo_id) REFERENCES sexos (id);
  "
  execute "
    ALTER TABLE users
      ADD CONSTRAINT fk_users_sexos
      FOREIGN KEY (sexo_id) REFERENCES sexos (id);
  "
end

# Datos precargados al inicializar el sistema
Sexo.create([
        { #:id => 1,
          :nombre => "Femenino",
          :codigo => "F" },
        { #:id => 2,
          :nombre => "Masculino",
          :codigo => "M" }
])
