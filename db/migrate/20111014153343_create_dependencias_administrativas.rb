# -*- encoding : utf-8 -*-
class CreateDependenciasAdministrativas < ActiveRecord::Migration
  def change
    create_table :dependencias_administrativas do |t|
      t.string :nombre, :null => false
      t.string :tipo_de_dependencia
    end
  end
end
