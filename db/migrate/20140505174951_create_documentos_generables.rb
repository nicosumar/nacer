class CreateDocumentosGenerables < ActiveRecord::Migration
  def up
    create_table :documentos_generables do |t|
      t.string :nombre, null: false
      t.string :modelo, null: false

      t.timestamps
    end

    DocumentoGenerable.create([
      { #ID: 1
        nombre: "Cuasifactura Sumar",
        modelo: "LiquidacionSumarCuasifactura"
      },
      { #ID: 2
        nombre: "Consolidado Sumar",
        modelo: "ConsolidadoSumar"
      },
      { #ID: 3
        nombre: "Expediente de Liquidacion Sumar",
        modelo: "ExpedienteSumar"
      },
      { #ID: 4
        nombre: "Informes de Liquidacion Sumar",
        modelo: "LiquidacionInforme"
      }

    ])
  end

  def down
    drop_table :documentos_generables
  end
end
