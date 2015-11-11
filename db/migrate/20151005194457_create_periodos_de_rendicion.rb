class CreatePeriodosDeRendicion < ActiveRecord::Migration
  def change
    create_table :periodos_de_rendicion do |t|
      t.string :nombre
      t.date :fecha_desde
      t.date :fecha_hasta

      t.timestamps
    end
  end
end
