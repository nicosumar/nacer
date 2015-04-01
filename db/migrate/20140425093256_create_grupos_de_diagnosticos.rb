class CreateGruposDeDiagnosticos < ActiveRecord::Migration
  def change
    create_table :grupos_de_diagnosticos do |t|
      t.string :codigo
      t.string :nombre
    end
  end
end
