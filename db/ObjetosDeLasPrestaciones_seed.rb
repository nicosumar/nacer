# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
ObjetoDeLaPrestacion.create([
  {
    #:id => 1,
    :nombre => "Citología",
    :codigo => "A001",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("AP"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 2,
    :nombre => "Examen macro y microscópico de pieza anatómica",
    :codigo => "A002",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("AP"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 3,
    :nombre => "Medulograma",
    :codigo => "A003",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("AP"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 4,
    :nombre => "Materna",
    :codigo => "H001",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("AU"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 5,
    :nombre => "Infantil",
    :codigo => "H002",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("AU"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 6,
    :nombre => "Embarazadas del primer trimestre",
    :codigo => "W001",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CA"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 7,
    :nombre => "Abandono de controles - Embarazadas",
    :codigo => "W002",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CA"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 8,
    :nombre => "Abandono de controles - Niñas y niños hasta los nueve años",
    :codigo => "W003",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CA"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 9,
    :nombre => "Búsqueda activa de embarazadas adolescentes por agente sanitario y/o personal de salud",
    :codigo => "W004",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CA"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 10,
    :nombre => "Búsqueda activa de adolescentes para valoración integral",
    :codigo => "W005",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CA"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 11,
    :nombre => "Población indígena con factores de riesgo",
    :codigo => "W006",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CA"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 12,
    :nombre => "Población general con factores de riesgo",
    :codigo => "W007",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CA"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 13,
    :nombre => "Consulta de primera vez o única",
    :codigo => "C001",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 14,
    :nombre => "Consulta ulterior",
    :codigo => "C002",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 15,
    :nombre => "Consulta de detección temprana del embarazo",
    :codigo => "C003",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 16,
    :nombre => "Consulta preconcepcional de primera vez",
    :codigo => "C004",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 17,
    :nombre => "Consulta obstétrica de primera vez o única",
    :codigo => "C005",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 18,
    :nombre => "Consulta obtétrica ulterior",
    :codigo => "C006",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 19,
    :nombre => "Consulta obstétrica de alto riesgo de primera vez",
    :codigo => "C007",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 20,
    :nombre => "Consulta ginecológica",
    :codigo => "C008",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 21,
    :nombre => "Consulta de control de salud individual para población indígena en terreno",
    :codigo => "C009",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 22,
    :nombre => "Consulta odontológica",
    :codigo => "C010",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 23,
    :nombre => "Consulta oftalmológica",
    :codigo => "C011",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 24,
    :nombre => "Consulta en emergencia/urgencia",
    :codigo => "C012",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 25,
    :nombre => "Consulta preconcepcional ulterior",
    :codigo => "C013",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 26,
    :nombre => "Consulta de salud mental",
    :codigo => "C014",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 27,
    :nombre => "Consulta a trabajador social",
    :codigo => "C015",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 28,
    :nombre => "Consulta con especialista",
    :codigo => "C016",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 29,
    :nombre => "Consulta obstétrica de alto riesgo post-alta",
    :codigo => "C017",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 30,
    :nombre => "Consulta obstétrica inicial - Puerperio",
    :codigo => "C018",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 31,
    :nombre => "Consulta obstétrica ulterior - Puerperio",
    :codigo => "C019",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 32,
    :nombre => "Consulta de seguimiento del recién nacido de alto riesgo - Consulta de ingreso al módulo",
    :codigo => "C020",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 33,
    :nombre => "Consulta de seguimiento del recién nacido de alto riesgo - Consulta de egreso del módulo",
    :codigo => "C021",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 34,
    :nombre => "Consulta obstétrica de alto riesgo ulterior",
    :codigo => "C022",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("CT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 35,
    :nombre => "Relevamiento de datos de población de riesgo por efector (informe final de ronda)",
    :codigo => "Y001",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("DS"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 36,
    :nombre => "Densitometría ósea",
    :codigo => "R002",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 37,
    :nombre => "Ecocardiograma (incluye con fracción de eyección)",
    :codigo => "R003",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 38,
    :nombre => "Eco-Doppler color",
    :codigo => "R004",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 39,
    :nombre => "Ecografía bilateral de caderas (en menores de dos meses)",
    :codigo => "R005",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 40,
    :nombre => "Ecografía cerebral",
    :codigo => "R006",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 41,
    :nombre => "Ecografía de cuello",
    :codigo => "R007",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 42,
    :nombre => "Ecografía ginecológica",
    :codigo => "R008",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 43,
    :nombre => "Ecografía mamaria",
    :codigo => "R009",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 44,
    :nombre => "Ecografía tiroidea",
    :codigo => "R010",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 45,
    :nombre => "Fibrocolonoscopía",
    :codigo => "R011",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 46,
    :nombre => "Fibrogastroscopía",
    :codigo => "R012",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 47,
    :nombre => "Fibrorectosigmoideoscopía",
    :codigo => "R013",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 48,
    :nombre => "Mamografía bilateral cráneo caudal y oblicua, con proyección axilar",
    :codigo => "R014",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 49,
    :nombre => "Mamografía, variedad magnificada",
    :codigo => "R015",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 50,
    :nombre => "Rx de codo, antebrazo, muñeca, mano, dedos, rodilla, pierna, tobillo o pie (total o focalizada), frente y perfil",
    :codigo => "R017",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 51,
    :nombre => "Rx de colon por enema, evacuado e insuflado (con o sin doble contraste)",
    :codigo => "R018",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 52,
    :nombre => "Rx de columna cervical (total o focalizada), frente y perfil",
    :codigo => "R019",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 53,
    :nombre => "Rx de columna dorsal (total o focalizada), frente y perfil",
    :codigo => "R020",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 54,
    :nombre => "Rx de columna lumbar (total o focalizada), frente y perfil",
    :codigo => "R021",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 55,
    :nombre => "Rx de cráneo, frente y perfil / Rx de senos paranasales",
    :codigo => "R022",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 56,
    :nombre => "Rx de estudio seriado del tránsito esófagogastroduodenal contrastado",
    :codigo => "R023",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 57,
    :nombre => "Rx de estudio del tránsito de intestino delgado y cecoapendicular",
    :codigo => "R024",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 58,
    :nombre => "Rx de hombro, húmero, pelvis y fémur (total o focalizada), frente y perfil",
    :codigo => "R025",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 59,
    :nombre => "Rx o Tele-Rx de tórax (total o focalizada), frente y perfil",
    :codigo => "R026",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 60,
    :nombre => "Rx sacrococcígea (total o focalizada) frente y perfil",
    :codigo => "R028",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 61,
    :nombre => "Rx simple de abdomen, frente y perfil",
    :codigo => "R029",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 62,
    :nombre => "Tomografía axial computada (TAC)",
    :codigo => "R030",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 63,
    :nombre => "Ecografía obstétrica",
    :codigo => "R031",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 64,
    :nombre => "Ecografía abdominal",
    :codigo => "R032",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 65,
    :nombre => "Eco-Doppler fetal",
    :codigo => "R037",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 66,
    :nombre => "Ecografía renal",
    :codigo => "R038",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 67,
    :nombre => "Ecocardiograma fetal",
    :codigo => "R039",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 68,
    :nombre => "Hemodinamia diagnóstica",
    :codigo => "R040",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 69,
    :nombre => "Resonancia magnética nuclear (RMN)",
    :codigo => "R041",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IG"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 70,
    :nombre => "Incubadora por 48 horas",
    :codigo => "I001",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IC"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 71,
    :nombre => "Dosis aplicada de triple viral",
    :codigo => "V001",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 72,
    :nombre => "Dosis aplicada de Sabin",
    :codigo => "V002",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 73,
    :nombre => "Dosis aplicada de pentavalente",
    :codigo => "V003",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 74,
    :nombre => "Dosis aplicada de cuádruple",
    :codigo => "V004",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 75,
    :nombre => "Dosis aplicada de hepatitis A",
    :codigo => "V005",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 76,
    :nombre => "Dosis aplicada de triple bacteriana celular",
    :codigo => "V006",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 77,
    :nombre => "Dosis aplicada de anti-amarílica",
    :codigo => "V007",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 78,
    :nombre => "Dosis aplicada de DTAP triple acelular",
    :codigo => "V008",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 79,
    :nombre => "Dosis aplicada de anti-hepatitis B monovalente",
    :codigo => "V009",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 80,
    :nombre => "Dosis aplicada de doble para adultos",
    :codigo => "V010",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 81,
    :nombre => "Dosis aplicada de doble viral",
    :codigo => "V011",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 82,
    :nombre => "Dosis aplicada de BCG",
    :codigo => "V012",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 83,
    :nombre => "Dosis aplicada de vacuna antigripal",
    :codigo => "V013",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 84,
    :nombre => "Dosis aplicada de vacuna contra VPH en niñas de 11 años",
    :codigo => "V014",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IM"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 85,
    :nombre => "Clínica pediátrica - Menos de 16 horas",
    :codigo => "E001",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 86,
    :nombre => "Clínica pediátrica - Entre 16 y 48 horas",
    :codigo => "E002",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 87,
    :nombre => "Clínica pediátrica - 48 horas o más",
    :codigo => "E003",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 88,
    :nombre => "Clínica obstétrica - Primer trimestre",
    :codigo => "E004",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 89,
    :nombre => "Clínica obstétrica - Segundo trimestre",
    :codigo => "E005",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 90,
    :nombre => "Clínica obstétrica - Tercer trimestre",
    :codigo => "E006",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 91,
    :nombre => "Clínica obstétrica - Alto riesgo - Módulo de emergencias hipertensivas",
    :codigo => "E007",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 92,
    :nombre => "Clínica obstétrica - Alto riesgo - Módulo de amenaza de parto prematuro",
    :codigo => "E008",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 93,
    :nombre => "Clínica obstétrica - Alto riesgo - Módulo de diabetes gestacional",
    :codigo => "E009",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 94,
    :nombre => "Clínica obstétrica - Alto riesgo - Hospital de día - Módulo de diabetes gestacional",
    :codigo => "E010",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 95,
    :nombre => "Clínica obstétrica - Alto riesgo - Hospital de día - Módulo de hipertensión en el embarazo",
    :codigo => "E011",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 96,
    :nombre => "Clínica obstétrica - Alto riesgo - Hospital de día - Módulo de restricción del crecimiento intauterino - Pequeño para edad gestacional",
    :codigo => "E012",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 97,
    :nombre => "Clínica neonatológica - Módulo RNPT (500 a 1500 gramos) con requerimiento de ARM o CPAP",
    :codigo => "E013",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 98,
    :nombre => "Clínica neonatológica - Módulo RNPT (500 a 1500 gramos) sin requerimiento de ARM o CPAP",
    :codigo => "E014",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 99,
    :nombre => "Clínica obstétrica - Alto riesgo - Hospital de día - Módulo de diabetes gestacional compensada no insulino-dependiente",
    :codigo => "E015",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 100,
    :nombre => "Clínica obstétrica - Alto riesgo - Hospital de día - Módulo de hipertensión gestacional no proteinúrica",
    :codigo => "E016",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 101,
    :nombre => "Quirúrgica - Parto vaginal normal o instrumental",
    :codigo => "Q001",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 102,
    :nombre => "Quirúrgica - Cesárea",
    :codigo => "Q002",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 103,
    :nombre => "Quirúrgica - Cirugía del embarazo ectópico",
    :codigo => "Q003",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 104,
    :nombre => "Quirúrgica - Histerectomía por complicaciones del parto o puerperio",
    :codigo => "Q004",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 105,
    :nombre => "Quirúrgica - Tratamiento quirúrgico de hemorragias del primer trimestre",
    :codigo => "Q005",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 106,
    :nombre => "Quirúrgica - Tratamiento quirúrgico de hemorragias del segundo trimestre",
    :codigo => "Q006",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 107,
    :nombre => "Quirúrgica - Tratamiento quirúrgico de hemorragias del tercer trimestre",
    :codigo => "Q007",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 108,
    :nombre => "Quirúrgica obstétrica - Alto riesgo - Módulo de hemorragia posparto",
    :codigo => "Q008",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 109,
    :nombre => "Quirúrgica neonatal - Módulo de atresia esofágica",
    :codigo => "Q009",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 110,
    :nombre => "Quirúrgica neonatal - Módulo de gastrosquisis",
    :codigo => "Q010",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 111,
    :nombre => "Quirúrgica neonatal - Módulo de oclusión intestinal",
    :codigo => "Q011",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 112,
    :nombre => "Quirúrgica neonatal - Módulo de malformación anorrectal",
    :codigo => "Q012",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 113,
    :nombre => "Quirúrgica neonatal - Módulo de mielomeningocele",
    :codigo => "Q013",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 114,
    :nombre => "Quirúrgica neonatal - Módulo de hidrocefalia congénita",
    :codigo => "Q014",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 115,
    :nombre => "Cardiopatías congénitas - Módulo I - Cierre de ductus con cirugía convencional",
    :codigo => "K001",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 116,
    :nombre => "Cardiopatías congénitas - Módulo I - Cerclaje de arteria pulmonar con cirugía convencional",
    :codigo => "K002",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 117,
    :nombre => "Cardiopatías congénitas - Módulo I - Anastomosis sublcavio-pulmonar con cirugía convencional",
    :codigo => "K003",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 118,
    :nombre => "Cardiopatías congénitas - Módulo I - Corrección de coartación de la aorta con cirugía convencional",
    :codigo => "K004",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 119,
    :nombre => "Cardiopatías congénitas - Módulo I - Cierre de ductus con hemodinamia intervencionista",
    :codigo => "K005",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 120,
    :nombre => "Cardiopatías congénitas - Módulo I - Corrección de coartación de la aorta con hemodinamia intervencionista",
    :codigo => "K006",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 121,
    :nombre => "Cardiopatías congénitas - Módulo I - Cierre de canal intra-auricular con hemodinamia intervencionista",
    :codigo => "K007",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 122,
    :nombre => "Cardiopatías congénitas - Módulo I - Cierre de canal intra-ventricular con hemodinamia intervencionista",
    :codigo => "K008",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 123,
    :nombre => "Cardiopatías congénitas - Módulo I - Colocación de Stent en ramas pulmonares con hemodinamia intervencionista",
    :codigo => "K009",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 124,
    :nombre => "Cardiopatías congénitas - Módulo I - Embolización de colaterales de ramas pulmonares con hemodinamia intervencionista",
    :codigo => "K010",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 125,
    :nombre => "Cardiopatías congénitas - Módulo II - Cierre de ductus",
    :codigo => "K011",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 126,
    :nombre => "Cardiopatías congénitas - Módulo II - Cerclaje de arteria pulmonar",
    :codigo => "K012",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 127,
    :nombre => "Cardiopatías congénitas - Módulo II - Anastomosis sublcavio-pulmonar",
    :codigo => "K013",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 128,
    :nombre => "Cardiopatías congénitas - Módulo II - Corrección de coartación de la aorta",
    :codigo => "K014",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 129,
    :nombre => "Cardiopatías congénitas - Módulo III - Cirugía de Glenn",
    :codigo => "K015",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 130,
    :nombre => "Cardiopatías congénitas - Módulo III - Cierre de canal intra-auricular",
    :codigo => "K016",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 131,
    :nombre => "Cardiopatías congénitas - Módulo IV - Cierre de canal intra-ventricular",
    :codigo => "K017",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #:id => 132,
    :nombre => "Cardiopatías congénitas - Módulo V - Corrección de canal aurículo-ventricular",
    :codigo => "K018",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 133,
    :nombre => "Cardiopatías congénitas - Módulo V - Correctora de Fallot",
    :codigo => "K019",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 134,
    :nombre => "Cardiopatías congénitas - Módulo V - Correctora de doble salida de ventrículo derecho",
    :codigo => "K020",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 135,
    :nombre => "Cardiopatías congénitas - Módulo V - Cirugía de Fontan o by-pass total",
    :codigo => "K021",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 136,
    :nombre => "Cardiopatías congénitas - Módulo V - Cierre de canal intra-ventricular y del defecto asociado",
    :codigo => "K022",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 137,
    :nombre => "Cardiopatías congénitas - Módulo V - Reemplazo o plástica valvular con prótesis u homoinjerto, cirugía de Ross",
    :codigo => "K023",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 138,
    :nombre => "Cardiopatías congénitas - Módulo V - Cirugía de Rastelli",
    :codigo => "K024",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 139,
    :nombre => "Cardiopatías congénitas - Módulo VI - Switch arterial - Nikeido - Doble switch",
    :codigo => "K025",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 140,
    :nombre => "Cardiopatías congénitas - Módulo VI - Plástica o reemplazo valvular",
    :codigo => "K026",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 141,
    :nombre => "Cardiopatías congénitas - Módulo VI - Cierre de canal intra-ventricular más colocación de homoinjerto - Recambio de homoinjerto - Colocación de tubo con unifocalización",
    :codigo => "K027",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 142,
    :nombre => "Cardiopatías congénitas - Módulo VI - Correctora de tronco arterioso",
    :codigo => "K028",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 143,
    :nombre => "Cardiopatías congénitas - Módulo VI - Correctora de ATRVP",
    :codigo => "K029",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 144,
    :nombre => "Cardiopatías congénitas - Módulo VI - Cirugía de Stansel con anastomosis - Glenn o Sano",
    :codigo => "K030",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 145,
    :nombre => "Cardiopatías congénitas - Módulo VI - Reconstrucción del arco aórtico",
    :codigo => "K031",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 146,
    :nombre => "Cardiopatías congénitas - Módulo VII - Norwood o Sano",
    :codigo => "K032",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 147,
    :nombre => "Cardiopatías congénitas - Módulo VII - Glenn",
    :codigo => "K033",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #:id => 148,
    :nombre => "Cardiopatías congénitas - Módulo VII - Fontan",
    :codigo => "K034",
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo("IT"),
    :define_si_es_catastrofica => true,
    :es_catastrofica => true
  },
  {
    #id => 149,
    :nombre => '17 Hidroxiprogesterona',
    :codigo => 'L001',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 150,
    :nombre => 'Ácido úrico',
    :codigo => 'L002',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 151,
    :nombre => 'Ácidos biliares',
    :codigo => 'L003',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 152,
    :nombre => 'Amilasa pancreática',
    :codigo => 'L004',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 153,
    :nombre => 'Antibiograma micobacterias',
    :codigo => 'L005',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 154,
    :nombre => 'Anticuerpos antitreponémicos',
    :codigo => 'L006',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 155,
    :nombre => 'Antígeno prostático específico',
    :codigo => 'L007',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 156,
    :nombre => 'Apolipoproteína B',
    :codigo => 'L008',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 157,
    :nombre => 'ASTO',
    :codigo => 'L009',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 158,
    :nombre => 'Baciloscopía',
    :codigo => 'L010',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 159,
    :nombre => 'Bacteriología directa y cultivo',
    :codigo => 'L011',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 160,
    :nombre => 'Bilirrubinas totales y fraccionadas',
    :codigo => 'L012',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 161,
    :nombre => 'Biotinidasa neonatal',
    :codigo => 'L013',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 162,
    :nombre => 'Calcemia',
    :codigo => 'L014',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 163,
    :nombre => 'Calciuria',
    :codigo => 'L015',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 164,
    :nombre => 'Campo oscuro',
    :codigo => 'L016',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 165,
    :nombre => 'Citología',
    :codigo => 'L017',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 166,
    :nombre => 'Colesterol',
    :codigo => 'L018',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 167,
    :nombre => 'Coprocultivo',
    :codigo => 'L019',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 168,
    :nombre => 'CPK',
    :codigo => 'L020',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 169,
    :nombre => 'Creatinina en orina',
    :codigo => 'L021',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 170,
    :nombre => 'Creatinina sérica',
    :codigo => 'L022',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 171,
    :nombre => 'Cuantificación fibrinógeno',
    :codigo => 'L023',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 172,
    :nombre => 'Cultivo Streptococo B hemolítico',
    :codigo => 'L024',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 173,
    :nombre => 'Cultivo vaginal. Exudado flujo',
    :codigo => 'L025',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 174,
    :nombre => 'Cultivo y antibiograma general',
    :codigo => 'L026',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 175,
    :nombre => 'Electroforesis de proteínas',
    :codigo => 'L027',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 176,
    :nombre => 'Eritrosedimentación',
    :codigo => 'L028',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 177,
    :nombre => 'Esputo seriado',
    :codigo => 'L029',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 178,
    :nombre => 'Estado ácido base',
    :codigo => 'L030',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 179,
    :nombre => 'Estudio citoquímico de médula ósea: pas-peroxidasa-esterasas',
    :codigo => 'L031',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 180,
    :nombre => 'Estudio citogenético de médula ósea (técnica de bandeo G)',
    :codigo => 'L032',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 181,
    :nombre => 'Estudio de genética molecular de médula ósea (BCR/ABL, MLL/AF4 y TEL/AML1 por técnicas de RT-PCR o Fish)',
    :codigo => 'L033',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 182,
    :nombre => 'Factor de coagulación 5, 7, 8, 9 y 10',
    :codigo => 'L034',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 183,
    :nombre => 'Fenilalanina',
    :codigo => 'L035',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 184,
    :nombre => 'Fenilcetonuria',
    :codigo => 'L036',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 185,
    :nombre => 'Ferremia',
    :codigo => 'L037',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 186,
    :nombre => 'Ferritina',
    :codigo => 'L038',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 187,
    :nombre => 'Fibrinógeno',
    :codigo => 'L039',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 188,
    :nombre => 'Fosfatasa alcalina y ácida',
    :codigo => 'L040',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 189,
    :nombre => 'Fosfatemia',
    :codigo => 'L041',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 190,
    :nombre => 'FSH',
    :codigo => 'L042',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 191,
    :nombre => 'Galactosemia',
    :codigo => 'L043',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 192,
    :nombre => 'Gamma-GT (Gamma glutamil transpeptidasa)',
    :codigo => 'L044',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 193,
    :nombre => 'Glucemia',
    :codigo => 'L045',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 194,
    :nombre => 'Glucosuria',
    :codigo => 'L046',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 195,
    :nombre => 'Gonadotrofina coriónica humana en sangre',
    :codigo => 'L047',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 196,
    :nombre => 'Gonadotrofina coriónica humana en orina',
    :codigo => 'L048',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 197,
    :nombre => 'Grasas en material fecal cualitativa',
    :codigo => 'L049',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 198,
    :nombre => 'Grupo y factor',
    :codigo => 'L050',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 199,
    :nombre => 'Hbs Ag',
    :codigo => 'L051',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 200,
    :nombre => 'HDL y LDL',
    :codigo => 'L052',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 201,
    :nombre => 'Hematocrito',
    :codigo => 'L053',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 202,
    :nombre => 'Hemocultivo aerobio-anaerobio',
    :codigo => 'L054',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 203,
    :nombre => 'Hemoglobina',
    :codigo => 'L055',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 204,
    :nombre => 'Hemoglobina glicosilada',
    :codigo => 'L056',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 205,
    :nombre => 'Hemograma completo',
    :codigo => 'L057',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 206,
    :nombre => 'Hepatitis B anti HBS - Anticore total',
    :codigo => 'L058',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 207,
    :nombre => 'Hepatograma',
    :codigo => 'L059',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 208,
    :nombre => 'Hidatidosis por hemoaglutinación',
    :codigo => 'L060',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 209,
    :nombre => 'Hidatidosis por IFI',
    :codigo => 'L061',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 210,
    :nombre => 'Hisopado de fauces',
    :codigo => 'L062',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 211,
    :nombre => 'Homocistina',
    :codigo => 'L063',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 211,
    :nombre => 'IFI infecciones respiratorias',
    :codigo => 'L064',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 212,
    :nombre => 'IFI y hemoaglutinación directa para Chagas',
    :codigo => 'L065',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 213,
    :nombre => 'Insulinemia basal',
    :codigo => 'L066',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 214,
    :nombre => 'Inmunofenotipo de médula ósea por citometría de flujo',
    :codigo => 'L067',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 215,
    :nombre => 'Ionograma plasmático y orina',
    :codigo => 'L068',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 216,
    :nombre => 'KPTT',
    :codigo => 'L069',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 217,
    :nombre => 'LDH',
    :codigo => 'L070',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 218,
    :nombre => 'Leucocitos en material fecal',
    :codigo => 'L071',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 219,
    :nombre => 'LH',
    :codigo => 'L072',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 220,
    :nombre => 'Lipidograma electroforético',
    :codigo => 'L073',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 221,
    :nombre => 'Líquido cefalorraquídeo citoquímico y bacteriológico',
    :codigo => 'L074',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 222,
    :nombre => 'Líquido cefalorraquídeo - Recuento celular (cámara), citología (MGG, Cytospin) e histoquímica',
    :codigo => 'L075',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 223,
    :nombre => 'Micológico',
    :codigo => 'L076',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 224,
    :nombre => 'Microalbuminuria',
    :codigo => 'L077',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 225,
    :nombre => 'Monotest',
    :codigo => 'L078',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 226,
    :nombre => 'Orina completa',
    :codigo => 'L079',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 227,
    :nombre => 'Parasitemia para Chagas',
    :codigo => 'L080',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 228,
    :nombre => 'Parasitológico de materia fecal',
    :codigo => 'L081',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 229,
    :nombre => 'PH en materia fecal',
    :codigo => 'L082',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 230,
    :nombre => 'Porcentaje de saturación de hierro funcional',
    :codigo => 'L083',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 231,
    :nombre => 'PPD',
    :codigo => 'L084',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 232,
    :nombre => 'Productos de degradación del fibrinógeno (PDF)',
    :codigo => 'L085',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 233,
    :nombre => 'Progesterona',
    :codigo => 'L086',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 234,
    :nombre => 'Prolactina',
    :codigo => 'L087',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 235,
    :nombre => 'Proteína C reactiva',
    :codigo => 'L088',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 236,
    :nombre => 'Proteínas totales y fraccionadas',
    :codigo => 'L089',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 237,
    :nombre => 'Proteinuria',
    :codigo => 'L090',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 238,
    :nombre => 'Protoporfirina libre eritrocitaria',
    :codigo => 'L091',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 239,
    :nombre => 'Prueba de Coombs directa',
    :codigo => 'L092',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 240,
    :nombre => 'Prueba de Coombs indirecta cuantitativa',
    :codigo => 'L093',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 241,
    :nombre => 'Prueba de tolerancia a la glucosa',
    :codigo => 'L094',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 242,
    :nombre => 'Reacción de Hudleson',
    :codigo => 'L095',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 243,
    :nombre => 'Reacción de Widal',
    :codigo => 'L096',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 244,
    :nombre => 'Receptores libres de transferrina',
    :codigo => 'L097',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 245,
    :nombre => 'Sangre oculta en heces',
    :codigo => 'L098',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 246,
    :nombre => 'Serología para Chagas (Elisa)',
    :codigo => 'L099',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 247,
    :nombre => 'Serología para hepatitis A IgM',
    :codigo => 'L100',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 248,
    :nombre => 'Serología para hepatitis A total',
    :codigo => 'L101',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 249,
    :nombre => 'Serología para rubéola IgM',
    :codigo => 'L102',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 250,
    :nombre => 'Sideremia',
    :codigo => 'L103',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 251,
    :nombre => 'T3',
    :codigo => 'L104',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 252,
    :nombre => 'T4 libre',
    :codigo => 'L105',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 253,
    :nombre => 'Test de Graham',
    :codigo => 'L106',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 254,
    :nombre => 'Test de látex',
    :codigo => 'L107',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 255,
    :nombre => 'TIBC',
    :codigo => 'L108',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 256,
    :nombre => 'Tiempo de lisis de euglobulina',
    :codigo => 'L109',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 257,
    :nombre => 'Toxoplasmosis por IFI',
    :codigo => 'L110',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 258,
    :nombre => 'Toxoplasmosis por MEIA',
    :codigo => 'L111',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 259,
    :nombre => 'Transaminasas TGO/TGP',
    :codigo => 'L112',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 260,
    :nombre => 'Transferrinas',
    :codigo => 'L113',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 261,
    :nombre => 'Triglicéridos',
    :codigo => 'L114',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 262,
    :nombre => 'Tripsina catiónica inmunorreactiv',
    :codigo => 'L115',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 263,
    :nombre => 'TSH',
    :codigo => 'L116',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 264,
    :nombre => 'Urea',
    :codigo => 'L117',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 265,
    :nombre => 'Urocultivo',
    :codigo => 'L118',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 266,
    :nombre => 'VDRL',
    :codigo => 'L119',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 267,
    :nombre => 'Vibrio choleræ. Cultivo e identificación',
    :codigo => 'L120',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 268,
    :nombre => 'VIH Elisa',
    :codigo => 'L121',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 269,
    :nombre => 'VIH Western Blot',
    :codigo => 'L122',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 270,
    :nombre => 'Serología para hepatitis C',
    :codigo => 'L123',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 271,
    :nombre => 'Magnesemia',
    :codigo => 'L124',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 272,
    :nombre => 'Serología LCR',
    :codigo => 'L125',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 273,
    :nombre => 'Recuento de plaquetas',
    :codigo => 'L126',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 274,
    :nombre => 'Antígeno P24',
    :codigo => 'L127',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 275,
    :nombre => 'Hemoaglutinación indirecta Chagas',
    :codigo => 'L128',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 276,
    :nombre => 'IgE sérica',
    :codigo => 'L129',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 277,
    :nombre => 'Tiempo de coagulación y sangría',
    :codigo => 'L130',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 278,
    :nombre => 'Tiempo de protrombina',
    :codigo => 'L131',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 279,
    :nombre => 'Tiempo de trombina',
    :codigo => 'L132',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 280,
    :nombre => 'Frotis de sangre periférica',
    :codigo => 'L133',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 281,
    :nombre => 'Recuento reticulocitario',
    :codigo => 'L134',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('LB'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 282,
    :nombre => 'Alprostadil',
    :codigo => 'X001',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('XM'),
    :define_si_es_catastrofica => false,
    :es_catastrofica => false
  },
  {
    #id => 283,
    :nombre => 'Óxido nítrico y dispenser para su administración',
    :codigo => 'X002',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('XM'),
    :define_si_es_catastrofica => false,
    :es_catastrofica => false
  },
  {
    #id => 284,
    :nombre => 'Levosimedan',
    :codigo => 'X003',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('XM'),
    :define_si_es_catastrofica => false,
    :es_catastrofica => false
  },
  {
    #id => 285,
    :nombre => 'Factor VII activado recombinante',
    :codigo => 'X004',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('XM'),
    :define_si_es_catastrofica => false,
    :es_catastrofica => false
  },
  {
    #id => 286,
    :nombre => 'Iloprost',
    :codigo => 'X005',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('XM'),
    :define_si_es_catastrofica => false,
    :es_catastrofica => false
  },
  {
    #id => 287,
    :nombre => 'Trometanol',
    :codigo => 'X006',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('XM'),
    :define_si_es_catastrofica => false,
    :es_catastrofica => false
  },
  {
    #id => 288,
    :nombre => 'Surfactante',
    :codigo => 'X007',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('XM'),
    :define_si_es_catastrofica => false,
    :es_catastrofica => false
  },
  {
    #id => 289,
    :nombre => 'Nutrición parenteral total',
    :codigo => 'X008',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('XM'),
    :define_si_es_catastrofica => false,
    :es_catastrofica => false
  },
  {
    #id => 290,
    :nombre => 'Prótesis y órtesis biológica, homoinjerto, parche de Goretex o Dacron, tubo de Goretex',
    :codigo => 'X009',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('XM'),
    :define_si_es_catastrofica => false,
    :es_catastrofica => false
  },
  {
    #id => 291,
    :nombre => 'De caso positivo de muestra citológica',
    :codigo => 'N001',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('NT'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 292,
    :nombre => 'De inicio de tratamiento',
    :codigo => 'N002',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('NT'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 293,
    :nombre => 'De caso positivo de biopsia',
    :codigo => 'N003',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('NT'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 294,
    :nombre => 'Consulta de notificación de riesgo',
    :codigo => 'N004',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('NT'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 295,
    :nombre => 'Referencia oportuna por embarazo de alto riesgo de nivel 2 o 3 a niveles de complejidad superiores',
    :codigo => 'N006',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('NT'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 296,
    :nombre => 'Acceso vascular central o periférico por cateterismo',
    :codigo => 'P001',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 297,
    :nombre => 'Colposcopía',
    :codigo => 'P002',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 298,
    :nombre => 'Colocación de DIU',
    :codigo => 'P003',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 299,
    :nombre => 'Electrocardiograma',
    :codigo => 'P004',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 300,
    :nombre => 'Ergometría',
    :codigo => 'P005',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 301,
    :nombre => 'Espirometría',
    :codigo => 'P006',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 302,
    :nombre => 'Escisión / Remoción / Toma para biopsia / Punción lumbar',
    :codigo => 'P007',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 303,
    :nombre => 'Extracción de sangre',
    :codigo => 'P008',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 304,
    :nombre => 'Incisión / Drenaje / Lavado',
    :codigo => 'P009',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 305,
    :nombre => 'Inyección / Infiltración local / Venopuntura',
    :codigo => 'P010',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 306,
    :nombre => 'Medicina física / Rehabilitación',
    :codigo => 'P011',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 307,
    :nombre => 'Pruebas de sensibilización',
    :codigo => 'P014',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 308,
    :nombre => 'Registro de trazados eléctricos cerebrales',
    :codigo => 'P016',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 309,
    :nombre => 'Oftalmoscopía binocular indirecta (OBI)',
    :codigo => 'P017',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 310,
    :nombre => 'Toma para citología exfoliativa/histológica',
    :codigo => 'P018',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 311,
    :nombre => 'Audiometría tonal',
    :codigo => 'P019',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 312,
    :nombre => 'Logoaudiometría',
    :codigo => 'P020',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 313,
    :nombre => 'Otoemisiones acústicas',
    :codigo => 'P021',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 314,
    :nombre => 'Potenciales evocados',
    :codigo => 'P022',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 315,
    :nombre => 'Sellado de surcos',
    :codigo => 'P024',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 316,
    :nombre => 'Barniz fluorado de surcos',
    :codigo => 'P025',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 317,
    :nombre => 'Inactivación de caries',
    :codigo => 'P026',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 318,
    :nombre => 'Barniz fluorado (embarazadas)',
    :codigo => 'P027',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 319,
    :nombre => 'Fondo de ojo',
    :codigo => 'P028',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 320,
    :nombre => 'Punción de médula ósea',
    :codigo => 'P029',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 321,
    :nombre => 'Uso de tirillas reactivas para determinación rápida de proteinuria',
    :codigo => 'P030',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 322,
    :nombre => 'Monitoreo fetal anteparto',
    :codigo => 'P031',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 323,
    :nombre => 'Oftalmoscopía directa (examen de fondo de ojo)',
    :codigo => 'P032',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 324,
    :nombre => 'Tartrectomía y cepillado mecánico',
    :codigo => 'P033',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 325,
    :nombre => 'Holter de 24 horas',
    :codigo => 'P034',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 326,
    :nombre => 'Presurometría',
    :codigo => 'P035',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('PR'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 327,
    :nombre => 'Ronda rural',
    :codigo => 'X001',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('RO'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 328,
    :nombre => 'Ronda en poblaciones indígenas',
    :codigo => 'X002',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('RO'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 329,
    :nombre => 'Promoción de salud sexual y reproductiva, conductas saludables, hábitos de higiene',
    :codigo => 'T001',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 330,
    :nombre => 'Promoción de pautas alimentarias en embarazadas, puérperas y niños menores de 6 años',
    :codigo => 'T002',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 331,
    :nombre => 'Promoción del desarrollo infantil, prevención de patologías prevalentes en la infancia, conductas saludables, hábitos de higiene',
    :codigo => 'T003',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 332,
    :nombre => 'Pautas nutricionales respetando la cultura alimentaria de comunidades indígenas',
    :codigo => 'T004',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 333,
    :nombre => 'Prevención de accidentes',
    :codigo => 'T005',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 334,
    :nombre => 'Prevención de accidentes domésticos',
    :codigo => 'T006',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 335,
    :nombre => 'Prevención de HIV e infecciones de transmisión sexual',
    :codigo => 'T007',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 336,
    :nombre => 'Prevención de violencia de género',
    :codigo => 'T008',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 337,
    :nombre => 'Prevención de violencia familiar',
    :codigo => 'T009',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 338,
    :nombre => 'Prevención de comportamientos adictivos: tabaquismo, uso de drogas y alcoholismo',
    :codigo => 'T010',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 339,
    :nombre => 'Promoción de hábitos saludables: salud bucal, educación alimentaria, pautas de higiene, trastornos de la alimentación',
    :codigo => 'T011',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 340,
    :nombre => 'Promoción de pautas alimentarias',
    :codigo => 'T012',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 341,
    :nombre => 'Promoción de salud sexual y reproductiva',
    :codigo => 'T013',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 342,
    :nombre => 'Salud sexual, confidencialidad, género y derecho (actividad en sala de espera)',
    :codigo => 'T014',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TA'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 343,
    :nombre => 'Consejería en salud sexual en adolescente',
    :codigo => 'T015',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('CO'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 344,
    :nombre => 'Consejería en salud sexual (en terreno)',
    :codigo => 'T016',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('CO'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 345,
    :nombre => 'Consejería puerperal en salud sexual y reproductiva, lactancia materna y puericultura (prevención de muerte súbita y signos de alarma)',
    :codigo => 'T017',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('CO'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 346,
    :nombre => 'Consejería post-aborto',
    :codigo => 'T018',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('CO'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 347,
    :nombre => 'Carta de derechos de la mujer embarazada indígena',
    :codigo => 'T019',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('CO'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 348,
    :nombre => 'Consejería en salud sexual y procreación responsable',
    :codigo => 'T020',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('CO'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 349,
    :nombre => 'Educación para la salud en el embarazo (bio-psico-social)',
    :codigo => 'T021',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('CO'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 350,
    :nombre => 'Psicoprofilaxis del parto',
    :codigo => 'T022',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('CO'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 351,
    :nombre => 'Unidad móvil de baja o mediana complejidad',
    :codigo => 'M010',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 352,
    :nombre => 'Unidad móvil de alta complejidad (adultos)',
    :codigo => 'M020',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 353,
    :nombre => 'Unidad móvil de alta complejidad (pediátrica/neonatal)',
    :codigo => 'M030',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 354,
    :nombre => 'Módulo de traslado de RN entre 500 y 1500 gramos con malformación quirúrgica mayor',
    :codigo => 'M040',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 355,
    :nombre => 'Módulo de traslado "in-utero"',
    :codigo => 'M041',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 356,
    :nombre => 'Unidad móvil de baja o mediana complejidad (hasta 50 km)',
    :codigo => 'M081',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 357,
    :nombre => 'Unidad móvil de baja o mediana complejidad (más de 50 km)',
    :codigo => 'M082',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 358,
    :nombre => 'Unidad móvil de alta complejidad adultos (hasta 50 km)',
    :codigo => 'M083',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 359,
    :nombre => 'Unidad móvil de alta complejidad adultos (más de 50 km)',
    :codigo => 'M084',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 360,
    :nombre => 'Unidad móvil de alta complejidad pediátrica (hasta 50 km)',
    :codigo => 'M085',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  },
  {
    #id => 361,
    :nombre => 'Unidad móvil de alta complejidad (más de 50 km)',
    :codigo => 'M086',
    :tipo_de_prestacion_id => TipoDePrestacion.id_del_codigo('TL'),
    :define_si_es_catastrofica => true,
    :es_catastrofica => false
  }
])
