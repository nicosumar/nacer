class CreateSolicitudesAddendas < ActiveRecord::Migration
  def change
    create_table :solicitudes_addendas do |t|
      t.date :fecha_solicitud
      t.date :fecha_revision_medica
      t.date :fecha_revision_legal
      t.date :fecha_envio_a_efector
      t.text :observaciones
      t.references :efector

      t.timestamps
    end
    add_index :solicitudes_addendas, :efector_id
  end
end
