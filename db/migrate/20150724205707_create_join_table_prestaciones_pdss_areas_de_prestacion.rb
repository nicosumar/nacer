class CreateJoinTablePrestacionesPdssAreasDePrestacion < ActiveRecord::Migration
  def up
    create_table :areas_de_prestacion_prestaciones_pdss, id: false do |t|
      t.references :area_de_prestacion
      t.references :prestacion_pdss
    end

    load 'db/AreasDePrestacionPrestacionesPdss_seed.rb'
  end

  def down
    drop_table :areas_de_prestacion_prestaciones_pdss
  end
end
