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
  fecha_de_inicio_nueva = Date.new(2015, 3, 1)

  # Obtener el nomenclador
  nomenclador_sumar = Nomenclador.find(5)

  # Dejar únicamente el diagnóstico "W78" asociado a la prestación "PRP002" (colposcopía en control de embarazo)
  prestacion = Prestacion.find(268)
  prestacion.diagnosticos = [Diagnostico.find_by_codigo('W78')]

  # Cambio la descripción del código IMV008 / Añado métodos de validación faltantes
  prestacion = Prestacion.where(:id => 764, :codigo => "IMV008").first
  prestacion.update_attributes({:nombre => "Dosis aplicada de vacuna triple bacteriana acelular (dTpa) en el embarazo"})
  CantidadDePrestacionesPorPeriodo.create!(
    {
      :prestacion_id => prestacion.id,
      :cantidad_maxima => 2,
      :periodo => "9.months",
      :intervalo => "1.month"
    }
  )
  prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])

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

  # Eliminar el código de diagnóstico "003" de la prestación "ITK003"
  prestacion = Prestacion.find(410)
  prestacion.diagnosticos.delete(Diagnostico.find(215))

  # Eliminar los códigos de diagnóstico "026" y "087" de la prestación "ITK011" y añadir el código correcto "015"
  prestacion = Prestacion.find(410)
  prestacion.diagnosticos = [Diagnostico.find(120)]

  # Cambiar el nombre de las prestaciones de código "XMX003" (Levosimedan -> Levosimendán)
  prestacion = Prestacion.find(448)
  prestacion.update_attributes({:nombre => "Levosimendán (en módulos I, II, III y IV -no catastróficos-)"})
  prestacion = Prestacion.find(612)
  prestacion.update_attributes({:nombre => "Levosimendán (en módulos V, VI y VII -catastróficos-)"})

  # Cambiar el nombre de la prestación CTC001 con id 455
  prestacion = Prestacion.find(455)
  prestacion.update_attributes({:nombre => "Examen periódico de salud de niñas y niños menores de un año"})

  # Cambiar el nombre de la prestación CTC001 con id 456
  prestacion = Prestacion.find(456)
  prestacion.update_attributes({:nombre => "Examen periódico de salud de niñas y niños de uno a cinco años"})

  # Eliminar el grupo poblacional de 6 a 9 años de la prestación "IMV002" con id 464 (existe equivalente con id 501)
  prestacion = Prestacion.find(464)
  prestacion.grupos_poblacionales.delete(de_6_a_9)

  # Eliminar el grupo poblacional de 6 a 9 años de la prestación "IMV006"??? Duda consultada
  #prestacion = Prestacion.find(463)
  #prestacion.grupos_poblacionales.delete(de_6_a_9)

  # Crear la prestación "IMV015", que quedó en el tintero
  prestacion = Prestacion.create!({
    # :id => 815,
    :codigo => "IMV015",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V015"),
    :nombre => "Dosis aplicada de vacuna neumococo conjugada",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << menores_de_6
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => # 20.0000, # Averiguar precios viejos
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => # 40.0000, # Averiguar precios viejos
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

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

  # Agregar el diagnóstico "R77"
  Diagnostico.create!({:nombre => "Laringitis/Traqueítis aguda", :codigo => "R77"})

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
  prestacion.update_attributes({:nombre => "Examen periódico de salud de niñas y niños de seis a nueve años"})

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
    # :id => 816,
    :codigo => "NTN002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("N002"),
    :nombre => 'Notificación de inicio de tratamiento en tiempo oportuno (leucemia)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 5.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion = Prestacion.create!({
    # :id => 817,
    :codigo => "NTN002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("N002"),
    :nombre => 'Notificación de inicio de tratamiento en tiempo oportuno (linfoma)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 5.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Generamos una adenda para cada efector que tenga autorizada la prestación "NTN002" con id 520 dando de baja esa prestación
  # y habilitando las dos nuevas.
  ntn002_autorizadas = PrestacionAutorizada.where(prestacion_id: 520, fecha_de_finalizacion: nil)

  ultima_addenda_sistema => AddendaSumar.where("numero ILIKE 'AD-001-%'").order("numero DESC").limit(1).first.numero.split("-")[2].to_i

  ntn002_autorizadas.each do |na|
    addenda = AddendaSumar.create!({
        numero: "AD-001" + '%03d' % (ultima_addenda_sistema += 1),
        convenio_de_gestion_sumar_id: (na.autorizante_al_alta_type == 'ConvenioDeGestionSumar' ? na.autorizante_al_alta_id : AddendaSumar.find(autorizante_al_alta_id).convenio_de_gestion_sumar_id),
        firmante: nil,
        fecha_de_suscripcion: fecha_de_inicio_nueva,
        observaciones: 'Adenda generada por sistema, por reemplazo de la prestación "NTN002".',
        creator_id: 1,
        updater_id: 1,
        created_at: ahora,
        updated_at: ahora
      })
    na.update_attributes({
        fecha_de_finalizacion: fecha_de_inicio_nueva,
        autorizante_de_la_baja_id: addenda.id,
        autorizante_de_la_baja_type: "AddendaSumar"
      })
    PrestacionAutorizada.create!({
        efector_id: na.efector_id,
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
        efector_id: na.efector_id,
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





  #Modificar las prestaciones diagnósticas de CC para habilitar los nuevos grupos de 6 a 9 y 10 a 19 años.
  #prestaciones = Prestacion.find([402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417])
  #prestaciones.each do |prestacion|
  #  prestacion.grupos_poblacionales << de_6_a_9
  #  prestacion.grupos_poblacionales << adolescentes
  #end




# Revisión general de prestaciones surgidas de la evaluación a partir de la incorporación de los modelos PDSS


# Logoaudiometría (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(:codigo => "PRP020").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find([1, 2])
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Monotest (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(:codigo => "LBL078").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Reacción de Widal (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(:codigo => "LBL096").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Receptores libres de transferrinas (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(:codigo => "LBL097").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Sangre oculta en heces (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(:codigo => "LBL098").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Cambio la descripción del código LBL112
Prestacion.where(:id => 342, :codigo => "LBL112").first.update_attributes({:nombre => "Enzimas hepáticas: Transaminasas TGO/TGP (embarazo de alto riesgo)"})

# Falta el método de validación de "beneficiaria_embarazada?" en la prestación "Ecografía renal"
Prestacion.find(350).metodos_de_validacion << [MetodoDeValidacion.find(1)]

# Falta el método de validación de "beneficiaria_embarazada?" en la prestación "Monitoreo fetal anteparto"
Prestacion.find(351).metodos_de_validacion << [MetodoDeValidacion.find(1)]

# Traslado en unidad móvil de alta complejidad para adultos (faltó definir los grupos poblacionales habilitados y diagnósticos)
prestacion = Prestacion.where(:codigo => "TLM020").first
prestacion.sexos << [Sexo.find_by_codigo!("F")]
prestacion.grupos_poblacionales << [GrupoPoblacional.find_by_codigo("D")]
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98") # Medicina preventiva








#  DUPLICAR PRACTICAS COMPLEMENTARIAS DE CCC PARA MÓDULOS CATASTRÓFICOS
#
#  Prestacion.find_by_codigo("XMX001").update_attributes({
#    :nombre => "Alprostadil (en módulos I, II, III y IV -no catastróficos-)",
#    :es_catastrofica => false
#  })
#
#  Prestacion.find_by_codigo("XMX002").update_attributes({
#    :nombre => "Óxido nítrico y dispenser para su administración (en módulos I, II, III y IV -no catastróficos-)",
#    :es_catastrofica => false
#  })
#
#  Prestacion.find_by_codigo("XMX003").update_attributes({
#    :nombre => "Levosimedan (en módulos I, II, III y IV -no catastróficos-)",
#    :es_catastrofica => false
#  })
#
#  Prestacion.find_by_codigo("XMX004").update_attributes({
#    :nombre => "Factor VII activado recombinante (en módulos I, II, III y IV -no catastróficos-)",
#    :es_catastrofica => false
#  })
#
#  Prestacion.find_by_codigo("XMX005").update_attributes({
#    :nombre => "Iloprost (en módulos I, II, III y IV -no catastróficos-)",
#    :es_catastrofica => false
#  })
#
#  Prestacion.find_by_codigo("XMX006").update_attributes({
#    :nombre => "Trometanol (en módulos I, II, III y IV -no catastróficos-)",
#    :es_catastrofica => false
#  })
#
#  Prestacion.find_by_codigo("XMX007").update_attributes({
#    :nombre => "Surfactante (en módulos I, II, III y IV -no catastróficos-)",
#    :es_catastrofica => false
#  })
#
#  Prestacion.find_by_codigo("XMX008").update_attributes({
#    :nombre => "Nutrición parenteral total (en módulos I, II, III y IV -no catastróficos-)",
#    :es_catastrofica => false
#  })
#
#  Prestacion.find_by_codigo("XMX009").update_attributes({
#    :nombre => "Prótesis y órtesis (en módulos I, II, III y IV -no catastróficos-)",
#    :es_catastrofica => false
#  })
#
#  prestacion = Prestacion.create!({
#    :codigo => "XMX001",
#    :objeto_de_la_prestacion_id => (
#      ObjetoDeLaPrestacion.where(:codigo => 'X001', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    :nombre => 'Alprostadil (en módulos V, VI y VII -catastróficos-)',
#    :es_catastrofica => true,
#    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :minimo => 0.0100,
#    :necesario => true,
#    :obligatorio => true
#  })
#  AsignacionDePrecios.create!({
#    :precio_por_unidad => 1.0000,
#    :adicional_por_prestacion => 0.0000,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#  })
#
#  prestacion = Prestacion.create!({
#    :codigo => "XMX002",
#    :objeto_de_la_prestacion_id => (
#      ObjetoDeLaPrestacion.where(:codigo => 'X002', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    :nombre => 'Óxido nítrico y dispenser para su administración (en módulos V, VI y VII -catastróficos-)',
#    :es_catastrofica => true,
#    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :minimo => 0.0100,
#    :necesario => true,
#    :obligatorio => true
#  })
#  AsignacionDePrecios.create!({
#    :precio_por_unidad => 1.0000,
#    :adicional_por_prestacion => 0.0000,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#  })
#
#  prestacion = Prestacion.create!({
#    :codigo => "XMX003",
#    :objeto_de_la_prestacion_id => (
#      ObjetoDeLaPrestacion.where(:codigo => 'X003', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    :nombre => 'Levosimedan (en módulos V, VI y VII -catastróficos-)',
#    :es_catastrofica => true,
#    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :minimo => 0.0100,
#    :necesario => true,
#    :obligatorio => true
#  })
#  AsignacionDePrecios.create!({
#    :precio_por_unidad => 1.0000,
#    :adicional_por_prestacion => 0.0000,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#  })
#
#  prestacion = Prestacion.create!({
#    :codigo => "XMX004",
#    :objeto_de_la_prestacion_id => (
#      ObjetoDeLaPrestacion.where(:codigo => 'X004', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    :nombre => 'Factor VII activado recombinante (en módulos V, VI y VII -catastróficos-)',
#    :es_catastrofica => true,
#    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :minimo => 0.0100,
#    :necesario => true,
#    :obligatorio => true
#  })
#  AsignacionDePrecios.create!({
#    :precio_por_unidad => 1.0000,
#    :adicional_por_prestacion => 0.0000,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#  })
#
#  prestacion = Prestacion.create!({
#    :codigo => "XMX005",
#    :objeto_de_la_prestacion_id => (
#      ObjetoDeLaPrestacion.where(:codigo => 'X005', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    :nombre => 'Iloprost (en módulos V, VI y VII -catastróficos-)',
#    :es_catastrofica => true,
#    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :minimo => 0.0100,
#    :necesario => true,
#    :obligatorio => true
#  })
#  AsignacionDePrecios.create!({
#    :precio_por_unidad => 1.0000,
#    :adicional_por_prestacion => 0.0000,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#  })
#
#  prestacion = Prestacion.create!({
#    :codigo => "XMX006",
#    :objeto_de_la_prestacion_id => (
#      ObjetoDeLaPrestacion.where(:codigo => 'X006', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    :nombre => 'Trometanol (en módulos V, VI y VII -catastróficos-)',
#    :es_catastrofica => true,
#    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :minimo => 0.0100,
#    :necesario => true,
#    :obligatorio => true
#  })
#  AsignacionDePrecios.create!({
#    :precio_por_unidad => 1.0000,
#    :adicional_por_prestacion => 0.0000,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#  })
#
#  prestacion = Prestacion.create!({
#    :codigo => "XMX007",
#    :objeto_de_la_prestacion_id => (
#      ObjetoDeLaPrestacion.where(:codigo => 'X007', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    :nombre => 'Surfactante (en módulos V, VI y VII -catastróficos-)',
#    :es_catastrofica => true,
#    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :minimo => 0.0100,
#    :necesario => true,
#    :obligatorio => true
#  })
#  AsignacionDePrecios.create!({
#    :precio_por_unidad => 1.0000,
#    :adicional_por_prestacion => 0.0000,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#  })
#
#  prestacion = Prestacion.create!({
#    :codigo => "XMX008",
#    :objeto_de_la_prestacion_id => (
#      ObjetoDeLaPrestacion.where(:codigo => 'X008', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    :nombre => 'Nutrición parenteral total (en módulos V, VI y VII -catastróficos-)',
#    :es_catastrofica => true,
#    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :minimo => 0.0100,
#    :necesario => true,
#    :obligatorio => true
#  })
#  AsignacionDePrecios.create!({
#    :precio_por_unidad => 1.0000,
#    :adicional_por_prestacion => 0.0000,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#  })
#
#  prestacion = Prestacion.create!({
#    :codigo => "XMX009",
#    :objeto_de_la_prestacion_id => (
#      ObjetoDeLaPrestacion.where(:codigo => 'X009', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
#    ),
#    :nombre => 'Prótesis y órtesis (en módulos V, VI y VII -catastróficos-)',
#    :es_catastrofica => true,
#    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
#  })
#  prestacion.sexos << [sexo_femenino, sexo_masculino]
#  prestacion.grupos_poblacionales << [menores_de_6]
#  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :minimo => 0.0100,
#    :necesario => true,
#    :obligatorio => true
#  })
#  AsignacionDePrecios.create!({
#    :precio_por_unidad => 1.0000,
#    :adicional_por_prestacion => 0.0000,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
#    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#  })
#
#  prestacion = Prestacion.where(
#    "codigo = 'APA001' AND EXISTS (
#       SELECT * FROM diagnosticos_prestaciones JOIN diagnosticos ON (diagnosticos.id = diagnosticos_prestaciones.diagnostico_id)
#         WHERE diagnosticos_prestaciones.prestacion_id = prestaciones.id AND diagnosticos.codigo = 'W78'
#     )").first
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("DIAGAP"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :obligatorio => false
#  })
#  DatoReportableRequerido.create!({
#    :prestacion_id => prestacion.id,
#    :dato_reportable_id => DatoReportable.id_del_codigo!("SITAM"),
#    :fecha_de_inicio => fecha_de_inicio,
#    :obligatorio => true
#  })
#  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_mayor_de_24_anios?")

end
