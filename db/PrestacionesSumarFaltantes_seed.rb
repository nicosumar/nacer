# -*- encoding : utf-8 -*-
ActiveRecord::Base.transaction do

  # Crear nuevas restricciones de claves foráneas
  ActiveRecord::Base.connection.execute "
    ALTER TABLE prestaciones
      ADD CONSTRAINT fk_prestaciones_tipos_de_tratamientos
        FOREIGN KEY (tipo_de_tratamiento_id) REFERENCES tipos_de_tratamientos(id);
  "

  # Acabamos de añadir columnas en una migración, resetear la info en el modelo para evitar fallos
  Prestacion.reset_column_information

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

  # DUPLICAR PRACTICAS COMPLEMENTARIAS DE CCC PARA MÓDULOS CATASTRÓFICOS

  Prestacion.find_by_codigo("XMX001").update_attributes({
    :nombre => "Alprostadil (en módulos I, II, III y IV -no catastróficos-)",
    :es_catastrofica => false
  })

  Prestacion.find_by_codigo("XMX002").update_attributes({
    :nombre => "Óxido nítrico y dispenser para su administración (en módulos I, II, III y IV -no catastróficos-)",
    :es_catastrofica => false
  })

  Prestacion.find_by_codigo("XMX003").update_attributes({
    :nombre => "Levosimedan (en módulos I, II, III y IV -no catastróficos-)",
    :es_catastrofica => false
  })

  Prestacion.find_by_codigo("XMX004").update_attributes({
    :nombre => "Factor VII activado recombinante (en módulos I, II, III y IV -no catastróficos-)",
    :es_catastrofica => false
  })

  Prestacion.find_by_codigo("XMX005").update_attributes({
    :nombre => "Iloprost (en módulos I, II, III y IV -no catastróficos-)",
    :es_catastrofica => false
  })

  Prestacion.find_by_codigo("XMX006").update_attributes({
    :nombre => "Trometanol (en módulos I, II, III y IV -no catastróficos-)",
    :es_catastrofica => false
  })

  Prestacion.find_by_codigo("XMX007").update_attributes({
    :nombre => "Surfactante (en módulos I, II, III y IV -no catastróficos-)",
    :es_catastrofica => false
  })

  Prestacion.find_by_codigo("XMX008").update_attributes({
    :nombre => "Nutrición parenteral total (en módulos I, II, III y IV -no catastróficos-)",
    :es_catastrofica => false
  })

  Prestacion.find_by_codigo("XMX009").update_attributes({
    :nombre => "Prótesis y órtesis (en módulos I, II, III y IV -no catastróficos-)",
    :es_catastrofica => false
  })

  prestacion = Prestacion.create!({
    :codigo => "XMX001",
    :objeto_de_la_prestacion_id => (
      ObjetoDeLaPrestacion.where(:codigo => 'X001', :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo!('XM')).first.id
    ),
    :nombre => 'Alprostadil (en módulos V, VI y VII -catastróficos-)',
    :es_catastrofica => true,
    :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true,
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
    :nombre => 'Óxido nítrico y dispenser para su administración (en módulos V, VI y VII -catastróficos-)',
    :es_catastrofica => true,
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
    :nombre => 'Levosimedan (en módulos V, VI y VII -catastróficos-)',
    :es_catastrofica => true,
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
    :nombre => 'Factor VII activado recombinante (en módulos V, VI y VII -catastróficos-)',
    :es_catastrofica => true,
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
    :nombre => 'Iloprost (en módulos V, VI y VII -catastróficos-)',
    :es_catastrofica => true,
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
    :nombre => 'Trometanol (en módulos V, VI y VII -catastróficos-)',
    :es_catastrofica => true,
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
    :nombre => 'Surfactante (en módulos V, VI y VII -catastróficos-)',
    :es_catastrofica => true,
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
    :nombre => 'Nutrición parenteral total (en módulos V, VI y VII -catastróficos-)',
    :es_catastrofica => true,
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
    :nombre => 'Prótesis y órtesis (en módulos V, VI y VII -catastróficos-)',
    :es_catastrofica => true,
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

  prestacion = Prestacion.where(
    "codigo = 'APA001' AND EXISTS (
       SELECT * FROM diagnosticos_prestaciones JOIN diagnosticos ON (diagnosticos.id = diagnosticos_prestaciones.diagnostico_id)
         WHERE diagnosticos_prestaciones.prestacion_id = prestaciones.id AND diagnosticos.codigo = 'W78'
     )").first
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
end
