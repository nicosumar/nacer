class AddCamposBajaToPeriodosDeActividad < ActiveRecord::Migration
  def change
    add_column :periodos_de_actividad, :motivo_de_la_baja_id, :integer
    add_column :periodos_de_actividad, :mensaje_de_la_baja, :string
  end
end
