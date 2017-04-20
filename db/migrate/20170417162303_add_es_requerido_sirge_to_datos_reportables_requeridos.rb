class AddEsRequeridoSirgeToDatosReportablesRequeridos < ActiveRecord::Migration
  def change
    add_column :datos_reportables_requeridos, :es_requerido_sirge, :boolean
  end
end
