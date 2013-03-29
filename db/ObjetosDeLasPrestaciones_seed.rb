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
])
