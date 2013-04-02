class CreateDiagnosticosPrestacionesJoinTable < ActiveRecord::Migration
  def change
    create_table :diagnosticos_prestaciones, :id => false do |t|
      t.references :diagnostico
      t.references :prestacion
    end
  end
end
