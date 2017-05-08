class CreateTiposProcesosDeSistemas < ActiveRecord::Migration
  def change
    create_table :tipos_procesos_de_sistemas do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
