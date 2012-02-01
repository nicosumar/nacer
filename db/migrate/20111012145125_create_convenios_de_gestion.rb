class CreateConveniosDeGestion < ActiveRecord::Migration
  def change
    create_table :convenios_de_gestion do |t|
      t.string :numero, :null => false
      t.references :efector, :null => false
      t.string :firmante
      t.string :email_notificacion
      t.date :fecha_de_suscripcion
      t.date :fecha_de_inicio, :null => false
      t.date :fecha_de_finalizacion, :null => false
      t.text :observaciones

      t.timestamps
    end
  end
end
