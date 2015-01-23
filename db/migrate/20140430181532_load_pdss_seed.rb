class LoadPdssSeed < ActiveRecord::Migration
  def up
    load 'db/GruposPdss_seed.rb'
    load 'db/SubgruposPdss_seed.rb'
    load 'db/ApartadosPdss_seed.rb'
    load 'db/PrestacionesPdss_seed.rb'
    load 'db/PrestacionesPrestacionesPdss_seed.rb'
  end

  def down
  end
end
