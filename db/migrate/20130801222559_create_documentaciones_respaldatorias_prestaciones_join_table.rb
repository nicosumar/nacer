# -*- encoding : utf-8 -*-
class CreateDocumentacionesRespaldatoriasPrestacionesJoinTable < ActiveRecord::Migration
  def change
    create_table :documentaciones_respaldatorias_prestaciones, :id => false do |t|
      t.references :documentacion_respaldatoria
      t.references :prestacion
    end
  end
end
