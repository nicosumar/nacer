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
  prestacion.diagnosticos << Diagnostico.find_by_codigo("D62")
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
    :codigo => "LBL047",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L047"),
    :nombre => 'Laboratorio de prueba de embarazo - Gonadotrofina coriónica humana en sangre',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create({
    :codigo => "LBL048",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L048"),
    :nombre => 'Laboratorio de prueba de embarazo - Gonadotrofina coriónica humana en orina',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create({
    :codigo => "LBL050",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L050"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Grupo y factor',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL055",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L055"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Hemoglobina',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL045",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L045"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Glucemia',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL079",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L079"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Orina completa',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL119",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L119"),
    :nombre => 'Laboratorio de control prenatal de primera vez - VDRL',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL065",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L065"),
    :nombre => 'Laboratorio de control prenatal de primera vez - IFI y hemoaglutinación directa para Chagas',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL080",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L080"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Parasitemia para Chagas',
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
    :codigo => "LBL099",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L099"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Serología para Chagas (ELISA)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL128",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L128"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Hemoaglutinación indirecta para Chagas',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL121",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L121"),
    :nombre => 'Laboratorio de control prenatal de primera vez - VIH ELISA',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL122",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L122"),
    :nombre => 'Laboratorio de control prenatal de primera vez - VIH Western Blot',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL110",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L110"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Toxoplasmosis por IFI',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL111",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L111"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Toxoplasmosis por MEIA',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL051",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L051"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Hbs antígeno',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL055",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L055"),
    :nombre => 'Laboratorio ulterior de control prenatal - Hemoglobina',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL045",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L045"),
    :nombre => 'Laboratorio ulterior de control prenatal - Glucemia',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL079",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L079"),
    :nombre => 'Laboratorio ulterior de control prenatal - Orina completa',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL119",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L119"),
    :nombre => 'Laboratorio ulterior de control prenatal - VDRL',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL121",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L121"),
    :nombre => 'Laboratorio ulterior de control prenatal - VIH ELISA',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL122",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L122"),
    :nombre => 'Laboratorio ulterior control prenatal - VIH Western Blot',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 18.7500,
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

  prestacion = Prestacion.create({
    :codigo => "AUH001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("H001"),
    :nombre => 'Informe del comité de auditoría de muerte materna, recibido y aprobado por el Ministerio de Salud de la provincia, según ordenamiento',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A51")
  AsignacionDePrecios.create({
    :precio_por_unidad => 250.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C005"),
    :nombre => 'Atención y tratamiento ambulatorio de anemia leve del embarazo (primera vez)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("B80")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C006"),
    :nombre => 'Atención y tratamiento ambulatorio de anemia leve del embarazo (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("B80")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C007"),
    :nombre => 'Atención y tratamiento ambulatorio de anemia grave del embarazo (no incluye hemoderivados)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("B80")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C007"),
    :nombre => 'Tratamiento de la hemorragia del primer trimestre',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W06")
  AsignacionDePrecios.create({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "ITE004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("E004"),
    :nombre => 'Tratamiento de la hemorragia del primer trimestre (clínica obstétrica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W06")
  AsignacionDePrecios.create({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "ITQ005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("Q005"),
    :nombre => 'Tratamiento de la hemorragia del primer trimestre (quirúrgica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W06")
  AsignacionDePrecios.create({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "ITE005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("E005"),
    :nombre => 'Tratamiento de la hemorragia del segundo trimestre (clínica obstétrica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W07")
  AsignacionDePrecios.create({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "ITQ006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("Q006"),
    :nombre => 'Tratamiento de la hemorragia del segundo trimestre (quirúrgica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W07")
  AsignacionDePrecios.create({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "ITE006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("E006"),
    :nombre => 'Tratamiento de la hemorragia del tercer trimestre (clínica obstétrica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W08")
  AsignacionDePrecios.create({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "ITQ007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("Q007"),
    :nombre => 'Tratamiento de la hemorragia del segundo trimestre (quirúrgica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W08")
  AsignacionDePrecios.create({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C005"),
    :nombre => 'Atención y tratamiento ambulatorio de infección urinaria en el embarazo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("U71")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C007"),
    :nombre => 'Atención y tratamiento ambulatorio de sífilis e ITS en el embarazo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("X70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("X71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("X90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("X91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("X92")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C007"),
    :nombre => 'Atención y tratamiento ambulatorio de VIH en el embarazo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("B90")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "APA001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("A001"),
    :nombre => 'Lectura de muestra tomada en mujeres embarazadas, en laboratorio de Anatomía patológica/Citología, firmado por anátomo-patólogo matriculado (CA cérvico-uterino)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "ITQ001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("Q001"),
    :nombre => 'Atención de parto y recién nacido',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W91")
  AsignacionDePrecios.create({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "ITQ002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("Q002"),
    :nombre => 'Cesárea y atención de recién nacido',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W88")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W89")
  AsignacionDePrecios.create({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C018"),
    :nombre => 'Tratamiento ambulatorio de complicaciones del parto en el puerperio inmediato (primera vez)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W17")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W94")
  AsignacionDePrecios.create({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC019",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C019"),
    :nombre => 'Tratamiento ambulatorio de complicaciones del parto en el puerperio inmediato (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W17")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W94")
  AsignacionDePrecios.create({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  # OJO: Se han añadido los códigos de diagnóstico W78 y W84, pero probablemente deban añadirse más
  prestacion = Prestacion.create({
    :codigo => "PRP004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("P004"),
    :nombre => 'Electrocardiograma en el embarazo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78") # Embarazo
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W84") # Embarazo de alto riesgo
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "TLM081",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("M081"),
    :nombre => 'Transporte por referencia de embarazadas de zona A (hasta 50 km)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W84")
  AsignacionDePrecios.create({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "TLM082",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("M082"),
    :nombre => 'Transporte por referencia de embarazadas de zona B (más de 50 km)',
    :unidad_de_medida_id => UnidadDeMedida.find_by_codigo("K"), # Kilómetros excedentes (de 50 km)
    :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W84")
  AsignacionDePrecios.create({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 150.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 500, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "IGR031",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("R031"),
    :nombre => 'Ecografía obstétrica en control prenatal',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "IGR022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("R022"),
    :nombre => 'Rx de cráneo (frente y perfil) en embarazadas',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("W78")
  AsignacionDePrecios.create({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "NTN004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("N004"),
    :nombre => 'Consulta de notificación de factores de riesgo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("Z35.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("Z35.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("Z35.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("Z35.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("Z35.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("Z35.5")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("Z35.6")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("Z35.7")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("Z35.8")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("Z35.9")
  AsignacionDePrecios.create({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "NTN006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("N006"),
    :nombre => 'Consulta de referencia por embarazo de alto riesgo de nivel 2 o 3 a niveles de complejidad superior',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O14")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O15")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O24.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("P05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O47")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O72.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O72.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O98.4")
  AsignacionDePrecios.create({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C007"),
    :nombre => 'Consulta inicial de la embarazada con hipertensión crónica',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  AsignacionDePrecios.create({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C022"),
    :nombre => 'Consulta de seguimiento de la embarazada con hipertensión crónica',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  AsignacionDePrecios.create({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C007"),
    :nombre => 'Consulta inicial de la embarazada con hipertensión gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C022"),
    :nombre => 'Consulta de seguimiento de la embarazada con hipertensión gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C011"),
    :nombre => 'Consulta con oftalmología de embarazadas con hipertensión crónica',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C016"),
    :nombre => 'Consulta con cardiología de embarazadas con hipertensión crónica o gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "CTC016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("C016"),
    :nombre => 'Consulta con nefrología de embarazadas con hipertensión crónica',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  AsignacionDePrecios.create({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "PRP030",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("P030"),
    :nombre => 'Proteinuria rápida con tira reactiva',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "PRP030",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("P030"),
    :nombre => 'Proteinuria rápida con tira reactiva',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL057",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L057"),
    :nombre => 'Hemograma completo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL069",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L069"),
    :nombre => 'Coagulograma con fibrinógeno: KPTT',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL131",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L131"),
    :nombre => 'Coagulograma con fibrinógeno: Tiempo de protrombina',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL132",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L132"),
    :nombre => 'Coagulograma con fibrinógeno: Tiempo de trombina',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL023",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L023"),
    :nombre => 'Coagulograma con fibrinógeno: Cuantificación de fibrinógeno',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL045",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L045"),
    :nombre => 'Glucemia',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L002"),
    :nombre => 'Ácido úrico',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L022"),
    :nombre => 'Creatinina sérica',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL021",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L021"),
    :nombre => 'Creatinina en orina',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL090",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L090"),
    :nombre => 'Proteinuria',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL112",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L112"),
    :nombre => 'Enzimas hepáticas: Transaminasas TGO/TGP',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL040",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L040"),
    :nombre => 'Enzimas hepáticas: Fosfatasa alcalina y ácida',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL044",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L044"),
    :nombre => 'Enzimas hepáticas: Gamma-GT (Gamma glutamil transpeptidasa)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L012"),
    :nombre => 'Bilirrubinas totales y fraccionadas',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL052",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L052"),
    :nombre => 'HDL y LDL',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "LBL079",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("L079"),
    :nombre => 'Orina completa',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "IGR031",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("R031"),
    :nombre => 'Ecografía obstétrica en embarazo de alto riesgo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "IGR037",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("R037"),
    :nombre => 'Eco-Doppler fetal',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create({
    :codigo => "IGR038",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("R038"),
    :nombre => 'Ecografía renal',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo("O16")
  AsignacionDePrecios.create({
    :precio_por_unidad => 25.0000,
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


  # ANEXO: PRACTICAS


  # ANEXO: TALLERES

  # OJO: Se ha colocado aparte como comunitaria aunque en el PDSS figura sólo en los grupos poblacionales de embarazo y niños menores de 6 años
  prestacion = Prestacion.create({
    :codigo => "TAT003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("T003"),
    :nombre => 'Encuentros para promoción del desarrollo infantil, prevención de patologías prevalentes en la infancia, conductas saludables, hábitos de higiene',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })

  # OJO: Se ha colocado aparte como comunitaria aunque en el PDSS figura sólo en los grupos poblacionales de embarazo y niños menores de 6 años
  prestacion = Prestacion.create({
    :codigo => "TAT002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("T002"),
    :nombre => 'Encuentros para promoción de pautas alimentarias en embarazadas, puérperas y niños menores de 6 años',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :unidades_maximas => 1, :created_at => ahora, :updated_at => ahora
  })

  # OJO: Se ha colocado aparte como comunitaria aunque en el PDSS figura sólo en los grupos poblacionales de embarazo y niños menores de 6 años
  prestacion = Prestacion.create({
    :codigo => "TAT001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo("T001"),
    :nombre => 'Encuentros para promoción de salud sexual y reproductiva, conductas saludables, hábitos de higiene',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo("A98")
  AsignacionDePrecios.create({
    :precio_por_unidad => 50.0000,
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
