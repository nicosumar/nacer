class CreateJoinTablePrestacionesPdssAreasDePrestacion < ActiveRecord::Migration
  def up
    create_table :areas_de_prestacion_prestaciones_pdss, index: false do |t|
      t.references :area_de_prestacion
      t.references :prestaciones_pdss
    end
  end

  def down
    drop_table :areas_de_prestaciones_prestaciones_pdss
  end
end
