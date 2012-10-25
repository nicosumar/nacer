class CreateUnidadesDeAltaDeDatosUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :unidades_de_alta_de_datos_users, :id => false do |t|
      t.references :unidad_de_alta_de_datos
      t.references :user
      t.boolean :predeterminada
      t.integer :creator_id
      t.integer :updater_id
      t.timestamps
    end
  end
end
