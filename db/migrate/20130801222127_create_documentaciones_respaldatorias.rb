class CreateDocumentacionesRespaldatorias < ActiveRecord::Migration
  def change
    create_table :documentaciones_respaldatorias do |t|
      t.string :nombre
      t.string :codigo
      t.text :descripcion

      t.timestamps
    end
  end
end
