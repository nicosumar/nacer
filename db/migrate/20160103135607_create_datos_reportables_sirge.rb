class CreateDatosReportablesSirge < ActiveRecord::Migration
  def up
    create_table :datos_reportables_sirge do |t|
      t.string      :nombre, null: false
      t.string      :codigo, null: false, unique: true
      t.integer     :sirge_id, null: false
      t.string      :funcion_de_transformacion, null: false, unique: true
      t.timestamps
    end

    DatoReportableSirge.create!([
        {
          #id: 1
          nombre: "Peso",
          codigo: "PKG",
          sirge_id: 1,
          funcion_de_transformacion: "sirge_dr_peso"
        },
        {
          #id: 2
          nombre: "Talla",
          codigo: "TCM",
          sirge_id: 2,
          funcion_de_transformacion: "sirge_dr_talla"
        },
        {
          #id: 3
          nombre: "Toma de tensión arterial",
          codigo: "TA",
          sirge_id: 3,
          funcion_de_transformacion: "sirge_dr_toma_tension_arterial"
        },
        {
          #id: 4
          nombre: "Perímetro cefálico",
          codigo: "PC",
          sirge_id: 4,
          funcion_de_transformacion: "sirge_dr_perimetro_cefalico"
        },
        {
          #id: 5
          nombre: "Registro de edad gestacional",
          codigo: "EG",
          sirge_id: 5,
          funcion_de_transformacion: "sirge_dr_registro_edad_gestacional"
        },
        {
          #id: 6
          nombre: "Ïndice CPOD",
          codigo: "CPOD",
          sirge_id: 6,
          funcion_de_transformacion: "sirge_dr_cpod"
        },
        {
          #id: 7
          nombre: "Ïndice CeO",
          codigo: "CEO",
          sirge_id: 6,
          funcion_de_transformacion: "sirge_dr_ceo"
        },
        {
          #id: 8
          nombre: "Resultado OEA (oído derecho)",
          codigo: "ROD",
          sirge_id: 7,
          funcion_de_transformacion: "sirge_dr_resultado_oea_od"
        },
        {
          #id: 9
          nombre: "Resultado OEA (oído izquierdo)",
          codigo: "ROI",
          sirge_id: 7,
          funcion_de_transformacion: "sirge_dr_resultado_oea_oi"
        },
        {
          #id: 10
          nombre: "Resultado OBI (grado de retinopatía)",
          codigo: "ROP",
          sirge_id: 8,
          funcion_de_transformacion: "sirge_dr_resultado_obi"
        },
        {
          #id: 11
          nombre: "Informe o transcripción de resultados (biopsia CA mama)",
          codigo: "DIAGAPBM",
          sirge_id: 9,
          funcion_de_transformacion: "sirge_dr_resultado_biopsia_mama"
        },
        {
          #id: 12
          nombre: "Informe o transcripción de resultados (biopsia CA cuello)",
          codigo: "DIAGAPB",
          sirge_id: 10,
          funcion_de_transformacion: "sirge_dr_resultado_biopsia"
        },
        {
          #id: 13
          nombre: "Informe o transcripción de resultados (lectura PAP)",
          codigo: "DIAGAPC",
          sirge_id: 11,
          funcion_de_transformacion: "sirge_dr_resultado_citologia"
        },
        {
          #id: 14
          nombre: "Informe o transcripción de resultados (mamografía)",
          codigo: "BIRADS",
          sirge_id: 12,
          funcion_de_transformacion: "sirge_dr_resultado_birads"
        },
        {
          #id: 15
          nombre: "Informe o transcripción de resultados (VDRL)",
          codigo: "VDRL",
          sirge_id: 13,
          funcion_de_transformacion: "sirge_dr_resultado_vdrl"
        },
        {
          #id: 16
          nombre: "Tratamiento instaurado (CA cuello)",
          codigo: "TRATC",
          sirge_id: 14,
          funcion_de_transformacion: "sirge_dr_tratamiento_instaurado_cu"
        }
      ])
  end

  def down
    drop_table :datos_reportables_sirge
  end
end
