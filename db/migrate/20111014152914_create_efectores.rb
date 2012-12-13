# -*- encoding : utf-8 -*-
class CreateEfectores < ActiveRecord::Migration
  def change
    create_table :efectores do |t|
      t.string :cuie, :null => false
      t.string :efector_sissa_id
      t.integer :efector_bio_id
      t.string :nombre, :null => false
      t.string :domicilio
      t.references :departamento
      t.references :distrito
      t.string :codigo_postal
      t.string :latitud
      t.string :longitud
      t.string :telefonos
      t.string :email
      t.references :grupo_de_efectores
      t.references :area_de_prestacion
      t.integer :camas_de_internacion
      t.integer :ambientes
      t.references :dependencia_administrativa
      t.boolean :integrante, :null => false, :default => true
      t.boolean :evaluacion_de_impacto
      t.text :observaciones

      t.timestamps
    end
  end
end
