class CreateEfectores < ActiveRecord::Migration
  def change
    create_table :efectores do |t|
      t.string :cuie, :null => false
      t.string :efector_sissa_id
      t.integer :efector_bio_id
      t.string :nombre, :null => false
      t.string :domicilio
      t.references :departamento, :null => true
      t.references :distrito, :null => true
      t.string :codigo_postal
      t.string :latitud
      t.string :longitud
      t.string :telefonos
      t.string :email
      t.references :grupo_de_efectores, :null => true
      t.references :area_de_prestacion, :null => true
      t.integer :camas_de_internacion
      t.integer :ambientes
      t.references :dependencia_administrativa, :null => true
      t.boolean :integrante, :null => false
      t.boolean :evaluacion_de_impacto
      t.text :observaciones

      t.timestamps
    end
  end
end
