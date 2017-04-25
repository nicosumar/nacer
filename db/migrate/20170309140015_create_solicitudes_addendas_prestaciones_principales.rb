class CreateSolicitudesAddendasPrestacionesPrincipales < ActiveRecord::Migration
  def change
    create_table :solicitudes_addendas_prestaciones_principales do |t|
      t.string :observaciones
      t.references :solicitud_addenda
      t.boolean :es_autorizacion
      t.boolean :aprobado_por_medica
      t.references :prestacion_principal
      t.references :estado_solicitud_addenda
      t.timestamps
    end
    add_index :solicitudes_addendas_prestaciones_principales, :solicitud_addenda_id, :name => 'solicitud_addenda_id'
    add_index :solicitudes_addendas_prestaciones_principales, :prestacion_principal_id, :name => ':prestacion_principal_id'
    
  end
end
