# -*- encoding : utf-8 -*-
class CreatePeriodosDeActividad < ActiveRecord::Migration
  def change
    create_table :periodos_de_actividad do |t|
      t.integer :afiliado_id
      t.date :fecha_de_inicio
      t.date :fecha_de_finalizacion

      t.timestamps
    end
  end
end
