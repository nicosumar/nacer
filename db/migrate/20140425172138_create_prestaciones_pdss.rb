# -*- encoding : utf-8 -*-
class CreatePrestacionesPdss < ActiveRecord::Migration

  def change

    create_table :prestaciones_pdss do |t|
      t.string :nombre, :null => false
      t.references :grupo_pdss
      t.integer :orden, :null => false
      t.references :linea_de_cuidado
      t.references :modulo
      t.references :tipo_de_prestacion

      t.timestamps
    end

    add_index :prestaciones_pdss, :grupo_pdss_id
    add_index :prestaciones_pdss, :linea_de_cuidado_id
    add_index :prestaciones_pdss, :modulo_id
    add_index :prestaciones_pdss, :tipo_de_prestacion_id
  end

end
