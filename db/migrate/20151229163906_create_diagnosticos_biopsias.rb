class CreateDiagnosticosBiopsias < ActiveRecord::Migration
  def up
    create_table :diagnosticos_biopsias do |t|
      t.string :codigo
      t.string :nombre
      t.integer :codigo_sirge
    end

    DiagnosticoBiopsia.create([
        {
          #id: 1
          codigo: "HSIL",
          nombre: "H-SIL",
          codigo_sirge: 1
        },
        {
          #id: 2
          codigo: "CIN2",
          nombre: "CIN 2",
          codigo_sirge: 2
        },
        {
          #id: 3
          codigo: "CIN3",
          nombre: "CIN 3",
          codigo_sirge: 3
        },
        {
          #id: 4
          codigo: "CIS",
          nombre: "CIS - Carcinoma in situ",
          codigo_sirge: 4
        },
        {
          #id: 5
          codigo: "CA",
          nombre: "Cáncer cervicouterino",
          codigo_sirge: 5
        },
        {
          #id: 6
          codigo: "LSIL",
          nombre: "Lesión de bajo grado (CIN 1/L-SIL)",
          codigo_sirge: 6
        },
        {
          #id: 7
          codigo: "NEG",
          nombre: "Sin lesión",
          codigo_sirge: 7
        }
      ])

  end

  def down
    drop_table :diagnosticos_biopsias
  end
end
