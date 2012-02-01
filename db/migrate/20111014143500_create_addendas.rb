class CreateAddendas < ActiveRecord::Migration
  def change
    create_table :addendas do |t|
      t.references :convenio_de_gestion, :null => false
      t.string :firmante
      t.date :fecha_de_suscripcion
      t.date :fecha_de_inicio, :null => false

      t.timestamps
    end
  end
end
