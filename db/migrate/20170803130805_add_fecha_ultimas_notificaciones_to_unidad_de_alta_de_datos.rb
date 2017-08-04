class AddColumnUnidadesDeAltaDeDatos < ActiveRecord::Migration
  def change
    add_column :unidadDeAltaDeDatos, :fecha_ultimas_notificaciones, :date
  end
end
