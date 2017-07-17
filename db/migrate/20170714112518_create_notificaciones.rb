class CreateNotificaciones < ActiveRecord::Migration
  def change
    create_table :notificaciones do |t|
      t.string :mensaje
      t.string :enlace
      t.date :fecha_lectura
      t.references :unidad_de_alta_de_datos
      t.boolean :tiene_vista
      t.date :fecha_evento

      t.timestamps
    end
    add_index :notificaciones, :unidad_de_alta_de_datos_id
  end
end
