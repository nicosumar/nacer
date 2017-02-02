# -*- encoding : utf-8 -*-
class ModifyClasesDeDocumentos < ActiveRecord::Migration
  def change
    remove_column :clases_de_documentos, :codigo_para_prestaciones
    rename_column :clases_de_documentos, :codigo_para_inscripciones, :codigo
  end
end
