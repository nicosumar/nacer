class AddNumeroAddendaToSolicitudesAddendas < ActiveRecord::Migration
  def change
      add_column :solicitudes_addendas, :numero_addenda, :string
  end
end
