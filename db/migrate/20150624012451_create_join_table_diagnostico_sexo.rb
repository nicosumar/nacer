class CreateJoinTableDiagnosticoSexo < ActiveRecord::Migration
  def up
    create_table :diagnosticos_sexos do |t|
      t.diagnostico :references
      t.sexo :references
    end

    ActiveRecord::Base.connection.execute "
      ALTER TABLE ONLY diagnosticos_sexos ADD CONSTRAINT fk_diagnosticos_sexos_diagnostico_id (diagnostico_id) REFERENCES diagnosticos (id);
      ALTER TABLE ONLY diagnosticos_sexos ADD CONSTRAINT fk_diagnosticos_sexos_sexo_id (sexo_id) REFERENCES sexos (id);
    "
    load 'db/DiagnosticosSexos_seed.rb'

  end

  def down
    drop_table :
  end
end
