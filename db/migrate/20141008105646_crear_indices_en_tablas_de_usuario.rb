class CrearIndicesEnTablasDeUsuario < ActiveRecord::Migration
  def change
    add_index :users, :current_sign_in_at
    add_index :unidades_de_alta_de_datos_users, :user_id
    add_index :unidades_de_alta_de_datos, [:activa, :id]
    add_index :user_groups_users, :user_id
  end
end
