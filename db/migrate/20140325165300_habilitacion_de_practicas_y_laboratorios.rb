# -*- encoding : utf-8 -*-
class HabilitacionDePracticasYLaboratorios < ActiveRecord::Migration
  def up
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

    # Obtener el nomenclador
    nomenclador_sumar = Nomenclador.find(5)

    # Concepto de facturación
    paquete_basico_id = ConceptoDeFacturacion.find_by_codigo!("BAS").id

    # Tipos de tratamientos
    ambulatorio_id = TipoDeTratamiento.find_by_codigo!("A").id
    internacion_id = TipoDeTratamiento.find_by_codigo!("I").id

    # Área rural
    rural_id = AreaDePrestacion.id_del_codigo!("R")

    # PRÁCTICAS

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
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("N79") # Conmoción cerebral

    # Oftalmoscopía
    prestacion = Prestacion.where(:id => 631, :codigo => "PRP017").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Cambio la descripción del código PRP018
    Prestacion.where(:id => 267, :codigo => "PRP018").first.update_attributes({:nombre => "Toma de muestra para PAP en el embarazo (incluye material descartable)"})

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

    # Cambio la descripción del código PRP034
    Prestacion.where(:codigo => "PRP034").first.update_attributes({:nombre => "Holter de 24 hs (en pacientes con cardiopatía congénita)"})

    # Cambio la descripción del código PRP035
    Prestacion.where(:codigo => "PRP035").first.update_attributes({:nombre => "Presurometría (en pacientes con cardiopatía congénita)"})

    # IMAGENOLOGÍA

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
    prestacion.grupos_poblacionales << [mujeres_20_a_64]
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
    prestacion.grupos_poblacionales = [de_6_a_9]
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
    prestacion.grupos_poblacionales << mujeres_20_a_64
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
    prestacion.grupos_poblacionales << mujeres_20_a_64
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
    prestacion.grupos_poblacionales << mujeres_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A21") # Factor de riesgo para cáncer
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "beneficiaria_mayor_de_49_anios?").first

    # Fibrogastroscopía
    prestacion = Prestacion.where(:codigo => "IGR012").first
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_20_a_64
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
    prestacion.grupos_poblacionales << mujeres_20_a_64
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
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_20_a_64]
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

    # Colon por enema
    prestacion = Prestacion.where(:codigo => "IGR018").first
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A21") # Factor de riesgo para cáncer
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.metodos_de_validacion << MetodoDeValidacion.where(:metodo => "beneficiaria_mayor_de_49_anios?").first

    # Rx de columna cervical
    prestacion = Prestacion.where(:codigo => "IGR019").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Rx de columna dorsal
    prestacion = Prestacion.where(:codigo => "IGR020").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Rx de columna lumbar
    prestacion = Prestacion.where(:codigo => "IGR021").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Rx de cráneo (menores de 6 años)
    prestacion = Prestacion.where(:id => 489, :codigo => "IGR022").first
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L32") # Fisura labiopalatina
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("R87") # Cuerpo extraño en nariz / laringe / bronquios

    # Rx de cráneo (resto de los grupos poblacionales)
    prestacion = Prestacion.create!({
      :codigo => "IGR022",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R022"),
      :nombre => "Rx de cráneo frente y perfil",
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
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

    # Rx de tránsito esófagogastroduodenal
    prestacion = Prestacion.where(:codigo => "IGR023").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Rx de tránsito intestino delgado
    prestacion = Prestacion.where(:codigo => "IGR024").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Rx de huesos largos... (menores de 6 años)
    prestacion = Prestacion.where(:codigo => "IGR025").first
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L72") # Fractura de cúbito / radio
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L73") # Fractura de tibia / peroné
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("L80") # Luxación y subluxación

    # Rx de huesos largos... (resto de los grupos poblacionales)
    prestacion = Prestacion.create!({
      :codigo => "IGR025",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R025"),
      :nombre => "Rx de hombro, húmero, pelvis, cadera y fémur (total o focalizada), frente y perfil",
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
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

    # Rx de tórax (menores de 6 años)
    prestacion = Prestacion.where(:id => 488, :codigo => "IGR026").first
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("R03") # Respiración jadeante / sibilante
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("R72") # Faringitis / amigdalitis estreptocócica
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("R80") # Gripe
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("R87") # Cuerpo extraño en nariz / laringe / bronquios

    # Rx de tórax (resto de los grupos poblacionales)
    prestacion = Prestacion.where(:id => 653, :codigo => "IGR026").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Rx sacrococcígea
    prestacion = Prestacion.where(:codigo => "IGR028").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Rx simple de abdomen
    prestacion = Prestacion.where(:codigo => "IGR029").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Cambio la descripción del código IGR030
    Prestacion.where(:id => 407, :codigo => "IGR030").first.update_attributes({:nombre => "Tomografía axial computada (en pacientes con cardiopatía congénita)"})

    # Tomografía axial computada
    prestacion = Prestacion.where(:id => 656, :codigo => "IGR030").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Ecografía abdominal (de 6 a 9 años)
    prestacion = Prestacion.where(:codigo => "IGR032").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << de_6_a_9
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02") # Adenopatías / dolor ganglio linfático
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79") # Sobrepeso con factores de riesgo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82") # Obesidad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83") # Sobrepeso

    # Ecografía abdominal (adolescentes)
    prestacion = Prestacion.create!({
      :codigo => "IGR032",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R032"),
      :nombre => 'Ecografía abdominal',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << adolescentes
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02") # Adenopatías / dolor ganglio linfático
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("P20") # Abuso agudo de alcohol
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("P23") # Abuso agudo de fármacos
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("P24") # Abuso agudo de drogas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("P98") # Suicidio / Intento de suicidio
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T79") # Sobrepeso con factores de riesgo
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T82") # Obesidad
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("T83") # Sobrepeso
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z31") # Víctima de violencia sexual
    AsignacionDePrecios.create!({
      :precio_por_unidad => 20.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Ecografía abdominal (mujeres de 20 a 64 años)
    prestacion = Prestacion.create!({
      :codigo => "IGR032",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("R032"),
      :nombre => 'Ecografía abdominal',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75") # Neoplasia maligna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76") # Neoplasia maligna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79") # Neoplasia benigna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80") # Neoplasia benigna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("Z31") # Víctima de violencia sexual
    AsignacionDePrecios.create!({
      :precio_por_unidad => 20.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })


    # ANATOMÍA PATOLÓGICA

    # Medulograma
    prestacion = Prestacion.where(:codigo => "APA003").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02") # Adenopatías / dolor ganglio linfático
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas

    # Medulograma
    prestacion = Prestacion.create!({
      :codigo => "APA003",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("A003"),
      :nombre => 'Medulograma (recuento diferencial con tinción de MGG)',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75") # Neoplasia maligna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76") # Neoplasia maligna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79") # Neoplasia benigna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80") # Neoplasia benigna cuello
    AsignacionDePrecios.create!({
      :precio_por_unidad => 150.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })


    # LABORATORIO

    # Cambio la descripción del código LBL002
    Prestacion.where(:id => 338, :codigo => "LBL002").first.update_attributes({:nombre => "Ácido úrico (embarazo de alto riesgo)"})

    # Ácido úrico
    prestacion = Prestacion.where(:id => 662, :codigo => "LBL002").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Habilitación de códigos varios con los mismos sexos, grupos y diagnóstico
    prestacion = Prestacion.where(
      :codigo => [
        "LBL003", "LBL004", "LBL005", "LBL006", "LBL008", "LBL009", "LBL010", "LBL011", "LBL014", "LBL015", "LBL016",
        "LBL017", "LBL018", "LBL019", "LBL020", "LBL024", "LBL026", "LBL027", "LBL028", "LBL029", "LBL030", "LBL034",
        "LBL036", "LBL037", "LBL038", "LBL041", "LBL042", "LBL046", "LBL049", "LBL053", "LBL054", "LBL058", "LBL059",
        "LBL060", "LBL061", "LBL062", "LBL063", "LBL064", "LBL066", "LBL068", "LBL070", "LBL071", "LBL072", "LBL073",
        "LBL074", "LBL075", "LBL076", "LBL077", "LBL081", "LBL082", "LBL083", "LBL084", "LBL085", "LBL086", "LBL087",
        "LBL088", "LBL089", "LBL091", "LBL092", "LBL093", "LBL095", "LBL100", "LBL101", "LBL102", "LBL103", "LBL104",
        "LBL105", "LBL106", "LBL107", "LBL108", "LBL109", "LBL113", "LBL114", "LBL120", "LBL123", "LBL124", "LBL125",
        "LBL126", "LBL127", "LBL129", "LBL130", "LBL134", "LBL135"
      ]
    ).each do |prestacion|
      prestacion.sexos = [sexo_femenino, sexo_masculino]
      prestacion.grupos_poblacionales = [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
      prestacion.diagnosticos = [Diagnostico.find_by_codigo!("A97")] # Sin enfermedad
    end

    # Cambio la descripción del código LBL012
    Prestacion.where(:id => 345, :codigo => "LBL012").first.update_attributes({:nombre => "Bilirrubinas totales y fraccionadas (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL012",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L012"),
      :nombre => 'Bilirrubinas totales y fraccionadas',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL012
    Prestacion.where(:id => 340, :codigo => "LBL021").first.update_attributes({:nombre => "Creatinina en orina (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL021",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L021"),
      :nombre => 'Creatinina en orina',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL012
    Prestacion.where(:id => 339, :codigo => "LBL022").first.update_attributes({:nombre => "Creatinina sérica (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL022",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L022"),
      :nombre => 'Creatinina sérica',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL012
    Prestacion.where(:id => 336, :codigo => "LBL023").first.update_attributes({:nombre => "Coagulograma con fibrinógeno: Cuantificación de fibrinógeno (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL023",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L023"),
      :nombre => 'Coagulograma con fibrinógeno: Cuantificación de fibrinógeno',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
    AsignacionDePrecios.create!({
      :precio_por_unidad => 6.2500,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Cultivo vaginal / Exudado de flujo
    prestacion = Prestacion.where(:codigo => "LBL025").first
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Estudio citoquímico de médula ósea
    prestacion = Prestacion.where(:codigo => "LBL031").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02") # Adenopatías / dolor ganglio linfático
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas

    # Estudio citoquímico de médula ósea
    prestacion = Prestacion.create!({
      :codigo => "LBL031",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L031"),
      :nombre => 'Estudio citoquímico de médula ósea: pas-peroxidasa-esterasas',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75") # Neoplasia maligna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76") # Neoplasia maligna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79") # Neoplasia benigna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80") # Neoplasia benigna cuello
    AsignacionDePrecios.create!({
      :precio_por_unidad => 150.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Estudio citogenético de médula ósea
    prestacion = Prestacion.where(:codigo => "LBL032").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02") # Adenopatías / dolor ganglio linfático
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas

    # Estudio citogenético de médula ósea
    prestacion = Prestacion.create!({
      :codigo => "LBL032",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L032"),
      :nombre => 'Estudio citogenético de médula ósea (técnica de bandeo G)',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75") # Neoplasia maligna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76") # Neoplasia maligna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79") # Neoplasia benigna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80") # Neoplasia benigna cuello
    AsignacionDePrecios.create!({
      :precio_por_unidad => 150.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Estudio genético de médula ósea
    prestacion = Prestacion.where(:codigo => "LBL033").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02") # Adenopatías / dolor ganglio linfático
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas

    # Estudio genético de médula ósea
    prestacion = Prestacion.create!({
      :codigo => "LBL033",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L033"),
      :nombre => 'Estudio de genética molecular de médula ósea (BCR/ABL, MLL/AF4 y TEL/AML1 por técnicas de RT-PCR o Fish)',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75") # Neoplasia maligna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76") # Neoplasia maligna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79") # Neoplasia benigna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80") # Neoplasia benigna cuello
    AsignacionDePrecios.create!({
      :precio_por_unidad => 150.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Cambio la descripción del código LBL040
    Prestacion.where(:id => 343, :codigo => "LBL040").first.update_attributes({:nombre => "Enzimas hepáticas: Fosfatasa alcalina y ácida (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL040",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L040"),
      :nombre => 'Enzimas hepáticas: Fosfatasa alcalina y ácida',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL044
    Prestacion.where(:id => 344, :codigo => "LBL044").first.update_attributes({:nombre => "Enzimas hepáticas: Gamma-GT (Gamma glutamil transpeptidasa) (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL044",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L044"),
      :nombre => 'Enzimas hepáticas: Gamma-GT (Gamma glutamil transpeptidasa)',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL045
    Prestacion.where(:id => 337, :codigo => "LBL045").first.update_attributes({:nombre => "Glucemia (embarazo de alto riesgo)"})

    # Glucemia
    prestacion = Prestacion.where(:id => 697, :codigo => "LBL045").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Grupo y factor
    prestacion = Prestacion.where(:id => 700, :codigo => "LBL050").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Cambio la descripción del código LBL052
    Prestacion.where(:id => 346, :codigo => "LBL052").first.update_attributes({:nombre => "HDL y LDL (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL052",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L052"),
      :nombre => 'HDL y LDL',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Hemoglobina
    prestacion = Prestacion.where(:id => 703, :codigo => "LBL055").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Cambio la descripción del código LBL057
    Prestacion.where(:id => 332, :codigo => "LBL057").first.update_attributes({:nombre => "Hemograma completo (embarazo de alto riesgo)"})

    # Hemograma completo
    prestacion = Prestacion.where(:id => 704, :codigo => "LBL057").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # IFI y hemoaglutinación para Chagas
    prestacion = Prestacion.create!({
      :codigo => "LBL065",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L065"),
      :nombre => 'IFI y hemoaglutinación directa para Chagas',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
    AsignacionDePrecios.create!({
      :precio_por_unidad => 6.2500,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Inmunofenotipo de médula ósea
    prestacion = Prestacion.where(:codigo => "LBL067").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B02") # Adenopatías / dolor ganglio linfático
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B72") # Linfomas
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B73") # Leucemia
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("B78") # Anemias hemolíticas

    # Inmunofenotipo de médula ósea
    prestacion = Prestacion.create!({
      :codigo => "LBL067",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L067"),
      :nombre => 'Inmunofenotipo de médula ósea por citometría de flujo',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << mujeres_20_a_64
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X75") # Neoplasia maligna cuello
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X76") # Neoplasia maligna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X79") # Neoplasia benigna mama
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("X80") # Neoplasia benigna cuello
    AsignacionDePrecios.create!({
      :precio_por_unidad => 150.0000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Cambio la descripción del código LBL069
    Prestacion.where(:id => 333, :codigo => "LBL069").first.update_attributes({:nombre => "Coagulograma con fibrinógeno: KPTT (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL069",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L069"),
      :nombre => 'Coagulograma con fibrinógeno: KPTT',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL057
    Prestacion.where(:id => 347, :codigo => "LBL079").first.update_attributes({:nombre => "Orina completa (embarazo de alto riesgo)"})

    # Orina completa
    prestacion = Prestacion.where(:id => 724, :codigo => "LBL079").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

    # Parasitemia para Chagas
    prestacion = Prestacion.create!({
      :codigo => "LBL080",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L080"),
      :nombre => 'Parasitemia para Chagas',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL090
    Prestacion.where(:id => 341, :codigo => "LBL090").first.update_attributes({:nombre => "Proteinuria (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL090",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L090"),
      :nombre => 'Proteinuria',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL094
    Prestacion.where(:id => 363, :codigo => "LBL094").first.update_attributes({:nombre => "Prueba de tolerancia a la glucosa (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL094",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L094"),
      :nombre => 'Prueba de tolerancia a la glucosa',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Serología para Chagas
    prestacion = Prestacion.create!({
      :codigo => "LBL099",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L099"),
      :nombre => 'Serología para Chagas',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Toxoplasmosis por IFI
    prestacion = Prestacion.create!({
      :codigo => "LBL110",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L110"),
      :nombre => 'Toxoplasmosis por IFI',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
    AsignacionDePrecios.create!({
      :precio_por_unidad => 18.7500,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Toxoplasmosis por MEIA
    prestacion = Prestacion.create!({
      :codigo => "LBL111",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L111"),
      :nombre => 'Toxoplasmosis por MEIA',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
    AsignacionDePrecios.create!({
      :precio_por_unidad => 6.2500,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Enzimas hepáticas: Transaminasas TGO/TGP
    prestacion = Prestacion.create!({
      :codigo => "LBL112",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L112"),
      :nombre => 'Enzimas hepáticas: Transaminasas TGO/TGP',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL117
    Prestacion.where(:id => 361, :codigo => "LBL117").first.update_attributes({:nombre => "Urea (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL117",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L117"),
      :nombre => 'Urea',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL118
    Prestacion.where(:id => 362, :codigo => "LBL118").first.update_attributes({:nombre => "Urocultivo (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL118",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L118"),
      :nombre => 'Urocultivo',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # VDRL
    prestacion = Prestacion.create!({
      :codigo => "LBL119",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L119"),
      :nombre => 'VDRL',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # VIH ELISA
    prestacion = Prestacion.create!({
      :codigo => "LBL121",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L121"),
      :nombre => 'VIH ELISA',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # VIH Western Blot
    prestacion = Prestacion.create!({
      :codigo => "LBL122",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L122"),
      :nombre => 'VIH Western Blot',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Hemoaglutinación indirecta para Chagas
    prestacion = Prestacion.create!({
      :codigo => "LBL128",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L128"),
      :nombre => 'Hemoaglutinación indirecta para Chagas',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL131
    Prestacion.where(:id => 334, :codigo => "LBL131").first.update_attributes({:nombre => "Coagulograma con fibrinógeno: Tiempo de protrombina (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL131",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L131"),
      :nombre => 'Coagulograma con fibrinógeno: Tiempo de protrombina',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL132
    Prestacion.where(:id => 335, :codigo => "LBL132").first.update_attributes({:nombre => "Coagulograma con fibrinógeno: Tiempo de trombina (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL132",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L132"),
      :nombre => 'Coagulograma con fibrinógeno: Tiempo de trombina',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

    # Cambio la descripción del código LBL131
    Prestacion.where(:id => 360, :codigo => "LBL133").first.update_attributes({:nombre => "Frotis de sangre periférica (embarazo de alto riesgo)"})

    prestacion = Prestacion.create!({
      :codigo => "LBL133",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L133"),
      :nombre => 'Frotis de sangre periférica',
      :requiere_historia_clinica => false,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
      :concepto_de_facturacion_id => paquete_basico_id, :es_catastrofica => false,
      :tipo_de_tratamiento_id => ambulatorio_id
    })
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")
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

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
