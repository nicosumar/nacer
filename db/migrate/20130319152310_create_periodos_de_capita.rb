class CreatePeriodosDeCapita < ActiveRecord::Migration
  def change
    create_table :periodos_de_capita do |t|
      t.integer :afiliado_id
      t.date :fecha_de_inicio
      t.date :fecha_de_finalizacion
      t.integer :capitas_al_inicio

      t.timestamps
    end
  end
end
