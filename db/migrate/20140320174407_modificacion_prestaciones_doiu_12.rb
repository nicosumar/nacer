# -*- encoding : utf-8 -*-
class ModificacionPrestacionesDoiu12 < ActiveRecord::Migration
  def up
    # Precargamos ciertos datos útiles para no ejecutar tantas consultas a la base
    um_unitaria = UnidadDeMedida.find_by_codigo!("U")
    sexo_femenino = Sexo.find_by_codigo!("F")
    sexo_masculino = Sexo.find_by_codigo!("M")
    menores_de_6 = GrupoPoblacional.find_by_codigo!("A")
    de_6_a_9 = GrupoPoblacional.find_by_codigo!("B")
    adolescentes = GrupoPoblacional.find_by_codigo!("C")
    mujeres_20_a_64 = GrupoPoblacional.find_by_codigo!("D")
    paquete_basico = ConceptoDeFacturacion.find_by_codigo!("BAS")
    ambulatorio = TipoDeTratamiento.find_by_codigo!("A")

    # Determinar la hora y fecha actual
    ahora = DateTime.now()

    # Fecha de publicación de la DOIU Nº 12
    fecha_de_inicio = Date.new(2013, 12, 27)

    # Obtener el nomenclador
    nomenclador_sumar = Nomenclador.find(5)

    prestacion = Prestacion.create!({
      :codigo => "IMV008",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V008"),
      :nombre => 'Dosis aplicada de vacuna triple bacteriana acelular (dTpa)',
      :concepto_de_facturacion_id => paquete_basico.id,
      :tipo_de_tratamiento_id => ambulatorio.id,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
    })
    prestacion.sexos << sexo_femenino
    prestacion.grupos_poblacionales << [adolescentes, mujeres_20_a_64]
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
      :codigo => "IMV011",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("V011"),
      :nombre => 'Dosis aplicada de vacuna doble viral (SR) al ingreso escolar',
      :concepto_de_facturacion_id => paquete_basico.id,
      :tipo_de_tratamiento_id => ambulatorio.id,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
    })
    prestacion.sexos << [sexo_masculino, sexo_femenino]
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

    Prestacion.find_by_codigo("IMV003").update_attributes!({
      :nombre => "Dosis aplicada de inmunización pentavalente en niños de 2, 4, 6 y 18 meses o actualización de esquema"
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
