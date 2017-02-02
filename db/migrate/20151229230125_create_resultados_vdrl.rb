class CreateResultadosVdrl < ActiveRecord::Migration
  def change
    create_table :resultados_vdrl do |t|
      t.string :codigo
      t.string :nombre
      t.string :codigo_sirge
    end

    ResultadoVdrl.create!([
        {
          #id: 1,
          nombre: "Positivo",
          codigo: "P",
          codigo_sirge: "+"
        },
        {
          #id: 2,
          nombre: "Negativo",
          codigo: "N",
          codigo_sirge: "-"
        }
      ])
  end
end
