# -*- encoding : utf-8 -*-
ActiveRecord::Base.transaction do

  ActiveRecord::Base.connection.execute "
    ALTER TABLE diagnosticos
      ADD CONSTRAINT fk_diagnosticos_gg_dd
      FOREIGN KEY (grupo_de_diagnosticos_id) REFERENCES grupos_de_diagnosticos (id);
  "

  # Crear los grupos de diagnósticos
  GrupoDeDiagnosticos.create!([
    {
      # id: 1,
      codigo: "A",
      nombre: "Problemas generales e inespecíficos"
    },
    {
      # id: 2,
      codigo: "B",
      nombre: "Sangre, órganos hematopoyéticos y sistema inmunitario (linfáticos, bazo y médula ósea)"
    },
    {
      # id: 3,
      codigo: "D",
      nombre: "Aparato digestivo"
    },
    {
      # id: 4,
      codigo: "F",
      nombre: "Ojos y anexos"
    },
    {
      # id: 5,
      codigo: "H",
      nombre: "Aparato auditivo"
    },
    {
      # id: 6,
      codigo: "K",
      nombre: "Aparato circulatorio"
    },
    {
      # id: 7,
      codigo: "L",
      nombre: "Aparato locomotor"
    },
    {
      # id: 8,
      codigo: "N",
      nombre: "Sistema nervioso"
    },
    {
      # id: 9,
      codigo: "P",
      nombre: "Problemas psicológicos"
    },
    {
      # id: 10,
      codigo: "R",
      nombre: "Aparato respiratorio"
    },
    {
      # id: 11,
      codigo: "S",
      nombre: "Piel y faneras"
    },
    {
      # id: 12,
      codigo: "T",
      nombre: "Aparato endocrino, metabolismo y nutrición"
    },
    {
      # id: 13,
      codigo: "U",
      nombre: "Aparato urinario"
    },
    {
      # id: 14,
      codigo: "W",
      nombre: "Planificación familiar - Embarazo - Parto - Puerperio"
    },
    {
      # id: 15,
      codigo: "X",
      nombre: "Aparato genital femenino y mamas"
    },
    {
      # id: 16,
      codigo: "Y",
      nombre: "Aparato genital masculino y mamas"
    },
    {
      # id: 17,
      codigo: "Z",
      nombre: "Problemas sociales"
    },
    {
      # id: 18,
      codigo: "CCC",
      nombre: "Cardiopatías congénitas"
    },
    {
      # id: 19,
      codigo: "PPAC",
      nombre: "Paquete perinatal de alta complejidad"
    }
  ])

  # Modificar los diagnosticos existentes y añadir los nuevos diagnósticos
  ActiveRecord::Base.connection.execute "
    UPDATE diagnosticos
      SET grupo_de_diagnosticos_id = 18
      WHERE codigo BETWEEN '001' AND '999';
    UPDATE diagnosticos
      SET grupo_de_diagnosticos_id = 1
      WHERE codigo BETWEEN 'A01' AND 'A99';
    UPDATE diagnosticos
      SET grupo_de_diagnosticos_id = 2
      WHERE codigo BETWEEN 'B01' AND 'B99';
    "

  Diagnostico.create!([
    {
      codigo: "A07",
      nombre: "Coma",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A10",
      nombre: "Sangrado/Hemorragia NE",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A16",
      nombre: "Lactante irritable/nervioso",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A23",
      nombre: "Factor de riesgo NE",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A43",
      nombre: "Otras infecciones del recién nacido",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A47",
      nombre: "Otras patologías severas del recién nacido",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A48",
      nombre: "Efectos adversos de la medicación en dosis correctas del recién nacido",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A69",
      nombre: "Chagas",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A70",
      nombre: "Tuberculosis",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A71",
      nombre: "Sarampión",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A72",
      nombre: "Varicela",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A74",
      nombre: "Rubéola",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A76",
      nombre: "Otras enfermedades virales con exantema",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A77",
      nombre: "Otras enfermedades virales NE",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A82",
      nombre: "Efectos secundarios tardíos de traumatismos",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A84",
      nombre: "Intoxicaciones/envenenamientos/sobredosificación por medicamentos",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A85",
      nombre: "Efecto adverso por medicamento a su dosis correcta",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A86",
      nombre: "Efectos tóxicos de sustancias no medicamentosas",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A87",
      nombre: "Complicación de tratamiento médico",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A88",
      nombre: "Efectos adversos de factores físicos",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A90",
      nombre: "Anomalías congénitas múltiples NE",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A93",
      nombre: "Recién nacidos prematuros/inmaduros",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "A94",
      nombre: "Otra morbilidad perinatal",
      grupo_de_diagnosticos_id: 1
    },
    {
      codigo: "B04",
      nombre: "Signos/síntomas de la sangre/órganos hematopoyéticos",
      grupo_de_diagnosticos_id: 2
    },
    {
      codigo: "B70",
      nombre: "Linfadenitis aguda",
      grupo_de_diagnosticos_id: 2
    },
    {
      codigo: "B71",
      nombre: "Linfadenitis crónica/inespecífica",
      grupo_de_diagnosticos_id: 2
    },
    {
      codigo: "B74",
      nombre: "Otras neoplasias malignas hematológicas",
      grupo_de_diagnosticos_id: 2
    },
    {
      codigo: "B75",
      nombre: "Neoplasias hematológicas benignas/inespecíficas",
      grupo_de_diagnosticos_id: 2
    },
    {
      codigo: "B76",
      nombre: "Rotura traumática de bazo",
      grupo_de_diagnosticos_id: 2
    },
    {
      codigo: "B77",
      nombre: "Otros traumatismos de órganos hematopoyéticos/linfáticos/bazo",
      grupo_de_diagnosticos_id: 2
    },
    {
      codigo: "B79",
      nombre: "Otras anomalías congénitas de la sangre/órganos hematopoyéticos/linfáticos",
      grupo_de_diagnosticos_id: 2
    },
    {
      codigo: "B83",
      nombre: "Púrpura/alteraciones de la coagulación",
      grupo_de_diagnosticos_id: 2
    },
    {
      codigo: "B84",
      nombre: "Leucocitos anormales",
      grupo_de_diagnosticos_id: 2
    },
    {
      codigo: "D02",
      nombre: "Dolor de estómago/epigástrico",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D04",
      nombre: "Dolor rectal/anal",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D06",
      nombre: "Otros dolores abdominales localizados",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D07",
      nombre: "Dispepsia/indigestión",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D09",
      nombre: "Náusea",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D12",
      nombre: "Estreñimiento",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D13",
      nombre: "Ictericia",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D14",
      nombre: "Hematemesis/vómito de sangre",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D15",
      nombre: "Melena",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D16",
      nombre: "Rectorragia/hemorragia rectal",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D19",
      nombre: "Signos/síntomas de dientes y encías",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D20",
      nombre: "Signos/síntomas de boca, lengua, labios",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D21",
      nombre: "Problemas de la deglución",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D24",
      nombre: "Masa abdominal NE",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D25",
      nombre: "Distensión abdominal",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D70",
      nombre: "Infección gastrointestinal",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D71",
      nombre: "Parotiditis epidémica/paperas",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D73",
      nombre: "Infección intestinal inespecífica/posible",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D81",
      nombre: "Anomalías congénitas del aparato digestivo",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D84",
      nombre: "Enfermedades del esófago",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D85",
      nombre: "Úlcera duodenal",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D86",
      nombre: "Otras úlceras pépticas",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D89",
      nombre: "Hernia inguinal",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D90",
      nombre: "Hernia de hiato",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "D91",
      nombre: "Otras hernias abdominales",
      grupo_de_diagnosticos_id: 3
    },
    {
      codigo: "F03",
      nombre: "Secreción ocular",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "F28",
      nombre: "Incapacidad/minusvalía de ojo y anexos",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "F70",
      nombre: "Conjuntivitis infecciosas",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "F71",
      nombre: "Conjuntivitis alérgicas",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "F72",
      nombre: "Blefaritis/orzuelo/chalazión",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "F75",
      nombre: "Contusión/hemorragia de ojos/anexos",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "F76",
      nombre: "Cuerpo extraño en el ojo",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "F80",
      nombre: "Obstrucción del conducto lagrimal en el lactante",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "F81",
      nombre: "Otras anomalías oculares congénitas",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "F83",
      nombre: "Retinopatía",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "F95",
      nombre: "Estrabismo",
      grupo_de_diagnosticos_id: 4
    },
    {
      codigo: "H01",
      nombre: "Dolor de oído/oreja",
      grupo_de_diagnosticos_id: 5
    },
    {
      codigo: "H04",
      nombre: "Secreción por el oído",
      grupo_de_diagnosticos_id: 5
    },
    {
      codigo: "H05",
      nombre: "Sangre en/del oído",
      grupo_de_diagnosticos_id: 5
    },
    {
      codigo: "H06",
      nombre: "Sangre en/del oído",
      grupo_de_diagnosticos_id: 5
    },
    {
      codigo: "H13",
      nombre: "Sensación de taponamiento",
      grupo_de_diagnosticos_id: 5
    },
    {
      codigo: "H70",
      nombre: "Otitis externa",
      grupo_de_diagnosticos_id: 5
    },
    {
      codigo: "H73",
      nombre: "Salpingitis de la trompa de Eustaquio",
      grupo_de_diagnosticos_id: 5
    },
    {
      codigo: "H77",
      nombre: "Perforación del tímpano",
      grupo_de_diagnosticos_id: 5
    },
    {
      codigo: "H80",
      nombre: "Anomalías congénitas del aparato auditivo",
      grupo_de_diagnosticos_id: 5
    },
    {
      codigo: "H81",
      nombre: "Cera excesiva en el conducto auditivo",
      grupo_de_diagnosticos_id: 5
    },
    {
      codigo: "K07",
      nombre: "Tobillos hinchados/edematosos",
      grupo_de_diagnosticos_id: 6
    },
    {
      codigo: "K80",
      nombre: "Arritmia cardíaca NE",
      grupo_de_diagnosticos_id: 6
    },
    {
      codigo: "K85",
      nombre: "Elevación de la presión arterial",
      grupo_de_diagnosticos_id: 6
    },
    {
      codigo: "K85",
      nombre: "Elevación de la presión arterial",
      grupo_de_diagnosticos_id: 6
    },
    {
      codigo: "K87",
      nombre: "Hipertensión con afectación del órgano diana",
      grupo_de_diagnosticos_id: 6
    },
    {
      codigo: "K88",
      nombre: "Hipotensión postural",
      grupo_de_diagnosticos_id: 6
    },
    {
      codigo: "K94",
      nombre: "Flebitis y tromboflebitis",
      grupo_de_diagnosticos_id: 6
    },
    {
      codigo: "K95",
      nombre: "Venas varicosas en extremidades inferiores",
      grupo_de_diagnosticos_id: 6
    },
    {
      codigo: "L01",
      nombre: "Signos/síntomas del cuello",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L02",
      nombre: "Signos/síntomas de la espalda",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L03",
      nombre: "Signos/síntomas lumbares",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L04",
      nombre: "Signos/síntomas torácicos",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L05",
      nombre: "Signos/síntomas de flancos y axilas",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L07",
      nombre: "Signos/síntomas de la mandíbula",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L08",
      nombre: "Signos/síntomas del hombro",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L09",
      nombre: "Signos/síntomas del brazo",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L10",
      nombre: "Signos/síntomas del codo",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L11",
      nombre: "Signos/síntomas de la muñeca",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L12",
      nombre: "Signos/síntomas de la mano y sus dedos",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L13",
      nombre: "Signos/síntomas de la cadera",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L14",
      nombre: "Signos/síntomas del muslo y de la pierna",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L15",
      nombre: "Signos/síntomas de la rodilla",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L16",
      nombre: "Signos/síntomas del tobillo",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L17",
      nombre: "Signos/síntomas del pie y sus dedos",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L30",
      nombre: "Displasia congénita de cadera",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L31",
      nombre: "Pie bot",
      grupo_de_diagnosticos_id: 7
    },
    {
      codigo: "L32",
      nombre: "Fisura labiopalatina/fisura palatina/labio leporino",
      grupo_de_diagnosticos_id: 7
    },
  ])

  # Eliminar diagnósticos duplicados no asignados
  Diagnostico.find(239).destroy  # "A21"

  end
end
