class CreatePlantillasDeReglas < ActiveRecord::Migration
  def change
    create_table :plantillas_de_reglas do |t|
      t.string :nombre
      t.text :observaciones
      t.timestamps
    end
  end
end
