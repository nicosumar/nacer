class CreateSolicitudesAddendasPrestaciones < ActiveRecord::Migration
  def change
    create_table :solicitudes_addendas_prestaciones do |t|
      t.boolean :es_autorizacion
      t.string :observaciones
      t.boolean :aprobacion_medica
      t.references :solicitud_addenda

      t.timestamps
    end
    add_index :solicitudes_addendas_prestaciones, :solicitud_addenda_id
  end
end
