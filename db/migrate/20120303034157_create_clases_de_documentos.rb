# -*- encoding : utf-8 -*-
class CreateClasesDeDocumentos < ActiveRecord::Migration
  def change
    create_table :clases_de_documentos do |t|
      t.string :nombre
      t.string :codigo_para_prestaciones
      t.string :codigo_para_inscripciones
    end
  end
end
