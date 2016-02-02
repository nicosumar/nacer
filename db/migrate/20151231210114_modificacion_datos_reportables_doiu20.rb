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

    # Mantenemos la definición del DR "Índice CeO: Caries"
    dr_ceo_c = DatoReportable.where(codigo: "CEO_C").first
    dr_ceo_c.update_attributes!({sirge_id: 6})

    # Mantenemos la definición del DR "Índice CeO: Extracción indicada"
    dr_ceo_e = DatoReportable.where(codigo: "CEO_E").first
    dr_ceo_e.update_attributes!({sirge_id: 6})

    # Mantenemos la definición del DR "Índice CeO: Obturados"
    dr_ceo_o = DatoReportable.where(codigo: "CEO_O").first
    dr_ceo_o.update_attributes!({sirge_id: 6})

    # Nueva definición para el DR "Resultado expresado en BIRADS"
    dr_birads2 = DatoReportable.create!({
        nombre: "Resultado expresado en BIRADS",
        codigo: "BIRADS2",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 12,
        enumerable: false,
        clase_para_enumeracion: nil,
        integra_grupo: false,
        nombre_de_grupo: nil,
        codigo_de_grupo: nil,
        orden_de_grupo: nil,
        opciones_de_formateo: "{:size => 6}"
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

    dr_tratc = DatoReportable.create!({
        nombre: "Tratamiento instaurado",
        codigo: "TRATC",
        tipo_postgres: "integer",
        tipo_ruby: "integer",
        sirge_id: 14,
        enumerable: true,
        clase_para_enumeracion: "TratamientoInstauradoCu",
        integra_grupo: false,
        nombre_de_grupo: nil,
        codigo_de_grupo: nil,
        orden_de_grupo: nil,
        opciones_de_formateo: nil
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
    Prestacion.find(353).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

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
    Prestacion.find(354).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

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
    Prestacion.find(324).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first


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
    Prestacion.find(325).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

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
    Prestacion.find(326).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

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
    Prestacion.find(327).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

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
    Prestacion.find(369).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

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
      maximo: 80.000
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
      maximo: 180.0
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
      maximo: 80.000
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
      maximo: 180.0
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
      fecha_de_finalizacion: Date.new(2015, 7, 1)
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
    # Añadir el método de validación para verificación de DR completos
    Prestacion.find(585).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

    # Prestación LBL119A97/W78 - VDRL
    DatoReportableRequerido.create!({                      # Resultado del estudio
      prestacion: Prestacion.find(875),
      dato_reportable: dr_vdrl,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true
    })
    Prestacion.find(875).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first


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
    Prestacion.find(260).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

    # Prestación CTC010A97 - Consulta de salud buco-dental en niños 
    DatoReportableRequerido.create!({                     # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceo_c,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceo_c,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceo_e,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceo_e,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceo_o,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(457),
      dato_reportable: dr_ceo_o,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    # Añadir el método de validación para el DR Índice CeO
    MetodoDeValidacion.create!({
        nombre: "Verificar que el número de dientes con caries, extracción indicada y obturados no superan los 32",
        metodo: "indice_ceo_valido?",
        mensaje: "En el índice CeO la suma de la cantidad de dientes cariados, con extracción indicada y obturados no puede superar los 32",
        genera_error: true,
        visible: true
      })
    Prestacion.find(457).metodos_de_validacion << MetodoDeValidacion.where(metodo: "indice_ceo_valido?").first
    Prestacion.find(457).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

    # Prestación CTC010A97 - Control odontológico (6 a 9 años)
    DatoReportableRequerido.find(29).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(495),
      dato_reportable: dr_ceo_c,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.find(30).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(495),
      dato_reportable: dr_ceo_e,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.find(31).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(495),
      dato_reportable: dr_ceo_o,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    # Añadir el método de validación para el DR Índice CeO
    Prestacion.find(495).metodos_de_validacion << MetodoDeValidacion.where(metodo: "indice_ceo_valido?").first
    # Añadir los campos para relever el Ínidice CPOD
    DatoReportableRequerido.create!({                     # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(495),
      dato_reportable: dr_cpod_c,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(495),
      dato_reportable: dr_cpod_c,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(495),
      dato_reportable: dr_cpod_p,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(495),
      dato_reportable: dr_cpod_p,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(495),
      dato_reportable: dr_cpod_o,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(495),
      dato_reportable: dr_cpod_o,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    # Añadir el método de validación para el DR Índice CPOD
    Prestacion.find(495).metodos_de_validacion << MetodoDeValidacion.where(metodo: "indice_cpod_valido?").first
    Prestacion.find(495).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

    # Prestación CTC001T79/T82 - Obesidad inicial (6 a 9 años)
    DatoReportableRequerido.find(273).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(516),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 8.000,
      maximo: 80.000
    })
    DatoReportableRequerido.find(274).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(516),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 80.0,
      maximo: 180.0
    })
    DatoReportableRequerido.find(275).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(516),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(276).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(516),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC002T79/T82 - Obesidad ulterior (6 a 9 años)
    DatoReportableRequerido.find(277).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(517),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 8.000,
      maximo: 80.000
    })
    DatoReportableRequerido.find(278).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(517),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 80.0,
      maximo: 180.0
    })
    DatoReportableRequerido.find(279).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(517),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(280).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(517),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC001T83 - Sobrepeso inicial (6 a 9 años)
    DatoReportableRequerido.find(281).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(518),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 8.000,
      maximo: 80.000
    })
    DatoReportableRequerido.find(282).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(518),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 80.0,
      maximo: 180.0
    })
    DatoReportableRequerido.find(283).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(518),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(284).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(518),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC002T83 - Sobrepeso ulterior (6 a 9 años)
    DatoReportableRequerido.find(285).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(519),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 8.000,
      maximo: 80.000
    })
    DatoReportableRequerido.find(286).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(519),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 80.0,
      maximo: 180.0
    })
    DatoReportableRequerido.find(287).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(519),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(288).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(519),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })

    # Prestación CTC010A97 - Control odontológico (10 a 19 años)
    DatoReportableRequerido.find(297).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(524),
      dato_reportable: dr_cpod_c,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.find(298).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(524),
      dato_reportable: dr_cpod_p,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.find(299).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                     # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(524),
      dato_reportable: dr_cpod_o,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    # Añadir el método de validación para el DR Índice CPOD
    Prestacion.find(524).metodos_de_validacion << MetodoDeValidacion.where(metodo: "indice_cpod_valido?").first
    Prestacion.find(524).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

    # Prestación CTC001T79/T82 - Obesidad inicial (10 a 19 años)
    DatoReportableRequerido.find(306).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(554),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 10.000,
      maximo: 200.000
    })
    DatoReportableRequerido.find(307).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(554),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 100.0,
      maximo: 210.0
    })
    DatoReportableRequerido.find(308).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(554),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(309).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(554),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    # Añadir el método de validación para el DR Tensión arterial
    Prestacion.find(554).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

    # Prestación CTC002T79/T82 - Obesidad ulterior (10 a 19 años)
    DatoReportableRequerido.find(310).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(555),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 10.000,
      maximo: 200.000
    })
    DatoReportableRequerido.find(311).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(555),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 100.0,
      maximo: 210.0
    })
    DatoReportableRequerido.find(312).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(555),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(313).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(555),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    # Añadir el método de validación para el DR Tensión arterial
    Prestacion.find(555).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

    # Prestación CTC001T83 - Sobrepeso inicial (10 a 19 años)
    DatoReportableRequerido.find(314).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(556),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 10.000,
      maximo: 200.000
    })
    DatoReportableRequerido.find(315).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(556),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 100.0,
      maximo: 210.0
    })
    DatoReportableRequerido.find(316).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(556),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(317).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(556),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    # Añadir el método de validación para el DR Tensión arterial
    Prestacion.find(556).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

    # Prestación CTC002T83 - Sobrepeso ulterior (10 a 19 años)
    DatoReportableRequerido.find(318).update_attributes!({ # Peso en kg: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Peso en kg: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(557),
      dato_reportable: dr_pkg2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 10.000,
      maximo: 200.000
    })
    DatoReportableRequerido.find(319).update_attributes!({ # Talla en centímetros: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Talla en cm: dar de alta con nuevos rangos
      prestacion: Prestacion.find(557),
      dato_reportable: dr_tcm2,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 100.0,
      maximo: 210.0
    })
    DatoReportableRequerido.find(320).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(557),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(321).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(557),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    # Añadir el método de validación para el DR Tensión arterial
    Prestacion.find(557).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

    # Prestación CTC001A97 - Examen periódico de salud (mujeres 20 a 64 años)
    DatoReportableRequerido.find(322).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(560),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(323).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(560),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    # Añadir el método de validación para el DR Tensión arterial
    Prestacion.find(560).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

    # Prestación CTC009A97 - Control de salud individual para población indígena en terreno (mujeres 20 a 64 años)
    DatoReportableRequerido.find(324).update_attributes!({ # TA sistólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA sistólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(561),
      dato_reportable: dr_tas,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    DatoReportableRequerido.find(325).update_attributes!({ # TA diastólica: dar de baja
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # TA diastólica: dar de alta con nuevos rangos de validación
      prestacion: Prestacion.find(561),
      dato_reportable: dr_tad,
      fecha_de_inicio: fecha_anexo_1,
      necesario: false,
      obligatorio: true,
      minimo: 30.0,
      maximo: 300.0
    })
    # Añadir el método de validación para el DR Tensión arterial
    Prestacion.find(561).metodos_de_validacion << MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first

    # Prestación CTC010A97 - Control odontológico (Mujeres 20 a 64 años)
    DatoReportableRequerido.find(326).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                      # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(563),
      dato_reportable: dr_cpod_c,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.find(327).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                      # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(563),
      dato_reportable: dr_cpod_p,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    DatoReportableRequerido.find(328).update_attributes!({ # Dar de baja como opcional a partir de la fecha_anexo_2
      fecha_de_finalizacion: fecha_anexo_2
    })
    DatoReportableRequerido.create!({                      # Dar de alta como obligatorio a partir de la fecha_anexo_2
      prestacion: Prestacion.find(563),
      dato_reportable: dr_cpod_o,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 32.0
    })
    # Añadir el método de validación para el DR Índice CPOD
    Prestacion.find(563).metodos_de_validacion << MetodoDeValidacion.where(metodo: "indice_cpod_valido?").first
    Prestacion.find(563).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

    # Prestación IGR014A98 - Mamografía bilateral, craneocaudal y oblicua
    DatoReportableRequerido.find(330).update_attributes!({ # Dar de baja el dato anterior a partir de la fecha_anexo_1
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(583),
      dato_reportable: dr_birads2,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false,
      minimo: 0.0,
      maximo: 5.0
    })
    DatoReportableRequerido.create!({                      # Dar de alta como opcional a partir de la fecha_anexo_1
      prestacion: Prestacion.find(583),
      dato_reportable: dr_birads2,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true,
      minimo: 0.0,
      maximo: 5.0
    })
    # Añadir el método de validación para el DR Índice CPOD
    Prestacion.find(583).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

    # Prestación APA001A98/X86/X75/w78 - Lectura de la muestra (tamizaje CA cervicouterino)
    DatoReportableRequerido.find(360).update_attributes!({ # Diagnóstico anatomopatológico
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Diagnóstico anatomopatológico: opcional
      prestacion: Prestacion.find(312),
      dato_reportable: dr_diagapc,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false
    })
    DatoReportableRequerido.create!({                      # Diagnóstico anatomopatológico: obligatorio
      prestacion: Prestacion.find(312),
      dato_reportable: dr_diagapc,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true
    })
    DatoReportableRequerido.find(361).update_attributes!({ # Carga al SITAM
      fecha_de_finalizacion: Date.new(2015, 7, 1)
    })
    Prestacion.find(312).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first
    DatoReportableRequerido.find(333).update_attributes!({ # Diagnóstico anatomopatológico
      fecha_de_finalizacion: fecha_anexo_1
    })
    DatoReportableRequerido.create!({                      # Diagnóstico anatomopatológico: opcional
      prestacion: Prestacion.find(587),
      dato_reportable: dr_diagapc,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false
    })
    DatoReportableRequerido.create!({                      # Diagnóstico anatomopatológico: obligatorio
      prestacion: Prestacion.find(587),
      dato_reportable: dr_diagapc,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true
    })
    DatoReportableRequerido.find(334).update_attributes!({ # Carga al SITAM
      fecha_de_finalizacion: Date.new(2015, 7, 1)
    })

    # Prestación NTN002X75 - Notificación de inicio de tratamiento oportuno
    DatoReportableRequerido.create!({                      # Tratamiento instaurado: opcional
      prestacion: Prestacion.find(590),
      dato_reportable: dr_tratc,
      fecha_de_inicio: fecha_anexo_1,
      fecha_de_finalizacion: fecha_anexo_2,
      necesario: false,
      obligatorio: false
    })
    DatoReportableRequerido.create!({                      # Tratamiento instaurado: obligatorio
      prestacion: Prestacion.find(590),
      dato_reportable: dr_tratc,
      fecha_de_inicio: fecha_anexo_2,
      necesario: false,
      obligatorio: true
    })
    Prestacion.find(590).metodos_de_validacion << MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first

  end

  def down
    fecha_anexo_1 = Date.new(2016, 1, 1)
    fecha_anexo_2 = Date.new(2016, 7, 1)

    DatoReportableRequerido.where(fecha_de_finalizacion: fecha_anexo_1).each do |drr|
      drr.update_attributes!({ fecha_de_finalizacion: nil })
    end
    DatoReportableRequerido.where(fecha_de_finalizacion: fecha_anexo_2).each do |drr|
      drr.update_attributes!({ fecha_de_finalizacion: nil })
    end
    DatoReportableRequerido.where(fecha_de_inicio: fecha_anexo_1).each do |drr|
      drr.destroy
    end
    DatoReportableRequerido.where(fecha_de_inicio: fecha_anexo_2).each do |drr|
      drr.destroy
    end
    Prestacion.find(590).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(312).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(583).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(563).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(563).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "indice_cpod_valido?").first)
    Prestacion.find(561).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(560).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(557).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(556).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(555).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(554).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(524).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(524).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "indice_cpod_valido?").first)
    Prestacion.find(493).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(495).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(495).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "indice_cpod_valido?").first)
    Prestacion.find(495).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "indice_ceo_valido?").first)
    Prestacion.find(457).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(457).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "indice_ceo_valido?").first)
    Prestacion.find(260).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(260).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "indice_cpod_valido?").first)
    Prestacion.find(875).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(585).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(494).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(493).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(369).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(369).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(327).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(327).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(326).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(326).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(325).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(325).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(324).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(324).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(354).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(354).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    Prestacion.find(353).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "datos_reportables_asociados_completos?").first)
    Prestacion.find(353).metodos_de_validacion.destroy(MetodoDeValidacion.where(metodo: "tension_arterial_valida?").first)
    MetodoDeValidacion.where(metodo: "indice_ceo_valido?").first.destroy
    DatoReportable.where(codigo: "TRATC").first.destroy
    DatoReportable.where(codigo: "DIAGAPC").first.destroy
    DatoReportable.where(codigo: "BIRADS2").first.destroy
    DatoReportable.where(codigo: "VDRL").first.destroy
    DatoReportable.where(codigo: "DIAGAPBM").first.destroy
    DatoReportable.where(codigo: "DIAGAPB").first.destroy
    DatoReportable.where(codigo: "PC2").first.destroy
    DatoReportable.where(codigo: "ROI2").first.destroy
    DatoReportable.where(codigo: "ROD2").first.destroy
    DatoReportable.where(codigo: "EG2").first.destroy
    DatoReportable.where(codigo: "TCM2").first.destroy
    DatoReportable.where(codigo: "PKG2").first.destroy
  end
end
