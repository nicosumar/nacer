class CreateEstadosProcesosDeSistemas < ActiveRecord::Migration
  def change
    create_table :estados_procesos_de_sistemas do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
