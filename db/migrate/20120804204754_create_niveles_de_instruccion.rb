class CreateNivelesDeInstruccion < ActiveRecord::Migration
  def change
    create_table :niveles_de_instruccion do |t|
      t.string :nombre
      t.string :codigo_para_gestion
    end
  end
end
