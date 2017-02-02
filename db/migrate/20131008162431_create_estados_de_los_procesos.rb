class CreateEstadosDeLosProcesos < ActiveRecord::Migration
  def up
    create_table :estados_de_los_procesos do |t|
      t.string :nombre
      t.column :codigo, "char(1)"

      t.timestamps
    end
    
    load "db/EstadosDeLosProcesos_seed.rb"
  end

  def down
  	drop_table :estados_de_los_procesos

  	
  end
end
