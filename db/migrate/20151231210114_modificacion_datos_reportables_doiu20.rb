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

    # Definición del DR "Talla (en centímetros)" de tipo entero para controles de embarazo
    dr_tcm = DatoReportable.where(codigo: "TCM").first
    dr_tcm.update_attributes!({sirge_id: 2})

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
    dr_tas.update_attributes!({sirge_id: 3})

    # Mantenemos la definición del DR "Tensión arterial diastólica"
    dr_tad = DatoReportable.where(codigo: "TAD").first
    dr_tad.update_attributes!({sirge_id: 3})

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
    dr_rop.update_attributes({sirge_id: 8})

    # Nueva definición para el DR "Perímetro cefálico (en centímetros)"
    dr_pc2 = DatoReportable.create!({
        nombre: "Perímetro cefálico (en centímetros)",
        codigo: "PC2",
        tipo_postgres: "numeric(3, 1)",
        tipo_ruby: "big_decimal",
        sirge_id: 4,
        enumerable: false,
        clase_para_enumeracion: nil,
        integra_grupo: false,
        nombre_de_grupo: nil,
        codigo_de_grupo: nil,
        orden_de_grupo: nil,
        opciones_de_formateo: "{:size => 6}"
      })

    # Nueva definición para el DR "Diagnóstico anatomopatológico (biopsia)"
    dr_diagapb = DatoReportable.create!({
        nombre: "Diagnóstico anatomopatológico",
        codigo: "DIAGAPB",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 10,
        enumerable: true,
        clase_para_enumeracion: "DiagnosticoBiopsia",
        integra_grupo: false,
        nombre_de_grupo: nil,
        codigo_de_grupo: nil,
        orden_de_grupo: nil,
        opciones_de_formateo: nil
      })

    # Nueva definición para el DR "Diagnóstico anatomopatológico (biopsia de mama)"
    dr_diagapbm = DatoReportable.create!({
        nombre: "Diagnóstico anatomopatológico",
        codigo: "DIAGAPBM",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 9,
        enumerable: true,
        clase_para_enumeracion: "DiagnosticoBiopsiaMama",
        integra_grupo: false,
        nombre_de_grupo: nil,
        codigo_de_grupo: nil,
        orden_de_grupo: nil,
        opciones_de_formateo: nil
      })

    # Nueva definición para el DR "Diagnóstico anatomopatológico (citología)"
    dr_diagapc = DatoReportable.create!({
        nombre: "Diagnóstico anatomopatológico",
        codigo: "DIAGAPC",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 11,
        enumerable: true,
        clase_para_enumeracion: "DiagnosticoCitologia",
        integra_grupo: false,
        nombre_de_grupo: nil,
        codigo_de_grupo: nil,
        orden_de_grupo: nil,
        opciones_de_formateo: nil
      })

    # Nueva definición para el DR "Diagnóstico anatomopatológico (citología)"
    dr_vdrl = DatoReportable.create!({
        nombre: "Resultado del estudio",
        codigo: "VDRL",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 13,
        enumerable: true,
        clase_para_enumeracion: "ResultadoVdrl",
        integra_grupo: false,
        nombre_de_grupo: nil,
        codigo_de_grupo: nil,
        orden_de_grupo: nil,
        opciones_de_formateo: nil
      })

    # Mantenemos la definición del DR "Índice CPOD: Caries"
    dr_cpod_c = DatoReportable.where(codigo: "CPOD_C").first
    dr_cpod_c.update_attributes!({sirge_id: 6})

    # Mantenemos la definición del DR "Índice CPOD: Perdidos"
    dr_cpod_p = DatoReportable.where(codigo: "CPOD_P").first
    dr_cpod_p.update_attributes!({sirge_id: 6})

    # Mantenemos la definición del DR "Índice CPOD: Obturados"
    dr_cpod_o = DatoReportable.where(codigo: "CPOD_O").first
    dr_cpod_o.update_attributes!({sirge_id: 6})

    # Nueva definición para el DR "Índice ceod: Caries"
    dr_ceod_c = DatoReportable.create!({
        nombre: "Caries",
        codigo: "CEOD_C",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 6,
        enumerable: false,
        clase_para_enumeracion: nil,
        integra_grupo: true,
        nombre_de_grupo: "Índice ceod",
        codigo_de_grupo: "ceod",
        orden_de_grupo: 1,
        opciones_de_formateo: "{:size => 6}"
      })

    # Nueva definición para el DR "Índice ceod: Extracción indicada"
    dr_ceod_e = DatoReportable.create!({
        nombre: "Extracción indicada",
        codigo: "CEOD_E",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 6,
        enumerable: false,
        clase_para_enumeracion: nil,
        integra_grupo: true,
        nombre_de_grupo: "Índice ceod",
        codigo_de_grupo: "ceod",
        orden_de_grupo: 2,
        opciones_de_formateo: "{:size => 6}"
      })

    # Nueva definición para el DR "Índice ceod: Obturados"
    dr_ceod_o = DatoReportable.create!({
        nombre: "Obturados",
        codigo: "CEOD_O",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 6,
        enumerable: false,
        clase_para_enumeracion: nil,
        integra_grupo: true,
        nombre_de_grupo: "Índice ceod",
        codigo_de_grupo: "ceod",
        orden_de_grupo: 3,
        opciones_de_formateo: "{:size => 6}"
      })


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
      dato_reportable: dr_tcm,
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
      dato_reportable: dr_tcm,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 210.0
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
    # Añadir el método de validación para el DR tensión arterial
    Prestacion.find(353).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

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
    # Añadir el método de validación para el DR tensión arterial
    Prestacion.find(354).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

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
    # Añadir el método de validación para el DR tensión arterial
    Prestacion.find(324).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first


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
    # Añadir el método de validación para el DR tensión arterial
    Prestacion.find(325).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

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
    # Añadir el método de validación para el DR tensión arterial
    Prestacion.find(326).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

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
    # Añadir el método de validación para el DR tensión arterial
    Prestacion.find(327).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

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
    # Añadir el método de validación para el DR tensión arterial
    Prestacion.find(369).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first


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

    # Prestación CTC001A97 - Pediátrica en menores de un año
    DatoReportableRequerido.find(253).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(455),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 0.500,
      maximo: 30.000
    })
    DatoReportableRequerido.find(254).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(455),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 45.0,
      maximo: 90.0
    })
    DatoReportableRequerido.find(255).update_attributes!({ # Perímetro cefálico: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Perímetro cefálico: dar de alta con nuevos rangos
      prestacion: Prestacion.find(455),
      dato_reportable: dr_pc2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 55.0
    })

    # Prestación CTC001A97 - Pediátrica de 1 a 5 años
    DatoReportableRequerido.find(256).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(456),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 4.000,
      maximo: 45.000
    })
    DatoReportableRequerido.find(257).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(456),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 55.0,
      maximo: 150.0
    })

    # Prestación CTC001A97 - Control en niños de 6 a 9 años
    DatoReportableRequerido.find(263).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(493),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 8.000,
      maximo: 60.000
    })
    DatoReportableRequerido.find(264).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(493),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 80.0,
      maximo: 170.0
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(493),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(493),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    # Añadir el método de validación para el DR tensión arterial
    Prestacion.find(493).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

    # Prestación CTC009A97 - Control de salud individual para población indígena en terreno
    DatoReportableRequerido.find(265).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(494),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 8.000,
      maximo: 60.000
    })
    DatoReportableRequerido.find(266).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(494),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 80.0,
      maximo: 170.0
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(494),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(494),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    # Añadir el método de validación para el DR tensión arterial
    Prestacion.find(494).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

    # Prestación CTC001A97 - Examen periódico de salud del adolescente
    DatoReportableRequerido.find(289).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(521),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 10.000,
      maximo: 200.000
    })
    DatoReportableRequerido.find(290).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(521),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 100.0,
      maximo: 210.0
    })
    DatoReportableRequerido.find(291).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(521),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(292).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(521),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC009A97 - Control de salud individual para población indígena en terreno
    DatoReportableRequerido.find(293).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(522),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 10.000,
      maximo: 200.000
    })
    DatoReportableRequerido.find(294).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(522),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 100.0,
      maximo: 210.0
    })
    DatoReportableRequerido.find(295).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(522),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(296).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(522),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación APA002A98/X75/X80 - Diagnóstico por biopsia para mujeres con citología ASC-H, H-SIL, CA...
    DatoReportableRequerido.find(331).update_attributes!({ # Diagnóstico anatomopatológico
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Diagnóstico anatomopatológico: dar de alta con categorías
      prestacion: Prestacion.find(586),
      dato_reportable: dr_diagapb,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true
    })
    DatoReportableRequerido.find(332).update_attributes!({ # Carga al SITAM
      fecha_de_finalizacion: fecha_anexo_1
    })

    # Prestación APA002X76 - Anatomía patológica de biopsia CA de mama
    DatoReportableRequerido.find(362).update_attributes!({ # Diagnóstico anatomopatológico
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Diagnóstico anatomopatológico: dar de alta con categorías
      prestacion: Prestacion.find(585),
      dato_reportable: dr_diagapbm,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true
    })

    # Prestación LBL119A97/W78 - VDRL
    DatoReportableRequerido.create!({                      # Resultado del estudio
      prestacion: Prestacion.find(875),
      dato_reportable: dr_vdrl,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true
    })


    ###
    ### ANEXO II
    ###

    # Prestación CTC010W78 - Odontológica prenatal (profilaxis)
    DatoReportableRequerido.find(10).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(260),
      dato_reportable: dr_cpod_c,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.find(11).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(260),
      dato_reportable: dr_cpod_p,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.find(12).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(260),
      dato_reportable: dr_cpod_o,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    # Añadir el método de validación para el DR Índice CPOD
    Prestacion.find(260).metodos_de_validacion << MetodoDeValidacion.where(metodo: "indice_cpod_valido?").first

    # Prestación CTC010A97 - Consulta de salud buco-dental en niños 
    DatoReportableRequerido.create!({                     # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceod_c,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceod_c,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceod_e,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceod_e,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceod_o,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceod_o,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    # Añadir el método de validación para el DR Índice CEOD
    MetodoDeValidacion.create!({
        nombre: "Verificar que el número de dientes con caries, extracción indicada y obturados no superan los 32",
        metodo: "indice_ceod_valido?",
        mensaje: "En el índice CEOD la suma de la cantidad de dientes cariados, con extracción indicada y obturados no puede superar los 32",
        genera_error: true,
        visible: true
      })
    Prestacion.find(457).metodos_de_validacion << MetodoDeValidacion.where(metodo: "indice_ceod_valido?").first

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
    Prestacion.find(353).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(354).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(324).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(325).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(326).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(327).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(369).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(493).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(494).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(260).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "indice_cpod_valido?").first)
    Prestacion.find(457).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "indice_ceod_valido?").first)
    MetodoDeValidacion.where(metodo: "indice_ceod_valido?").first.destroy
  end
end
