# Crear las restricciones adicionales en la base de datos
class ModificarUserGroupsUsersJoinTable < ActiveRecord::Migration
  execute "
    ALTER TABLE user_groups_users
      ADD CONSTRAINT fk_user_groups
      FOREIGN KEY (user_group_id) REFERENCES user_groups (id);
  "
end

# Datos precargados al inicializar el sistema
UserGroup.create([
  { #:id => 1,
    :user_group_name => 'Administradores' }
])
