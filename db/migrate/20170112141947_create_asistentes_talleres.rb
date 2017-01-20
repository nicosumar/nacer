class CreateAsistentesTalleres < ActiveRecord::Migration
  def change
    create_table :asistentes_talleres do |t|
      t.references :efector
      t.references :prestacion_brindada
      t.references :clase_de_documento
      t.references :tipo_de_documento
      t.integer :numero_de_documento
      t.text :nombre
      t.text :apellido
      t.references :sexo
      t.date :fecha_de_nacimiento

      t.timestamps
    end
    add_index :asistentes_talleres, :efector_id
    add_index :asistentes_talleres, :prestacion_brindada_id
    add_index :asistentes_talleres, :clase_de_documento_id
    add_index :asistentes_talleres, :tipo_de_documento_id
    add_index :asistentes_talleres, :sexo_id
  end
end
