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

  # Concepto de facturación
  paquete_basico_id = ConceptoDeFacturacion.find_by_codigo!("BAS").id

  # Tipo de tratamiento
  ambulatorio_id = TipoDeTratamiento.find_by_codigo!("A").id

  # Área rural
  rural_id = AreaDePrestacion.id_del_codigo!("R")

  # ANEXO VALORIZACIÓN

  prestacion = Prestacion.create!({
    :codigo => "CTC015",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("C015"),
    :nombre => 'Consulta de trabajador social',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P001"),
    :nombre => 'Cateterización',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural a la práctica PRP003 (DOIU Nº 4)
  prestacion = Prestacion.find_by_codigo!("PRP003")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 80.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora,
  })

  # Ya está habilitada para embarazadas y menores de 6, pero hay que agregar la asignación de precios rurales
  prestaciones = Prestacion.where(:codigo => "PRP004").each do |prestacion|
    AsignacionDePrecios.create!({
      :precio_por_unidad => 10.0000,
      :adicional_por_prestacion => 0.0000,
      :area_de_prestacion_id => rural_id,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora,
    })
  end

  # Creamos otro ID para la misma prestación por si tenemos que habilitarlas en otros grupos
  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P004"),
    :nombre => 'Electrocardiograma',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P005"),
    :nombre => 'Ergometría',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P006"),
    :nombre => 'Espirometría',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 30.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P007"),
    :nombre => 'Escisión / Remoción / Toma para biopsia / Punción lumbar',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P008"),
    :nombre => 'Extracción de sangre',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 1.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P009"),
    :nombre => 'Incisión / Drenaje / Lavado',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P010"),
    :nombre => 'Inyección / Infiltración local / Venopuntura',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 3.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P011"),
    :nombre => 'Medicina física / Rehabilitación',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP014",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P014"),
    :nombre => 'Pruebas de sensibilización',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P016"),
    :nombre => 'Registro de trazados eléctricos cerebrales',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP017",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P017"),
    :nombre => 'Oftalmoscopía binocular indirecta (OBI)',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP019",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P019"),
    :nombre => 'Audiometría tonal',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 15.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP020",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P020"),
    :nombre => 'Logoaudiometría',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP028",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P028"),
    :nombre => 'Fondo de ojo',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP029",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P029"),
    :nombre => 'Punción de médula ósea',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "PRP030",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P030"),
    :nombre => 'Uso de tirillas reactivas para determinación rápida de proteinuria',
    :requiere_historia_clinica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R002"),
    :nombre => 'Densitometría ósea',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R003"),
    :nombre => 'Ecocardiograma (incluye con fracción de eyección)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 50.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R006"),
    :nombre => 'Ecografía cerebral',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR007",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R007"),
    :nombre => 'Ecografía de cuello',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R008"),
    :nombre => 'Ecografía ginecológica',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R009"),
    :nombre => 'Ecografía mamaria',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  prestacion.sexos << sexo_femenino
  prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R010"),
    :nombre => 'Ecografía tiroidea',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R011"),
    :nombre => 'Fibrocolonoscopía',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR012",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R012"),
    :nombre => 'Fibrogastroscopía',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R013"),
    :nombre => 'Fibrorectosigmoideoscopía',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 100.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural a la práctica IGR017 (DOIU Nº 4)
  prestacion = Prestacion.find_by_codigo!("IGR017")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R018"),
    :nombre => 'Rx de colon por enema, evacuado e insuflado (con o sin doble contraste)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR019",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R019"),
    :nombre => 'Rx de columna cervical (total o focalizada), frente y perfil',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR020",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R020"),
    :nombre => 'Rx de columna dorsal (total o focalizada), frente y perfil',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR021",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R021"),
    :nombre => 'Rx de columna lumbar (total o focalizada), frente y perfil',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Ya está habilitada para embarazadas y menores de 6, pero hay que agregar la asignación de precios rurales
  prestaciones = Prestacion.where(:codigo => "IGR022").each do |prestacion|
    AsignacionDePrecios.create!({
      :precio_por_unidad => 10.0000,
      :adicional_por_prestacion => 0.0000,
      :area_de_prestacion_id => rural_id,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora,
    })
  end

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR023",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R023"),
    :nombre => 'Rx de estudio seriado del tránsito esófagogastroduodenal contrastado',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR024",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R024"),
    :nombre => 'Rx de estudio del tránsito de intestino delgado y cecoapendicular',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 25.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural a la práctica IGR025 (DOIU Nº 4)
  prestacion = Prestacion.find_by_codigo!("IGR025")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora,
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR026",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R026"),
    :nombre => 'Rx o Tele-Rx de tórax (total o focalizada), frente y perfil',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR028",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R028"),
    :nombre => 'Rx sacrococcígea (total o focalizada) frente y perfil',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR029",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R029"),
    :nombre => 'Rx simple de abdomen, frente y perfil',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR030",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R030"),
    :nombre => 'Tomografía axial computada (TAC)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Ya está habilitada para embarazadas, pero hay que agregar la asignación de precios rurales
  prestaciones = Prestacion.where(:codigo => "IGR031").each do |prestacion|
    AsignacionDePrecios.create!({
      :precio_por_unidad => 25.0000,
      :adicional_por_prestacion => 0.0000,
      :area_de_prestacion_id => rural_id,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora,
    })
  end

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "IGR032",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R032"),
    :nombre => 'Ecografía abdominal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 20.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "APA003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("A003"),
    :nombre => 'Medulograma (recuento diferencial con tinción de MGG)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "TLM020",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("M020"),
    :nombre => 'Unidad móvil de alta complejidad (adultos)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "TLM030",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("M030"),
    :nombre => 'Unidad móvil de alta complejidad (pediátrica/neonatal)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
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
    :precio_por_unidad => 350.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 350.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Crear el método de validación para neonatos (< 28 días)
  neonato = MetodoDeValidacion.create!({
    #:id => 12,
    :nombre => "Verificar que sea un neonato",
    :metodo => "neonato?",
    :mensaje => "La prestación debería haberse brindado a un neonato (antes de los 28 días de vida).",
    :genera_error => false
  })

  prestacion = Prestacion.create!({
    :codigo => "LBL001",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L001"),
    :nombre => '17 Hidroxiprogesterona',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << menores_de_6
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << neonato

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL002",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L002"),
    :nombre => 'Ácido úrico',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL003",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L003"),
    :nombre => 'Ácidos biliares',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL004",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L004"),
    :nombre => 'Amilasa pancreática',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL005",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L005"),
    :nombre => 'Antibiograma micobacterias',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL006",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L006"),
    :nombre => 'Anticuerpos antitreponémicos',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL008",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L008"),
    :nombre => 'Apolipoproteína B',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL009",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L009"),
    :nombre => 'ASTO',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL010",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L010"),
    :nombre => 'Baciloscopía',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL011",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L011"),
    :nombre => 'Bacteriología directa y cultivo',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural a la práctica LBL012
  prestacion = Prestacion.find_by_codigo!("LBL012")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "LBL013",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L013"),
    :nombre => 'Biotinidasa neonatal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << menores_de_6
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << neonato

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL014",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L014"),
    :nombre => 'Calcemia',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL015",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L015"),
    :nombre => 'Calciuria',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL016",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L016"),
    :nombre => 'Campo oscuro',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL017",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L017"),
    :nombre => 'Citología',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL018",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L018"),
    :nombre => 'Colesterol',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL019",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L019"),
    :nombre => 'Coprocultivo',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL020",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L020"),
    :nombre => 'CPK',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural a la práctica LBL021
  prestacion = Prestacion.find_by_codigo!("LBL021")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural a la práctica LBL022
  prestacion = Prestacion.find_by_codigo!("LBL022")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL024",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L024"),
    :nombre => 'Cultivo Streptococo B hemolítico',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL025",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L025"),
    :nombre => 'Cultivo vaginal / Exudado de flujo',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL026",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L026"),
    :nombre => 'Cultivo y antibiograma general',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL027",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L027"),
    :nombre => 'Electroforesis de proteínas',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL028",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L028"),
    :nombre => 'Eritrosedimentación',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL029",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L029"),
    :nombre => 'Esputo seriado',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL030",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L030"),
    :nombre => 'Estado ácido base',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL031",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L031"),
    :nombre => 'Estudio citoquímico de médula ósea: pas-peroxidasa-esterasas',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL032",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L032"),
    :nombre => 'Estudio citogenético de médula ósea (técnica de bandeo G)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL033",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L033"),
    :nombre => 'Estudio de genética molecular de médula ósea (BCR/ABL, MLL/AF4 y TEL/AML1 por técnicas de RT-PCR o Fish)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL034",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L034"),
    :nombre => 'Factor de coagulación 5, 7, 8, 9 y 10',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "LBL035",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L035"),
    :nombre => 'Fenilalanina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << menores_de_6
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << neonato

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL036",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L036"),
    :nombre => 'Fenilcetonuria',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL037",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L037"),
    :nombre => 'Ferremia',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL038",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L038"),
    :nombre => 'Ferritina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural a la práctica LBL040
  prestacion = Prestacion.find_by_codigo!("LBL040")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL041",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L041"),
    :nombre => 'Fosfatemia',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL042",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L042"),
    :nombre => 'FSH',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "LBL043",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L043"),
    :nombre => 'Galactosemia',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << menores_de_6
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << neonato

  # Agregamos una asignación de precios rural a la práctica LBL044
  prestacion = Prestacion.find_by_codigo!("LBL044")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural a los laboratorios LBL044 existentes
  prestaciones = Prestacion.where(:codigo => "LBL045").each do |prestacion|
    AsignacionDePrecios.create!({
      :precio_por_unidad => 2.5000,
      :adicional_por_prestacion => 0.0000,
      :area_de_prestacion_id => rural_id,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })
  end

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL045",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L045"),
    :nombre => 'Glucemia',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL046",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L046"),
    :nombre => 'Glucosuria',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL047
  prestacion = Prestacion.find_by_codigo!("LBL047")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL048
  prestacion = Prestacion.find_by_codigo!("LBL048")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL049",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L049"),
    :nombre => 'Grasas en material fecal cualitativa',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL050
  prestacion = Prestacion.find_by_codigo!("LBL050")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL050",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L050"),
    :nombre => 'Grupo y factor',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL052
  prestacion = Prestacion.find_by_codigo!("LBL052")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL053",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L053"),
    :nombre => 'Hematocrito',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL054",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L054"),
    :nombre => 'Hemocultivo aerobio-anaerobio',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL055
  prestaciones = Prestacion.where(:codigo => "LBL055").each do |prestacion|
    AsignacionDePrecios.create!({
      :precio_por_unidad => 2.5000,
      :adicional_por_prestacion => 0.0000,
      :area_de_prestacion_id => rural_id,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })
  end

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL055",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L055"),
    :nombre => 'Hemoglobina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL057
  prestacion = Prestacion.find_by_codigo!("LBL057")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL057",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L057"),
    :nombre => 'Hemograma completo',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL058",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L058"),
    :nombre => 'Hepatitis B anti HBS - Anticore total',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL059",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L059"),
    :nombre => 'Hepatograma',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL060",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L060"),
    :nombre => 'Hidatidosis por hemoaglutinación',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL061",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L061"),
    :nombre => 'Hidatidosis por IFI',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL062",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L062"),
    :nombre => 'Hisopado de fauces',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL063",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L063"),
    :nombre => 'Homocistina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL064",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L064"),
    :nombre => 'IFI infecciones respiratorias',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL066",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L066"),
    :nombre => 'Insulinemia basal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL067",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L067"),
    :nombre => 'Inmunofenotipo de médula ósea por citometría de flujo',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 150.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL068",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L068"),
    :nombre => 'Ionograma plasmático y orina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL069
  prestacion = Prestacion.find_by_codigo!("LBL069")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.25000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL070",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L070"),
    :nombre => 'LDH',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL071",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L071"),
    :nombre => 'Leucocitos en material fecal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL072",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L072"),
    :nombre => 'LH',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL073",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L073"),
    :nombre => 'Lipidograma electroforético',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL074",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L074"),
    :nombre => 'Líquido cefalorraquídeo citoquímico y bacteriológico',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL075",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L075"),
    :nombre => 'Líquido cefalorraquídeo - Recuento celular (cámara), citología (MGG, Cytospin) e histoquímica',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL076",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L076"),
    :nombre => 'Micológico',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL077",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L077"),
    :nombre => 'Microalbuminuria',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL078",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L078"),
    :nombre => 'Monotest',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL079
  prestaciones = Prestacion.where(:codigo => "LBL079").each do |prestacion|
    AsignacionDePrecios.create!({
      :precio_por_unidad => 6.2500,
      :adicional_por_prestacion => 0.0000,
      :area_de_prestacion_id => rural_id,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })
  end

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL079",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L079"),
    :nombre => 'Orina completa',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL080
  prestacion = Prestacion.find_by_codigo!("LBL080")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL081",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L081"),
    :nombre => 'Parasitológico de materia fecal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL082",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L082"),
    :nombre => 'PH en materia fecal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL083",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L083"),
    :nombre => 'Porcentaje de saturación de hierro funcional',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL084",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L084"),
    :nombre => 'PPD',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL085",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L085"),
    :nombre => 'Productos de degradación del fibrinógeno (PDF)',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL086",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L086"),
    :nombre => 'Progesterona',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL087",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L087"),
    :nombre => 'Prolactina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL088",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L088"),
    :nombre => 'Proteína C reactiva',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL089",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L089"),
    :nombre => 'Proteínas totales y fraccionadas',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL090
  prestacion = Prestacion.find_by_codigo!("LBL090")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL091",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L091"),
    :nombre => 'Protoporfirina libre eritrocitaria',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL092",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L092"),
    :nombre => 'Prueba de Coombs directa',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL093",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L093"),
    :nombre => 'Prueba de Coombs indirecta cuantitativa',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL090
  prestacion = Prestacion.find_by_codigo!("LBL094")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL095",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L095"),
    :nombre => 'Reacción de Hudleson',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL096",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L096"),
    :nombre => 'Reacción de Widal',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL097",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L097"),
    :nombre => 'Receptores libres de transferrina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL098",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L098"),
    :nombre => 'Sangre oculta en heces',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL099
  prestacion = Prestacion.find_by_codigo!("LBL099")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL100",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L100"),
    :nombre => 'Serología para hepatitis A IgM',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL101",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L101"),
    :nombre => 'Serología para hepatitis A total',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL102",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L102"),
    :nombre => 'Serología para rubéola IgM',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL103",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L103"),
    :nombre => 'Sideremia',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL104",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L104"),
    :nombre => 'T3',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL105",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L105"),
    :nombre => 'T4 libre',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL106",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L106"),
    :nombre => 'Test de Graham',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL107",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L107"),
    :nombre => 'Test de látex',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL108",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L108"),
    :nombre => 'TIBC',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL109",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L109"),
    :nombre => 'Tiempo de lisis de euglobulina',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL112
  prestacion = Prestacion.find_by_codigo!("LBL112")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL113",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L113"),
    :nombre => 'Transferrinas',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL114",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L114"),
    :nombre => 'Triglicéridos',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  prestacion = Prestacion.create!({
    :codigo => "LBL115",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L115"),
    :nombre => 'Tripsina catiónica inmunorreactiva',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << menores_de_6
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << neonato

  prestacion = Prestacion.create!({
    :codigo => "LBL116",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L116"),
    :nombre => 'TSH',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
  })
  prestacion.sexos << [sexo_femenino, sexo_masculino]
  prestacion.grupos_poblacionales << menores_de_6
  prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  prestacion.metodos_de_validacion << neonato

  # Agregamos una asignación de precios rural al laboratorio LBL117
  prestacion = Prestacion.find_by_codigo!("LBL117")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL118
  prestacion = Prestacion.find_by_codigo!("LBL118")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 10.0000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL119
  prestacion = Prestacion.where(:codigo => "LBL119").each do |prestacion|
    AsignacionDePrecios.create!({
      :precio_por_unidad => 6.2500,
      :adicional_por_prestacion => 0.0000,
      :area_de_prestacion_id => rural_id,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })
  end

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL120",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L120"),
    :nombre => 'Vibrio choleræ. Cultivo e identificación',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL121
  prestacion = Prestacion.where(:codigo => "LBL121").each do |prestacion|
    AsignacionDePrecios.create!({
      :precio_por_unidad => 18.7500,
      :adicional_por_prestacion => 0.0000,
      :area_de_prestacion_id => rural_id,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })
  end

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL123",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L123"),
    :nombre => 'Serología para hepatitis C',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL124",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L124"),
    :nombre => 'Magnesemia',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL125",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L125"),
    :nombre => 'Serología LCR',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 18.7500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL126",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L126"),
    :nombre => 'Recuento de plaquetas',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL127",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L127"),
    :nombre => 'Antígeno P24',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL128
  prestacion = Prestacion.find_by_codigo!("LBL128")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL129",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L129"),
    :nombre => 'IgE sérica',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 6.2500,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL130",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L130"),
    :nombre => 'Tiempo de coagulación y sangría',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL131
  prestacion = Prestacion.find_by_codigo!("LBL131")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL132
  prestacion = Prestacion.find_by_codigo!("LBL132")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # Agregamos una asignación de precios rural al laboratorio LBL133
  prestacion = Prestacion.find_by_codigo!("LBL133")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

  # TODO: indicar a qué grupos, sexos y diagnósticos está referida
  prestacion = Prestacion.create!({
    :codigo => "LBL134",
    :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L134"),
    :nombre => 'Recuento reticulocitario',
    :requiere_historia_clinica => false,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
    :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
    :tipo_de_tratamiento_id => ambulatorio_id
  })
  #prestacion.sexos << [sexo_femenino, sexo_masculino]
  #prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
  #prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })
  AsignacionDePrecios.create!({
    :precio_por_unidad => 2.5000,
    :adicional_por_prestacion => 0.0000,
    :area_de_prestacion_id => rural_id,
    :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
  })

end
