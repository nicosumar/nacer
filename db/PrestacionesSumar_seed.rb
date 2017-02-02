# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
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

  # Creación del nuevo nomenclador
  nomenclador_sumar = Nomenclador.create!({
    :nombre => "PDSS Sumar Agosto de 2012",
    :fecha_de_inicio => fecha_de_inicio,
    :activo => true,
    :created_at => ahora,
    :updated_at => ahora
  })

  # Creación de prestaciones

  # EMBARAZO / PARTO / PUERPERIO

  prestacion = Prestacion.create!({
    :codigo => "CTC005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C005"),
    :nombre => "Control prenatal de primera vez",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 20.00,
    :maximo => 300.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.8000,
    :maximo => 2.5000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("EG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 1.0000,
    :maximo => 46.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("tension_arterial_valida?")

  prestacion = Prestacion.create!({
    :codigo => "CTC006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C006"),
    :nombre => "Consulta ulterior de control prenatal",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 20.00,
    :maximo => 300.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("EG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 1.0000,
    :maximo => 46.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("tension_arterial_valida?")

  prestacion = Prestacion.create!({
    :codigo => "CTC010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C010"),
    :nombre => "Consulta odontológica prenatal - Profilaxis",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CPOD_C"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CPOD_P"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CPOD_O"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C010"),
    :nombre => "Control odontológico en el tratamiento de la gingivitis y enfermedad periodontal leve en el embarazo",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D61")
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("D62") # TODO: Determinar si es necesario agregar este código
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("indice_cpod_valido?")

  # OJO: con observaciones
  prestacion = Prestacion.create!({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C007"),
    :nombre => "Control prenatal de embarazo de alto riesgo de primera vez",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W84")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 20.00,
    :maximo => 300.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.8000,
    :maximo => 2.5000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("EG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 1.0000,
    :maximo => 46.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("tension_arterial_valida?")

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Consulta de puerperio inmediato",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W86")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("FP"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "IMV010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V010"),
    :nombre => "Inmunización doble para adultos en el embarazo",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 4.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "IMV013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V013"),
    :nombre => "Dosis aplicada de vacuna antigripal en el embarazo o puerperio",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 4.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "IMV011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V011"),
    :nombre => "Inmunización puerperal doble viral (rubéola)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 4.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "PRP018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P018"),
    :nombre => "Toma de muestra para PAP (incluye material descartable)",
    :otorga_cobertura => true,
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 7.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "PRP002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P002"),
    :nombre => "Colposcopía en control de embarazo (incluye material descartable)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "PRP033",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P033"),
    :nombre => "Tartrectomía y cepillado mecánico en el embarazo",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "PRP026",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P026"),
    :nombre => "Inactivación de caries en el embarazo",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL047",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L047"),
    :nombre => 'Laboratorio de prueba de embarazo - Gonadotrofina coriónica humana en sangre',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "LBL048",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L048"),
    :nombre => 'Laboratorio de prueba de embarazo - Gonadotrofina coriónica humana en orina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "LBL050",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L050"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Grupo y factor',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL055",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L055"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Hemoglobina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL045",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L045"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Glucemia',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL079",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L079"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Orina completa',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL119",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L119"),
    :nombre => 'Laboratorio de control prenatal de primera vez - VDRL',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL065",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L065"),
    :nombre => 'Laboratorio de control prenatal de primera vez - IFI y hemoaglutinación directa para Chagas',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL080",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L080"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Parasitemia para Chagas',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL099",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L099"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Serología para Chagas (ELISA)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL128",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L128"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Hemoaglutinación indirecta para Chagas',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL121",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L121"),
    :nombre => 'Laboratorio de control prenatal de primera vez - VIH ELISA',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL122",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L122"),
    :nombre => 'Laboratorio de control prenatal de primera vez - VIH Western Blot',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL110",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L110"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Toxoplasmosis por IFI',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL111",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L111"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Toxoplasmosis por MEIA',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL051",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L051"),
    :nombre => 'Laboratorio de control prenatal de primera vez - Hbs antígeno',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL055",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L055"),
    :nombre => 'Laboratorio ulterior de control prenatal - Hemoglobina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL045",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L045"),
    :nombre => 'Laboratorio ulterior de control prenatal - Glucemia',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL079",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L079"),
    :nombre => 'Laboratorio ulterior de control prenatal - Orina completa',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL119",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L119"),
    :nombre => 'Laboratorio ulterior de control prenatal - VDRL',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL121",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L121"),
    :nombre => 'Laboratorio ulterior de control prenatal - VIH ELISA',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL122",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L122"),
    :nombre => 'Laboratorio ulterior control prenatal - VIH Western Blot',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "COT017",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T017"),
    :nombre => 'Consejería puerperal en salud sexual y reproductiva, lactancia materna y puericultura (prevención de muerte súbita y signos de alarma)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W86")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "COT019",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T019"),
    :nombre => 'Carta de derechos de la mujer embarazada indígena',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "COT021",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T021"),
    :nombre => 'Educación para la salud en el embarazo (bio-psico-social)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CAW001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("W001"),
    :nombre => 'Búsqueda activa de embarazadas en el primer trimestre por agente sanitario y/o personal de salud',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 200.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("diagnostico_de_embarazo_del_primer_trimestre?")

  prestacion = Prestacion.create!({
    :codigo => "CAW002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("W002"),
    :nombre => 'Búsqueda activa de embarazadas con abandono de controles, por agente sanitario y/o personal de salud',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 200.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "AUH001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("H001"),
    :nombre => 'Informe del comité de auditoría de muerte materna, recibido y aprobado por el Ministerio de Salud de la provincia, según ordenamiento',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A51")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 250.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C005"),
    :nombre => 'Atención y tratamiento ambulatorio de anemia leve del embarazo (primera vez)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("HB"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 2.0000,
    :maximo => 20.0000,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C006"),
    :nombre => 'Atención y tratamiento ambulatorio de anemia leve del embarazo (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("HB"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 2.0000,
    :maximo => 20.0000,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C007"),
    :nombre => 'Atención y tratamiento ambulatorio de anemia grave del embarazo (no incluye hemoderivados)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("HB"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 2.0000,
    :maximo => 20.0000,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C007"),
    :nombre => 'Tratamiento de la hemorragia del primer trimestre',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W06")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITE004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E004"),
    :nombre => 'Tratamiento de la hemorragia del primer trimestre (clínica obstétrica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W06")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q005"),
    :nombre => 'Tratamiento de la hemorragia del primer trimestre (quirúrgica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W06")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DIAG"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("AMEU"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITE005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E005"),
    :nombre => 'Tratamiento de la hemorragia del segundo trimestre (clínica obstétrica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W07")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q006"),
    :nombre => 'Tratamiento de la hemorragia del segundo trimestre (quirúrgica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W07")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITE006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E006"),
    :nombre => 'Tratamiento de la hemorragia del tercer trimestre (clínica obstétrica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W08")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q007"),
    :nombre => 'Tratamiento de la hemorragia del tercer trimestre (quirúrgica)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W08")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C005"),
    :nombre => 'Atención y tratamiento ambulatorio de infección urinaria en el embarazo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C007"),
    :nombre => 'Atención y tratamiento ambulatorio de sífilis e ITS en el embarazo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X92")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C007"),
    :nombre => 'Atención y tratamiento ambulatorio de VIH en el embarazo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "APA001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("A001"),
    :nombre => 'Lectura de muestra tomada en mujeres embarazadas, en laboratorio de Anatomía patológica/Citología, firmado por anátomo-patólogo matriculado (CA cérvico-uterino)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q001"),
    :nombre => 'Atención de parto y recién nacido',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W91")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 400.0000,
    :maximo => 9999.0000,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q002"),
    :nombre => 'Cesárea y atención de recién nacido',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W88")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W89")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 400.0000,
    :maximo => 9999.0000,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C018"),
    :nombre => 'Tratamiento ambulatorio de complicaciones del parto en el puerperio inmediato (primera vez)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W17")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W94")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC019",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C019"),
    :nombre => 'Tratamiento ambulatorio de complicaciones del parto en el puerperio inmediato (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W17")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W94")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  # OJO: Se han añadido los códigos de diagnóstico W78 y W84, pero probablemente deban añadirse más
  prestacion = Prestacion.create!({
    :codigo => "PRP004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P004"),
    :nombre => 'Electrocardiograma en embarazo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78") # Embarazo
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W84") # Embarazo de alto riesgo
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4") # Embarazo con diabetes gestacional
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P05") # Amenaza de parto prematuro
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "TLM081",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("M081"),
    :nombre => 'Transporte por referencia de embarazadas de zona A (hasta 50 km)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W84")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 300.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "TLM082",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("M082"),
    :nombre => 'Transporte por referencia de embarazadas de zona B (más de 50 km)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => UnidadDeMedida.find_by_codigo!("K").id, # Kilómetros excedentes (de 50 km)
    :unidades_maximas => 500.0000,
    :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W84")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 150.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.0000,
    :adicional_por_prestacion => 300.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "IGR031",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R031"),
    :nombre => 'Ecografía en control prenatal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "IGR022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R022"),
    :nombre => 'Rx de cráneo (frente y perfil) en embarazadas',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  # EMBARAZO DE ALTO RIESGO: Ambulatorio

  prestacion = Prestacion.create!({
    :codigo => "NTN004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("N004"),
    :nombre => 'Notificación de factores de riesgo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z35.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z35.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z35.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z35.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z35.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z35.5")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z35.6")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z35.7")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z35.8")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z35.9")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "NTN006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("N006"),
    :nombre => 'Referencia por embarazo de alto riesgo de nivel 2 o 3 a niveles de complejidad superior',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O14")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O15")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O47")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O98.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C007"),
    :nombre => 'Consulta inicial de la embarazada con hipertensión crónica',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C022"),
    :nombre => 'Consulta de seguimiento de la embarazada con hipertensión crónica',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C007"),
    :nombre => 'Consulta inicial de la embarazada con hipertensión gestacional',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C022"),
    :nombre => 'Consulta de seguimiento de la embarazada con hipertensión gestacional',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C011"),
    :nombre => 'Consulta con oftalmología de embarazadas con hipertensión crónica',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C016"),
    :nombre => 'Consulta con cardiología de embarazadas con hipertensión crónica o gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C016"),
    :nombre => 'Consulta con nefrología de embarazadas con hipertensión crónica',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "PRP030",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P030"),
    :nombre => 'Proteinuria rápida con tira reactiva',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL057",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L057"),
    :nombre => 'Hemograma completo',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4") # Añadido de la nosología de diabetes gestacional
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.1") # Añadido de la nosología de hemorragia posparto
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.2") # Añadido de la nosología de hemorragia posparto
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL069",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L069"),
    :nombre => 'Coagulograma con fibrinógeno: KPTT',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL131",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L131"),
    :nombre => 'Coagulograma con fibrinógeno: Tiempo de protrombina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL132",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L132"),
    :nombre => 'Coagulograma con fibrinógeno: Tiempo de trombina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL023",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L023"),
    :nombre => 'Coagulograma con fibrinógeno: Cuantificación de fibrinógeno',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4") ## ¿Quizás?
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL045",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L045"),
    :nombre => 'Glucemia',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L002"),
    :nombre => 'Ácido úrico', # En la parte de HTA figura como 'Uricemia'
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L022"),
    :nombre => 'Creatinina sérica',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL021",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L021"),
    :nombre => 'Creatinina en orina', # En la parte de HTA figura como 'Creatinina urinaria (24 hs)
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL090",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L090"),
    :nombre => 'Proteinuria',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL112",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L112"),
    :nombre => 'Enzimas hepáticas: Transaminasas TGO/TGP',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL040",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L040"),
    :nombre => 'Enzimas hepáticas: Fosfatasa alcalina y ácida',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL044",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L044"),
    :nombre => 'Enzimas hepáticas: Gamma-GT (Gamma glutamil transpeptidasa)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L012"),
    :nombre => 'Bilirrubinas totales y fraccionadas',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL052",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L052"),
    :nombre => 'HDL y LDL',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL079",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L079"),
    :nombre => 'Orina completa',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "IGR031",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R031"),
    :nombre => 'Ecografía obstétrica',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P05")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "IGR037",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R037"),
    :nombre => 'Eco-Doppler fetal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "IGR038",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R038"),
    :nombre => 'Ecografía renal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP031",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P031"),
    :nombre => 'Monitoreo fetal anteparto',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P05")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C018"),
    :nombre => 'Consulta de seguimiento del puerperio de paciente con hipertensión',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C007"),
    :nombre => 'Consulta inicial de diabetes gestacional',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C022"),
    :nombre => 'Consulta de seguimiento de diabetes gestacional',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C011"),
    :nombre => 'Consulta con oftalmólogo de embarazadas con diabetes gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C016"),
    :nombre => 'Consulta con cardiólogo de embarazadas con diabetes gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C016"),
    :nombre => 'Consulta con endocrinólogo de embarazadas con diabetes gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C016"),
    :nombre => 'Consulta con nutricionista de embarazadas con diabetes gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  # Hemograma completo se añade como otro diagnóstico al ya creado para las pacientes con HTA
  # KPTT se añade como otro diagnóstico al ya creado para las pacientes con HTA
  # Tiempo de protrombina se añade como otro diagnóstico al ya creado para las pacientes con HTA
  # Tiempo de trombina se añade como otro diagnóstico al ya creado para las pacientes con HTA

  prestacion = Prestacion.create!({
    :codigo => "LBL056",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L056"),
    :nombre => 'Hemoglobina glicosilada',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL133",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L133"),
    :nombre => 'Fructosamina', # En el anexo figura 'Frotis de sangre periférica'
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL117",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L117"),
    :nombre => 'Urea',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  # Ácido úrico: lo añado en la prestación ya creada para HTA
  # Creatinina sérica: lo añado en la prestación ya creada para HTA
  # Creatinina en orina: lo añado en la prestación ya creada para HTA
  # Proteinuria: lo añado en la prestación ya creada para HTA

  prestacion = Prestacion.create!({
    :codigo => "LBL118",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L118"),
    :nombre => 'Urocultivo',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "LBL094",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L094"),
    :nombre => 'Prueba de tolerancia a la glucosa',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  # Proteinuria: lo añado en la prestación ya creada para HTA

  prestacion = Prestacion.create!({
    :codigo => "IGR039",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R039"),
    :nombre => 'Ecocardiograma fetal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  # Monitoreo fetal anteparto: lo añado en la prestación ya creada para HTA
  # Monitoreo fetal anteparto: lo añado en la prestación ya creada para HTA

  prestacion = Prestacion.create!({
    :codigo => "CTC018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C018"),
    :nombre => 'Consulta de seguimiento del puerperio de paciente con diabetes gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C018"),
    :nombre => 'Consulta del puerperio con nutricionista',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "CTC018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C018"),
    :nombre => 'Consulta de seguimiento del puerperio de paciente con hemorragia posparto',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.2")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "IGR008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R008"),
    :nombre => 'Ecografía ginecológica',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.2")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  # Hemograma: agrego los diagnósticos O72.1 y O72.2 en la prestación creada para HTA

  prestacion = Prestacion.create!({
    :codigo => "CTC017",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C017"),
    :nombre => 'Consulta de seguimiento post alta',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P05")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  # EMBARAZO DE ALTO RIESGO: Internación

  prestacion = Prestacion.create!({
    :codigo => "ITE007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E007"),
    :nombre => 'Emergencia hipertensiva: preeclampsia grave, eclampsia, sindrome de Hellp',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O14")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O15")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("UTI"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 1.0000,
    :maximo => 7.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 636.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("UTI"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITE008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E008"),
    :nombre => 'Amenaza de parto prematuro',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O47")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 1.0000,
    :maximo => 5.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q004"),
    :nombre => 'Hemorragia posparto con histerectomía',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.2")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("UTI"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 636.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("UTI"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q008"),
    :nombre => 'Hemorragia posparto sin histerectomía',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.2")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 1.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITE009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E009"),
    :nombre => 'Diabetes gestacional sin requerimiento de insulina',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 1.0000,
    :maximo => 7.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITE009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E009"),
    :nombre => 'Diabetes gestacional con requerimiento de insulina',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 1.0000,
    :maximo => 7.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")


  # EMBARAZO DE ALTO RIESGO: HOSPITAL DE DÍA

  prestacion = Prestacion.create!({
    :codigo => "ITE010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E010"),
    :nombre => 'Hospital de día: Diabetes gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 520.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITE011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E011"),
    :nombre => 'Hospital de día: Hipertensión en el embarazo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 820.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITE012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E012"),
    :nombre => 'Hospital de día: Restricción del crecimiento intrauterino - Pequeño para la edad gestacional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O98.4")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 740.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")


  # EMBARAZO DE ALTO RIESGO: TRASLADO

  prestacion = Prestacion.create!({
    :codigo => "TLM041",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("M041"),
    :nombre => 'Traslado de la gestante con patología del embarazo, APP o malformación fetal mayor a centro de referencia',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O14")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O15")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O47")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O72.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O98.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("O24.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 415.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")


  # 0 A 5 AÑOS: RECIÉN NACIDO (POSPARTO INMEDIATO)

  prestacion = Prestacion.create!({
    :codigo => "IMV012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V012"),
    :nombre => 'Inmunización del recién nacido: BCG antes del alta',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?")

  prestacion = Prestacion.create!({
    :codigo => "IMV009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V009"),
    :nombre => 'Inmunización del recién nacido: anti-hepatitis B',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?")

  prestacion = Prestacion.create!({
    :codigo => "AUH002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("H002"),
    :nombre => 'Informe del comité de auditoría de muerte infantil recibido y aprobado por el Ministerio de Salud de la provincia, según ordenamiento',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A50")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A96")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 250.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  #prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?") # TODO: Verificar si corresponde únicamente durante las prim 48 hs
  #prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?") # Debe ser menor de un año a la fecha de la defunción.

  prestacion = Prestacion.create!({
    :codigo => "PRP021",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P021"),
    :nombre => 'Otoemisiones acústicas para detección temprana de hipoacusia en recién nacidos',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ROD"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ROI"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?")

  prestacion = Prestacion.create!({
    :codigo => "ITE002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E002"),
    :nombre => 'Tratamiento inmediato de sífilis congénita en el recién nacido',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?")

  prestacion = Prestacion.create!({
    :codigo => "ITE002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E002"),
    :nombre => 'Tratamiento inmediato de transmisión vertical del VIH en el recién nacido',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?")

  prestacion = Prestacion.create!({
    :codigo => "ITE002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E002"),
    :nombre => 'Tratamiento inmediato de Chagas congénito en el recién nacido',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?")

  prestacion = Prestacion.create!({
    :codigo => "ITE002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E002"),
    :nombre => 'Atención de recién nacido con condición grave al nacer (tratamiento de pre-referencia)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.2")
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?")

  prestacion = Prestacion.create!({
    :codigo => "ITE013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E013"),
    :nombre => 'Prematurez - RNPT de 500 a 1499 g con requerimiento de ARM o CPAP',
    :es_catastrofica => true,
    :unidad_de_medida_id => UnidadDeMedida.id_del_codigo!("D"),
    :unidades_maximas => 30.0000,
    :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << menores_de_6
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.2")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2120.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ITE014",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E014"),
    :nombre => 'Prematurez - RNPT de 500 a 1499 g sin requerimiento de ARM o CPAP',
    :es_catastrofica => true,
    :unidad_de_medida_id => UnidadDeMedida.id_del_codigo!("D"),
    :unidades_maximas => 30.0000,
    :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << menores_de_6
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.2")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1940.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_embarazada?")

  prestacion = Prestacion.create!({
    :codigo => "ICI001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("I001"),
    :nombre => 'Incubadora hasta 48 horas en recién nacidos',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.2")
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 75.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?")

  prestacion = Prestacion.create!({
    :codigo => "PRP017",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P017"),
    :nombre => 'Pesquisa de retinopatía del prematuro: Oftalmoscopía binocular indirecta (OBI) a niñas y niños de riesgo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ROP"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 1.0000,
    :maximo => 5.0000,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?")

  prestacion = Prestacion.create!({
    :codigo => "ITE002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E002"),
    :nombre => 'Tratamiento inmediato de trastornos metabólicos (estado ácido base y electrolitos) en el recién nacido',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("recien_nacido?")


  # 0 A 5 AÑOS: RECIÉN NACIDO (MALFORMACIONES QUIRÚRGICAS)

  prestacion = Prestacion.create!({
    :codigo => "ITQ009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q009"),
    :nombre => 'Malformaciones quirúrgicas - Atresia esofágica - Cualquier tipo de atresia esofágica',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 1.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 5.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3065.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 7000.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3380.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1940.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q010"),
    :nombre => 'Malformaciones quirúrgicas - Gastrosquisis - Defecto del cierre de la pared abdominal, excluido el onfalocele',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 1.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 5.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3065.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 4000.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3370.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1940.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q011"),
    :nombre => 'Malformaciones quirúrgicas - Oclusión intestinal - Todos los cuadros de oclusión intestinal, excluida la aganglionosis intestinal',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 1.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 5.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3065.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 7000.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3360.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1940.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q012"),
    :nombre => 'Malformaciones quirúrgicas - Malformación anorrectal - Ano imperforado alto o bajo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 1.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1530.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6000.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3400.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 970.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q013"),
    :nombre => 'Malformaciones quirúrgicas - Mielomeningocele - Defecto del cierre de la columna vertebral en todas sus variantes',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 1.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 7.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1530.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 5200.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3150.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 970.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?")

  prestacion = Prestacion.create!({
    :codigo => "ITQ014",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Q014"),
    :nombre => 'Malformaciones quirúrgicas - Hidrocefalia - Hidrocefalia congénita',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 1.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 7.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1530.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6200.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3150.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 970.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQCI"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?")


  # 0 A 5 AÑOS: SEGUIMIENTO AMBULATORIO DE RN DE ALTO RIESGO

  prestacion = Prestacion.create!({
    :codigo => "CTC020",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C020"),
    :nombre => 'Ingreso al módulo de seguimiento ambulatorio de recién nacidos de alto riesgo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.2")
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 600.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?")

  prestacion = Prestacion.create!({
    :codigo => "CTC021",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C021"),
    :nombre => 'Egreso del módulo de seguimiento ambulatorio de recién nacidos de alto riesgo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.2")
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 400.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?")


  # 0 A 5 AÑOS: TRASLADO DE RN DE ALTO RIESGO

  prestacion = Prestacion.create!({
    :codigo => "TLM040",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("M040"),
    :nombre => 'Traslado de recién nacido prematuro de 500 a 1500 gramos o con malformación congénita quirúrgica',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q39.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q79.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q43.4")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.1")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.2")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q42.3")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q03")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Q05")
f  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.0")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P07.2")
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 570.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?")


  # 0 A 5 AÑOS: CARDIOPATÍAS CONGÉNITAS

  prestacion = Prestacion.create!({
    :codigo => "PRP005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P005"),
    :nombre => 'Ergometría',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP034",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P034"),
    :nombre => 'Holter de 24 horas',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP035",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P035"),
    :nombre => 'Presurometría',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 200.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IGR040",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R040"),
    :nombre => 'Hemodinamia diagnóstica',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3000.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IGR041",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R041"),
    :nombre => 'Resonancia magnética',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1000.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IGR030",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R030"),
    :nombre => 'Tomografía',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1500.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })


  # 0 A 5 AÑOS: CARDIOPATÍAS CONGÉNITAS - MÓDULOS QUIRÚRGICOS

  prestacion = Prestacion.create!({
    :codigo => "ITK001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K001"),
    :nombre => 'Cardiopatías congénitas - Módulo I - Cierre de ductus con cirugía convencional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("088")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 77.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2004.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  # TODO: *** AGREGAR METODOS DE VALIDACION DE DIAS TOTALES ***

  prestacion = Prestacion.create!({
    :codigo => "ITK002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K002"),
    :nombre => 'Cardiopatías congénitas - Módulo I - Cerclaje de la arteria pulmonar con cirugía convencional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("121")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("122")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("123")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("125")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("127")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("157")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 77.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2004.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K003"),
    :nombre => 'Cardiopatías congénitas - Módulo I - Anastomosis subclavio-pulmonar con cirugía convencional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("003")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("039")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("041")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("055")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("103")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("104")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("105")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("106")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("107")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("108")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("116")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("123")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("126")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("135")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("137")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("139")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("141")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("150")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 77.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2004.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K004"),
    :nombre => 'Cardiopatías congénitas - Módulo I - Corrección de coartación de la aorta con cirugía convencional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("035")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 77.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2004.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K005"),
    :nombre => 'Cardiopatías congénitas - Módulo I - Cierre de ductus con hemodinamia intervencionista',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("088")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("091")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 77.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2004.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K006"),
    :nombre => 'Cardiopatías congénitas - Módulo I - Corrección de coartación de la aorta con hemodinamia intervencionista',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("035")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 77.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2004.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K007"),
    :nombre => 'Cardiopatías congénitas - Módulo I - Cierre de CIA con hemodinamia intervencionista',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("022")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("023")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("024")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 77.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2004.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K008"),
    :nombre => 'Cardiopatías congénitas - Módulo I - Cierre de CIV con hemodinamia intervencionista',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("158")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("159")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("160")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("161")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 77.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2004.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K009"),
    :nombre => 'Cardiopatías congénitas - Módulo I - Colocación de Stent en ramas pulmonares con hemodinamia intervencionista',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("105")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 77.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2004.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K010"),
    :nombre => 'Cardiopatías congénitas - Módulo I - Embolización de colaterales de ramas pulmnonares con hemodinamia intervencionista',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("069")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("110")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 3.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 77.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2004.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K011"),
    :nombre => 'Cardiopatías congénitas - Módulo II - Cierre de ductus',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("088")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("091")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 123.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2049.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K012"),
    :nombre => 'Cardiopatías congénitas - Módulo II - Cerclaje de arteria pulmonar',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("015")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("127")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("121")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("122")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("123")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("125")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("157")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 123.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2049.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K013"),
    :nombre => 'Cardiopatías congénitas - Módulo II - Anastomosis subclavio-pulmonar',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("039")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("041")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("055")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("103")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("104")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("105")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("106")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("107")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("108")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("109")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("116")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("123")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("126")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("135")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("137")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("139")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("141")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("150")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 123.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2049.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK014",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K014"),
    :nombre => 'Cardiopatías congénitas - Módulo II - Corrección de coartación de la aorta',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("035")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6017.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 123.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2049.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK015",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K015"),
    :nombre => 'Cardiopatías congénitas - Módulo III - Cirugía de Glenn',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("116")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("127")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("121")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("122")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("123")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("125")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("157")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 12009.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 123.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2049.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K016"),
    :nombre => 'Cardiopatías congénitas - Módulo III - Cierre de canal intra-auricular con cirugía convencional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("015")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("021")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("022")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("023")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("024")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("026")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("029")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("087")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("095")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 12009.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 123.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2049.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK035",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K035"),
    :nombre => 'Cardiopatías congénitas - Módulo III - Cirugía correctora de anomalía parcial del retorno venoso pulmonar. Cimitarra',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("026")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("087")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 12009.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 123.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2049.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK036",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K036"),
    :nombre => 'Cardiopatías congénitas - Módulo III - Cirugía correctora de ventana aorto-pulmonar',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("026")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("087")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 12009.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 123.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2049.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK037",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K037"),
    :nombre => 'Cardiopatías congénitas - Módulo III - Cirugía correctora de canal aurículo-ventricular parcial',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("029")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 4.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 12009.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 123.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2049.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK017",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K017"),
    :nombre => 'Cardiopatías congénitas - Módulo IV - Cierre de canal intraventricular con cirugía convencional',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("158")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("159")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("160")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("161")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("162")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 10.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 14685.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 283.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2210.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K018"),
    :nombre => 'Cardiopatías congénitas - Módulo V - Corrección de canal aurículo-ventricular completo',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("027")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("028")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15936.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 335.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2262.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK019",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K019"),
    :nombre => 'Cardiopatías congénitas - Módulo V - Correctora de Fallot',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("139")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("140")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("141")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15936.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 335.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2262.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK020",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K020"),
    :nombre => 'Cardiopatías congénitas - Módulo V - Correctora de doble salida de ventrículo derecho',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("052")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("054")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("055")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("056")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15936.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 335.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2262.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK021",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K021"),
    :nombre => 'Cardiopatías congénitas - Módulo V - Cirugía de Fontan o by-pass total',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("121")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("122")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("123")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("124")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("125")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("126")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("127")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("151")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15936.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 335.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2262.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K022"),
    :nombre => 'Cardiopatías congénitas - Módulo V - Cierre de canal intra-ventricular y defecto asociado',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("157")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15936.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 335.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2262.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK023",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K023"),
    :nombre => 'Cardiopatías congénitas - Módulo V - Reemplazo o plástica valvular con prótesis u homoinjerto, cirugía de Ross',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
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
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("152")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15936.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 335.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2262.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK024",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K024"),
    :nombre => 'Cardiopatías congénitas - Módulo V - Cirugía de Rastelli',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("037")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("038")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("039")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("040")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("041")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("135")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("137")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 15.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15936.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 335.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2262.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK025",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K025"),
    :nombre => 'Cardiopatías congénitas - Módulo VI - Switch arterial, Nikeido, doble switch',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("134")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("136")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 17243.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 342.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2268.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK026",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K026"),
    :nombre => 'Cardiopatías congénitas - Módulo VI - Plástica o reemplazo valvular',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("026")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("057")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 17243.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 342.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2268.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK027",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K027"),
    :nombre => 'Cardiopatías congénitas - Módulo VI - Cierre de canal intra-ventricular más colocación de homoinjerto, recambio de homoinjerto, colocación de tubo con unifocalización',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("069")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("106")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("109")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("110")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 17243.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 342.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2268.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK028",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K028"),
    :nombre => 'Cardiopatías congénitas - Módulo VI - Correctora de tronco arterioso',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("152")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("153")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 17243.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 342.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2268.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK029",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K029"),
    :nombre => 'Cardiopatías congénitas - Módulo VI - Correctora de ATRVP',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("042")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("043")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("045")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("046")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("047")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("120")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("132")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("142")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("143")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("144")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("145")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 17243.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 342.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2268.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK030",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K030"),
    :nombre => 'Cardiopatías congénitas - Módulo VI - Cirugía de Stansel con anastomosis, Glenn o Sano',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("013")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("014")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("125")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 17243.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 342.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2268.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK031",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K031"),
    :nombre => 'Cardiopatías congénitas - Módulo VI - Reconstrucción del arco aórtico',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("065")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 17243.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 342.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2268.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK038",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K038"),
    :nombre => 'Cardiopatías congénitas - Módulo VI - Reimplante o Takeuchi',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("045")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 17243.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 342.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2268.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK032",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K032"),
    :nombre => 'Cardiopatías congénitas - Módulo VII - Cirugía de Norwood o Sano',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("062")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20909.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 708.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2634.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK033",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K033"),
    :nombre => 'Cardiopatías congénitas - Módulo VII - Cirugía de Glenn',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("062")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20909.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 708.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2634.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITK034",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("K034"),
    :nombre => 'Cardiopatías congénitas - Módulo VII - Cirugía de Fontan',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("062")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 2.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 25.0000,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPREQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20909.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1926.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQU"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 708.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DMPOSTQ"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2634.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQUM"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 861.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DEPOSTQSC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })


  # 0 A 5 AÑOS: CARDIOPATÍAS CONGÉNITAS - PRÁCTICAS COMPLEMENTARIAS A MÓDULOS QUIRÚRGICOS

  prestacion = Prestacion.create!({
    :codigo => "XMX001",
    :objeto_de_la_prestacion_id => (
      ObjetoDeLaPrestacion.where(:codigo => 'X001', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
    ),
    :nombre => 'Alprostadil',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0100,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "XMX002",
    :objeto_de_la_prestacion_id => (
      ObjetoDeLaPrestacion.where(:codigo => 'X002', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
    ),
    :nombre => 'Óxido nítrico y dispenser para su administración',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0100,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "XMX003",
    :objeto_de_la_prestacion_id => (
      ObjetoDeLaPrestacion.where(:codigo => 'X003', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
    ),
    :nombre => 'Levosimedan',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0100,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "XMX004",
    :objeto_de_la_prestacion_id => (
      ObjetoDeLaPrestacion.where(:codigo => 'X004', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
    ),
    :nombre => 'Factor VII activado recombinante',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0100,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "XMX005",
    :objeto_de_la_prestacion_id => (
      ObjetoDeLaPrestacion.where(:codigo => 'X005', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
    ),
    :nombre => 'Iloprost',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0100,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "XMX006",
    :objeto_de_la_prestacion_id => (
      ObjetoDeLaPrestacion.where(:codigo => 'X006', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
    ),
    :nombre => 'Trometanol',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0100,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "XMX007",
    :objeto_de_la_prestacion_id => (
      ObjetoDeLaPrestacion.where(:codigo => 'X007', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
    ),
    :nombre => 'Surfactante',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0100,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "XMX008",
    :objeto_de_la_prestacion_id => (
      ObjetoDeLaPrestacion.where(:codigo => 'X008', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
    ),
    :nombre => 'Nutrición parenteral total',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0100,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "XMX009",
    :objeto_de_la_prestacion_id => (
      ObjetoDeLaPrestacion.where(:codigo => 'X009', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
    ),
    :nombre => 'Prótesis y órtesis',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.where("codigo BETWEEN '001' AND '999'")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0100,
    :necesario => true,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :dato_reportable_id => DatoReportable.id_del_codigo!("VC"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })


  # 0 A 5 AÑOS: CUIDADO DE LA SALUD

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Consulta pediátrica en menores de un año',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.50,
    :maximo => 20.00,
    :necesario => false,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TCM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 20.0,
    :maximo => 99.0,
    :necesario => false,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PC"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 25.0,
    :maximo => 55.0,
    :necesario => false,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("menor_de_un_anio?")

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Consulta pediátrica de 1 a 5 años',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 5.00,
    :maximo => 50.00,
    :necesario => false,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TCM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 40.0,
    :maximo => 150.0,
    :necesario => false,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C010"),
    :nombre => 'Consulta de salud buco-dental en niños menores de 6 años',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C011"),
    :nombre => 'Consulta oftalmológica en niños de 5 años',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("mayor_de_53_meses?")

  prestacion = Prestacion.create!({
    :codigo => "IMV007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V007"),
    :nombre => 'Dosis aplicada de inmunización anti-amarílica en niños de 12 meses en departamentos de riesgo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 5.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V004"),
    :nombre => 'Dosis aplicada de inmunización cuádruple en niños de 18 meses o actualización de esquema',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 12.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 24.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V005"),
    :nombre => 'Dosis aplicada de inmunización para hepatitis A en niños de 12 meses o actualización de esquema',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V003"),
    :nombre => 'Dosis aplicada de inmunización pentavalente en niños de 2, 4 y 6 meses o actualización de esquema',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V006"),
    :nombre => 'Dosis aplicada de inmunización triple bacteriana celular en niños de 6 años o actualización de esquema',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V002"),
    :nombre => 'Dosis aplicada de Sabin en niños de 2, 4, 6 y 18 meses, 6 años o actualización de esquema',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V001"),
    :nombre => 'Dosis aplicada de vacuna triple viral en niños menores de 6 años',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V013"),
    :nombre => 'Dosis aplicada de vacuna antigripal en niños de 6 a 24 meses o en niños mayores con factores de riesgo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # ROX001, ROX002 y DSY001 ya se han creado como prestaciones comunitarias

  prestacion = Prestacion.create!({
    :codigo => "CAW003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("W003"),
    :nombre => 'Búsqueda activa de niñas y niños con abandono de controles por agente sanitario o personal de salud',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 200.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TAT003, TAT002 se han añadido como prestaciones comunitarias
  # AUH002A96 se ha añadido como otro diagnóstico para la AUH002A50 (muerte neonatal)

  prestacion = Prestacion.create!({
    :codigo => "CTC016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C016"),
    :nombre => 'Consulta con pediatra especialista en cardiología, nefrología, infectología, gastroenterología',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Atención ambulatoria con suplementación vitamínica a niños desnutridos menores de 6 años (inicial)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => 'Atención ambulatoria con suplementación vitamínica a niños desnutridos menores de 6 años (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Atención ambulatoria de infección respiratoria aguda en niños menores de 6 años (inicial)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => 'Atención ambulatoria de infección respiratoria aguda en niños menores de 6 años (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P011"),
    :nombre => 'Kinesioterapia ambulatoria en infecciones respiratorias agudas en niños menores de 6 años (5 sesiones)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITE001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E001"),
    :nombre => 'Internación abreviada de síndrome bronquial obstructivo (prehospitalización en ambulatorio)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 75.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITE002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E002"),
    :nombre => 'Internación abreviada de síndrome bronquial obstructivo (24 a 48 horas de internación en hospital)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 80.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITE003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E003"),
    :nombre => 'Internación por neumonía',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Consulta de niños con especialistas (hipoacusia en lactante "No pasa" con otoemisiones acústicas)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("GH"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P022"),
    :nombre => 'Rescreening de hipoacusia en lactante "No pasa" con BERA',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ROD"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ROI"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP021",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P021"),
    :nombre => 'Rescreening de hipoacusia en lactante "No pasa" con otoemisiones acústicas',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ROD"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ROI"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Atención ambulatoria de enfermedades diarreicas agudas en niños menores de 6 años (inicial)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => 'Atención ambulatoria de enfermedades diarreicas agudas en niños menores de 6 años (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "ITE001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("E001"),
    :nombre => 'Posta de rehidratación: diarrea aguda en ambulatorio',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 70.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 140.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C012"),
    :nombre => 'Consulta pediátrica de menores de 6 años en emergencia hospitalaria',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P004"),
    :nombre => 'Electrocardiograma en niños menores de 6 años',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP026",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P026"),
    :nombre => "Inactivación de caries",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "TLM081",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("M081"),
    :nombre => 'Transporte por referencia de niños menores de 6 años de zona A (hasta 50 km)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "TLM082",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("M082"),
    :nombre => 'Transporte por referencia de niños menores de 6 años de zona B (más de 50 km)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => UnidadDeMedida.find_by_codigo!("K").id, # Kilómetros excedentes (de 50 km)
    :unidades_maximas => 500.0000,
    :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 150.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 150.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IGR005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R005"),
    :nombre => 'Ecografía bilateral de cadera en niños menores de 2 meses',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IGR026",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R026"),
    :nombre => 'Rx de tórax frente y perfil en niños menores de 6 años',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IGR022",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R022"),
    :nombre => 'Rx de cráneo frente y perfil en niños menores de 6 años',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IGR017",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R017"),
    :nombre => 'Rx de huesos cortos, frente y perfil, en niños menores de 6 años con patología prevalente',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IGR025",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R025"),
    :nombre => 'Rx de huesos largos, frente y perfil, en niños menores de 6 años con patología prevalente',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IGR004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R004"),
    :nombre => 'Ecodoppler en niños menores de 6 años',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A40")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A41")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A42")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A44")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A46")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })


  # 6 A 9 AÑOS

  # 6 A 9 AÑOS: CUIDADO DE LA SALUD

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Control en niños y niñas de 6 a 9 años',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.00,
    :maximo => 80.00,
    :necesario => false,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TCM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 50.0,
    :maximo => 200.0,
    :necesario => false,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C009"),
    :nombre => 'Control de salud individual para población indígena en terreno',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.00,
    :maximo => 80.00,
    :necesario => false,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TCM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 50.0,
    :maximo => 200.0,
    :necesario => false,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiario_indigena?")

  prestacion = Prestacion.create!({
    :codigo => "CTC010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C010"),
    :nombre => 'Control odontológico',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CEO_C"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CEO_E"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CEO_O"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C011"),
    :nombre => 'Control oftalmológico',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CAW003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("W003"),
    :nombre => 'Búsqueda activa de niñas y niños con abandono de controles por agente sanitario o personal de salud',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CAW006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("W006"),
    :nombre => 'Consulta para confirmación diagnóstica en población indígena con riesgo detectado en terreno',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("H86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R81")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R96")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DIAG"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiario_indigena?")

  prestacion = Prestacion.create!({
    :codigo => "IMV008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V008"),
    :nombre => 'Dosis aplicada de vacuna dTap triple acelular (actualización de esquema en niños mayores de 7 años)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V009"),
    :nombre => 'Dosis aplicada de inmunización anti-hepatitis B (actualización de esquema)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V002"),
    :nombre => 'Dosis aplicada Sabin oral (actualización de esquema)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V001"),
    :nombre => 'Dosis aplicada de triple viral (actualización de esquema)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V013"),
    :nombre => 'Dosis aplicada de vacuna antigripal en niñas y niños con factores de riesgo',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP025",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P025"),
    :nombre => 'Barniz fluorado de surcos',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP026",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P026"),
    :nombre => 'Inactivación de caries',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP024",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P024"),
    :nombre => 'Sellado de surcos',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Anemia leve y moderada (inicial)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => 'Anemia leve y moderada (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Asma bronquial (inicial)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R96")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ASM"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => 'Asma bronquial (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R96")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ASM"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C012"),
    :nombre => 'Asma bronquial (urgencia)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R96")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Consulta diagnóstica y de seguimiento de leucemia (inicial)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => 'Consulta diagnóstica y de seguimiento de leucemia (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Consulta diagnóstica y de seguimiento de linfoma (inicial)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => 'Consulta diagnóstica y de seguimiento de linfoma (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Consulta de obesidad (inicial)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.00,
    :maximo => 100.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.5,
    :maximo => 2.0,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("tension_arterial_valida?")

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => 'Consulta de obesidad (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.00,
    :maximo => 100.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.5,
    :maximo => 2.0,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("tension_arterial_valida?")

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Consulta de sobrepeso (inicial)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.00,
    :maximo => 100.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.5,
    :maximo => 2.0,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("tension_arterial_valida?")

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => 'Consulta de sobrepeso (ulterior)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.00,
    :maximo => 100.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.5,
    :maximo => 2.0,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("tension_arterial_valida?")

  prestacion = Prestacion.create!({
    :codigo => "NTN002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("N002"),
    :nombre => 'Notificación de inicio de tratamiento en tiempo oportuno (leucemia/linfoma)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [de_6_a_9]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 5.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # ADOLESCENTES DE 10 A 19 AÑOS

  # ADOLESCENTES: CUIDADO DE LA SALUD

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => 'Examen periódico de salud del adolescente',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 20.00,
    :maximo => 300.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.8,
    :maximo => 2.5,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("tension_arterial_valida?")

  prestacion = Prestacion.create!({
    :codigo => "CTC009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C009"),
    :nombre => 'Control de salud individual para población indígena en terreno',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 20.00,
    :maximo => 300.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.8,
    :maximo => 2.5,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 80.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("tension_arterial_valida?")
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiario_indigena?")

  prestacion = Prestacion.create!({
    :codigo => "CTC008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C008"),
    :nombre => 'Control ginecológico',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C010"),
    :nombre => "Consulta odontológica",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CPOD_C"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CPOD_P"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CPOD_O"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C011"),
    :nombre => 'Control oftalmológico',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V011"),
    :nombre => "Doble viral (rubéola + sarampión)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V010"),
    :nombre => "Dosis aplicada de doble para adultos (> 16 años)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V008"),
    :nombre => "Dosis aplicada de dTap triple acelular (refuerzo a los 11 años)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V009"),
    :nombre => "Dosis aplicada de inmunización anti-hepatitis B monovalente (a partir de 11 años sin inmunización previa)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V013"),
    :nombre => "Dosis aplicada de vacuna antigripal en adolescentes con factores de riesgo",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV014",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V014"),
    :nombre => "Dosis aplicada de vacuna contra VPH en adolescentes de 11 años",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 12.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 24.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "COT018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T018"),
    :nombre => "Consejería post-aborto",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "COT016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T016"),
    :nombre => "Consejería en salud sexual (en terreno)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "COT015",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T015"),
    :nombre => "Consejería en salud sexual para adolescentes",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CAW005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("W005"),
    :nombre => "Búsqueda activa de adolescentes para valoración integral",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 80.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CAW004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("W004"),
    :nombre => "Búsqueda activa de embarazadas adolescentes por agente sanitario o personal de salud",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 80.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CAW006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("W006"),
    :nombre => "Consulta para confirmación diagnóstica en población indígena con riesgo detectado en terreno",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D11")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D61")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D62")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P20")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P23")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P24")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R96")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W06")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W07")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W08")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W12")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W17")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W18")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W19")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W84")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W88")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W94")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X92")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z31")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DIAG"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Anemia leve y moderada en mujeres (inicial)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => "Anemia leve y moderada en mujeres (ulterior)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C012"),
    :nombre => "Asma bronquial (urgencia)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R96")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Asma bronquial (inicial)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R96")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ASM"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => "Asma bronquial (ulterior)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R96")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("ASM"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C012"),
    :nombre => "Consumo episódico excesivo de alcohol y/u otras sustancias psicoactivas (urgencia/consultorio externo)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P20")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P23")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P24")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("EFE"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C012"),
    :nombre => "Intento de suicidio (urgencia)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("EFE"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C012"),
    :nombre => "Víctima de violencia sexual (urgencia)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z31")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("EFE"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Consulta diagnóstica y de seguimiento de leucemia (inicial)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => "Consulta diagnóstica y de seguimiento de leucemia (ulterior)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Consulta diagnóstica y de seguimiento de linfoma (inicial)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => "Consulta diagnóstica y de seguimiento de linfoma (ulterior)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C003"),
    :nombre => "Consulta de diagnóstico temprano y confidencial de embarazo en adolescente",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Seguimiento por consumo episódico excesivo de alcohol y/u otras sustancias psicoactivas (inicial)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P20")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P23")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P24")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => "Seguimiento por consumo episódico excesivo de alcohol y/u otras sustancias psicoactivas (ulterior)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P20")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P23")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P24")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Seguimiento por intento de suicidio",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Consulta por obesidad (inicial)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 20.00,
    :maximo => 300.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.8,
    :maximo => 2.5,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => "Consulta por obesidad (ulterior)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 20.00,
    :maximo => 300.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.8,
    :maximo => 2.5,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Consulta por sobrepeso (inicial)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 20.00,
    :maximo => 300.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.8,
    :maximo => 2.5,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => "Consulta por sobrepeso (ulterior)",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("PKG"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 20.00,
    :maximo => 300.00,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TM"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.8,
    :maximo => 2.5,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P003"),
    :nombre => 'Colocación de DIU',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W12")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 80.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "NTN002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("N002"),
    :nombre => 'Notificación de inicio de tratamiento en tiempo oportuno (linfoma/leucemia)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << adolescentes
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 5.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })


  # MUJERES DE 20 A 64 AÑOS

  # MUJERES DE 20 A 64 AÑOS: CUIDADO DE LA SALUD

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Examen periódico de salud",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C009"),
    :nombre => "Control de salud individual para población indígena en terreno",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 80.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAS"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 30.0000,
    :maximo => 390.0000,
    :obligatorio => true
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TAD"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 10.0000,
    :maximo => 310.0000,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiario_indigena?")

  prestacion = Prestacion.create!({
    :codigo => "CTC008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C008"),
    :nombre => "Control ginecológico",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C010"),
    :nombre => "Control odontológico",
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CPOD_C"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CPOD_P"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("CPOD_O"),
    :fecha_de_inicio => fecha_de_inicio,
    :minimo => 0.0000,
    :maximo => 32.0000,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V010"),
    :nombre => "Dosis aplicada de doble para adultos",
#    :otorga_cobertura => true, # TODO: según DOIU no otorga cobertura
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V011"),
    :nombre => "Dosis aplicada de doble viral",
#    :otorga_cobertura => true, # TODO: según DOIU no otorga cobertura
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IMV013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V013"),
    :nombre => "Dosis aplicada de vacuna antigripal en personas con factores de riesgo",
#    :otorga_cobertura => true, # TODO: según DOIU no otorga cobertura
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 8.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 16.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C004"),
    :nombre => "Control preconcepcional (inicial)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C013"),
    :nombre => "Control preconcepcional (ulterior)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "COT018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T018"),
    :nombre => "Consejería post-aborto",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "COT020",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T020"),
    :nombre => "Consejería en salud sexual y procreación responsable",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CAW006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("W006"),
    :nombre => "Consulta para confirmación diagnóstica en población indígena con riesgo detectado en terreno",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D60")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D61")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D62")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("D72")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("K86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P23")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("P24")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R25")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R74")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("R78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("T91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("U71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W06")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W07")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W08")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W12")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W17")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W18")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W19")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W84")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W88")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("W94")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X19")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X30")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X70")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X71")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X86")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X90")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X91")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X92")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z31")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DIAG"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Anemia leve y moderada en mujeres de 20 a 49 años (inicial)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_menor_de_50_anios?")

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => "Anemia leve y moderada en mujeres de 20 a 49 años (ulterior)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("B80")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_menor_de_50_anios?")

  prestacion = Prestacion.create!({
    :codigo => "CTC012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C012"),
    :nombre => "Víctima de violencia sexual (urgencia)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z31")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Consulta diagnóstica y de seguimiento de cáncer cérvico-uterino (inicial)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => "Consulta diagnóstica y de seguimiento de cáncer cérvico-uterino (ulterior)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C001"),
    :nombre => "Consulta diagnóstica y de seguimiento de cáncer de mama (inicial)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "CTC002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C002"),
    :nombre => "Consulta diagnóstica y de seguimiento de cáncer de mama (ulterior)",
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P007"),
    :nombre => 'Biopsia para las mujeres con mamografía BIRADS 4 y 5 (cáncer de mama)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X30")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P002"),
    :nombre => 'Colposcopía de lesión en cuello uterino, realizada por especialista en ASC-H, H-SIL, cáncer (CA cérvico-uterino)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P007"),
    :nombre => 'Biopsia de lesión en cuello uterino, realizada por especialista en ASC-H, H-SIL, cáncer (CA cérvico-uterino)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X86")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 40.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "PRP018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P018"),
    :nombre => 'Toma de muestra citológica en mujeres de 20 a 64 años (tamizaje de CA cérvico-uterino)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "IGR014",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R014"),
    :nombre => 'Mamografía bilateral, craneocaudal y oblicua, con proyección axilar en mujeres mayores de 49 años',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("BIRADS"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_mayor_de_49_anios?")

  prestacion = Prestacion.create!({
    :codigo => "IGR015",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R015"),
    :nombre => 'Mamografía, variedad magnificada',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X19")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X30")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
#  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_mayor_de_49_anios?") # TODO: determinar si también es para mayores de 49

  prestacion = Prestacion.create!({
    :codigo => "APA002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("A002"),
    :nombre => 'Anatomía patológica de biopsia (CA de mama)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "APA002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("A002"),
    :nombre => 'Diagnóstico por biopsia en laboratorio de anatomía patológica, para mujeres con citología ASC-H, H-SIL, cáncer (CA cérvico-uterino)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DIAGAP"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SITAM"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "APA001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("A001"),
    :nombre => 'Lectura de muestra tomada en mujeres de 25 a 64 años, en laboratorio de anatomía patológica / citología, con diagnóstico firmado por anátomo patólogo matriculado (tamizaje de CA cérvico-uterino)',
    :otorga_cobertura => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75")
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X86")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("DIAGAP"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SITAM"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })
  prestacion.metodos_de_validacion << MetodoDeValidacion.find_by_metodo("beneficiaria_mayor_de_24_anios?")

  prestacion = Prestacion.create!({
    :codigo => "NTN001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("N001"),
    :nombre => 'Notificación de caso positivo al responsable del servicio donde se realizó la toma de muestra para PAP (CA cérvico-uterino)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SITAM"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "NTN003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("N003"),
    :nombre => 'Notificación de caso positivo al responsable del servicio donde se realizó la toma de muestra para biopsia (CA cérvico-uterino)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("SITAM"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "NTN002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("N002"),
    :nombre => 'Notificación de inicio de tratamiento en tiempo oportuno ASC-H, H-SIL, cáncer (CA cérvico-uterino)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "NTN002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("N002"),
    :nombre => 'Notificación de inicio de tratamiento en tiempo oportuno (CA de mama)',
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << mujeres_20_a_64
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Colocación de DIU PRP003W12 lo añado en la prestación creada para adolescentes





  # PRESTACIONES COMUNITARIAS

  # OJO: se repite el código de objeto "X001", se ha colocado aparte, aunque en el PDSS figura repetida para cada grupo poblacional, además es comunitaria
  prestacion = Prestacion.create!({
    :codigo => "ROX001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.where(:codigo => 'X001', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('RO')).first.id,
    :nombre => 'Ronda sanitaria completa orientada a la detección de población de riesgo en área rural',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 300.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # OJO: se repite el código de objeto "X002", se ha colocado aparte, aunque en el PDSS figura repetida para cada grupo poblacional, además es comunitaria
  prestacion = Prestacion.create!({
    :codigo => "ROX002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.where(:codigo => 'X002', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('RO')).first.id,
    :nombre => 'Ronda sanitaria completa orientada a la detección de población de riesgo en población indígena',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 300.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })


  # ANEXO: TALLERES

  # OJO: Se ha colocado aparte como comunitaria aunque en el PDSS figura sólo en los grupos poblacionales de embarazo y niños menores de 6 años
  prestacion = Prestacion.create!({
    :codigo => "TAT003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T003"),
    :nombre => 'Encuentros para promoción del desarrollo infantil, prevención de patologías prevalentes en la infancia, conductas saludables, hábitos de higiene',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  # OJO: Se ha colocado aparte como comunitaria aunque en el PDSS figura sólo en los grupos poblacionales de embarazo y niños menores de 6 años
  prestacion = Prestacion.create!({
    :codigo => "TAT002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T002"),
    :nombre => 'Encuentros para promoción de pautas alimentarias en embarazadas, puérperas y niños menores de 6 años',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  # OJO: Se ha colocado aparte como comunitaria aunque en el PDSS figura sólo en los grupos poblacionales de embarazo y niños menores de 6 años
  prestacion = Prestacion.create!({
    :codigo => "TAT001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T001"),
    :nombre => 'Encuentros para promoción de salud sexual y reproductiva, conductas saludables, hábitos de higiene',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  # OJO: Se ha colocado aparte como comunitaria aunque en el PDSS figura sólo en los nuevos grupos poblacionales
  prestacion = Prestacion.create!({
    :codigo => "TAT004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T004"),
    :nombre => 'Pautas nutricionales respetando la cultura alimentaria de comunidades indígenas',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "TAT006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T006"),
    :nombre => 'Prevención de accidentes domésticos',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "TAT010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T010"),
    :nombre => 'Prevención de comportamientos adictivos: tabaquismo, uso de drogas, alcoholismo',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "TAT007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T007"),
    :nombre => 'Prevención de VIH e infecciones de transmisión sexual',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "TAT005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T005"),
    :nombre => 'Prevención de accidentes',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "TAT008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T008"),
    :nombre => 'Prevención de violencia de género',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "TAT009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T009"),
    :nombre => 'Prevención de violencia familiar',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "TAT011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T011"),
    :nombre => 'Promoción de hábitos saludables: salud bucal, educación alimentaria, pautas de higiene, trastornos de la alimentación',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "TAT012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T012"),
    :nombre => 'Promoción de pautas alimentarias',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => false
  })

  prestacion = Prestacion.create!({
    :codigo => "TAT013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T013"),
    :nombre => 'Promoción de salud sexual y reproductiva',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })

  prestacion = Prestacion.create!({
    :codigo => "TAT014",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("T014"),
    :nombre => 'Salud sexual, confidencialidad, género y derecho (actividad en sala de espera)',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  DatoReportableRequerido.create!({
    :prestacion_id => prestacion.id,
    :dato_reportable_id => DatoReportable.id_del_codigo!("TEMA"),
    :fecha_de_inicio => fecha_de_inicio,
    :obligatorio => true
  })


  # ANEXO: DIAGNÓSTICO SOCIOEPIDEMIOLÓGICO

  # OJO: Se ha colocado aparte como comunitaria aunque en el PDSS figura sólo en los grupos poblacionales de embarazo y niños menores de 6 años
  prestacion = Prestacion.create!({
    :codigo => "DSY001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("Y001"),
    :nombre => 'Diagnóstico socioepidemiológico de población en riesgo por efector (informe final de ronda entregado y aprobado)',
    :comunitaria => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 60.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

end
