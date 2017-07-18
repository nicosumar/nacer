class CreateInformesDeRendicion < ActiveRecord::Migration
  def change
    create_table :informes_de_rendicion do |t|
      t.date :fecha_informe
      t.float :total
      t.references :efector
      t.references :estado_del_proceso
      t.string :codigo
      t.boolean :rechazado

      t.timestamps
    end
    add_index :informes_de_rendicion, :efector_id
  end
end
