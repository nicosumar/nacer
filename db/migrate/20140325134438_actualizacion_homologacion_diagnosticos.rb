# -*- encoding : utf-8 -*-
class ActualizacionHomologacionDiagnosticos < ActiveRecord::Migration
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

    # Obtener el nomenclador
    nomenclador_sumar = Nomenclador.find(5)

    # Corrección de errores existentes en la definición previa del PDSS
    Prestacion.find_by_codigo("LBL133").update_attributes!({
      :nombre => "Frotis de sangre periférica"
    })

    ObjetoDeLaPrestacion.create!({
      #id => 367,
      :nombre => 'Fructosamina',
      :codigo => 'L135',
      :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
      :define_si_es_catastrofica => true,
      :es_catastrofica => false
    })

    prestacion = Prestacion.create!({
      :codigo => "LBL135",
      :objeto_de_la_prestacion_id => ObjetoDeLaPrestacion.id_del_codigo!("L135"),
      :nombre => 'Fructosamina',
      :concepto_de_facturacion_id => paquete_basico.id,
      :tipo_de_tratamiento_id => ambulatorio.id,
      :unidad_de_medida_id => um_unitaria.id, :created_at => ahora, :updated_at => ahora, :activa => true
    })
    prestacion.sexos << [sexo_masculino, sexo_femenino]
    #prestacion.grupos_poblacionales << []
    #prestacion.diagnosticos << Diagnostico.find_by_codigo!("")
    AsignacionDePrecios.create!({
      :precio_por_unidad => 2.5000,
      :adicional_por_prestacion => 0.0000,
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })
    AsignacionDePrecios.create!({
      :precio_por_unidad => 2.5000,
      :adicional_por_prestacion => 0.0000,
      :area_de_prestacion_id => AreaDePrestacion.id_del_codigo!("R"),
      :nomenclador_id => nomenclador_sumar.id, :prestacion_id => prestacion.id, :created_at => ahora, :updated_at => ahora
    })

    # Creación de nuevos diagnósticos de acuerdo a la actualización enviada por mail el 07/02/2014
    Diagnostico.create([
      {
        #:id => 237,
        :nombre => "Fiebre",
        :codigo => "A03"
      },
      {
        #:id => 238,
        :nombre => "Factor de riesgo para cáncer NE",
        :codigo => "A21"
      },
      {
        #:id => 239,
        :nombre => "Factor de riesgo para cáncer NE",
        :codigo => "A21"
      },
      {
        #:id => 240,
        :nombre => "SDR del recién nacido",
        :codigo => "A45"
      },
      {
        #:id => 241,
        :nombre => "Mononucleosis infecciosa",
        :codigo => "A75"
      },
      {
        #:id => 242,
        :nombre => "Traumatismos / lesiones múltiples",
        :codigo => "A81"
      },
      {
        #:id => 243,
        :nombre => "Alergia / reacciones alérgicas NE",
        :codigo => "A92"
      },
      {
        #:id => 244,
        :nombre => "Adenopatía / dolor ganglio linfático",
        :codigo => "B02"
      },
      {
        #:id => 245,
        :nombre => "Anemias hemolíticas hereditarias",
        :codigo => "B78"
      },
      {
        #:id => 246,
        :nombre => "Anemia perniciosa / déficit de folatos",
        :codigo => "B81"
      },
      {
        #:id => 247,
        :nombre => "Otras anemias inespecíficas",
        :codigo => "B82"
      },
      {
        #:id => 248,
        :nombre => "Esplenomegalia",
        :codigo => "B87"
      },
      {
        #:id => 249,
        :nombre => "Dolor abdominal general / retortijones",
        :codigo => "D01"
      },
      {
        #:id => 250,
        :nombre => "Pirosis",
        :codigo => "D03"
      },
      {
        #:id => 251,
        :nombre => "Prurito perianal",
        :codigo => "D05"
      },
      {
        #:id => 252,
        :nombre => "Vómito",
        :codigo => "D10"
      },
      {
        #:id => 253,
        :nombre => "Hepatomegalia",
        :codigo => "D23"
      },
      {
        #:id => 254,
        :nombre => "Enfermedad de los dientes / encías",
        :codigo => "D82"
      },
      {
        #:id => 255,
        :nombre => "Oxiuros / áscaris / otros parásitos",
        :codigo => "D96"
      },
      {
        #:id => 256,
        :nombre => "Otitis media / miringitis aguda",
        :codigo => "H71"
      },
      {
        #:id => 257,
        :nombre => "Otitis media serosa",
        :codigo => "H72"
      },
      {
        #:id => 258,
        :nombre => "Cuerpo extraño en el oído",
        :codigo => "H76"
      },
      {
        #:id => 259,
        :nombre => "Anomalías congénitas cardiovasculares",
        :codigo => "K73"
      },
      {
        #:id => 260,
        :nombre => "Insuficiencia cardíaca",
        :codigo => "K77"
      },
      {
        #:id => 261,
        :nombre => "Soplos cardíacos / arteriales NE",
        :codigo => "K81"
      },
      {
        #:id => 262,
        :nombre => "Enfermedad de válvula cardíaca",
        :codigo => "K83"
      },
      {
        #:id => 263,
        :nombre => "Hemorroides",
        :codigo => "K96"
      },
      {
        #:id => 264,
        :nombre => "Displasia congénita de cadera",
        :codigo => "L30"
      },
      {
        #:id => 265,
        :nombre => "Pie bot",
        :codigo => "L31"
      },
      {
        #:id => 266,
        :nombre => "Fisura labiopalatina / fisura palatina / labio leporino",
        :codigo => "L32"
      },
      {
        #:id => 267,
        :nombre => "Fractura de cúbito / radio",
        :codigo => "L72"
      },
      {
        #:id => 268,
        :nombre => "Fractura de tibia / peroné",
        :codigo => "L73"
      },
      {
        #:id => 269,
        :nombre => "Fractura de carpo / tarso / mano / pie",
        :codigo => "L74"
      },
      {
        #:id => 270,
        :nombre => "Esguinces / distensiones del tobillo",
        :codigo => "L77"
      },
      {
        #:id => 271,
        :nombre => "Esguinces / distensiones de la rodilla",
        :codigo => "L78"
      },
      {
        #:id => 272,
        :nombre => "Luxación y subluxación",
        :codigo => "L80"
      },
      {
        #:id => 273,
        :nombre => "Convulsiones / crisis convulsivas",
        :codigo => "N07"
      },
      {
        #:id => 274,
        :nombre => "Conmoción cerebral / contusión",
        :codigo => "N79"
      },
      {
        #:id => 275,
        :nombre => "Respiración jadeante / sibilante",
        :codigo => "R03"
      },
      {
        #:id => 276,
        :nombre => "Epistaxis / hemorragia nasal",
        :codigo => "R06"
      },
      {
        #:id => 277,
        :nombre => "Faringitis / amigdalitis estreptocócica",
        :codigo => "R72"
      },
      {
        #:id => 278,
        :nombre => "Gripe",
        :codigo => "R80"
      },
      {
        #:id => 279,
        :nombre => "Cuerpo extraño en nariz / laringe / bronquios",
        :codigo => "R87"
      },
      {
        #:id => 280,
        :nombre => "Mordedura humana / animales",
        :codigo => "S13"
      },
      {
        #:id => 281,
        :nombre => "Quemaduras / escaldaduras",
        :codigo => "S14"
      },
      {
        #:id => 282,
        :nombre => "Laceración / herida incisa",
        :codigo => "S18"
      },
      {
        #:id => 283,
        :nombre => "Impétigo",
        :codigo => "S84"
      },
      {
        #:id => 284,
        :nombre => "Deshidratación",
        :codigo => "T11"
      },
      {
        #:id => 285,
        :nombre => "Diabetes insulinodependiente",
        :codigo => "T89"
      },
      {
        #:id => 286,
        :nombre => "Diabetes no insulinodependiente",
        :codigo => "T90"
      },
      {
        #:id => 287,
        :nombre => "Signos / síntomas de los pezones en la mujer",
        :codigo => "X20"
      },
      {
        #:id => 288,
        :nombre => "Lesiones genitales femeninas",
        :codigo => "X82"
      },
      {
        #:id => 289,
        :nombre => "Otros problemas del cuello del útero",
        :codigo => "X85"
      },
      {
        #:id => 290,
        :nombre => "Sífilis, en el varón",
        :codigo => "Y70"
      }
    ])

    # Corrección / creación de nuevos objetos de las prestaciones
    ObjetoDeLaPrestacion.find_by_codigo("K035").update_attributes!({:es_catastrofica => false})

    ObjetoDeLaPrestacion.find_by_codigo("K036").update_attributes!({:es_catastrofica => false})

    ObjetoDeLaPrestacion.find_by_codigo("K037").update_attributes!({:es_catastrofica => false})

    ObjetoDeLaPrestacion.create([
      {
        #:id => 367,
        :nombre => "Dosis aplicada de vacuna neumococo conjugada",
        :codigo => "V015",
        :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
        :define_si_es_catastrofica => true,
        :es_catastrofica => false
      },
      {
        #:id => 368,
        :nombre => "Cardiopatías congénitas - Reoperación",
        :codigo => "K200",
        :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
        :define_si_es_catastrofica => true,
        :es_catastrofica => true
      },
      {
        #:id => 369,
        :nombre => "Cardiopatías congénitas - Reintervención",
        :codigo => "K201",
        :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
        :define_si_es_catastrofica => true,
        :es_catastrofica => true
      }
    ])
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
