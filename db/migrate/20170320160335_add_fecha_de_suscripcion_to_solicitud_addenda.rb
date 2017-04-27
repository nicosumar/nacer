class AddFechaDeSuscripcionToSolicitudAddenda < ActiveRecord::Migration
  def change
     add_column :solicitudes_addendas, :fecha_de_suscripcion, :date
     add_column :solicitudes_addendas, :fecha_de_inicio, :date
  end
end
