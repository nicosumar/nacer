class CreateOrganismosGubernamentales < ActiveRecord::Migration
  def change
    create_table :organismos_gubernamentales do |t|
      t.text :nombre
      t.text :domicilio
      t.references :provincia
      t.references :departamento
      t.references :distrito
      t.text :codigo_postal
      t.text :telefonos
      t.text :email

      t.timestamps
    end
    add_index :organismos_gubernamentales, :provincia_id
    add_index :organismos_gubernamentales, :departamento_id
    add_index :organismos_gubernamentales, :distrito_id
  end
end
