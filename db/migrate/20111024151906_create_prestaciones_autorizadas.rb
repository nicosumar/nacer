# -*- encoding : utf-8 -*-
class CreatePrestacionesAutorizadas < ActiveRecord::Migration
  def change
    create_table :prestaciones_autorizadas do |t|
      t.references :efector, :null => false
      t.references :prestacion, :null => false
      t.date :fecha_de_inicio, :null => false
      t.references :autorizante_al_alta, :polymorphic => true
      t.date :fecha_de_finalizacion
      t.references :autorizante_de_la_baja, :polymorphic => true

      t.timestamps
    end
  end
end
