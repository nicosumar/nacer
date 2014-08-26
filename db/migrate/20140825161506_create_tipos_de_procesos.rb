class CreateTiposDeProcesos < ActiveRecord::Migration
  def change
    create_table :tipos_de_procesos do |t|
      t.string :codigo
      t.string :nombre
      t.string :modelo_de_datos
    end

    load 'db/TiposDeProcesos_seed.rb'
  end
end
