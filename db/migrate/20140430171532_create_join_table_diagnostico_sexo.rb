class CreateJoinTableDiagnosticoSexo < ActiveRecord::Migration
  def up
    create_table :diagnosticos_sexos, id: false do |t|
      t.references :diagnostico
      t.references :sexo
    end
  end

  def down
  end
end
