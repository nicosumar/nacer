class LoadPdssSeed < ActiveRecord::Migration
  def up
    load 'db/Diagnosticos2015_seed.rb'
    load 'db/PrestacionesSumar2015_seed.rb'
    load 'db/GruposPdss_seed.rb'
    load 'db/PrestacionesPdss_seed.rb'
    load 'db/PrestacionesPrestacionesPdss_seed.rb'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
