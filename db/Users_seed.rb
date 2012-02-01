# Crear las restricciones adicionales en la base de datos
class ModificarUserGroupsUsersJoinTable < ActiveRecord::Migration
  execute "
    ALTER TABLE user_groups_users
      ADD CONSTRAINT fk_users
      FOREIGN KEY (user_id) REFERENCES users (id);
  "
end

# Crear el primer usuario en el grupo "Administradores"
# El login es 'admin' al igual que la contraseña.
# ¡CREE UN NUEVO USUARIO ADMINISTRADOR CON OTRA CONTRASEÑA ANTES DE PASAR
# EL SISTEMA A PRODUCCIÓN!
admin = User.new(
  #:id => 1,
  :firstname => "Usuario",
  :lastname => "Administrador",
  :login => 'admin',
  :email => 'cambiame@por-uno-real.com',
  :crypted_password => "eedead46d1b1945206b4df2f991e29de5b5a13f133150df97fd64b1d981b40085fc8b12feae560ae4ce3bee0abc17b04dc0cb3d6b28d3471e4da847d34db96bd",
  :password_salt => "tDKNLxXqV3oTYbrWeB",
  :persistence_token => "e31e453dabc826d3cd4fa38e91a6a033a85172053a50167ea6943f447e44a34266b5921f57483632f857146846c5f32b8ae15cd20d0704b1fbee7bcd3dce52cb"
)

admin.save(:validate => false)

admin_group = UserGroup.find(1)

admin.user_groups << admin_group
