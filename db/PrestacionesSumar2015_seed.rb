# -*- encoding : utf-8 -*-
ActiveRecord::Base.transaction do

  # Precargamos ciertos datos útiles para no ejecutar tantas consultas a la base
  um_unitaria = UnidadDeMedida.find_by_codigo!("U")
  sexo_femenino = Sexo.find_by_codigo!("F")
  sexo_masculino = Sexo.find_by_codigo!("M")
  menores_de_6 = GrupoPoblacional.find_by_codigo!("A")
  de_6_a_9 = GrupoPoblacional.find_by_codigo!("B")
  adolescentes = GrupoPoblacional.find_by_codigo!("C")
  mujeres_20_a_64 = GrupoPoblacional.find_by_codigo!("D")

  # Determinar la hora y fecha actual
  ahora = DateTime.now()

  # Fecha de inicio del nomenclador viejo
  fecha_de_inicio = Date.new(2012, 8, 1)

  # Fecha de inicio del nomenclador nuevo
  fecha_de_inicio_nueva = Date.new(2015, 7, 1)

  # Obtener el nomenclador
  nomenclador_sumar = Nomenclador.find(5)

  # Dejar únicamente el diagnóstico "W78" asociado a la prestación "PRP002" (colposcopía en control de embarazo)
  prestacion = Prestacion.find(268)
  prestacion.diagnosticos = [Diagnostico.find_by_codigo('W78')]

  # Cambio la descripción del código IMV008 / Añado métodos de validación faltantes
  prestacion = Prestacion.where(id: 764, codigo: "IMV008").first
  prestacion.update_attributes({nombre: "Dosis aplicada de vacuna triple bacteriana acelular (dTpa) en el embarazo"})
  CantidadDePrestacionesPorPeriodo.create!(
    {
      prestacion_id: prestacion.id,
      cantidad_maxima: 2,
      periodo: "9.months",
      intervalo: "1.month"
    }
  )
  prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación
  convenios_con_inmunizaciones_de_embarazo_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [264, 265, 266],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Añadir los diagnósticos de RCIU y malformaciones a la prestación "NTN006"
  prestacion = Prestacion.find(323)
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")
  # Añadir los códigos de cardiopatías congénitas o el diagnóstico "K73" (figura en las líneas de cuidado pero no en la matriz PSS)
  # prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")

  # Modificar los diagnósticos habilitados para la prestación "PRP021", eliminar el diagnóstico "H86" según SIRGe (admitido en PSS)
  prestacion = Prestacion.find(383)
  prestacion.diagnosticos = [Diagnostico.find_by_codigo!("A97")]

  # Modificar los diagnósticos habilitados para la prestación "ICI001"
  prestacion = Prestacion.find(390)
  prestacion.diagnosticos.delete_all
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A45")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K73")

  # Modificar los diagnósticos habilitados para la prestación "ITE002"
  prestacion = Prestacion.find(387)
  prestacion.diagnosticos.delete_all
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A45")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K73")

  # Modificar los diagnósticos habilitados para la prestación "CTC020"
  prestacion = Prestacion.find(399)
  prestacion.diagnosticos.delete_all
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")

  # Modificar los diagnósticos habilitados para la prestación "CTC021"
  prestacion = Prestacion.find(400)
  prestacion.diagnosticos.delete_all
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")

  # Modificar la descripción de la prestación 'PRP035'
  Prestacion.find(404).update_attributes!({nombre: "Presurometría"})

  # Eliminar el código de diagnóstico "003" de la prestación "ITK003"
  prestacion = Prestacion.find(410)
  prestacion.diagnosticos.delete(Diagnostico.find(215))

  # Eliminar los códigos de diagnóstico "026" y "087" de la prestación "ITK036" y añadir el código correcto "015"
  prestacion = Prestacion.find(425)
  prestacion.diagnosticos = [Diagnostico.find(120)]

  # Cambiar el nombre de las prestaciones de código "XMX003" (Levosimedan -> Levosimendán)
  prestacion = Prestacion.find(448)
  prestacion.update_attributes({nombre: "Levosimendán (en módulos I, II, III y IV -no catastróficos-)"})
  prestacion = Prestacion.find(612)
  prestacion.update_attributes({nombre: "Levosimendán (en módulos V, VI y VII -catastróficos-)"})

  # Cambiar el nombre de la prestación CTC001 con id 455
  prestacion = Prestacion.find(455)
  prestacion.update_attributes({nombre: "Examen periódico de salud de niñas y niños menores de un año"})

  # Cambiar el nombre de la prestación CTC001 con id 456
  prestacion = Prestacion.find(456)
  prestacion.update_attributes({nombre: "Examen periódico de salud de niñas y niños de uno a cinco años"})

  # Eliminar el grupo poblacional de 6 a 9 años de la prestación "IMV002" con id 464 (existe equivalente con id 501)
  prestacion = Prestacion.find(464)
  prestacion.grupos_poblacionales.delete(de_6_a_9)

  # Eliminar el grupo poblacional de 6 a 9 años de la prestación "IMV006"??? Duda consultada
  #prestacion = Prestacion.find(463)
  #prestacion.grupos_poblacionales.delete(de_6_a_9)

  # Crear la prestación "IMV015", que quedó en el tintero
  prestacion = Prestacion.create!({
    # id: 815,
    codigo: "IMV015",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("V015"),
    nombre: "Dosis aplicada de vacuna neumococo conjugada",
    otorga_cobertura: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << menores_de_6
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    precio_por_unidad:  20.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 40.0000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación
  convenios_con_inmunizaciones_de_menores_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [
          459, 460, 461, 462, 463, 464, 465, 466, 499, 500, 501, 502,
          503, 526, 527, 528, 529, 530, 531, 564, 565, 566, 765
        ],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Corregir los diagnósticos de la prestación "CTC016" con id 468
  prestacion = Prestacion.find(468)
  prestacion.diagnosticos.delete_all
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")

  # Añadir diagnósticos faltantes a la prestación "CTC001" con id 471
  prestacion = Prestacion.find(471)
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")

  # Añadir diagnósticos faltantes a la prestación "CTC002" con id 472
  prestacion = Prestacion.find(472)
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")

  # Corregir los diagnósticos de la prestación "CTC012" con id 482
  prestacion = Prestacion.find(482)
  prestacion.diagnosticos.delete_all
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A92")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D01")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D10")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R87")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("S14")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R06")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("S13")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("N07")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("N79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("S84")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R77")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("S18")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H76")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("L72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("L73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("L74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("L77")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("L78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("L80")

  # Cambiar el nombre de la prestación CTC001 con id 455
  prestacion = Prestacion.find(493)
  prestacion.update_attributes({nombre: "Examen periódico de salud de niñas y niños de seis a nueve años"})

  # Añadir los diagnósticos faltantes a la prestación CTC009 con id 494
  prestacion = Prestacion.find(494)
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A21")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B87")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D23")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79")

  # Corregir los diagnósticos de la prestación "CAW006" con id 498
  prestacion = Prestacion.find(498)
  prestacion.diagnosticos.delete_all
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A75")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D96")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D61")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D62")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K83")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T89")

  # Desdoblar la prestación "NTN002" (Notificación de inicio de tratamiento en tiempo oportuno -leucemia/linfoma-) en dos
  # prestaciones, con el mismo código. Una para leucemia y otra para linfoma.
  prestacion = Prestacion.create!({
    # id: 816,
    codigo: "NTN002",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("N002"),
    nombre: 'Notificación de inicio de tratamiento en tiempo oportuno (leucemia)',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 1,
    periodo: "1.year"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 5.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  prestacion = Prestacion.create!({
    # id: 817,
    codigo: "NTN002",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("N002"),
    nombre: 'Notificación de inicio de tratamiento en tiempo oportuno (linfoma)',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 1,
    periodo: "1.year"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 5.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para desdoblar la prestación
  convenios_con_notificacion_de_leucemia_autorizada = PrestacionAutorizada.where(
      prestacion_id: [520, 559],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Agregar el grupo poblacional de 6 a 9 años en las prestaciones diagnósticas de CC
  prestacion = Prestacion.find(402) # PRP005xxx - Ergometría
  prestacion.grupos_poblacionales << de_6_a_9
  prestacion = Prestacion.find(403) # PRP034xxx - Holter
  prestacion.grupos_poblacionales << de_6_a_9
  prestacion = Prestacion.find(404) # PRP035xxx - Presurometría
  prestacion.grupos_poblacionales << de_6_a_9
  prestacion = Prestacion.find(405) # IGR040xxx - Hemodinamia diagnóstica
  prestacion.grupos_poblacionales << de_6_a_9
  prestacion = Prestacion.find(406) # IGR041xxx - RMN
  prestacion.grupos_poblacionales << de_6_a_9
  prestacion = Prestacion.find(407) # IGR030 - TAC
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK001"
  prestacion = Prestacion.find(408)
  prestacion.grupos_poblacionales << de_6_a_9

  # Crear la prestación "ITK200" para el diagnóstico "088", que quedó en el tintero
  prestacion = Prestacion.create!({
    # id: 818
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo I - Reoperación por ductus residual',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("088")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6017.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 77.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2004.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK004"
  prestacion = Prestacion.find(411)
  prestacion.grupos_poblacionales << de_6_a_9

  # Crear la prestación "ITK200" para el diagnóstico "035", que quedó en el tintero
  prestacion = Prestacion.create!({
    # id: 819
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo I - Reoperación por coartación de aorta residual',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("035")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6017.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 77.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2004.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Duplicar la prestación "ITK005" para el grupo de 6 a 9 únicamente con el diagnóstico "088"
  prestacion = Prestacion.create!({
    # id: 820
    codigo: "ITK005",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K005"),
    nombre: 'Cardiopatías congénitas - Módulo I - Cierre de ductus con hemodinamia intervencionista',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("088")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6017.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 77.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2004.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Crear la prestación "ITK201" para el diagnóstico "088", que quedó en el tintero
  prestacion = Prestacion.create!({
    # id: 821
    codigo: "ITK201",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K201"),
    nombre: 'Cardiopatías congénitas - Módulo I - Reintervención por ductus residual con hemodinamia intervencionista',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("088")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6017.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 77.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2004.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK006"
  prestacion = Prestacion.find(413)
  prestacion.grupos_poblacionales << de_6_a_9

  # Crear la prestación "ITK201" para el diagnóstico "035", que quedó en el tintero
  prestacion = Prestacion.create!({
    # id: 822
    codigo: "ITK201",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K201"),
    nombre: 'Cardiopatías congénitas - Módulo I - Reintervención por coartación de aorta residual con hemodinamia intervencionista',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("035")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio_nueva,
    minimo: 0.0000,
    maximo: 3.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6017.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 77.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2004.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK007"
  prestacion = Prestacion.find(414)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK008"
  prestacion = Prestacion.find(415)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK009"
  prestacion = Prestacion.find(416)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK010" y modificar un error tipográfico en el nombre
  prestacion = Prestacion.find(417)
  prestacion.update_attributes!(nombre: "Cardiopatías congénitas - Módulo I - Embolización de colaterales de ramas pulmonares con hemodinamia intervencionista")
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK015"
  prestacion = Prestacion.find(422)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK016"
  prestacion = Prestacion.find(423)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK035"
  prestacion = Prestacion.find(424)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK037"
  prestacion = Prestacion.find(426)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "ITK017"
  prestacion = Prestacion.find(427)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "XMX002" (no catastróficas)
  prestacion = Prestacion.find(447)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "XMX003" (no catastróficas)
  prestacion = Prestacion.find(448)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "XMX004" (no catastróficas)
  prestacion = Prestacion.find(449)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "XMX005" (no catastróficas)
  prestacion = Prestacion.find(450)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "XMX006" (no catastróficas)
  prestacion = Prestacion.find(451)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "XMX008" (no catastróficas)
  prestacion = Prestacion.find(453)
  prestacion.grupos_poblacionales << de_6_a_9

  # Agregar el grupo poblacional de 6 a 9 años en la prestación "XMX009" (no catastróficas)
  prestacion = Prestacion.find(454)
  prestacion.grupos_poblacionales << de_6_a_9

  # Modificar el nombre de la prestación "CTC010" (id: 524)
  prestacion = Prestacion.find(524)
  prestacion.update_attributes!(nombre: "Control odontológico")

  # Modificar el nombre de la prestación "IMV011" (id: 526)
  prestacion = Prestacion.find(526)
  prestacion.update_attributes!(nombre: "Dosis aplicada de doble viral (rubéola + sarampión)")

  # Corregir los diagnósticos de la prestación "CAW006" con id 537
  prestacion = Prestacion.find(537)
  prestacion.diagnosticos.delete_all
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A75")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D96")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D61")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D62")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K96")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K83")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T89")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Y70")

  # Añadir el grupo poblacional de 10 a 19 años a las prestaciones NTN002
  # prestacion = Prestacion.find(816)
  # prestacion.grupos_poblacionales << adolescentes
  # prestacion = Prestacion.find(817)
  # prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en las prestaciones diagnósticas de CC
  prestacion = Prestacion.find(402) # PRP005xxx - Ergometría
  prestacion.grupos_poblacionales << adolescentes
  prestacion = Prestacion.find(403) # PRP034xxx - Holter
  prestacion.grupos_poblacionales << adolescentes
  prestacion = Prestacion.find(404) # PRP035xxx - Presurometría
  prestacion.grupos_poblacionales << adolescentes
  prestacion = Prestacion.find(405) # IGR040xxx - Hemodinamia diagnóstica
  prestacion.grupos_poblacionales << adolescentes
  prestacion = Prestacion.find(406) # IGR041xxx - RMN
  prestacion.grupos_poblacionales << adolescentes
  prestacion = Prestacion.find(407) # IGR030 - TAC
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK001"
  prestacion = Prestacion.find(408)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK004"
  prestacion = Prestacion.find(411)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK200" para el diagnóstico "035"
  # prestacion = Prestacion.find(819)
  # prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK005" para el diagnóstico "088"
  # prestacion = Prestacion.find(820)
  # prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK201" para el diagnóstico "088"
  # prestacion = Prestacion.find(821)
  # prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK006"
  prestacion = Prestacion.find(413)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK201" para el diagnóstico "035"
  # prestacion = Prestacion.find(822)
  # prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK007"
  prestacion = Prestacion.find(414)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK008"
  prestacion = Prestacion.find(415)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK009"
  prestacion = Prestacion.find(416)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK010"
  prestacion = Prestacion.find(417)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK016"
  prestacion = Prestacion.find(423)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK035"
  prestacion = Prestacion.find(424)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK037"
  prestacion = Prestacion.find(426)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK017"
  prestacion = Prestacion.find(427)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "XMX002" (no catastróficas)
  prestacion = Prestacion.find(447)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "XMX003" (no catastróficas)
  prestacion = Prestacion.find(448)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "XMX004" (no catastróficas)
  prestacion = Prestacion.find(449)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "XMX005" (no catastróficas)
  prestacion = Prestacion.find(450)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "XMX006" (no catastróficas)
  prestacion = Prestacion.find(451)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "XMX008" (no catastróficas)
  prestacion = Prestacion.find(453)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "XMX009" (no catastróficas)
  prestacion = Prestacion.find(454)
  prestacion.grupos_poblacionales << adolescentes

  # Añadir diagnósticos faltantes a la prestación "NTN001" con id "588"
  prestacion = Prestacion.find(588)
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X86")

  # Añadir diagnósticos faltantes a la prestación "CTC001" con id "577"
  prestacion = Prestacion.find(577)
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X30")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X19")

  # Añadir diagnósticos faltantes a la prestación "PRP007" con id "579"
  prestacion = Prestacion.find(579)
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X19")

  # Añadir diagnósticos faltantes a la prestación "APA002" con id "585"
  prestacion = Prestacion.find(585)
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79")

  # Añadir los diagnósticos faltantes a la prestación CTC009 con id 561
  prestacion = Prestacion.find(561)
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A21")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X19")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X20")

  # Corregir los diagnósticos de la prestación "CAW006" con id 571
  prestacion = Prestacion.find(571)
  prestacion.diagnosticos.delete_all
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A75")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D61")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D62")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K96")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K83")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80")

  # Eliminar el diagnóstico "Q43.1" de la prestación "ITQ011"
  prestacion = Prestacion.find(571)
  prestacion.diagnosticos.delete(Diagnostico.find_by_codigo!("Q43.1"))

  # Eliminar el diagnóstico "026" de la prestación "ITK026"
  prestacion = Prestacion.find(436)
  prestacion.diagnosticos.delete(Diagnostico.find_by_codigo!("026"))

  # Crear la prestación "ITK200" para los diagnósticos "027"/"028"
  prestacion = Prestacion.create!({
    # id: 823
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación por residuo en CAV completo',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("027")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("028")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 15936.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 335.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2262.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Agregar los grupos poblacionales de 6 a 9 años y 10 a 19 años en la prestación "ITK019"
  prestacion = Prestacion.find(429)
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]

  # Crear la prestación "ITK200" para los diagnósticos "139"/"140"/"141"
  prestacion = Prestacion.create!({
    # id: 824
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación por residuo en tetralogía de Fallot operada; recambio de homoinjerto; plástica de ramas pulmonares; cierre de CIV residual; obstrucción al tracto de salida VD',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("139")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("140")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("141")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 15936.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 335.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2262.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Agregar los grupos poblacionales de 6 a 9 años y 10 a 19 años en la prestación "ITK020"
  prestacion = Prestacion.find(430)
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]

  # Crear la prestación "ITK200" para los diagnósticos "052"/"054"/"055"/"056"
  prestacion = Prestacion.create!({
    # id: 825
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación por residuo en DSVD operada; recambio de homoinjerto; desobstrucción subaórtica',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("052")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("054")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("055")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("056")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 15936.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 335.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2262.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Agregar los grupos poblacionales de 6 a 9 años y 10 a 19 años en la prestación "ITK021"
  prestacion = Prestacion.find(431)
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]

  # Crear la prestación "ITK200" para la reoperación por fallo del Fontan
  prestacion = Prestacion.create!({
    # id: 826
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación por fallo del Fontan',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("121")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("122")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("123")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("124")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("125")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("126")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("127")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("152")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 15936.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 335.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2262.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Crear la prestación "ITK200" para el diagnóstico "157"
  prestacion = Prestacion.create!({
    # id: 827
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación por residuo en CIV compleja operada',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("157")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 15936.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 335.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2262.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Agregar los grupos poblacionales de 6 a 9 años y 10 a 19 años en la prestación "ITK023"
  prestacion = Prestacion.find(433)
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]

  # Crear la prestación "ITK200" para las patologías valvulares operadas
  prestacion = Prestacion.create!({
    # id: 828
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación en patología valvular operada; recambio de válvula u homoinjerto',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("008")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("009")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("010")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("011")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("012")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("013")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("014")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("076")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("077")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("078")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("079")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("080")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("081")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("082")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("083")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("101")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("113")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("114")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("115")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("117")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("148")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("149")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("150")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("151")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("153")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 15936.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 335.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2262.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Crear la prestación "ITK200" para TGA o estenosis pulmonar ya operadas
  prestacion = Prestacion.create!({
    # id: 829
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación por residuo en TGA o estenosis pulmonar operada',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("037")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("038")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("039")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("040")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("041")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("135")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("137")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 15.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 15936.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 335.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2262.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Crear la prestación "ITK200" para el diagnóstico "134"
  prestacion = Prestacion.create!({
    # id: 830
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación por residuo en transposición de los grandes vasos operada',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("134")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 17243.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 342.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2268.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Agregar los grupos poblacionales de 6 a 9 años y 10 a 19 años en la prestación "ITK026"
  prestacion = Prestacion.find(436)
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]

  # Crear la prestación "ITK200" para el diagnóstico "057"
  prestacion = Prestacion.create!({
    # id: 831
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación por residuo en anomalía de Ebstein operada',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("057")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 17243.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 342.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2268.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Crear la prestación "ITK200" para los diagnósticos "109"/"110"
  prestacion = Prestacion.create!({
    # id: 832
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación en atresia pulmonar con CIV operada',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("109")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("110")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 17243.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 342.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2268.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Crear la prestación "ITK200" para el diagnóstico "153"
  prestacion = Prestacion.create!({
    # id: 833
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación en tronco arterial operado; recambio de homoinjerto',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("153")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 17243.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 342.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2268.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Crear la prestación "ITK200" para el diagnóstico "124"
  prestacion = Prestacion.create!({
    # id: 834
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación en ventrículo único con obstrucción aórtica operado',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("153")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 17243.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 342.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2268.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Crear la prestación "ITK200" para el diagnóstico "065"
  prestacion = Prestacion.create!({
    # id: 835
    codigo: "ITK200",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K200"),
    nombre: 'Cardiopatías congénitas - Módulo V - Reoperación por residuo en interrupción del arco aórtico operada',
    es_catastrofica: true,
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("065")
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 2.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  DatoReportableRequerido.create!({
    prestacion_id: prestacion.id,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    fecha_de_inicio: fecha_de_inicio,
    minimo: 0.0000,
    maximo: 25.0000,
    necesario: true,
    obligatorio: true
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPREQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 17243.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1926.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQU"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 342.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DMPOSTQ"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2268.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQUM"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 861.0000,
    adicional_por_prestacion: 0.0000,
    dato_reportable_id: DatoReportable.id_del_codigo!("DEPOSTQSC"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Agregar los grupos poblacionales de 6 a 9 años y 10 a 19 años en la prestación "ITK038"
  prestacion = Prestacion.find(442)
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]

  # Agregar los grupos poblacionales de 6 a 9 años y 10 a 19 años en la prestación "ITK034"
  prestacion = Prestacion.find(445)
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]

  ### ANEXO ###

  # Modificar la prestación 'PRP001' para que admita todos los diagnósticos
  prestacion = Prestacion.find(620)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # No modifico la prestación 'PRP003' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(558)
  #prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "PRP004 - Electrocardiograma" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 836,
    codigo: "PRP004",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("P004"),
    nombre: 'Electrocardiograma',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_algun_electrocardiograma_autorizado = PrestacionAutorizada.where(
      prestacion_id: [317, 483, 621, 767, 768],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modificar los grupos poblacionales y diagnósticos de la prestación "PRP005" del anexo
  prestacion = Prestacion.find(622)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # No modifico la prestación 'PRP006' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(623)
  #prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modificar los grupos poblacionales y diagnósticos de la prestación "PRP007" del anexo
  prestacion = Prestacion.find(624)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64] # SIRGe admite el grupo menores_de_6 pero no el PSS
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17 AND codigo NOT IN ('X19', 'X30', 'X86')")

  # Modificar los diagnósticos de la prestación "PRP008" del anexo
  prestacion = Prestacion.find(625)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modificar los diagnósticos de la prestación "PRP009" del anexo
  prestacion = Prestacion.find(626)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modificar los diagnósticos de la prestación "PRP010" del anexo
  prestacion = Prestacion.find(627)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # No modifico la prestación 'PRP011' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(628)
  #prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # No modifico la prestación 'PRP014' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(629)
  #prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # No modifico la prestación 'PRP016' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(630)
  #prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'PRP017' de acuerdo al SIRGe que admite todos los diagnósticos y grupos (el PSS es más restrictivo)
  prestacion = Prestacion.find(631)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'PRP019' para que admita solo el grupo poblacional menores_de_6 (el SIRGe admite todos)
  prestacion = Prestacion.find(632)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'PRP020' para que admita solo el grupo poblacional menores_de_6 y todos los diagnósticos
  prestacion = Prestacion.find(633)
  prestacion.sexos << Sexo.find(:all)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'PRP028' de acuerdo al SIRGe que admite todos los diagnósticos y grupos (el PSS es más restrictivo)
  prestacion = Prestacion.find(634)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # No modifico la prestación 'PRP029' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(635)
  #prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Guardamos el listado de convenios que hay que adendar para eliminar la prestación 'PRP030' del anexo (según PSS solo es para embarazos de alto riesgo)
  convenios_con_uso_de_tiras_reactivas_autorizado = PrestacionAutorizada.where(
      prestacion_id: 636,
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # No modifico la prestación 'PRP031' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(351)
  #prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR002' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo para grupo mujeres_20_a_64)
  prestacion = Prestacion.find(637)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR003 - Ecocardiograma con fracción de eyección" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 837,
    codigo: "IGR003",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R003"),
    nombre: 'Ecocardiograma con fracción de eyección',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 50.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_algun_ecocardiograma_autorizado = PrestacionAutorizada.where(
      prestacion_id: [638, 769, 770],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "IGR004 - Eco-Doppler color" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 838,
    codigo: "IGR004",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R004"),
    nombre: 'Eco-Doppler color',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 20.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_ecodoppler_autorizado = PrestacionAutorizada.where(
      prestacion_id: 492,
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'IGR005' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo para grupo menores_de_6)
  prestacion = Prestacion.find(487)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR006' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo para grupo menores_de_6)
  prestacion = Prestacion.find(639)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR007 - Ecografía de cuello" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 839,
    codigo: "IGR007",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R007"),
    nombre: 'Ecografía de cuello',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_ecografias_de_cuello_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [640, 771, 772],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "IGR008 - Ecografía ginecológica" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 840,
    codigo: "IGR008",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R008"),
    nombre: 'Ecografía ginecológica',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 25.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_ecografias_ginecologicas_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [368, 641, 773, 774],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "IGR009 - Ecografía mamaria" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 841,
    codigo: "IGR009",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R009"),
    nombre: 'Ecografía mamaria',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 25.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_ecografias_mamarias_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [642, 775, 776],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "IGR010 - Ecografía tiroidea" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 842,
    codigo: "IGR010",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R010"),
    nombre: 'Ecografía tiroidea',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 20.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_ecografias_tiroideas_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [643, 777],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'IGR011' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo para grupo mujeres_20_a_64)
  prestacion = Prestacion.find(644)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR012 - Fibrogastroscopía" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 843,
    codigo: "IGR012",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R012"),
    nombre: 'Fibrogastroscopía',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 100.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_fibrogastroscopias_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [645, 778],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'IGR013' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo para grupo mujeres_20_a_64)
  prestacion = Prestacion.find(646)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR017 - Rx de codo, antebrazo, muñeca, mano, dedos, rodilla, pierna, tobillo, pie (total o focalizada), frente y perfil" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 844,
    codigo: "IGR017",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R017"),
    nombre: 'Rx de codo, antebrazo, muñeca, mano, dedos, rodilla, pierna, tobillo, pie (total o focalizada), frente y perfil',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_rx_huesos_cortos_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [490, 779],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'IGR018' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo para grupo mujeres_20_a_64)
  prestacion = Prestacion.find(647)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR019' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (exceptúa grupo mujeres_20_a_64)
  prestacion = Prestacion.find(648)
  prestacion.sexos = [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR020' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(649)
  prestacion.sexos = [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR021' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(650)
  prestacion.sexos = [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR022 - Rx de cráneo (frente y perfil); Rx de senos paranasales" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 845,
    codigo: "IGR022",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R022"),
    nombre: 'Rx de cráneo (frente y perfil); Rx de senos paranasales',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_rx_de_craneo_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [321, 489, 780],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'IGR023' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo grupos menores_de_6 y mujeres_20_a_64)
  prestacion = Prestacion.find(651)
  prestacion.sexos = [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales = [menores_de_6, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR024' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo grupo mujeres_20_a_64)
  prestacion = Prestacion.find(652)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR025 - Rx de hombro, húmero, pelvis, cadera y ..." y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 846,
    codigo: "IGR025",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R025"),
    nombre: 'Rx de hombro, húmero, pelvis, cadera y fémur (total o focalizada), frente y perfil',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_rx_de_huesos_largos_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [491, 781],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "IGR026 - Rx o tele-Rx de tórax (total o focalizada) ..." y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 847,
    codigo: "IGR026",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R026"),
    nombre: 'Rx o tele-Rx de tórax (total o focalizada), frente y perfil',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 3,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_rx_de_torax_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [488, 653],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'IGR028' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo grupo mujeres_20_a_64)
  prestacion = Prestacion.find(654)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR029' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo grupo menores_de_6)
  prestacion = Prestacion.find(655)
  prestacion.sexos = [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR030 - Tomografía axial computada (TAC)" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 848,
    codigo: "IGR030",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R030"),
    nombre: 'Tomografía axial computada (TAC)',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 150.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_tac_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [656, 782],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "IGR031 - Ecografía obstétrica" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 849,
    codigo: "IGR031",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R031"),
    nombre: 'Ecografía obstétrica',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17 OR grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "9.months",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])
  AsignacionDePrecios.create!({
    precio_por_unidad: 25.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 25.0000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_ecografias_obstetricas_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [320, 348],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "IGR032 - Ecografía abdominal" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 850,
    codigo: "IGR032",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("R032"),
    nombre: 'Ecografía abdominal',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 20.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_ecografias_abdominales_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [657, 783, 784],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'IGR037' de acuerdo al PSS y SIRGe que admite todos los diagnósticos
  prestacion = Prestacion.find(349)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17 OR grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")

  # Modifico la prestación 'IGR038' de acuerdo al PSS y SIRGe que admite todos los diagnósticos
  prestacion = Prestacion.find(350)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17 OR grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")

  # Modifico la prestación 'IGR039' de acuerdo al PSS y SIRGe que admite todos los diagnósticos
  prestacion = Prestacion.find(364)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17 OR grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")

  # Crear una nueva prestación "IGR031 - Ecografía obstétrica" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 851,
    codigo: "APA003",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("A003"),
    nombre: 'Medulograma (recuento diferencial con tinción de MGG)',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 150.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_medulogramas_autorizados = PrestacionAutorizada.where(
      prestacion_id: [658, 785],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'TLM020 - Traslado en unidad móvil de alta complejidad para adultos'
  prestacion = Prestacion.find(659)
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])

  # Modifico la prestación 'TLM030 - Unidad móvil de alta complejidad (pediátrica/neonatal)'
  prestacion = Prestacion.find(660)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)

  # Modifico la prestación 'TLM040 - Traslado del RN prematuro ...'
  prestacion = Prestacion.find(401)
  prestacion.diagnosticos.delete_all
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)

  # Modifico la prestación 'TLM041 - Traslado de la gestante ...'
  prestacion = Prestacion.find(379)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)

  # Crear una nueva prestación "TLM081 - Unidad móvil de baja y ... (hasta 50 km)" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 852,
    codigo: "TLM081",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("M081"),
    nombre: 'Unidad móvil de baja o mediana complejidad (hasta 50 km)',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 3,
    periodo: "1.year",
    intervalo: "1.week"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  DocumentacionRespaldatoriaPrestacion.create!(
    {
      documentacion_respaldatoria_id: 2,
      prestacion_id: prestacion.id,
      fecha_de_inicio: Date.new(2013, 6, 1),
      created_at: DateTime.now(),
      updated_at: DateTime.now()
    }
  )
  AsignacionDePrecios.create!({
    precio_por_unidad: 150.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 150.0000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_traslados_hasta_50_autorizados = PrestacionAutorizada.where(
      prestacion_id: [318, 485],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "TLM082 - Unidad móvil de baja y ... (más de 50 km)" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 853,
    codigo: "TLM082",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("M082"),
    nombre: 'Unidad móvil de baja o mediana complejidad (más de 50 km)',
    unidad_de_medida_id: UnidadDeMedida.find_by_codigo("K").id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 3,
    periodo: "1.year",
    intervalo: "1.week"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  DocumentacionRespaldatoriaPrestacion.create!(
    {
      documentacion_respaldatoria_id: 2,
      prestacion_id: prestacion.id,
      fecha_de_inicio: Date.new(2013, 6, 1),
      created_at: DateTime.now(),
      updated_at: DateTime.now()
    }
  )
  AsignacionDePrecios.create!({
    precio_por_unidad: 1.0000,
    adicional_por_prestacion: 150.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 1.0000,
    adicional_por_prestacion: 150.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_traslados_mas_50_autorizados = PrestacionAutorizada.where(
      prestacion_id: [319, 486],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL001' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (para todo el grupo menores_de_6, no solo neonatos)
  prestacion = Prestacion.find(661)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = [MetodoDeValidacion.find(15)]

  # Crear una nueva prestación "LBL002" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 854,
    codigo: "LBL002",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L002"),
    nombre: 'Ácido úrico',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para añadir la nueva prestación y eliminar las anteriores
  convenios_con_lbl002_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [338, 662],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL003' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo en embarazo)
  prestacion = Prestacion.find(663)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = MetodoDeValidacion.find([1, 15])

  # Modifico la prestación 'LBL004' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(664)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL005' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(665)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL006' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(666)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL008' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos excepto menores_de_6)
  prestacion = Prestacion.find(667)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL009' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(668)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL010' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(669)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL011' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(670)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico las prestaciones 'LBL012' de acuerdo al PSS y SIRGe (menores de 6 y embarazo de alto riesgo)
  prestacion = Prestacion.find(345)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  prestacion = Prestacion.find(786)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL013' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo menores_de_6)
  prestacion = Prestacion.find(671)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL014' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (excepto grupo mujeres_20_a_64)
  prestacion = Prestacion.find(672)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL015' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(673)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL016' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (excepto grupo de_6_a_9)
  prestacion = Prestacion.find(674)
  prestacion.grupos_poblacionales = [menores_de_6, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL017' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo en mujeres_20_a_64)
  prestacion = Prestacion.find(675)
  prestacion.grupos_poblacionales = [mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL018' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(676)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL019' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo menores_de_6 y de_6_a_9)
  prestacion = Prestacion.find(677)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL020' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo mujeres_20_a_64)
  prestacion = Prestacion.find(678)
  prestacion.grupos_poblacionales = [mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico las prestaciones 'LBL021' de acuerdo al PSS y SIRGe (todos excepto menores de 6 y embarazo de alto riesgo)
  prestacion = Prestacion.find(340)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  prestacion = Prestacion.find(787)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico las prestaciones 'LBL023' de acuerdo al PSS y SIRGe (solo embarazo de alto riesgo)
  prestacion = Prestacion.find(336)
  prestacion.update_attributes!({nombre: 'Cuantificación de fibrinógeno (embarazo de alto riesgo)'})
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")

  # Guardamos el listado de convenios que hay que adendar para eliminar la prestación general
  convenios_con_lbl023_autorizadas = PrestacionAutorizada.where(
      prestacion_id: 789,
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico las prestaciones 'LBL024' de acuerdo al PSS y SIRGe (solo menores_de_6, y embarazadas)
  prestacion = Prestacion.find(679)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL024" para embarazadas
  prestacion = Prestacion.create!({
    # id: 855,
    codigo: "LBL024",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L024"),
    nombre: 'Cultivo Streptococo B hemolítico (embarazadas)',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Modifico las prestaciones 'LBL025' de acuerdo al PSS y SIRGe (adolescentes mujeres, mujeres_20_a_64, y embarazadas)
  prestacion = Prestacion.find(680)
  prestacion.grupos_poblacionales = [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL026' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(681)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL027' de acuerdo al PSS y SIRGe (excepto mujeres_20_a_64)
  prestacion = Prestacion.find(682)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL028' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(683)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL029' de acuerdo al PSS y SIRGe (excepto menores_de_6)
  prestacion = Prestacion.find(684)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL030' de acuerdo al PSS y SIRGe (excepto mujeres_20_a_64)
  prestacion = Prestacion.find(685)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL031' de acuerdo al PSS y SIRGe (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(686)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Guardamos el listado de convenios que hay que adendar para eliminar la prestación general
  convenios_con_lbl031_autorizadas = PrestacionAutorizada.where(
      prestacion_id: 790,
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL032' de acuerdo al PSS y SIRGe (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(687)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Guardamos el listado de convenios que hay que adendar para eliminar la prestación general
  convenios_con_lbl032_autorizadas = PrestacionAutorizada.where(
      prestacion_id: 791,
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL033' de acuerdo al PSS y SIRGe (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(688)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Guardamos el listado de convenios que hay que adendar para eliminar la prestación general
  convenios_con_lbl033_autorizadas = PrestacionAutorizada.where(
      prestacion_id: 792,
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL034' de acuerdo al PSS y SIRGe (solo menores_de_6)
  prestacion = Prestacion.find(689)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL035' de acuerdo al PSS y SIRGe (solo menores_de_6)
  prestacion = Prestacion.find(690)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = [MetodoDeValidacion.find(15)]

  # Modifico la prestación 'LBL036' de acuerdo al PSS y SIRGe (solo menores_de_6)
  prestacion = Prestacion.find(691)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL037' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(692)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL038' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(693)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico las prestaciones 'LBL040' de acuerdo al PSS y SIRGe (todos excepto mujeres_20_a_64 y embarazo de alto riesgo)
  prestacion = Prestacion.find(343)
  prestacion.update_attributes!({nombre: 'Fosfatasa alcalina y ácida (embarazo de alto riesgo)'})
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  prestacion = Prestacion.find(793)
  prestacion.update_attributes!({nombre: 'Fosfatasa alcalina y ácida'})
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL041' de acuerdo al PSS y SIRGe (solo de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(694)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL042' de acuerdo al PSS y SIRGe (todos los grupos excepto menores_de_6)
  prestacion = Prestacion.find(695)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL043' de acuerdo al PSS y SIRGe (solo menores_de_6)
  prestacion = Prestacion.find(696)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = [MetodoDeValidacion.find(15)]

  # Modifico las prestaciones 'LBL044' de acuerdo al PSS y SIRGe (de_6_a_9, adolescentes y embarazo de alto riesgo)
  prestacion = Prestacion.find(344)
  prestacion.update_attributes!({nombre: 'Gamma-GT (gamma glutamil transpeptidasa), en embarazo de alto riesgo'})
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  prestacion = Prestacion.find(794)
  prestacion.update_attributes!({nombre: 'Gamma-GT (gamma glutamil transpeptidasa)'})
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL045 - Glucemia" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 856,
    codigo: "LBL045",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L045"),
    nombre: 'Glucemia',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17 OR grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl045_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [275, 288, 337, 697],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL046' de acuerdo al PSS y SIRGe (solo embarazos_de_alto_riesgo)
  prestacion = Prestacion.find(698)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = MetodoDeValidacion.find([1, 15])

  # Modifico la prestación 'LBL047' de acuerdo al PSS y SIRGe (adolescentes y mujeres_20_a_64)
  prestacion = Prestacion.find(271)
  prestacion.update_attributes!({nombre: "Gonadotrofina coriónica humana en sangre"})
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL048' de acuerdo al PSS y SIRGe (adolescentes y mujeres_20_a_64)
  prestacion = Prestacion.find(272)
  prestacion.update_attributes!({nombre: "Gonadotrofina coriónica humana en orina"})
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL049' de acuerdo al PSS y SIRGe (solo grupo menores_de_6)
  prestacion = Prestacion.find(699)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL050 - Grupo y factor" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 857,
    codigo: "LBL050",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L050"),
    nombre: 'Grupo y factor',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl050_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [273, 700],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL051' de acuerdo al PSS y SIRGe (todos excepto menores_de_6)
  prestacion = Prestacion.find(286)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = [MetodoDeValidacion.find(15)]

  # Crear una nueva prestación "LBL052 - HDL y LDL" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 858,
    codigo: "LBL052",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L052"),
    nombre: 'HDL y LDL',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl052_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [346, 795],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL053' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(701)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Desdoblar la prestación "LBL054" para menores de 6 años y embarazo de alto riesgo
  prestacion = Prestacion.create!({
    # id: 859,
    codigo: "LBL054",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L054"),
    nombre: 'Hemocultivo aerobio anaerobio',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  prestacion = Prestacion.create!({
    # id: 860,
    codigo: "LBL054",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L054"),
    nombre: 'Hemocultivo aerobio anaerobio (embarazo de alto riesgo)',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 4,
    periodo: "9.months",
    intervalo: "1.week"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para desdoblar la prestación
  convenios_con_lbl054_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [702],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "LBL055" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 861,
    codigo: "LBL055",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L055"),
    nombre: 'Hemoglobina',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl055_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [274, 287, 703],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL056' de acuerdo al PSS y SIRGe (solo embarazo de alto riesgo)
  prestacion = Prestacion.find(359)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")

  # Crear una nueva prestación "LBL057" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 862,
    codigo: "LBL057",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L057"),
    nombre: 'Hemograma completo',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl057_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [332, 704],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL058' de acuerdo al PSS y SIRGe (todos los grupos excepto menores_de_6)
  prestacion = Prestacion.find(705)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL059' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(706)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL060' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(707)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL061' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(708)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL062' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(709)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL063' de acuerdo al PSS y SIRGe (únicamente menores de 6)
  prestacion = Prestacion.find(710)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL064' de acuerdo al PSS y SIRGe (únicamente menores de 6)
  prestacion = Prestacion.find(711)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL065" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 863,
    codigo: "LBL065",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L065"),
    nombre: 'IFI y hemoaglutinación directa para Chagas',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl065_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [278, 796],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL066' de acuerdo al PSS y SIRGe (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(712)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL067" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 864,
    codigo: "LBL067",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L067"),
    nombre: 'Inmunofenotipo de médula ósea por citometría de flujo',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 150.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl067_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [713, 797],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL066' de acuerdo al PSS y SIRGe (todos excepto mujeres_20_a_64)
  prestacion = Prestacion.find(714)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL069" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 865,
    codigo: "LBL069",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L069"),
    nombre: 'KPTT',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl069_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [333, 798],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL070' de acuerdo al PSS y SIRGe (todos excepto menores_de_6)
  prestacion = Prestacion.find(715)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL071' de acuerdo al PSS y SIRGe (solo grupo menores_de_6)
  prestacion = Prestacion.find(716)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL072' de acuerdo al PSS y SIRGe (todos excepto grupo menores_de_6)
  prestacion = Prestacion.find(717)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL073' de acuerdo al PSS y SIRGe (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(718)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL074' de acuerdo al PSS y SIRGe (solo grupo menores_de_6)
  prestacion = Prestacion.find(719)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL075' de acuerdo al PSS y SIRGe (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(720)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL076' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(721)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL077' de acuerdo al PSS y SIRGe (solo embarazo de alto riesgo)
  prestacion = Prestacion.find(722)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = MetodoDeValidacion.find([1, 15])

  # Modifico la prestación 'LBL078' de acuerdo al PSS y SIRGe (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(723)
  prestacion.sexos = [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL079" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 866,
    codigo: "LBL079",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L079"),
    nombre: 'Orina completa',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl079_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [276, 289, 347, 724],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico las prestaciones 'LBL080' de acuerdo al PSS y SIRGe (embarazadas y menores_de_6)
  prestacion = Prestacion.find(279)
  prestacion.update_attributes!({nombre: "Parasitemia para Chagas"})
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion = Prestacion.find(799)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL081' de acuerdo al PSS y SIRGe (todos excepto mujeres_20_a_64)
  prestacion = Prestacion.find(725)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL082' de acuerdo al PSS y SIRGe (solo menores_de_6)
  prestacion = Prestacion.find(726)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL083' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(727)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL084' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(728)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL085' de acuerdo al PSS y SIRGe (solo embarazadas)
  prestacion = Prestacion.find(729)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(1)

  # Modifico la prestación 'LBL086' de acuerdo al PSS y SIRGe (solo mujeres adolescentes y adultas)
  prestacion = Prestacion.find(730)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL087' de acuerdo al PSS y SIRGe (solo mujeres adolescentes y adultas)
  prestacion = Prestacion.find(731)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL088' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(732)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL089' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(733)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL090" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 867,
    codigo: "LBL090",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L090"),
    nombre: 'Proteinuria',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 4,
    periodo: "9.months",
    intervalo: "1.week"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl090_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [341, 800],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL091' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(734)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL092' de acuerdo al PSS y SIRGe (solo embarazadas)
  prestacion = Prestacion.find(736)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(1)

  # Crear una nueva prestación "LBL094" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 868,
    codigo: "LBL094",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L094"),
    nombre: 'Prueba de tolerancia a la glucosa',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 4,
    periodo: "9.months",
    intervalo: "1.week"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl094_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [363, 801],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL095' de acuerdo al PSS y SIRGe (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(737)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  
  # Modifico la prestación 'LBL096' de acuerdo al PSS y SIRGe (solo menores_de_6)
  prestacion = Prestacion.find(738)
  prestacion.sexos = [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL097' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(739)
  prestacion.sexos = [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL098' de acuerdo al PSS y SIRGe (solo mujeres_20_a_64)
  prestacion = Prestacion.find(740)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL099" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 869,
    codigo: "LBL099",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L099"),
    nombre: 'Serología para Chagas (Elisa)',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl099_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [280, 802],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL100' de acuerdo al PSS y SIRGe (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(741)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL101' de acuerdo al PSS y SIRGe (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(742)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL102' de acuerdo al PSS y SIRGe (solo mujeres_20_a_64)
  prestacion = Prestacion.find(743)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL103' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(744)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL104' de acuerdo al PSS y SIRGe (todos excepto menores_de_6)
  prestacion = Prestacion.find(745)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL105' de acuerdo al PSS y SIRGe (todos excepto menores_de_6)
  prestacion = Prestacion.find(746)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL106' de acuerdo al PSS y SIRGe (solo menores_de_6 y de_6_a_9)
  prestacion = Prestacion.find(747)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL107' de acuerdo al PSS y SIRGe (solo mujeres_20_a_64)
  prestacion = Prestacion.find(748)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL108' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(749)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL109' de acuerdo al PSS y SIRGe (solo embarazo de alto riesgo)
  prestacion = Prestacion.find(750)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = MetodoDeValidacion.find([1, 15])

  # Crear una nueva prestación "LBL110" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 870,
    codigo: "LBL110",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L110"),
    nombre: 'Toxoplasmosis por IFI',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 18.7500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl110_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [284, 803],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "LBL111" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 871,
    codigo: "LBL111",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L111"),
    nombre: 'Toxoplasmosis por MEIA',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl111_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [285, 804],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl110_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [284, 803],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "LBL112" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 872,
    codigo: "LBL112",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L112"),
    nombre: 'Transaminasas TGO/TGP',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl112_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [342, 805],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL113' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(751)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL114' de acuerdo al PSS y SIRGe (todos excepto menores_de_6)
  prestacion = Prestacion.find(752)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL115' de acuerdo al PSS y SIRGe (todos excepto menores_de_6)
  prestacion = Prestacion.find(753)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = [MetodoDeValidacion.find(15)]

  # Modifico la prestación 'LBL116' de acuerdo al PSS y SIRGe (todos excepto menores_de_6)
  prestacion = Prestacion.find(754)
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = [MetodoDeValidacion.find(15)]

  # Crear una nueva prestación "LBL117" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 873,
    codigo: "LBL117",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L117"),
    nombre: 'Urea',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl117_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [361, 806],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "LBL118" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 874,
    codigo: "LBL118",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L118"),
    nombre: 'Urocultivo',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 10.0000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl118_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [362, 807],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "LBL119" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 875,
    codigo: "LBL119",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L119"),
    nombre: 'VDRL',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl119_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [277, 290, 808],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL120' de acuerdo al PSS y SIRGe (solo menores_de_6)
  prestacion = Prestacion.find(755)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL121" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 876,
    codigo: "LBL121",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L121"),
    nombre: 'VIH Elisa',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 18.7500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 18.7500,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl121_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [282, 291, 809],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "LBL122" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 877,
    codigo: "LBL122",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L122"),
    nombre: 'VIH Western Blot',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 18.7500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 18.7500,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl122_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [283, 292, 810],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL123' de acuerdo al PSS y SIRGe (todos excepto menores_de_6)
  prestacion = Prestacion.find(756)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL124' de acuerdo al PSS y SIRGe (todos excepto mujeres_20_a_64)
  prestacion = Prestacion.find(757)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL125' de acuerdo al PSS y SIRGe (solo menores_de_6)
  prestacion = Prestacion.find(758)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Desdoblar la prestación "LBL126" para menores de 6 años y embarazo de alto riesgo
  prestacion = Prestacion.create!({
    # id: 878,
    codigo: "LBL126",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L126"),
    nombre: 'Recuento de plaquetas',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  prestacion = Prestacion.create!({
    # id: 879,
    codigo: "LBL126",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L126"),
    nombre: 'Recuento de plaquetas',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 4,
    periodo: "9.months",
    intervalo: "1.week"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para desdoblar la prestación
  convenios_con_lbl126_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [759],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL127' de acuerdo al PSS y SIRGe (todos excepto mujeres_20_a_64)
  prestacion = Prestacion.find(760)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL128" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 880,
    codigo: "LBL128",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L128"),
    nombre: 'Hemoaglutinación indirecta para Chagas',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 6.2500,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl128_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [281, 811],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL129' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(761)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL130' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(762)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL131" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 881,
    codigo: "LBL131",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L131"),
    nombre: 'Tiempo de protrombina',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl131_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [334, 812],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Crear una nueva prestación "LBL131" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 882,
    codigo: "LBL132",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L132"),
    nombre: 'Tiempo de trombina',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find(15)
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl132_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [335, 813],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # Modifico la prestación 'LBL133' de acuerdo al PSS y SIRGe (todos excepto menores_de_6)
  prestacion = Prestacion.find(814)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL134' de acuerdo al PSS y SIRGe (todos excepto menores_de_6)
  prestacion = Prestacion.find(763)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL135" para unificar las restantes
  prestacion = Prestacion.create!({
    # id: 883,
    codigo: "LBL135",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("L135"),
    nombre: 'Fructosamina',
    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
  })
  prestacion.sexos << [sexo_femenino]
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  CantidadDePrestacionesPorPeriodo.create!({
    prestacion_id: prestacion.id,
    cantidad_maxima: 2,
    periodo: "1.year",
    intervalo: "1.month"
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })
  AsignacionDePrecios.create!({
    precio_por_unidad: 2.5000,
    adicional_por_prestacion: 0.0000,
    area_de_prestacion_id: AreaDePrestacion.id_del_codigo!("R"),
    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
  })

  # Guardamos el listado de convenios que hay que adendar para unificar la prestación
  convenios_con_lbl135_autorizadas = PrestacionAutorizada.where(
      prestacion_id: [360, 766],
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort




  ##### AÑADIR PRESTACIONES DE FLAP #####
  # PRP036, PRP038, PRP039, PRP040, PRP047, IGR042, IGR043, IGR044, IGR045, IGR046, TLM042?, TLM043?

  ##### AÑADIR PRESTACIONES DE PIE BOT #####
  # PRP041, PRP042, PRP046

  ##### AÑADIR PRESTACIONES DE DISPLASIA DE CADERA #####
  # PRP044, PRP045, 
  # Modificar diagnósticos de IGR005 (id: 487), añadiendo los diagnósticos de DCC



  ##### GENERAR ADENDAS ÚNICAS POR CONVENIOS DE GESTIÓN #####

  convenios_de_gestion_sumar_para_adendar = ConvenioDeGestionSumar.find(
      (
        convenios_con_inmunizaciones_de_embarazo_autorizadas +
        convenios_con_inmunizaciones_de_menores_autorizadas +
        convenios_con_notificacion_de_leucemia_autorizada +
        convenios_con_algun_electrocardiograma_autorizado +
        convenios_con_uso_de_tiras_reactivas_autorizado +
        convenios_con_algun_ecocardiograma_autorizado +
        convenios_con_ecodoppler_autorizado +
        convenios_con_ecografias_de_cuello_autorizadas +
        convenios_con_ecografias_ginecologicas_autorizadas +
        convenios_con_ecografias_mamarias_autorizadas +
        convenios_con_ecografias_tiroideas_autorizadas +
        convenios_con_fibrogastroscopias_autorizadas +
        convenios_con_rx_huesos_cortos_autorizadas +
        convenios_con_rx_de_craneo_autorizadas +
        convenios_con_rx_de_huesos_largos_autorizadas +
        convenios_con_rx_de_torax_autorizadas +
        convenios_con_tac_autorizadas +
        convenios_con_ecografias_obstetricas_autorizadas +
        convenios_con_ecografias_abdominales_autorizadas +
        convenios_con_medulogramas_autorizados +
        convenios_con_traslados_hasta_50_autorizados +
        convenios_con_lbl002_autorizadas +
        convenios_con_lbl023_autorizadas +
        convenios_con_lbl031_autorizadas +
        convenios_con_lbl032_autorizadas +
        convenios_con_lbl033_autorizadas +
        convenios_con_lbl045_autorizadas +
        convenios_con_lbl050_autorizadas +
        convenios_con_lbl052_autorizadas +
        convenios_con_lbl054_autorizadas +
        convenios_con_lbl055_autorizadas +
        convenios_con_lbl057_autorizadas +
        convenios_con_lbl065_autorizadas +
        convenios_con_lbl067_autorizadas +
        convenios_con_lbl069_autorizadas +
        convenios_con_lbl079_autorizadas +
        convenios_con_lbl090_autorizadas +
        convenios_con_lbl094_autorizadas +
        convenios_con_lbl099_autorizadas +
        convenios_con_lbl110_autorizadas +
        convenios_con_lbl111_autorizadas +
        convenios_con_lbl112_autorizadas +
        convenios_con_lbl117_autorizadas +
        convenios_con_lbl118_autorizadas +
        convenios_con_lbl119_autorizadas +
        convenios_con_lbl121_autorizadas +
        convenios_con_lbl122_autorizadas +
        convenios_con_lbl126_autorizadas +
        convenios_con_lbl128_autorizadas +
        convenios_con_lbl131_autorizadas +
        convenios_con_lbl132_autorizadas +
        convenios_con_lbl135_autorizadas
      ).uniq.sort
    )

  ultima_addenda_sistema = AddendaSumar.where("numero ILIKE 'AD-001-%'").order("numero DESC").limit(1).first.numero.split("-")[2].to_i

  convenios_de_gestion_sumar_para_adendar.each do |cgs|

    # Obtener el referente a la fecha de inicio nueva para el efector del convenio
    referente = Efector.find(cgs.efector_id).referente_al_dia(fecha_de_inicio_nueva)

    addenda = AddendaSumar.create!({
        numero: "AD-001-" + '%03d' % (ultima_addenda_sistema += 1),
        convenio_de_gestion_sumar_id: cgs.id,
        firmante: (referente.present? ? Contacto.find(referente.contacto_id).mostrado.mb_chars.upcase.to_s : nil),
        fecha_de_suscripcion: fecha_de_inicio_nueva,
        fecha_de_inicio: fecha_de_inicio_nueva,
        observaciones: 'Adenda generada por sistema, por incorporación de nuevas prestaciones en el PSS 2015.'
      })
    addenda.creator_id = 1
    addenda.updater_id = 1
    addenda.save

    # Verificar si tenemos que adendar (añadir) la prestación de inmunización en el embarazo
    if convenios_con_inmunizaciones_de_embarazo_autorizadas.member?(cgs.id) && PrestacionAutorizada.where(efector_id: cgs.efector_id, prestacion_id: 764).size == 0
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 764,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    # Verificar si tenemos que adendar (añadir) la prestación de inmunización contra neumococo
    if convenios_con_inmunizaciones_de_menores_autorizadas.member?(cgs.id)
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 815,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    # Verificar si tenemos que desdoblar la prestación 'NTN002'
    if convenios_con_notificacion_de_leucemia_autorizada.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [520, 559],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).first.update_attributes!({
          fecha_de_finalizacion: fecha_de_inicio_nueva,
          autorizante_de_la_baja_id: addenda.id,
          autorizante_de_la_baja_type: "AddendaSumar"
        })
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 816,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 817,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_algun_electrocardiograma_autorizado.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [317, 483, 621, 767, 768],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 836,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_uso_de_tiras_reactivas_autorizado.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: 636,
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).first.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
    end

    if convenios_con_algun_ecocardiograma_autorizado.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [638, 769, 770],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 837,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_ecodoppler_autorizado.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: 492,
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).first.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 838,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_ecografias_de_cuello_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [640, 771, 772],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 839,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_ecografias_ginecologicas_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [368, 641, 773, 774],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 840,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_ecografias_mamarias_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [642, 775, 776],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 841,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_ecografias_tiroideas_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [643, 777],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 842,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_fibrogastroscopias_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [645, 778],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 843,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_rx_huesos_cortos_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [490, 779],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 844,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_rx_de_craneo_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [321, 489, 780],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 845,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_rx_de_huesos_largos_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [491, 781],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 846,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_rx_de_torax_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [488, 653],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 847,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_tac_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [656, 782],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 848,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_ecografias_obstetricas_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [320, 348],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 849,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_ecografias_abdominales_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [657, 783, 784],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 850,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_medulogramas_autorizados.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [658, 785],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 851,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_traslados_hasta_50_autorizados.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [318, 485],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 852,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_traslados_mas_50_autorizados.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [319, 486],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 853,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl002_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [338, 662],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 854,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl023_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: 789,
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
    end

    if convenios_con_lbl031_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: 790,
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
    end

    if convenios_con_lbl032_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: 791,
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
    end

    if convenios_con_lbl033_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: 792,
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
    end

    if convenios_con_lbl045_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [275, 288, 337, 697],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 856,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl050_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [273, 700],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 857,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl052_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [346, 795],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 858,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl054_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [702],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 859,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 860,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl055_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [274, 287, 703],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 861,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl057_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [332, 704],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 862,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl065_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [278, 796],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 863,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl067_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [713, 797],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 864,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl069_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [333, 798],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 865,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl079_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [276, 289, 347, 724],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 866,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl090_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [341, 800],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 867,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl094_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [363, 801],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 868,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl099_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [280, 802],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 869,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl110_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [284, 803],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 870,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl111_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [285, 804],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 871,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl112_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [342, 805],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 872,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl117_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [361, 806],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 873,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl118_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [362, 807],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 874,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl119_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [277, 290, 808],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 875,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl121_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [282, 291, 809],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 876,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl122_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [283, 292, 810],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 877,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl126_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [759],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 878,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 879,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl128_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [281, 811],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 880,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl131_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [334, 812],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 881,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl132_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [335, 813],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 882,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    if convenios_con_lbl135_autorizadas.member?(cgs.id)
      PrestacionAutorizada.where(
          prestacion_id: [360, 766],
          fecha_de_finalizacion: nil,
          efector_id: cgs.efector_id
        ).each{ |pa| pa.update_attributes!({
            fecha_de_finalizacion: fecha_de_inicio_nueva,
            autorizante_de_la_baja_id: addenda.id,
            autorizante_de_la_baja_type: "AddendaSumar"
          })
        }
      PrestacionAutorizada.create!({
          efector_id: cgs.efector_id,
          prestacion_id: 883,
          fecha_de_inicio: fecha_de_inicio_nueva,
          autorizante_al_alta_id: addenda.id,
          autorizante_al_alta_type: "AddendaSumar",
          fecha_de_finalizacion: nil,
          created_at: ahora,
          updated_at: ahora,
          creator_id: 1,
          updater_id: 1
        })
    end

    # TO_DO: Aprovechar para arreglar el pedo de efectores rurales con prestaciones urbanas.
  end # convenios_de_gestion_sumar_para_adendar.each do |cgs|

  # Desactivar las prestaciones que fueron reemplazadas o dadas de baja
  Prestacion.find([
      520, 317, 483, 621, 767, 768, 636, 638, 769, 770, 492, 640, 771, 772, 368, 641, 773, 774,
      642, 775, 776, 643, 777, 645, 778, 490, 779, 321, 489, 780, 491, 781, 488, 653, 320, 348,
      657, 783, 784, 658, 785, 318, 485, 319, 486, 338, 662, 789, 790, 791, 792, 275, 288, 337,
      697, 273, 700, 346, 795, 702, 274, 287, 703, 332, 704, 278, 796, 713, 797, 333, 798, 341,
      800, 363, 801, 280, 802, 284, 803, 285, 804, 342, 805, 361, 806, 362, 807, 277, 290, 808,
      282, 291, 809, 283, 292, 810, 759, 281, 811, 334, 812, 335, 813, 360, 766, 559, 656, 782,
      276, 289, 347, 724
    ]).each do |p|
      p.update_attributes!({activa: false})
  end

  # Desactivar las prestaciones Nacer
  Prestacion.where(objeto_de_la_prestacion_id: nil).each do |p|
    p.update_attributes!({activa: false})
  end

end
