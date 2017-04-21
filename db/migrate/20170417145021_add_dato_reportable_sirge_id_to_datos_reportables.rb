class AddDatoReportableSirgeIdToDatosReportables < ActiveRecord::Migration
  def change
      add_column :datos_reportables, :dato_reportable_sirge_id, :integer
      add_index  :datos_reportables, :dato_reportable_sirge_id, :name => 'dato_reportable_sirge_id'
  end
  
end
