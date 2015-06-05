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
  fecha_de_inicio_nueva = Date.new(2015, 5, 1)

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
  prestacion.grupos_poblacionales << [de_6_a_9]
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
  prestacion.grupos_poblacionales << [de_6_a_9]
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
      prestacion_id: 520,
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
  prestacion = Prestacion.find(411)
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
  prestacion.grupos_poblacionales << [de_6_a_9]
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

  # Crear la prestación "ITK201" para el diagnóstico "088", que quedó en el tintero
  prestacion = Prestacion.create!({
    # id: 821
    codigo: "ITK201",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("K201"),
    nombre: 'Cardiopatías congénitas - Módulo I - Reintervención por ductus residual con hemodinamia intervencionista',
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
  prestacion.grupos_poblacionales << [de_6_a_9]
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
  prestacion = Prestacion.find(816)
  prestacion.grupos_poblacionales << adolescentes
  prestacion = Prestacion.find(817)
  prestacion.grupos_poblacionales << adolescentes

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
  prestacion = Prestacion.find(411)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK004"
  prestacion = Prestacion.find(411)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK200" para el diagnóstico "035"
  prestacion = Prestacion.find(819)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK005" para el diagnóstico "088"
  prestacion = Prestacion.find(820)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK201" para el diagnóstico "088"
  prestacion = Prestacion.find(821)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK006"
  prestacion = Prestacion.find(413)
  prestacion.grupos_poblacionales << adolescentes

  # Agregar el grupo poblacional de 10 a 19 años en la prestación "ITK201" para el diagnóstico "035"
  prestacion = Prestacion.find(822)
  prestacion.grupos_poblacionales << adolescentes

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
    # id: 833
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # No modifico la prestación 'PRP003' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(558)
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "PRP004 - Electrocardiograma" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 834,
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
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modificar los grupos poblacionales y diagnósticos de la prestación "PRP007" del anexo
  prestacion = Prestacion.find(624)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64] # SIRGe admite el grupo menores_de_6 pero no el PSS
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

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
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # No modifico la prestación 'PRP014' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(629)
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # No modifico la prestación 'PRP016' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(630)
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'PRP017' de acuerdo al SIRGe que admite todos los diagnósticos y grupos (el PSS es más restrictivo)
  prestacion = Prestacion.find(631)
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'PRP019' para que admita solo el grupo poblacional menores_de_6 (el SIRGe admite todos)
  prestacion = Prestacion.find(632)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'PRP020' para que admita solo el grupo poblacional menores_de_6 y todos los diagnósticos
  prestacion = Prestacion.find(633)
  prestacion.sexos << Sexo.find(:all)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'PRP028' de acuerdo al SIRGe que admite todos los diagnósticos y grupos (el PSS es más restrictivo)
  prestacion = Prestacion.find(634)
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # No modifico la prestación 'PRP029' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(635)
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Guardamos el listado de convenios que hay que adendar para eliminar la prestación 'PRP030' del anexo (según PSS solo es para embarazos de alto riesgo)
  convenios_con_uso_de_tiras_reactivas_autorizado = PrestacionAutorizada.where(
      prestacion_id: 636,
      fecha_de_finalizacion: nil
    ).collect{|pa| (pa.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? pa.autorizante_al_alta_id : AddendaSumar.find(pa.autorizante_al_alta_id).convenio_de_gestion_sumar_id)}.uniq.sort

  # No modifico la prestación 'PRP031' de acuerdo al SIRGe que admite todos los diagnósticos y grupos porque debe estar mal definido
  #prestacion = Prestacion.find(351)
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR002' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo para grupo mujeres_20_a_64)
  prestacion = Prestacion.find(637)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR003 - Ecocardiograma con fracción de eyección" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 835,
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
    # id: 836,
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR006' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo para grupo menores_de_6)
  prestacion = Prestacion.find(639)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR007 - Ecografía de cuello" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 837,
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
    # id: 838,
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
    # id: 839,
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
    # id: 840,
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR012 - Fibrogastroscopía" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 841,
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR017 - Rx de codo, antebrazo, muñeca, mano, dedos, rodilla, pierna, tobillo, pie (total o focalizada), frente y perfil" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 842,
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR019' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (exceptúa grupo mujeres_20_a_64)
  prestacion = Prestacion.find(648)
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR020' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(649)
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR021' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo grupos de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(650)
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR022 - Rx de cráneo (frente y perfil); Rx de senos paranasales" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 843,
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
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR024' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo grupo mujeres_20_a_64)
  prestacion = Prestacion.find(652)
  prestacion.sexos = [sexo_femenino]
  prestacion.grupos_poblacionales = [mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR025 - Rx de hombro, húmero, pelvis, cadera y ..." y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 844,
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
    # id: 845,
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'IGR029' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo grupo menores_de_6)
  prestacion = Prestacion.find(655)
  prestacion.sexos = [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "IGR030 - Tomografía axial computada (TAC)" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 846,
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
    # id: 847,
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

  # Crear una nueva prestación "IGR031 - Ecografía obstétrica" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 848,
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17 OR grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")

  # Modifico la prestación 'IGR038' de acuerdo al PSS y SIRGe que admite todos los diagnósticos
  prestacion = Prestacion.find(350)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17 OR grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")

  # Modifico la prestación 'IGR039' de acuerdo al PSS y SIRGe que admite todos los diagnósticos
  prestacion = Prestacion.find(364)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17 OR grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")

  # Crear una nueva prestación "IGR031 - Ecografía obstétrica" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 849,
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
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
    # id: 850,
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
  prestacion.documentaciones_respaldatorias << DocumentacionRespaldatoria.find(2)
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
    # id: 851,
    codigo: "TLM082",
    objeto_de_la_prestacion_id: ObjetoDeLaPrestacion.id_del_codigo!("M082"),
    nombre: 'Unidad móvil de baja o mediana complejidad (más de 50 km)',
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
  prestacion.documentaciones_respaldatorias << DocumentacionRespaldatoria.find(2)
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = MetodoDeValidacion.find(15)

  # Crear una nueva prestación "LBL002" y unificar las prestaciones ya existentes
  prestacion = Prestacion.create!({
    # id: 852,
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")
  prestacion.metodos_de_validacion = MetodoDeValidacion.find([1, 15])

  # Modifico la prestación 'LBL004' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(664)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL005' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(665)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL006' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(666)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL008' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos excepto menores_de_6)
  prestacion = Prestacion.find(667)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL009' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(668)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL010' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(669)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL011' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(670)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico las prestaciones 'LBL012' de acuerdo al PSS y SIRGe (menores de 6 y embarazo de alto riesgo)
  prestacion = Prestacion.find(345)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  prestacion = Prestacion.find(786)
  prestacion.grupos_poblacionales = [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL013' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo menores_de_6)
  prestacion = Prestacion.find(671)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL014' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (excepto grupo mujeres_20_a_64)
  prestacion = Prestacion.find(672)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL015' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo de_6_a_9 y adolescentes)
  prestacion = Prestacion.find(673)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL016' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (excepto grupo de_6_a_9)
  prestacion = Prestacion.find(674)
  prestacion.grupos_poblacionales = [menores_de_6, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL017' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo en mujeres_20_a_64)
  prestacion = Prestacion.find(675)
  prestacion.grupos_poblacionales = [mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL018' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (todos los grupos)
  prestacion = Prestacion.find(676)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL019' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo menores_de_6 y de_6_a_9)
  prestacion = Prestacion.find(677)
  prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico la prestación 'LBL020' de acuerdo al PSS y SIRGe que admite todos los diagnósticos (solo mujeres_20_a_64)
  prestacion = Prestacion.find(678)
  prestacion.grupos_poblacionales = [mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico las prestaciones 'LBL021' de acuerdo al PSS y SIRGe (todos excepto menores de 6 y embarazo de alto riesgo)
  prestacion = Prestacion.find(340)
  prestacion.diagnosticos = Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  prestacion = Prestacion.find(787)
  prestacion.grupos_poblacionales = [de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Crear una nueva prestación "LBL024" para embarazadas
  prestacion = Prestacion.create!({
    # id: 853,
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
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")

  # Modifico las prestaciones 'LBL026' de acuerdo al PSS y SIRGe (todos los grupos)
  prestacion = Prestacion.find(681)
  prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id BETWEEN 1 AND 17")





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
        convenios_con_lbl023_autorizadas
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
        observaciones: 'Adenda generada por sistema, por incorporación de nuevas prestaciones en el PSS 2015.',
        creator_id: 1,
        updater_id: 1,
        created_at: ahora,
        updated_at: ahora
      })

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
          prestacion_id: 520,
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
          prestacion_id: 834,
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
        }
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
          prestacion_id: 835,
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

    # TO_DO: Aprovechar para arreglar el pedo de efectores rurales con prestaciones urbanas.
  end # convenios_de_gestion_sumar_para_adendar.each do |cgs|

  # Desactivar las prestaciones que fueron reemplazadas o dadas de baja
  Prestacion.find([
      520, 317, 483, 621, 767, 768, 636, 638, 769, 770, 492, 640, 771, 772, 368, 641, 773, 774,
      642, 775, 776, 643, 777, 645, 778, 490, 779, 312, 489, 780, 491, 781, 488, 653, 320, 348,
      657, 783, 784, 658, 785, 318, 485, 319, 486, 338, 662, 789
    ]).each do |p|
      p.update_attributes!({activa: false})
  end



# Revisión general de prestaciones surgidas de la evaluación a partir de la incorporación de los modelos PDSS







############### PARA REVISAR ########################


# Monotest (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(codigo: "LBL078").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Reacción de Widal (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(codigo: "LBL096").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Receptores libres de transferrinas (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(codigo: "LBL097").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Sangre oculta en heces (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(codigo: "LBL098").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Cambio la descripción del código LBL112
Prestacion.where(id: 342, codigo: "LBL112").first.update_attributes({nombre: "Enzimas hepáticas: Transaminasas TGO/TGP (embarazo de alto riesgo)"})

# Falta el método de validación de "beneficiaria_embarazada?" en la prestación "Ecografía renal"
Prestacion.find(350).metodos_de_validacion << [MetodoDeValidacion.find(1)]

# Falta el método de validación de "beneficiaria_embarazada?" en la prestación "Monitoreo fetal anteparto"
Prestacion.find(351).metodos_de_validacion << [MetodoDeValidacion.find(1)]





#  DUPLICAR PRACTICAS COMPLEMENTARIAS DE CCC PARA MÓDULOS CATASTRÓFICOS
#
#  Prestacion.find_by_codigo("XMX001").update_attributes({
#    nombre: "Alprostadil (en módulos I, II, III y IV -no catastróficos-)",
#    es_catastrofica: false
#  })
#
#  Prestacion.find_by_codigo("XMX002").update_attributes({
#    nombre: "Óxido nítrico y dispenser para su administración (en módulos I, II, III y IV -no catastróficos-)",
#    es_catastrofica: false
#  })
#
#  Prestacion.find_by_codigo("XMX003").update_attributes({
#    nombre: "Levosimedan (en módulos I, II, III y IV -no catastróficos-)",
#    es_catastrofica: false
#  })
#
#  Prestacion.find_by_codigo("XMX004").update_attributes({
#    nombre: "Factor VII activado recombinante (en módulos I, II, III y IV -no catastróficos-)",
#    es_catastrofica: false
#  })
#
#  Prestacion.find_by_codigo("XMX005").update_attributes({
#    nombre: "Iloprost (en módulos I, II, III y IV -no catastróficos-)",
#    es_catastrofica: false
#  })
#
#  Prestacion.find_by_codigo("XMX006").update_attributes({
#    nombre: "Trometanol (en módulos I, II, III y IV -no catastróficos-)",
#    es_catastrofica: false
#  })
#
#  Prestacion.find_by_codigo("XMX007").update_attributes({
#    nombre: "Surfactante (en módulos I, II, III y IV -no catastróficos-)",
#    es_catastrofica: false
#  })
#
#  Prestacion.find_by_codigo("XMX008").update_attributes({
#    nombre: "Nutrición parenteral total (en módulos I, II, III y IV -no catastróficos-)",
#    es_catastrofica: false
#  })
#
#  Prestacion.find_by_codigo("XMX009").update_attributes({
#    nombre: "Prótesis y órtesis (en módulos I, II, III y IV -no catastróficos-)",
#    es_catastrofica: false
#  })
#
#  prestacion = Prestacion.create!({
#    codigo: "XMX001",
#    objeto_de_la_prestacion_id: (
#      ObjetoDeLaPrestacion.where(codigo: 'X001', tipo_de_prestacion_id: TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    nombre: 'Alprostadil (en módulos V, VI y VII -catastróficos-)',
#    es_catastrofica: true,
#    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true,
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    fecha_de_inicio: fecha_de_inicio,
#    minimo: 0.0100,
#    necesario: true,
#    obligatorio: true
#  })
#  AsignacionDePrecios.create!({
#    precio_por_unidad: 1.0000,
#    adicional_por_prestacion: 0.0000,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
#  })
#
#  prestacion = Prestacion.create!({
#    codigo: "XMX002",
#    objeto_de_la_prestacion_id: (
#      ObjetoDeLaPrestacion.where(codigo: 'X002', tipo_de_prestacion_id: TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    nombre: 'Óxido nítrico y dispenser para su administración (en módulos V, VI y VII -catastróficos-)',
#    es_catastrofica: true,
#    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    fecha_de_inicio: fecha_de_inicio,
#    minimo: 0.0100,
#    necesario: true,
#    obligatorio: true
#  })
#  AsignacionDePrecios.create!({
#    precio_por_unidad: 1.0000,
#    adicional_por_prestacion: 0.0000,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
#  })
#
#  prestacion = Prestacion.create!({
#    codigo: "XMX003",
#    objeto_de_la_prestacion_id: (
#      ObjetoDeLaPrestacion.where(codigo: 'X003', tipo_de_prestacion_id: TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    nombre: 'Levosimedan (en módulos V, VI y VII -catastróficos-)',
#    es_catastrofica: true,
#    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    fecha_de_inicio: fecha_de_inicio,
#    minimo: 0.0100,
#    necesario: true,
#    obligatorio: true
#  })
#  AsignacionDePrecios.create!({
#    precio_por_unidad: 1.0000,
#    adicional_por_prestacion: 0.0000,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
#  })
#
#  prestacion = Prestacion.create!({
#    codigo: "XMX004",
#    objeto_de_la_prestacion_id: (
#      ObjetoDeLaPrestacion.where(codigo: 'X004', tipo_de_prestacion_id: TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    nombre: 'Factor VII activado recombinante (en módulos V, VI y VII -catastróficos-)',
#    es_catastrofica: true,
#    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    fecha_de_inicio: fecha_de_inicio,
#    minimo: 0.0100,
#    necesario: true,
#    obligatorio: true
#  })
#  AsignacionDePrecios.create!({
#    precio_por_unidad: 1.0000,
#    adicional_por_prestacion: 0.0000,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
#  })
#
#  prestacion = Prestacion.create!({
#    codigo: "XMX005",
#    objeto_de_la_prestacion_id: (
#      ObjetoDeLaPrestacion.where(codigo: 'X005', tipo_de_prestacion_id: TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    nombre: 'Iloprost (en módulos V, VI y VII -catastróficos-)',
#    es_catastrofica: true,
#    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    fecha_de_inicio: fecha_de_inicio,
#    minimo: 0.0100,
#    necesario: true,
#    obligatorio: true
#  })
#  AsignacionDePrecios.create!({
#    precio_por_unidad: 1.0000,
#    adicional_por_prestacion: 0.0000,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
#  })
#
#  prestacion = Prestacion.create!({
#    codigo: "XMX006",
#    objeto_de_la_prestacion_id: (
#      ObjetoDeLaPrestacion.where(codigo: 'X006', tipo_de_prestacion_id: TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    nombre: 'Trometanol (en módulos V, VI y VII -catastróficos-)',
#    es_catastrofica: true,
#    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    fecha_de_inicio: fecha_de_inicio,
#    minimo: 0.0100,
#    necesario: true,
#    obligatorio: true
#  })
#  AsignacionDePrecios.create!({
#    precio_por_unidad: 1.0000,
#    adicional_por_prestacion: 0.0000,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
#  })
#
#  prestacion = Prestacion.create!({
#    codigo: "XMX007",
#    objeto_de_la_prestacion_id: (
#      ObjetoDeLaPrestacion.where(codigo: 'X007', tipo_de_prestacion_id: TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    nombre: 'Surfactante (en módulos V, VI y VII -catastróficos-)',
#    es_catastrofica: true,
#    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    fecha_de_inicio: fecha_de_inicio,
#    minimo: 0.0100,
#    necesario: true,
#    obligatorio: true
#  })
#  AsignacionDePrecios.create!({
#    precio_por_unidad: 1.0000,
#    adicional_por_prestacion: 0.0000,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
#  })
#
#  prestacion = Prestacion.create!({
#    codigo: "XMX008",
#    objeto_de_la_prestacion_id: (
#      ObjetoDeLaPrestacion.where(codigo: 'X008', tipo_de_prestacion_id: TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    nombre: 'Nutrición parenteral total (en módulos V, VI y VII -catastróficos-)',
#    es_catastrofica: true,
#    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    fecha_de_inicio: fecha_de_inicio,
#    minimo: 0.0100,
#    necesario: true,
#    obligatorio: true
#  })
#  AsignacionDePrecios.create!({
#    precio_por_unidad: 1.0000,
#    adicional_por_prestacion: 0.0000,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
#  })
#
#  prestacion = Prestacion.create!({
#    codigo: "XMX009",
#    objeto_de_la_prestacion_id: (
#      ObjetoDeLaPrestacion.where(codigo: 'X009', tipo_de_prestacion_id: TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    nombre: 'Prótesis y órtesis (en módulos V, VI y VII -catastróficos-)',
#    es_catastrofica: true,
#    unidad_de_medida_id: um_unitaria.id, created_at: ahora, updated_at: ahora, activa: true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    fecha_de_inicio: fecha_de_inicio,
#    minimo: 0.0100,
#    necesario: true,
#    obligatorio: true
#  })
#  AsignacionDePrecios.create!({
#    precio_por_unidad: 1.0000,
#    adicional_por_prestacion: 0.0000,
#    dato_reportable_id: DatoReportable.id_del_codigo!("VC"),
#    nomenclador_id: nomenclador_sumar.id, prestacion_id: prestacion.id, created_at: ahora, updated_at: ahora
#  })
#
#  prestacion = Prestacion.where(
#    "codigo = 'APA001' AND EXISTS (
#       SELECT * FROM diagnosticos_prestaciones JOIN diagnosticos ON (diagnosticos.id = diagnosticos_prestaciones.diagnostico_id)
#         WHERE diagnosticos_prestaciones.prestacion_id = prestaciones.id AND diagnosticos.codigo = 'W78'
#     )").first
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("DIAGAP"),
#    fecha_de_inicio: fecha_de_inicio,
#    obligatorio: false
#  })
#  DatoReportableRequerido.create!({
#    prestacion_id: prestacion.id,
#    dato_reportable_id: DatoReportable.id_del_codigo!("SITAM"),
#    fecha_de_inicio: fecha_de_inicio,
#    obligatorio: true
#  })
#  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_mayor_de_24_anios?")

end
