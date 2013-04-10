# -*- encoding : utf-8 -*-
class CreateMetodosDeValidacionPrestacionesJoinTable < ActiveRecord::Migration
  def change
    create_table :metodos_de_validacion_prestaciones, :id => false do |t|
      t.references :metodo_de_validacion
      t.references :prestacion
    end
  end
end
