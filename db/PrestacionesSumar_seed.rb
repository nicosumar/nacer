# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
ActiveRecord::Base.transaction do
  # Precargamos ciertos datos útiles para no ejecutar tantas consultas a la base
  um_unitaria = UnidadDeMedida.find_by_codigo("U")
  sexo_femenino = Sexo.find_by_codigo("F")
  sexo_masculino = Sexo.find_by_codigo("M")
  menores_de_6 = GrupoPoblacional.find_by_codigo("A")
  de_6_a_9 = GrupoPoblacional.find_by_codigo("B")
  adolescentes = GrupoPoblacional.find_by_codigo("C")
  mujeres_20_a_64 = GrupoPoblacional.find_by_codigo("D")

  # Determinar la hora y fecha actual
  ahora = DateTime.now()

  # Creación del nuevo nomenclador
  nomenclador_sumar = Nomenclador.create({
    :nombre => "Plan de servicios de salud 2013",
    :fecha_de_inicio => Date.new(2012, 8, 1),
    :activo => true,
    :created_at => ahora,
    :updated_at => ahora
  })

  # Creación de prestaciones

  # EMBARAZO / PARTO / PUERPERIO

  prestacion = Prestacion.create({
    :codigo => "CTC005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C005"),
    :nombre => "Control prenatal de primera vez",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C006"),
    :nombre => "Consulta ulterior de control prenatal",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C010"),
    :nombre => "Consulta odontológica prenatal - Profilaxis",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C010"),
    :nombre => "Control odontológico en el tratamiento de la gingivitis y enfermedad periodontal leve",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("D61")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  # OJO: con observaciones
  prestacion = Prestacion.create({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C007"),
    :nombre => "Control prenatal de embarazo de alto riesgo de primera vez",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W84")
  AsignacionDePrecios.create({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C001"),
    :nombre => "Consulta de puerperio inmediato",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W86")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "IMV010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("V010"),
    :nombre => "Inmunización doble para adultos en el embarazo",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 4.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "IMV013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("V013"),
    :nombre => "Dosis aplicada de vacuna antigripal en el embarazo o puerperio",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "IMV011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("V011"),
    :nombre => "Inmunización puerperal doble viral (rubéola)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "PRP018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("P018"),
    :nombre => "Toma de muestra para PAP (incluye material descartable)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 7.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "PRP002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("P002"),
    :nombre => "Colposcopía en control de embarazo (incluye material descartable)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "PRP033",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("P033"),
    :nombre => "Tartrectomía y cepillado mecánico en el embarazo",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "PRP026",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("P033"),
    :nombre => "Inactivación de caries en el embarazo",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "COT017",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("T017"),
    :nombre => 'Consejería puerperal en salud sexual y reproductiva, lactancia materna y puericultura (prevención de muerte súbita y signos de alarma)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W86")
  AsignacionDePrecios.create({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "COT019",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("T019"),
    :nombre => 'Carta de derechos de la mujer embarazada indígena',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "COT021",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("T021"),
    :nombre => 'Educación para la salud en el embarazo (bio-psico-social)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CAW001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("W001"),
    :nombre => 'Búsqueda activa de embarazadas en el primer trimestre por agente sanitario y/o personal de salud',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("diagnostico_de_embarazo_del_primer_trimestre?")

  prestacion = Prestacion.create({
    :codigo => "CAW002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("W002"),
    :nombre => 'Búsqueda activa de embarazadas con abandono de controles, por agente sanitario y/o personal de salud',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")


  # ANEXO: RONDAS

  # OJO: se repite el código de objeto "X001", se ha colocado aparte, aunque en el PDSS figura repetida para cada grupo poblacional, además es comunitaria
  prestacion = Prestacion.create({
    :codigo => "ROX001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.where(:codigo => 'X001', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('RO')).first.id,
    :nombre => 'Ronda sanitaria completa orientada a la detección de población de riesgo en área rural',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })

  # OJO: se repite el código de objeto "X002", se ha colocado aparte, aunque en el PDSS figura repetida para cada grupo poblacional, además es comunitaria
  prestacion = Prestacion.create({
    :codigo => "ROX002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.where(:codigo => 'X002', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('RO')).first.id,
    :nombre => 'Ronda sanitaria completa orientada a la detección de población de riesgo en población indígena',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })


  # ANEXO: DIAGNÓSTICO SOCIOEPIDEMIOLÓGICO

  # OJO: Se ha colocado aparte como comunitaria aunque en el PDSS figura sólo en los grupos poblacionales de embarazo y niños menores de 6 años
  prestacion = Prestacion.create({
    :codigo => "DSY001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("Y001"),
    :nombre => 'Diagnóstico socioepidemiológico de población en riesgo por efector (informe final de ronda entregado y aprobado)',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })


  # LABORATORIO
  # RECORDAR TENER CUIDADO CON LOS LABORATORIOS DE EMBARAZO
end
