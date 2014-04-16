class CreateCantidadesDePrestacionesPorPeriodo < ActiveRecord::Migration
  def change
    create_table :cantidades_de_prestaciones_por_periodo do |t|
      t.references :prestacion, :null => false
      t.integer :cantidad_maxima, :null => false
      t.string :periodo
      t.string :intervalo
    end

    load 'db/CantidadesDePrestacionesPorPeriodo_seed.rb'
  end
end
