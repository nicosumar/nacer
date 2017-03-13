class CreateSolicitudesAddendas < ActiveRecord::Migration
  def change
    create_table :solicitudes_addendas do |t|
      t.date :fecha_solicitud
      t.date :fecha_revision_medica
      t.date :fecha_revision_legal
      t.string :fecha_envio_efector
      t.string :firmante
      t.string :numero
      t.text :observaciones
      t.references :convenio_de_gestion_sumar
      t.references :estado_solicitud_addenda
      t.timestamps
    end
    
    add_index :solicitudes_addendas,:estado_solicitud_addenda_id,:name => 'estado_solicitud_id'
    add_index :solicitudes_addendas, :convenio_de_gestion_sumar_id, :name => 'convenio_de_gestion_sumar_id'
  end
end
