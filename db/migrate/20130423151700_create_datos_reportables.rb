# -*- encoding : utf-8 -*-
class CreateDatosReportables < ActiveRecord::Migration
  def change
    create_table :datos_reportables do |t|
      t.string :nombre, :null => false
      t.string :codigo, :null => false
      t.string :tipo_postgres, :null => false
      t.string :tipo_ruby, :null => false
      t.string :sirge_id
      t.boolean :enumerable
      t.string :clase_para_enumeracion
      t.boolean :integra_grupo
      t.string :nombre_de_grupo
    end
  end
end
