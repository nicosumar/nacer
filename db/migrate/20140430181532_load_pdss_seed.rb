class LoadPdssSeed < ActiveRecord::Migration
  def up
    load 'db/DiagnosticosSumar2015_seed.rb'
    load 'db/PrestacionesSumar2015_seed.rb'
    load 'db/SeccionesPdss_seed.rb'
    load 'db/GruposPdss_seed.rb'
    load 'db/LineasDeCuidados_seed.rb'
    load 'db/Modulos_seed.rb'
    load 'db/PrestacionesPdss_seed.rb'
    load 'db/PrestacionesPrestacionesPdss_seed.rb'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
