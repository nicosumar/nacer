class AgregarPrestacionesFaltantes < ActiveRecord::Migration
  def up
    load 'db/PrestacionesSumarFaltantes_seed.rb'
  end

  def down
  end
end
