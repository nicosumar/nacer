# -*- encoding : utf-8 -*-
class CreateMotivosDeRechazos < ActiveRecord::Migration
  def change
    create_table :motivos_de_rechazos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
