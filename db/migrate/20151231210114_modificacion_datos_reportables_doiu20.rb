class ModificacionDatosReportablesDoiu20 < ActiveRecord::Migration

  def up
    fecha_anexo_1 = Date.new(2016, 1, 1)
    fecha_anexo_2 = Date.new(2016, 7, 1)


    ###
    ### MODIFICACIÓN DE LA DEFINICIÓN DE DATOS REPORTABLES PARA ADAPTARLOS A LA DOIU 20
    ###

    # Nueva definición para el DR "Peso (en kilogramos)"
    dr_pkg2 = DatoReportable.create!({
        nombre: "Peso (en kilogramos)",
        codigo: "PKG2",
        tipo_postgres: "numeric(6, 3)",
        tipo_ruby: "big_decimal",
        sirge_id: 1,
        enumerable: false,
        clase_para_enumeracion: nil,
        integra_grupo: false,
        nombre_de_grupo: nil,
        codigo_de_grupo: nil,
        orden_de_grupo: nil,
        opciones_de_formateo: "{:size => 6}"
      })

    # Nueva definición para el DR "Talla (en centímetros)"
    dr_tcm2 = DatoReportable.create!({
        nombre: "Talla (en centímetros)",
        codigo: "TCM2",
        tipo_postgres: "numeric(4, 1)",
        tipo_ruby: "big_decimal",
        sirge_id: 2,
        enumerable: false,
        clase_para_enumeracion: nil,
        integra_grupo: false,
        nombre_de_grupo: nil,
        codigo_de_grupo: nil,
        orden_de_grupo: nil,
        opciones_de_formateo: "{:size => 6}"
      })

    # Nueva definición para el DR "EG (en semanas)"
    dr_eg2 = DatoReportable.create!({
        nombre: "Edad gestacional (en semanas cumplidas)",
        codigo: "EG2",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 5,
        enumerable: false,
        clase_para_enumeracion: nil,
        integra_grupo: false,
        nombre_de_grupo: nil,
        codigo_de_grupo: nil,
        orden_de_grupo: nil,
        opciones_de_formateo: "{:size => 6}"
      })

    # Mantenemos la definición del DR "Tensión arterial sistólica"
    dr_tas = DatoReportable.where(codigo: "TAS").first

    # Mantenemos la definición del DR "Tensión arterial diastólica"
    dr_tad = DatoReportable.where(codigo: "TAD").first

    # Nueva definición para el DR "Resultado OEA (oído derecho)"
    dr_rod2 = DatoReportable.create!({
        nombre: "Oído derecho",
        codigo: "ROD2",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 7,
        enumerable: true,
        clase_para_enumeracion: "ResultadoDeOtoemision",
        integra_grupo: true,
        nombre_de_grupo: "Resultados de la otoemisión acústica",
        codigo_de_grupo: "re_oea",
        orden_de_grupo: 1,
        opciones_de_formateo: nil
      })

    # Nueva definición para el DR "Resultado OEA (oído izquierdo)"
    dr_roi2 = DatoReportable.create!({
        nombre: "Oído izquierdo",
        codigo: "ROI2",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 7,
        enumerable: true,
        clase_para_enumeracion: "ResultadoDeOtoemision",
        integra_grupo: true,
        nombre_de_grupo: "Resultados de la otoemisión acústica",
        codigo_de_grupo: "re_oea",
        orden_de_grupo: 2,
        opciones_de_formateo: nil
      })

    # Mantenemos la definición del DR "Grado de retinopatía"
    dr_rop = DatoReportable.where(codigo: "ROP").first


    ###
    ### MODIFICACIÓN DE PRESTACIONES QUE REQUIEREN REPORTAR DATOS AL SIRGE SEGÚN DOIU 20
    ###

    # Prestación CTC005W78 - Control prenatal de 1a vez
    DatoReportableRequerido.find(1).update_attributes!({   # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(258),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 200.0
    })
    DatoReportableRequerido.find(2).update_attributes!({   # Talla en metros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta
      prestacion: Prestacion.find(258),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 250.0
    })
    DatoReportableRequerido.find(3).update_attributes!({   # Edad gestacional: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Edad gestacional: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(258),
      dato_reportable: dr_eg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 3.0,
      maximo: 46.0
    })
    DatoReportableRequerido.find(4).update_attributes!({   # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(258),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(5).update_attributes!({   # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(258),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC006W78 - Ulterior de control prenatal
    DatoReportableRequerido.find(6).update_attributes!({   # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(259),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 200.0
    })
    DatoReportableRequerido.find(7).update_attributes!({   # Edad gestacional: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Edad gestacional: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(259),
      dato_reportable: dr_eg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 3.0,
      maximo: 46.0
    })
    DatoReportableRequerido.find(8).update_attributes!({   # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(259),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(9).update_attributes!({   # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(259),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC007W84 - Control prenatal de embarazo de alto riesgo de 1a vez
    DatoReportableRequerido.find(13).update_attributes!({  # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(262),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 200.0
    })
    DatoReportableRequerido.find(14).update_attributes!({  # Talla en metros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta
      prestacion: Prestacion.find(262),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 250.0
    })
    DatoReportableRequerido.find(15).update_attributes!({  # Edad gestacional: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Edad gestacional: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(262),
      dato_reportable: dr_eg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 3.0,
      maximo: 46.0
    })
    DatoReportableRequerido.find(16).update_attributes!({  # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(262),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(17).update_attributes!({  # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(262),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC007O24.4 - Consulta inicial de diabetes gestacional
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(353),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 200.0
    })
    DatoReportableRequerido.create!({                      # Edad gestacional: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(353),
      dato_reportable: dr_eg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 3.0,
      maximo: 46.0
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(353),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(353),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC022O24.4 - Consulta de seguimiento de diabetes gestacional
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(354),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 200.0
    })
    DatoReportableRequerido.create!({                      # Edad gestacional: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(354),
      dato_reportable: dr_eg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 3.0,
      maximo: 46.0
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(354),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(354),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC007O10/O10.4 - Consulta inicial de la embarazada con hipertensión crónica
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(324),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 200.0
    })
    DatoReportableRequerido.create!({                      # Edad gestacional: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(324),
      dato_reportable: dr_eg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 3.0,
      maximo: 46.0
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(324),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(324),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC022O10/O10.4 - Consulta de seguimiento de la embarazada con hipertensión crónica
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(325),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 200.0
    })
    DatoReportableRequerido.create!({                      # Edad gestacional: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(325),
      dato_reportable: dr_eg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 3.0,
      maximo: 46.0
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(325),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(325),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC007O16 - Consulta inicial de hipertensión gestacional
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(326),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 200.0
    })
    DatoReportableRequerido.create!({                      # Edad gestacional: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(326),
      dato_reportable: dr_eg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 3.0,
      maximo: 46.0
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(326),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(326),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC022O16 - Consulta de seguimiento de hipertensión gestacional
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(327),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 200.0
    })
    DatoReportableRequerido.create!({                      # Edad gestacional: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(327),
      dato_reportable: dr_eg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 3.0,
      maximo: 46.0
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(327),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(327),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC017P05 - Consulta de seguimiento post alta
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(369),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 200.0
    })
    DatoReportableRequerido.create!({                      # Edad gestacional: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(369),
      dato_reportable: dr_eg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 3.0,
      maximo: 46.0
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(369),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(369),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación PRP021A97/H86 - Otoemisiones acústicas para DTH en RN y Rescreening de hipoacusia en lactante "No pasa"
    DatoReportableRequerido.find(33).update_attributes!({  # Resultado OD: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.find(34).update_attributes!({  # Resultado OI: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.find(261).update_attributes!({ # Resultado OD: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.find(262).update_attributes!({ # Resultado OI: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Resultado OD: dar de alta con nueva categoría enumerada
      prestacion: Prestacion.find(383),
      dato_reportable: dr_rod2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: nil,
      maximo: nil
    })
    DatoReportableRequerido.create!({                      # Resultado OI: dar de alta con nueva categoría enumerada
      prestacion: Prestacion.find(383),
      dato_reportable: dr_roi2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: nil,
      maximo: nil
    })
    DatoReportableRequerido.create!({                      # Resultado OD: dar de alta con nueva categoría enumerada
      prestacion: Prestacion.find(479),
      dato_reportable: dr_rod2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: nil,
      maximo: nil
    })
    DatoReportableRequerido.create!({                      # Resultado OI: dar de alta con nueva categoría enumerada
      prestacion: Prestacion.find(479),
      dato_reportable: dr_roi2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: nil,
      maximo: nil
    })

    # Prestación PRP017A46/A97 - OBI a todo niño de riesgo (pesquisa ROP)
    DatoReportableRequerido.find(35).update_attributes!({  # Grado de retinopatía: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Grado de ROP: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(391),
      dato_reportable: dr_rop,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 5.0
    })

  end

  def down
    fecha_anexo_1 = Date.new(2016, 1, 1)
    fecha_anexo_2 = Date.new(2016, 7, 1)

    DatoReportableRequerido.where(fecha_de_finalizacion: fecha_anexo_1).each do |drr|
      drr.update_attributes!({ fecha_de_finalizacion: nil })
    end
    DatoReportableRequerido.where(fecha_de_inicio: fecha_anexo_1).each do |drr|
      drr.destroy
    end
  end
end
