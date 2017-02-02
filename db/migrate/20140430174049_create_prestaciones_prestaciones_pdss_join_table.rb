# -*- encoding : utf-8 -*-
class CreatePrestacionesPrestacionesPdssJoinTable < ActiveRecord::Migration

  def change
    create_table :prestaciones_prestaciones_pdss, :id => false do |t|
      t.references :prestacion_pdss, :null => false
      t.references :prestacion, :null => false
    end

    add_index :prestaciones_prestaciones_pdss, :prestacion_pdss_id
    add_index :prestaciones_prestaciones_pdss, :prestacion_id
    add_index :prestaciones_prestaciones_pdss, [:prestacion_pdss_id, :prestacion_id], :unique => true, :name => "prestaciones_prestaciones_pdss_uniq"
  end

end
