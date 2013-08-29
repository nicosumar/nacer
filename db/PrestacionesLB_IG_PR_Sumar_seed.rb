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

  # PRESTACIONES DE LABORATORIO

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

end
