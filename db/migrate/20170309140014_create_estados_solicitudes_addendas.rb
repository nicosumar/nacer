class CreateEstadosSolicitudesAddendas < ActiveRecord::Migration
  def change
    create_table :estados_solicitudes_addendas do |t|
      t.string :nombre
      t.string :codigo
      t.boolean :pendiente
      t.boolean :indexable
      t.timestamps
    end

    load 'db/EstadosSolicitudesAddendas_seed.rb'
  end
end
