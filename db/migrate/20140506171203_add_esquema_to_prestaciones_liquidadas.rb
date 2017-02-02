class AddEsquemaToPrestacionesLiquidadas < ActiveRecord::Migration
  def change
  	add_column :prestaciones_liquidadas, :esquema, :string
  end
end
