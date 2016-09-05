class AddActivoToDatosReportables < ActiveRecord::Migration
  def change
    add_column :datos_reportables, :activo, :boolean, :default => true
  end
end
