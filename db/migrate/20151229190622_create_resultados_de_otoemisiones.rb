class CreateResultadosDeOtoemisiones < ActiveRecord::Migration
  def change
    create_table :resultados_de_otoemisiones do |t|
      t.string :nombre
      t.string :codigo
      t.string :subcodigo_sirge
    end

    ResultadoDeOtoemision.create!([
        {
          #id: 1,
          nombre: "Pasa",
          codigo: "P",
          subcodigo_sirge: "pasa"
        },
        {
          #id: 2,
          nombre: "NO pasa",
          codigo: "NP",
          subcodigo_sirge: "nopasa"
        }
      ])
  end
end
