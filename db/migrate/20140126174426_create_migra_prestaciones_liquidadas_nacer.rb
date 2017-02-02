class CreateMigraPrestacionesLiquidadasNacer < ActiveRecord::Migration
  def up
  	create_table :migra_prestaciones_liquidadas_nacer do |t|
      t.references :efector
      t.references :prestacion
      t.references :afiliado
      t.column :monto, "numeric(15,4)"
      t.date :fecha_de_la_prestacion

    end
  end

  def down
  	drop_table :migra_prestaciones_liquidadas_nacer
  end
end
