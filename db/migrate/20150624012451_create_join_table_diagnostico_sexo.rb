class CreateJoinTableDiagnosticoSexo < ActiveRecord::Migration
  def up
    create_table :diagnosticos_sexos, id: false do |t|
      t.references :diagnostico
      t.references :sexo
    end

    execute "
      ALTER TABLE ONLY diagnosticos_sexos
        ADD CONSTRAINT fk_diagnosticos_sexos_diagnostico_id
        FOREIGN KEY (diagnostico_id) REFERENCES diagnosticos (id);
      ALTER TABLE ONLY diagnosticos_sexos
        ADD CONSTRAINT fk_diagnosticos_sexos_sexo_id
        FOREIGN KEY (sexo_id) REFERENCES sexos (id);
    "

    load 'db/DiagnosticosSexos_seed.rb'
  end

  def down
  end
end
