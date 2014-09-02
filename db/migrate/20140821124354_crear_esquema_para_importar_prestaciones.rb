class CrearEsquemaParaImportarPrestaciones < ActiveRecord::Migration
  def up
    execute "
      CREATE SCHEMA procesos;
    "
  end

  def down
    execute "
      DROP SCHEMA procesos CASCADE;
    "
  end
end
