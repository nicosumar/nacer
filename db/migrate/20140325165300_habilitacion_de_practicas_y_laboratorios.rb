# -*- encoding : utf-8 -*-
class HabilitacionDePracticasYLaboratorios < ActiveRecord::Migration
  def up
    # Precargamos ciertos datos útiles para no ejecutar tantas consultas a la base
    sexo_femenino = Sexo.find_by_codigo!("F")
    sexo_masculino = Sexo.find_by_codigo!("M")
    menores_de_6 = GrupoPoblacional.find_by_codigo!("A")
    de_6_a_9 = GrupoPoblacional.find_by_codigo!("B")
    adolescentes = GrupoPoblacional.find_by_codigo!("C")
    mujeres_20_a_64 = GrupoPoblacional.find_by_codigo!("D")
    # Obtener el nomenclador
    nomenclador_sumar = Nomenclador.find(5)
    # Concepto de facturación
    paquete_basico_id = ConceptoDeFacturacion.find_by_codigo!("BAS").id
    # Tipos de tratamientos
    ambulatorio_id = TipoDeTratamiento.find_by_codigo!("A").id
    internacion_id = TipoDeTratamiento.find_by_codigo!("I").id

    # Área rural
    rural_id = AreaDePrestacion.id_del_codigo!("R")

    # Cateterización
    prestacion = Prestacion.where(:codigo => "PRP001").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")

    # Añado A97 a los códigos de ECG en menores de 6 años
    prestacion = Prestacion.where(:id => 483, :codigo => "PRP004").first
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")

    prestacion = Prestacion.where(:id => 621, :codigo => "PRP004").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")

    # Cambio la descripción del código PRP005
    Prestacion.where(:id => 402, :codigo => "PRP005").first.update_attributes({:nombre => "Ergometría (en pacientes con cardiopatía congénita)"})

    # Espirometría
    prestacion = Prestacion.where(:codigo => "PRP006").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hereditarias
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("R96") # Asma

    # Escisión / Remoción / Toma para biopsia / Punción lumbar
    prestacion = Prestacion.where(:codigo => "PRP007").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Extracción de sangre
    prestacion = Prestacion.where(:codigo => "PRP008").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Incisión / Drenaje / Lavado
    prestacion = Prestacion.where(:codigo => "PRP009").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Inyección / Infiltración local / Venopuntura
    prestacion = Prestacion.where(:codigo => "PRP010").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Medicina física / rehabilitación
    prestacion = Prestacion.where(:id => 628, :codigo => "PRP011").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Pruebas de sensibilización
    prestacion = Prestacion.where(:codigo => "PRP014").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("R96") # Asma

    # Registro de trazados eléctricos cerebrales
    prestacion = Prestacion.where(:codigo => "PRP016").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("N07") # Convulsiones
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Conmoción cerebral

    # Oftalmoscopía
    prestacion = Prestacion.where(:id => 631, :codigo => "PRP017").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Audiometría tonal
    prestacion = Prestacion.where(:codigo => "PRP019").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Fondo de ojo
    prestacion = Prestacion.where(:codigo => "PRP028").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Punción de médula ósea
    prestacion = Prestacion.where(:codigo => "PRP029").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas

    # Punción de médula ósea
    prestacion = Prestacion.where(:id => 636, :codigo => "PRP030").first
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78") # Embarazo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("W84") # Embarazo de alto riesgo

    # Monitoreo fetal anteparto
#    prestacion = Prestacion.create!({
#      :codigo => "PRP031",
#      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P031"),
#      :nombre => 'Monitoreo fetal anteparto',
#      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
#      :concepto_de_facturacion_id => paquete_basico_id,
#      :tipo_de_tratamiento_id => internacion_id
#    })
#    prestacion.sexos << sexo_femenino
#    prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
#    prestacion.diagnosticos << Diagnostico.find_by_codigo!("")
#    AsignacionDePrecios.create!({
#      :precio_por_unidad => 15.0000,
#      :adicional_por_prestacion => 0.0000,
#      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#    })

    # Tartrectomía y cepillado mecánico
#    prestacion = Prestacion.create!({
#      :codigo => "PRP033",
#      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("P033"),
#      :nombre => 'Tartrectomía y cepillado mecánico',
#      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
#      :concepto_de_facturacion_id => paquete_basico_id,
#      :tipo_de_tratamiento_id => ambulatorio_id
#    })
#    prestacion.sexos << sexo_femenino
#    prestacion.grupos_poblacionales << []
#    prestacion.diagnosticos << Diagnostico.find_by_codigo!("")
#    AsignacionDePrecios.create!({
#      :precio_por_unidad => 15.0000,
#      :adicional_por_prestacion => 0.0000,
#      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
#    })

    # Densitometría ósea
    prestacion = Prestacion.where(:codigo => "IGR002").first
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "beneficiaria_mayor_de_49_anios?").first

    # Ecocardiograma (en embarazo con HTA)
    prestacion = Prestacion.where(:codigo => "IGR003").first
    prestacion.update_attributes({:nombre => "Ecocardiograma en embarazo (incluye con fracción de eyección)"})
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.0") # HTA esencial en embarazo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("O10.4") # HTA secundaria en embarazo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("O16") # HTA inducida por el embarazo
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "beneficiaria_embarazada?").first

    # Ecocardiograma (leucemia y linfomas)
    prestacion = Prestacion.create!({
      :codigo => "IGR003",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R003"),
      :nombre => 'Ecocardiograma (incluye con fracción de eyección)',
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas
    AsignacionDePrecios.create!({
      :precio_por_unidad => 50.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Ecocardiograma (CA de cuello / mama)
    prestacion = Prestacion.create!({
      :codigo => "IGR003",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R003"),
      :nombre => 'Ecocardiograma (incluye con fracción de eyección)',
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << [mujeres_de_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75") # Neoplasia maligna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76") # Neoplasia maligna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79") # Neoplasia benigna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80") # Neoplasia benigna cuello
    AsignacionDePrecios.create!({
      :precio_por_unidad => 50.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Ecodoppler en niños menores de 6 años
    prestacion = Prestacion.where(:codigo => "IGR004").first
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("K73") # Anomalías congénitas cardiovasculares
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("K77") # Insuficiencia cardíaca
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("K81") # Soplos cardíacos
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("K83") # Enfermedad de válvula cardíaca

    # Eco bilateral de cadera
    metodo = MetodoDeValidacion.create!(
      {
        :nombre => "Verificar si el beneficiario es menor de tres meses",
        :metodo => "menor_de_tres_meses?",
        :mensaje => "La prestación debería haberse brindado antes de cumplir los tres meses de vida.",
        :genera_error => false
      }
    )
    prestacion = Prestacion.where(:codigo => "IGR005").first
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L30") # Displasia congénita de cadera
    prestacion.metodos_de_validacion << metodo

    # Ecografía cerebral
    prestacion = Prestacion.where(:codigo => "IGR006").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << menores_de_6
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "recien_nacido?").first

    # Ecografía de cuello
    prestacion = Prestacion.where(:codigo => "IGR007").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << adolescentes
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Ecografía de cuello (neoplasias)
    prestacion = Prestacion.create!({
      :codigo => "IGR007",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R007"),
      :nombre => 'Ecografía de cuello (neoplasias)',
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02") # Adenopatías / dolor ganglio linfático
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas
    AsignacionDePrecios.create!({
      :precio_por_unidad => 10.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Ecografía de cuello en recién nacidos
    prestacion = Prestacion.create!({
      :codigo => "IGR007",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R007"),
      :nombre => 'Ecografía de cuello en recién nacido',
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << menores_de_6
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    AsignacionDePrecios.create!({
      :precio_por_unidad => 10.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "recien_nacido?").first

    # Ecografía ginecológica (hemorragias posparto)
    prestacion = Prestacion.where(:id => 368, :codigo => "IGR008").first
    prestacion.update_attributes({:nombre => "Ecografía ginecológica (hemorragias posparto)"})

    # Ecografía ginecológica (de 6 a 9 años)
    prestacion = Prestacion.where(:id => 641, :codigo => "IGR008").first
    prestacion.grupos_poblacionales = de_6_a_9
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79") # Sobrepeso con factores de riesgo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82") # Obesidad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83") # Sobrepeso

    # Ecografía ginecológica (adolescentes)
    prestacion = Prestacion.create!({
      :codigo => "IGR008",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R008"),
      :nombre => 'Ecografía ginecológica',
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << adolescentes
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79") # Sobrepeso con factores de riesgo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82") # Obesidad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83") # Sobrepeso
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z31") # Víctima de violencia sexual
    AsignacionDePrecios.create!({
      :precio_por_unidad => 25.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Ecografía ginecológica (mujeres de 20 a 64)
    prestacion = Prestacion.create!({
      :codigo => "IGR008",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R008"),
      :nombre => 'Ecografía ginecológica',
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_de_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A21") # Factor de riesgo para cáncer
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("W12") # Contracepción intrauterina
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75") # Neoplasia maligna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76") # Neoplasia maligna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79") # Neoplasia benigna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80") # Neoplasia benigna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z31") # Víctima de violencia sexual
    AsignacionDePrecios.create!({
      :precio_por_unidad => 25.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Ecografía mamaria
    prestacion = Prestacion.where(:codigo => "IGR009").first
    prestacion.update_attributes({:nombre => "Ecografía mamaria en embarazo, parto o puerperio"})
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("W78") # Embarazo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("W84") # Embarazo de alto riesgo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("W86") # Puerperio
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "beneficiaria_embarazada?").first

    # Ecografía mamaria (adolescentes)
    prestacion = Prestacion.create!({
      :codigo => "IGR009",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R009"),
      :nombre => 'Ecografía mamaria',
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << adolescentes
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    AsignacionDePrecios.create!({
      :precio_por_unidad => 25.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Ecografía mamaria (mujeres 20 a 64)
    prestacion = Prestacion.create!({
      :codigo => "IGR009",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R009"),
      :nombre => 'Ecografía mamaria',
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_de_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75") # Neoplasia maligna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76") # Neoplasia maligna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79") # Neoplasia benigna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80") # Neoplasia benigna cuello
    AsignacionDePrecios.create!({
      :precio_por_unidad => 25.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Ecografía tiroidea (neonatos)
    prestacion = Prestacion.where(:codigo => "IGR010").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << menores_de_6
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "neonato?").first

    # Ecografía tiroidea (leucemia y linfoma)
    prestacion = Prestacion.create!({
      :codigo => "IGR010",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R010"),
      :nombre => 'Ecografía tiroidea',
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02") # Adenopatías / dolor ganglio linfático
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas
    AsignacionDePrecios.create!({
      :precio_por_unidad => 20.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Fibrocolonoscopía
    prestacion = Prestacion.where(:codigo => "IGR011").first
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_de_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A21") # Factor de riesgo para cáncer
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "beneficiaria_mayor_de_49_anios?").first

    # Fibrogastroscopía
    prestacion = Prestacion.where(:codigo => "IGR012").first
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_de_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A21") # Factor de riesgo para cáncer
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "beneficiaria_mayor_de_49_anios?").first

    # Fibrogastroscopía (intento de suicidio)
    prestacion = Prestacion.create!({
      :codigo => "IGR012",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R012"),
      :nombre => 'Fibrogastroscopía',
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << adolescentes
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("P98") # Suicidio / Intento de suicidio
    AsignacionDePrecios.create!({
      :precio_por_unidad => 100.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Fibrorectosigmoideoscopía
    prestacion = Prestacion.where(:codigo => "IGR013").first
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_de_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A21") # Factor de riesgo para cáncer
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "beneficiaria_mayor_de_49_anios?").first

    # Rx de huesos cortos en menores de 6 años
    prestacion = Prestacion.where(:codigo => "IGR017").first
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L31") # Pie bot
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L74") # Fractura de carpo / tarso / mano /pie
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L77") # Esguince de tobillo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L78") # Esguince de rodilla
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L80") # Luxación y subluxación

    # Rx de codo...
    prestacion = Prestacion.create!({
      :codigo => "IGR017",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R017"),
      :nombre => "Rx de codo, antebrazo, muñeca, mano, dedos, rodilla, pierna, tobillo, pie (total o focalizada), frente y perfil",
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_de_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L74") # Fractura de carpo / tarso / mano /pie
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L77") # Esguince de tobillo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L78") # Esguince de rodilla
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L80") # Luxación y subluxación
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

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
