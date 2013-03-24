# -*- encoding : utf-8 -*-
class CreatePeriodosDeCobertura < ActiveRecord::Migration
  def change
    create_table :periodos_de_cobertura do |t|
      t.integer :afiliado_id
      t.date :fecha_de_inicio
      t.date :fecha_de_finalizacion

      t.timestamps
    end
  end
end
