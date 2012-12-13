# -*- encoding : utf-8 -*-
class CreateSequencesForInscripciones < ActiveRecord::Migration
  def up
    execute "
      CREATE SEQUENCE secuencia_clave_de_beneficiario;
    "
    execute "
      CREATE SEQUENCE secuencia_archivo_a;
    "
  end

  def down
    execute "
      DROP SEQUENCE secuencia_clave_de_beneficiario;
    "
    execute "
      DROP SEQUENCE secuencia_archivo_a;
    "
  end
end
