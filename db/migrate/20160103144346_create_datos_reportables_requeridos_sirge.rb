class CreateDatosReportablesRequeridosSirge < ActiveRecord::Migration
  def up
    create_table :datos_reportables_requeridos_sirge do |t|
      t.references  :prestacion,             null: false
      t.references  :dato_reportable_sirge,  null: false
      t.integer     :orden,                  null: false
      t.timestamps
    end

    DatoReportableRequeridoSirge.create!([
        {
          #id: 1
          prestacion: Prestacion.find(258), # Control prenatal de 1a vez
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 2
          prestacion: Prestacion.find(258), # Control prenatal de 1a vez
          dato_reportable_sirge: DatoReportableSirge.find(5), # Registro de edad gestacional
          orden: 2
        },
        {
          #id: 3
          prestacion: Prestacion.find(258), # Control prenatal de 1a vez
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        # No ha sido especificado en el documento de la DOIU, pero para mí es una omisión.
        # Siempre se solicitó la talla en el control de 1a vez.
        {
          #id: 4
          prestacion: Prestacion.find(258), # Control prenatal de 1a vez
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 4
        },
        {
          #id: 5
          prestacion: Prestacion.find(259), # Ulterior de control prenatal
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 6
          prestacion: Prestacion.find(259), # Ulterior de control prenatal
          dato_reportable_sirge: DatoReportableSirge.find(5), # Registro de edad gestacional
          orden: 2
        },
        {
          #id: 7
          prestacion: Prestacion.find(259), # Ulterior de control prenatal
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 8
          prestacion: Prestacion.find(353), # Consulta inicial de diabetes gestacional
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 9
          prestacion: Prestacion.find(353), # Consulta inicial de diabetes gestacional
          dato_reportable_sirge: DatoReportableSirge.find(5), # Registro de edad gestacional
          orden: 2
        },
        {
          #id: 10
          prestacion: Prestacion.find(353), # Consulta inicial de diabetes gestacional
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 11
          prestacion: Prestacion.find(354), # Consulta de seguimiento de diabetes gestacional
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 12
          prestacion: Prestacion.find(354), # Consulta de seguimiento de diabetes gestacional
          dato_reportable_sirge: DatoReportableSirge.find(5), # Registro de edad gestacional
          orden: 2
        },
        {
          #id: 13
          prestacion: Prestacion.find(354), # Consulta de seguimiento de diabetes gestacional
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 14
          prestacion: Prestacion.find(324), # Consulta inicial de la embarazada con HTA crónica
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 15
          prestacion: Prestacion.find(324), # Consulta inicial de la embarazada con HTA crónica
          dato_reportable_sirge: DatoReportableSirge.find(5), # Registro de edad gestacional
          orden: 2
        },
        {
          #id: 16
          prestacion: Prestacion.find(324), # Consulta inicial de la embarazada con HTA crónica
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 17
          prestacion: Prestacion.find(325), # Consulta de seguimiento de la embarazada con HTA crónica
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 18
          prestacion: Prestacion.find(325), # Consulta de seguimiento de la embarazada con HTA crónica
          dato_reportable_sirge: DatoReportableSirge.find(5), # Registro de edad gestacional
          orden: 2
        },
        {
          #id: 19
          prestacion: Prestacion.find(325), # Consulta de seguimiento de la embarazada con HTA crónica
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 20
          prestacion: Prestacion.find(326), # Consulta inicial de hipertensión gestacional
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 21
          prestacion: Prestacion.find(326), # Consulta inicial de hipertensión gestacional
          dato_reportable_sirge: DatoReportableSirge.find(5), # Registro de edad gestacional
          orden: 2
        },
        {
          #id: 22
          prestacion: Prestacion.find(326), # Consulta inicial de hipertensión gestacional
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 23
          prestacion: Prestacion.find(327), # Consulta de seguimiento de hipertensión gestacional
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 24
          prestacion: Prestacion.find(327), # Consulta de seguimiento de hipertensión gestacional
          dato_reportable_sirge: DatoReportableSirge.find(5), # Registro de edad gestacional
          orden: 2
        },
        {
          #id: 25
          prestacion: Prestacion.find(327), # Consulta de seguimiento de hipertensión gestacional
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 26
          prestacion: Prestacion.find(369), # Consulta de seguimiento de post alta (APP)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 27
          prestacion: Prestacion.find(369), # Consulta de seguimiento de post alta (APP)
          dato_reportable_sirge: DatoReportableSirge.find(5), # Registro de edad gestacional
          orden: 2
        },
        {
          #id: 28
          prestacion: Prestacion.find(369), # Consulta de seguimiento de post alta (APP)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 29
          prestacion: Prestacion.find(383), # Otoemisiones acústicas para DTH en RN
          dato_reportable_sirge: DatoReportableSirge.find(8), # Resultado OEA (oído derecho)
          orden: 1
        },
        {
          #id: 30
          prestacion: Prestacion.find(383), # Otoemisiones acústicas para DTH en RN
          dato_reportable_sirge: DatoReportableSirge.find(9), # Resultado OEA (oído izquierdo)
          orden: 2
        },
        {
          #id: 31
          prestacion: Prestacion.find(391), # OBI a todo niño de riesgo (pesquisa de ROP)
          dato_reportable_sirge: DatoReportableSirge.find(10), # Resultado OBI (grado de ROP)
          orden: 1
        },
        {
          #id: 32
          prestacion: Prestacion.find(455), # Pediátrica en menores de 1 año
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 33
          prestacion: Prestacion.find(455), # Pediátrica en menores de 1 año
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 34
          prestacion: Prestacion.find(455), # Pediátrica en menores de 1 año
          dato_reportable_sirge: DatoReportableSirge.find(4), # Perímetro cefálico
          orden: 3
        },
        {
          #id: 35
          prestacion: Prestacion.find(456), # Pediátrica de 1 a 5 años
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 36
          prestacion: Prestacion.find(456), # Pediátrica de 1 a 5 años
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 37
          prestacion: Prestacion.find(493), # Control en niños de 6 a 9 años
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 38
          prestacion: Prestacion.find(493), # Control en niños de 6 a 9 años
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 39
          prestacion: Prestacion.find(493), # Control en niños de 6 a 9 años
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 40
          prestacion: Prestacion.find(494), # Control de salud individual para PI en terreno (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 41
          prestacion: Prestacion.find(494), # Control de salud individual para PI en terreno (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 42
          prestacion: Prestacion.find(494), # Control de salud individual para PI en terreno (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 43
          prestacion: Prestacion.find(521), # Examen periódico de salud del adolescente
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 44
          prestacion: Prestacion.find(521), # Examen periódico de salud del adolescente
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 45
          prestacion: Prestacion.find(521), # Examen periódico de salud del adolescente
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 46
          prestacion: Prestacion.find(522), # Control de salud individual para PI en terreno (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 47
          prestacion: Prestacion.find(522), # Control de salud individual para PI en terreno (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 48
          prestacion: Prestacion.find(522), # Control de salud individual para PI en terreno (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 49
          prestacion: Prestacion.find(586), # Diagnóstico por biopsia (CA de cuello)
          dato_reportable_sirge: DatoReportableSirge.find(12), # Informe resultado (biopsia CA cuello)
          orden: 1
        },
        {
          #id: 50
          prestacion: Prestacion.find(585), # Diagnóstico por biopsia (CA de mama)
          dato_reportable_sirge: DatoReportableSirge.find(11), # Informe resultado (biopsia CA mama)
          orden: 1
        },
        {
          #id: 51
          prestacion: Prestacion.find(875), # VDRL
          dato_reportable_sirge: DatoReportableSirge.find(15), # Informe resultado (biopsia CA mama)
          orden: 1
        },
        {
          #id: 52
          prestacion: Prestacion.find(260), # Odontológica prenatal (profilaxis)
          dato_reportable_sirge: DatoReportableSirge.find(6), # Índice CPOD
          orden: 1
        },
        {
          #id: 53
          prestacion: Prestacion.find(457), # Consulta buco-dental de salud en niños menores de 6 años
          dato_reportable_sirge: DatoReportableSirge.find(7), # Índice CeO
          orden: 1
        },
        {
          #id: 54
          prestacion: Prestacion.find(495), # Control odontológico (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(6), # Índice CPOD
          orden: 1
        },
        {
          #id: 55
          prestacion: Prestacion.find(495), # Control odontológico (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(7), # Índice CeO
          orden: 2
        },
        {
          #id: 56
          prestacion: Prestacion.find(516), # Obesidad inicial (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 57
          prestacion: Prestacion.find(516), # Obesidad inicial (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 58
          prestacion: Prestacion.find(516), # Obesidad inicial (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 59
          prestacion: Prestacion.find(517), # Obesidad ulterior (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 60
          prestacion: Prestacion.find(517), # Obesidad ulterior (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 61
          prestacion: Prestacion.find(517), # Obesidad ulterior (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 62
          prestacion: Prestacion.find(518), # Sobrepeso inicial (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 63
          prestacion: Prestacion.find(518), # Sobrepeso inicial (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 64
          prestacion: Prestacion.find(518), # Sobrepeso inicial (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 65
          prestacion: Prestacion.find(519), # Sobrepeso ulterior (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 66
          prestacion: Prestacion.find(519), # Sobrepeso ulterior (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 67
          prestacion: Prestacion.find(519), # Sobrepeso ulterior (6 a 9 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 68
          prestacion: Prestacion.find(524), # Control odontológico (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(6), # Índice CPOD
          orden: 1
        },
        {
          #id: 69
          prestacion: Prestacion.find(554), # Obesidad inicial (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 70
          prestacion: Prestacion.find(554), # Obesidad inicial (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 71
          prestacion: Prestacion.find(554), # Obesidad inicial (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 72
          prestacion: Prestacion.find(555), # Obesidad ulterior (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 73
          prestacion: Prestacion.find(555), # Obesidad ulterior (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 74
          prestacion: Prestacion.find(555), # Obesidad ulterior (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 75
          prestacion: Prestacion.find(556), # Sobrepeso inicial (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 76
          prestacion: Prestacion.find(556), # Sobrepeso inicial (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 77
          prestacion: Prestacion.find(556), # Sobrepeso inicial (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 78
          prestacion: Prestacion.find(557), # Sobrepeso ulterior (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(1), # Peso
          orden: 1
        },
        {
          #id: 79
          prestacion: Prestacion.find(557), # Sobrepeso ulterior (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(2), # Talla
          orden: 2
        },
        {
          #id: 80
          prestacion: Prestacion.find(557), # Sobrepeso ulterior (10 a 19 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 3
        },
        {
          #id: 81
          prestacion: Prestacion.find(560), # Examen periódico de salud (mujeres 20 a 64 años)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 1
        },
        {
          #id: 82
          prestacion: Prestacion.find(561), # Control de salud individual para PI en terreno (mujeres 20-64)
          dato_reportable_sirge: DatoReportableSirge.find(3), # Toma de TA
          orden: 1
        },
        {
          #id: 83
          prestacion: Prestacion.find(563), # Control odontológico (mujeres 20 a 64 años)
          dato_reportable_sirge: DatoReportableSirge.find(6), # Índice CPOD
          orden: 1
        },
        {
          #id: 84
          prestacion: Prestacion.find(583), # Mamografía
          dato_reportable_sirge: DatoReportableSirge.find(14), # Resultado expresado en BIRADS
          orden: 1
        },
        {
          #id: 85
          prestacion: Prestacion.find(587), # Informe o transcripción de resultado (lectura de PAP)
          dato_reportable_sirge: DatoReportableSirge.find(13), # Diagnóstico citológico
          orden: 1
        },
        {
          #id: 86
          prestacion: Prestacion.find(590), # Notificación de inicio de tratamiento (CA de cuello)
          dato_reportable_sirge: DatoReportableSirge.find(16), # Tratamiento instaurado (CA de cuello)
          orden: 1
        }
      ])

    add_index :datos_reportables_requeridos_sirge, :prestacion_id
    add_index :datos_reportables_requeridos_sirge, :dato_reportable_sirge_id,
      name: "idx_drrs_on_dato_reportable_sirge_id"
    add_index :datos_reportables_requeridos_sirge,
      [:prestacion_id, :dato_reportable_sirge_id], unique: true, name: "idx_uniq_drrs_on_prestacion_drs"
    add_index :datos_reportables_requeridos_sirge,
      [:prestacion_id, :orden], unique: true, name: "idx_uniq_drrs_on_prestacion_orden"

    execute "
      ALTER TABLE datos_reportables_requeridos_sirge
        ADD CONSTRAINT fk_drrs_prestaciones
        FOREIGN KEY (prestacion_id) REFERENCES prestaciones (id);
      ALTER TABLE datos_reportables_requeridos_sirge
        ADD CONSTRAINT fk_drrs_datos_reportables_sirge
        FOREIGN KEY (dato_reportable_sirge_id) REFERENCES datos_reportables_sirge (id);
    "

  end

  def down
    remove_index :datos_reportables_requeridos_sirge, name: "idx_uniq_drrs_on_prestacion_orden"
    remove_index :datos_reportables_requeridos_sirge, name: "idx_uniq_drrs_on_prestacion_drs"
    remove_index :datos_reportables_requeridos_sirge, :prestacion_id
    remove_index :datos_reportables_requeridos_sirge, name: "idx_drrs_on_dato_reportable_sirge_id"
    drop_table :datos_reportables_requeridos_sirge
  end
end
