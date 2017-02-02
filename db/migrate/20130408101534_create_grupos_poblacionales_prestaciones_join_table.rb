# -*- encoding : utf-8 -*-
class CreateGruposPoblacionalesPrestacionesJoinTable < ActiveRecord::Migration
  def change
    create_table :grupos_poblacionales_prestaciones, :id => false do |t|
      t.references :grupo_poblacional
      t.references :prestacion
    end
  end
end
