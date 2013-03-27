# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
TipoDePrestacion.create([
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
])
