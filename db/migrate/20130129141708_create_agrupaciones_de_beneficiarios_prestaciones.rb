class CreateAgrupacionesDeBeneficiariosPrestaciones < ActiveRecord::Migration
  def change
    create_table :agrupaciones_de_beneficiarios_prestaciones do |t|
      t.references :agrupacion_de_beneficiarios
      t.references :prestacion
      t.string :nombre
      t.boolean :activa
    end
  end
end
