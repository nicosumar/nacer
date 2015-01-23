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

  # Fecha de inicio del nomenclador
  fecha_de_inicio = Date.new(2012, 8, 1)

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
