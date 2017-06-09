class AddTimestampsToDatosReportablesRequeridos < ActiveRecord::Migration
  def change
    add_column(:datos_reportables_requeridos, :created_at, :datetime)
     add_column(:datos_reportables_requeridos, :updated_at, :datetime)
  end
end
