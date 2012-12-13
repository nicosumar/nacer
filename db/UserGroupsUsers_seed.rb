# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificarUserGroupsUsers < ActiveRecord::Migration
  execute "
    ALTER TABLE user_groups_users
      ADD CONSTRAINT fk_ugu_user_id
      FOREIGN KEY (user_id) REFERENCES users (id);
  "

  execute "
    ALTER TABLE user_groups_users
      ADD CONSTRAINT fk_ugu_user_group_id
      FOREIGN KEY (user_group_id) REFERENCES user_groups (id);
  "
end
