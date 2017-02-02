class CreateDiagnosticosBiopsiasMamas < ActiveRecord::Migration
  def change
    create_table :diagnosticos_biopsias_mamas do |t|
      t.string :codigo
      t.string :nombre
      t.integer :codigo_sirge
    end

    DiagnosticoBiopsiaMama.create([
        {
          #id: 1
          codigo: "IS",
          nombre: "In situ",
          codigo_sirge: 1
        },
        {
          #id: 2
          codigo: "INV",
          nombre: "Invasor",
          codigo_sirge: 2
        },
        {
          #id: 3
          codigo: "OC",
          nombre: "Oculto",
          codigo_sirge: 3
        },
        {
          #id: 4
          codigo: "OTRO",
          nombre: "Otro CA",
          codigo_sirge: 4
        },
        {
          #id: 5
          codigo: "PRE",
          nombre: "Preneoplásica",
          codigo_sirge: 5
        },
        {
          #id: 6
          codigo: "BEN",
          nombre: "Benigno",
          codigo_sirge: 6
        },
        {
          #id: 7
          codigo: "INS",
          nombre: "Insatisfactorio",
          codigo_sirge: 7
        }
      ])
  end
end
