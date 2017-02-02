class AgregarGruposDeEfectoresLiquidaciones < ActiveRecord::Migration
  def up
    load 'db/GruposDeEfectoresLiquidaciones_seed.rb'
  end

  def down
  end
end
