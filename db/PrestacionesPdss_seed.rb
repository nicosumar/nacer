# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class PrestacionesPdssSeed < ActiveRecord::Migration
  # Claves foráneas para asegurar la integridad referencial en el motor de la base de datos
  execute "
    ALTER TABLE prestaciones_pdss
      ADD CONSTRAINT fk_grupos_prestaciones_pdss
      FOREIGN KEY (grupo_pdss_id) REFERENCES grupos_pdss (id);
  "
  execute "
    ALTER TABLE prestaciones_pdss
      ADD CONSTRAINT fk_lineas_de_cuidado_prestaciones_pdss
      FOREIGN KEY (linea_de_cuidado_id) REFERENCES lineas_de_cuidado (id);
  "
  execute "
    ALTER TABLE prestaciones_pdss
      ADD CONSTRAINT fk_prestaciones_pdss_tipos
      FOREIGN KEY (tipo_de_prestacion_id) REFERENCES tipos_de_prestaciones (id);
  "
  execute "
    ALTER TABLE prestaciones_pdss
      ADD CONSTRAINT fk_prestaciones_pdss_modulos
      FOREIGN KEY (modulo_id) REFERENCES modulos (id);
  "
end

PrestacionPdss.create([

  # SECCIÓN 1 - Grupo 1

  {
    # id: 1
    nombre: "Atención y tratamiento ambulatorio de anemia grave del embarazo (no incluye hemoderivados)",
    grupo_pdss_id: 1,
    orden: 1,
    linea_de_cuidado_id: 1,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 2
    nombre: "Atención y tratamiento ambulatorio de anemia leve del embarazo (inicial)",
    grupo_pdss_id: 1,
    orden: 2,
    linea_de_cuidado_id: 2,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 3
    nombre: "Atención y tratamiento ambulatorio de anemia leve del embarazo (ulterior)",
    grupo_pdss_id: 1,
    orden: 3,
    linea_de_cuidado_id: 2,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 4
    nombre: "Tratamiento ambulatorio de complicaciones de parto en puerperio inmediato (inicial)",
    grupo_pdss_id: 1,
    orden: 4,
    linea_de_cuidado_id: 3,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 5
    nombre: "Tratamiento ambulatorio de complicaciones de parto en puerperio inmediato (ulterior)",
    grupo_pdss_id: 1,
    orden: 5,
    linea_de_cuidado_id: 3,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 6
    nombre: "Búsqueda activa de embarazadas en el primer trimestre por agente sanitario y/o personal de salud",
    grupo_pdss_id: 1,
    orden: 6,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 3
  },
  {
    # id: 7
    nombre: "Búsqueda activa de embarazadas con abandono de controles, por agente sanitario y/o personal de salud",
    grupo_pdss_id: 1,
    orden: 7,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 3
  },
  {
    # id: 8
    nombre: "Encuentros para promoción del desarrollo infantil, prevención de patologías prevalentes en la infancia, conductas saludables, hábitos de higiene",
    grupo_pdss_id: 1,
    orden: 8,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 9
    nombre: "Encuentros para promoción de pautas alimentarias en embarazadas, puérperas y niños menores de 6 años",
    grupo_pdss_id: 1,
    orden: 9,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 10
    nombre: "Encuentros para promoción de salud sexual y reproductiva, conductas saludables, hábitos de higiene",
    grupo_pdss_id: 1,
    orden: 10,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 11
    nombre: "Tratamiento de la hemorragia del 1er trimestre",
    grupo_pdss_id: 1,
    orden: 11,
    linea_de_cuidado_id: 5,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 12
    nombre: "Tratamiento de la hemorragia del 1er trimestre (clínica obstétrica)",
    grupo_pdss_id: 1,
    orden: 12,
    linea_de_cuidado_id: 5,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 13
    nombre: "Tratamiento de la hemorragia del 1er trimestre (quirúrgica)",
    grupo_pdss_id: 1,
    orden: 13,
    linea_de_cuidado_id: 5,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 14
    nombre: "Tratamiento de la hemorragia del 2do trimestre (clínica obstétrica)",
    grupo_pdss_id: 1,
    orden: 14,
    linea_de_cuidado_id: 6,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 15
    nombre: "Tratamiento de la hemorragia del 2do trimestre (quirúrgica)",
    grupo_pdss_id: 1,
    orden: 15,
    linea_de_cuidado_id: 6,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 16
    nombre: "Tratamiento de la hemorragia del 3er trimestre (clínica obstétrica)",
    grupo_pdss_id: 1,
    orden: 16,
    linea_de_cuidado_id: 7,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 17
    nombre: "Tratamiento de la hemorragia del 3er trimestre (quirúrgica)",
    grupo_pdss_id: 1,
    orden: 17,
    linea_de_cuidado_id: 7,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 18
    nombre: "Atención y tratamiento ambulatorio de infección urinaria en embarazada",
    grupo_pdss_id: 1,
    orden: 18,
    linea_de_cuidado_id: 8,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 19
    nombre: "Cesárea y atención del recién nacido",
    grupo_pdss_id: 1,
    orden: 19,
    linea_de_cuidado_id: 9,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 20
    nombre: "Atención de parto y recién nacido",
    grupo_pdss_id: 1,
    orden: 20,
    linea_de_cuidado_id: 10,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 21
    nombre: "Control prenatal de 1ra vez",
    grupo_pdss_id: 1,
    orden: 21,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 22
    nombre: "Ulterior de control prenatal",
    grupo_pdss_id: 1,
    orden: 22,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 23
    nombre: "Odontológica prenatal - profilaxis",
    grupo_pdss_id: 1,
    orden: 23,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 24
    nombre: "Control odontológico en el tratamiento de gingivitis y enfermedad periodontal leve",
    grupo_pdss_id: 1,
    orden: 24,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 25
    nombre: "Toma de muestra para PAP (incluye material descartable)",
    grupo_pdss_id: 1,
    orden: 25,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 26
    nombre: "Colposcopía en control de embarazo (incluye material descartable)",
    grupo_pdss_id: 1,
    orden: 26,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 27
    nombre: "Tartrectomía y cepillado mecánico",
    grupo_pdss_id: 1,
    orden: 27,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 28
    nombre: "Inactivación de caries",
    grupo_pdss_id: 1,
    orden: 28,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 29
    nombre: "Carta de derechos de la mujer embarazada indígena",
    grupo_pdss_id: 1,
    orden: 29,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 15
  },
  {
    # id: 30
    nombre: "Educación para la salud en embarazo (bio-psico-social)",
    grupo_pdss_id: 1,
    orden: 30,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 15
  },
  {
    # id: 31
    nombre: "Lectura de la muestra tomada en mujeres embarazadas, en laboratorio de Anatomía patológica/Citología con diagnóstico firmado por anátomo-patólogo matriculado (CA cérvicouterino)",
    grupo_pdss_id: 1,
    orden: 31,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 1
  },
  {
    # id: 32
    nombre: "Control prenatal de embarazo de alto riesgo",
    grupo_pdss_id: 1,
    orden: 32,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 33
    nombre: "Dosis aplicada de vacuna triple bacteriana acelular (dTpa)",
    grupo_pdss_id: 1,
    orden: 33,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 34
    nombre: "Inmunización doble adulto en embarazo",
    grupo_pdss_id: 1,
    orden: 34,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 35
    nombre: "Dosis aplicada de vacuna antigripal en embarazo o puerperio",
    grupo_pdss_id: 1,
    orden: 35,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 36
    nombre: "Puerperio inmediato",
    grupo_pdss_id: 1,
    orden: 36,
    linea_de_cuidado_id: 12,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 37
    nombre: "Dosis aplicada de vacuna antigripal en embarazo o puerperio",
    grupo_pdss_id: 1,
    orden: 37,
    linea_de_cuidado_id: 12,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 38
    nombre: "Inmunización puerperal doble viral (rubéola)",
    grupo_pdss_id: 1,
    orden: 38,
    linea_de_cuidado_id: 12,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 39
    nombre: "Consejería puerperal en SS y R; lactancia materna y puericultura (prevención de muerte súbita y signos de alarma)",
    grupo_pdss_id: 1,
    orden: 39,
    linea_de_cuidado_id: 12,
    tipo_de_prestacion_id: 15
  },
  {
    # id: 40
    nombre: "Atención y tratamiento ambulatorio de sífilis e ITS en embarazo",
    grupo_pdss_id: 1,
    orden: 40,
    linea_de_cuidado_id: 13,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 41
    nombre: "Atención y tratamiento ambulatorio de VIH en la embarazada",
    grupo_pdss_id: 1,
    orden: 41,
    linea_de_cuidado_id: 14,
    tipo_de_prestacion_id: 4
  },

  # SECCIÓN 1 - Grupo 2

  {
    # id: 42
    nombre: "Consulta seguimiento post alta",
    grupo_pdss_id: 2,
    orden: 1,
    linea_de_cuidado_id: 15,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 43
    nombre: "Ref. por embarazo de alto riesgo de Nivel 2 ó 3 a niveles de complejidad sup.",
    grupo_pdss_id: 2,
    orden: 2,
    linea_de_cuidado_id: 16,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 44
    nombre: "Consulta inicial de diabetes gestacional",
    grupo_pdss_id: 2,
    orden: 3,
    linea_de_cuidado_id: 17,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 45
    nombre: "Consulta de seguimiento de diabetes gestacional",
    grupo_pdss_id: 2,
    orden: 4,
    linea_de_cuidado_id: 17,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 46
    nombre: "Consulta con oftalmología",
    grupo_pdss_id: 2,
    orden: 5,
    linea_de_cuidado_id: 17,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 47
    nombre: "Consulta con cardiología",
    grupo_pdss_id: 2,
    orden: 6,
    linea_de_cuidado_id: 17,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 48
    nombre: "Consulta con endocrinólogo",
    grupo_pdss_id: 2,
    orden: 7,
    linea_de_cuidado_id: 17,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 49
    nombre: "Consulta con nutricionista",
    grupo_pdss_id: 2,
    orden: 8,
    linea_de_cuidado_id: 17,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 50
    nombre: "Consulta seguimiento puerperio paciente con diabetes gestacional",
    grupo_pdss_id: 2,
    orden: 9,
    linea_de_cuidado_id: 17,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 51
    nombre: "Consulta puerperio con nutricionista",
    grupo_pdss_id: 2,
    orden: 10,
    linea_de_cuidado_id: 17,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 52
    nombre: "Consulta seguimiento puerperio en hemorragia posparto",
    grupo_pdss_id: 2,
    orden: 11,
    linea_de_cuidado_id: 18,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 53
    nombre: "Consulta inicial de la embarazada con hipertensión crónica",
    grupo_pdss_id: 2,
    orden: 12,
    linea_de_cuidado_id: 19,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 54
    nombre: "Consulta de seguimiento de la embarazada con hipertensión crónica",
    grupo_pdss_id: 2,
    orden: 13,
    linea_de_cuidado_id: 19,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 55
    nombre: "Consulta con oftalmología",
    grupo_pdss_id: 2,
    orden: 14,
    linea_de_cuidado_id: 19,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 56
    nombre: "Consulta con nefrología",
    grupo_pdss_id: 2,
    orden: 15,
    linea_de_cuidado_id: 19,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 57
    nombre: "Consulta con cardiología",
    grupo_pdss_id: 2,
    orden: 16,
    linea_de_cuidado_id: 19,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 58
    nombre: "Consulta seguimiento puerperio de paciente con hipertensión",
    grupo_pdss_id: 2,
    orden: 17,
    linea_de_cuidado_id: 19,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 59
    nombre: "Consulta inicial de hipertensión gestacional",
    grupo_pdss_id: 2,
    orden: 18,
    linea_de_cuidado_id: 20,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 60
    nombre: "Consulta de seguimiento de la hipertensión gestacional",
    grupo_pdss_id: 2,
    orden: 19,
    linea_de_cuidado_id: 20,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 61
    nombre: "Consulta con cardiología",
    grupo_pdss_id: 2,
    orden: 20,
    linea_de_cuidado_id: 20,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 62
    nombre: "Consulta seguimiento puerperio de paciente con hipertensión",
    grupo_pdss_id: 2,
    orden: 21,
    linea_de_cuidado_id: 20,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 63
    nombre: "Notificación de factores de riesgo",
    grupo_pdss_id: 2,
    orden: 22,
    linea_de_cuidado_id: 11,
    tipo_de_prestacion_id: 4
  },

  # SECCIÓN 1 - Grupo 3

  {
    # id: 64
    nombre: "Internación por preeclampsia grave, eclampsia o sindrome Hellp",
    grupo_pdss_id: 3,
    orden: 1,
    linea_de_cuidado_id: 21,
    modulo_id: 1,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 65
    nombre: "Internación por amenaza de parto prematuro",
    grupo_pdss_id: 3,
    orden: 2,
    linea_de_cuidado_id: 15,
    modulo_id: 2,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 66
    nombre: "Hemorragia posparto con histerectomía",
    grupo_pdss_id: 3,
    orden: 3,
    linea_de_cuidado_id: 18,
    modulo_id: 3,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 67
    nombre: "Hemorragia posparto sin histerectomía",
    grupo_pdss_id: 3,
    orden: 4,
    linea_de_cuidado_id: 18,
    modulo_id: 4,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 68
    nombre: "Diabetes gestacional sin requerimiento de insulina",
    grupo_pdss_id: 3,
    orden: 5,
    linea_de_cuidado_id: 17,
    modulo_id: 5,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 69
    nombre: "Diabetes gestacional con requerimiento de insulina",
    grupo_pdss_id: 3,
    orden: 6,
    linea_de_cuidado_id: 17,
    modulo_id: 6,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 1 - Grupo 4

  {
    # id: 70
    nombre: "Diabetes gestacional",
    grupo_pdss_id: 4,
    orden: 1,
    linea_de_cuidado_id: 17,
    modulo_id: 7,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 71
    nombre: "Hipertensión en embarazo",
    grupo_pdss_id: 4,
    orden: 2,
    linea_de_cuidado_id: 22,
    modulo_id: 8,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 72
    nombre: "Restricción del crecimiento intrauterino: pequeño para edad gestacional",
    grupo_pdss_id: 4,
    orden: 3,
    linea_de_cuidado_id: 23,
    modulo_id: 9,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 1 - Grupo 5

  {
    # id: 73
    nombre: "Informe de comité de auditoría de muerte materna y/o infantil recibido y aprobado por el Ministerio de Salud de la Provincia, según ordenamiento",
    grupo_pdss_id: 5,
    orden: 1,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 2
  },

  # SECCIÓN 2 - Grupo 6

  {
    # id: 74
    nombre: "Tratamiento inmediato de Chagas congénito",
    grupo_pdss_id: 6,
    orden: 1,
    linea_de_cuidado_id: 24,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 75
    nombre: "Inmunización de recién nacido (BCG antes del alta y Hepatitis B en primeras 12 hs de vida)",
    grupo_pdss_id: 6,
    orden: 2,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 76
    nombre: "Oftalmoscopía binocular indirecta (OBI) a todo niño de riesgo (pesquisa de la retinopatía del prematuro)",
    grupo_pdss_id: 6,
    orden: 3,
    linea_de_cuidado_id: 26,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 77
    nombre: "Otoemisiones acústicas para detección temprana de hipoacusia en RN",
    grupo_pdss_id: 6,
    orden: 4,
    linea_de_cuidado_id: 27,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 78
    nombre: "Tratamiento inmediato de sífilis congénita en RN",
    grupo_pdss_id: 6,
    orden: 5,
    linea_de_cuidado_id: 28,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 79
    nombre: "Incubadora hasta 48 hs en RN",
    grupo_pdss_id: 6,
    orden: 6,
    linea_de_cuidado_id: 29,
    tipo_de_prestacion_id: 7
  },
  {
    # id: 80
    nombre: "Tratamiento inmediato de trastornos metabólicos (estado ácido base y electrolitos) en RN",
    grupo_pdss_id: 6,
    orden: 7,
    linea_de_cuidado_id: 30,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 81
    nombre: "Atención de RN con condición grave al nacer (tratamiento pre-referencia)",
    grupo_pdss_id: 6,
    orden: 8,
    linea_de_cuidado_id: 30,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 82
    nombre: "Tratamiento inmediato de transmisión vertical de VIH en RN",
    grupo_pdss_id: 6,
    orden: 9,
    linea_de_cuidado_id: 31,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 2 - Grupo 7

  {
    # id: 83
    nombre: "Ano imperforado alto o bajo",
    grupo_pdss_id: 7,
    orden: 1,
    linea_de_cuidado_id: 32,
    modulo_id: 10,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 84
    nombre: "Mielomeningocele",
    grupo_pdss_id: 7,
    orden: 2,
    linea_de_cuidado_id: 32,
    modulo_id: 11,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 85
    nombre: "Hidrocefalia",
    grupo_pdss_id: 7,
    orden: 3,
    linea_de_cuidado_id: 32,
    modulo_id: 12,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 2 - Grupo 8

  {
    # id: 86
    nombre: "Ingreso",
    grupo_pdss_id: 8,
    orden: 1,
    linea_de_cuidado_id: 33,
    modulo_id: 13,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 87
    nombre: "Egreso",
    grupo_pdss_id: 8,
    orden: 2,
    linea_de_cuidado_id: 33,
    modulo_id: 14,
    tipo_de_prestacion_id: 4
  },

  # SECCIÓN 2 - Grupo 9

  {
    # id: 88
    nombre: "Ergometría",
    grupo_pdss_id: 9,
    orden: 1,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 89
    nombre: "Holter de 24 hs",
    grupo_pdss_id: 9,
    orden: 2,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 90
    nombre: "Presurometría",
    grupo_pdss_id: 9,
    orden: 3,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 91
    nombre: "Hemodinamia diagnóstica",
    grupo_pdss_id: 9,
    orden: 4,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 92
    nombre: "Resonancia magnética",
    grupo_pdss_id: 9,
    orden: 5,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 93
    nombre: "Tomografía",
    grupo_pdss_id: 9,
    orden: 6,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 6
  },

  # SECCIÓN 2 - Grupo 10

  {
    # id: 94
    nombre: "Cierre de ductus con cirugía convencional",
    grupo_pdss_id: 10,
    orden: 1,
    linea_de_cuidado_id: 34,
    modulo_id: 15,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 95
    nombre: "Cerclaje de arteria pulmonar con cirugía convencional",
    grupo_pdss_id: 10,
    orden: 2,
    linea_de_cuidado_id: 34,
    modulo_id: 15,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 96
    nombre: "Anastomosis subclavio-pulmonar con cirugía convencional",
    grupo_pdss_id: 10,
    orden: 3,
    linea_de_cuidado_id: 34,
    modulo_id: 15,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 97
    nombre: "Corrección de coartación de la aorta con cirugía convencional",
    grupo_pdss_id: 10,
    orden: 4,
    linea_de_cuidado_id: 34,
    modulo_id: 15,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 98
    nombre: "Cierre de ductus con hemodinamia intervencionista",
    grupo_pdss_id: 10,
    orden: 5,
    linea_de_cuidado_id: 34,
    modulo_id: 15,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 99
    nombre: "Corrección de coartación de la aorta con hemodinamia intervencionista",
    grupo_pdss_id: 10,
    orden: 6,
    linea_de_cuidado_id: 34,
    modulo_id: 15,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 100
    nombre: "Cierre de CIA con hemodinamia intervencionista",
    grupo_pdss_id: 10,
    orden: 7,
    linea_de_cuidado_id: 34,
    modulo_id: 15,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 101
    nombre: "Cierre de CIV con hemodinamia intervencionista",
    grupo_pdss_id: 10,
    orden: 8,
    linea_de_cuidado_id: 34,
    modulo_id: 15,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 102
    nombre: "Colocación de Stent en ramas pulmonares con hemodinamia intervencionista",
    grupo_pdss_id: 10,
    orden: 9,
    linea_de_cuidado_id: 34,
    modulo_id: 15,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 103
    nombre: "Embolización de colaterales de ramas pulmonares con hemodinamia intervencionista",
    grupo_pdss_id: 10,
    orden: 10,
    linea_de_cuidado_id: 34,
    modulo_id: 15,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 104
    nombre: "Cierre de ductus",
    grupo_pdss_id: 10,
    orden: 11,
    linea_de_cuidado_id: 34,
    modulo_id: 16,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 105
    nombre: "Cerclaje de arteria pulmonar",
    grupo_pdss_id: 10,
    orden: 12,
    linea_de_cuidado_id: 34,
    modulo_id: 16,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 106
    nombre: "Anastomosis subclavio-pulmonar",
    grupo_pdss_id: 10,
    orden: 13,
    linea_de_cuidado_id: 34,
    modulo_id: 16,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 107
    nombre: "Corrección de coartación de la aorta",
    grupo_pdss_id: 10,
    orden: 14,
    linea_de_cuidado_id: 34,
    modulo_id: 16,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 108
    nombre: "Cirugía de Glenn",
    grupo_pdss_id: 10,
    orden: 15,
    linea_de_cuidado_id: 34,
    modulo_id: 17,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 109
    nombre: "Cierre de CIA con cirugía convencional",
    grupo_pdss_id: 10,
    orden: 16,
    linea_de_cuidado_id: 34,
    modulo_id: 17,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 110
    nombre: "Cirugía correctora",
    grupo_pdss_id: 10,
    orden: 17,
    linea_de_cuidado_id: 34,
    modulo_id: 17,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 111
    nombre: "Correctora de ventana aortopulmonar",
    grupo_pdss_id: 10,
    orden: 18,
    linea_de_cuidado_id: 34,
    modulo_id: 17,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 112
    nombre: "Correctora de canal A-V parcial",
    grupo_pdss_id: 10,
    orden: 19,
    linea_de_cuidado_id: 34,
    modulo_id: 17,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 113
    nombre: "Cierre de CIV con cirugía convencional",
    grupo_pdss_id: 10,
    orden: 20,
    linea_de_cuidado_id: 34,
    modulo_id: 18,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 2 - Grupo 11

  {
    # id: 114
    nombre: "Alprostadil",
    grupo_pdss_id: 11,
    orden: 1,
    linea_de_cuidado_id: 34,
    modulo_id: 19,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 115
    nombre: "Óxido nitríco y dispenser para su administración",
    grupo_pdss_id: 11,
    orden: 2,
    linea_de_cuidado_id: 34,
    modulo_id: 19,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 116
    nombre: "Levosimendán",
    grupo_pdss_id: 11,
    orden: 3,
    linea_de_cuidado_id: 34,
    modulo_id: 19,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 117
    nombre: "Factor VII activado recombinante",
    grupo_pdss_id: 11,
    orden: 4,
    linea_de_cuidado_id: 34,
    modulo_id: 19,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 118
    nombre: "Iloprost",
    grupo_pdss_id: 11,
    orden: 5,
    linea_de_cuidado_id: 34,
    modulo_id: 19,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 119
    nombre: "Trometanol",
    grupo_pdss_id: 11,
    orden: 6,
    linea_de_cuidado_id: 34,
    modulo_id: 19,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 120
    nombre: "Surfactante",
    grupo_pdss_id: 11,
    orden: 7,
    linea_de_cuidado_id: 34,
    modulo_id: 19,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 121
    nombre: "Nutrición parenteral total",
    grupo_pdss_id: 11,
    orden: 8,
    linea_de_cuidado_id: 34,
    modulo_id: 19,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 122
    nombre: "Prótesis y órtesis",
    grupo_pdss_id: 11,
    orden: 9,
    linea_de_cuidado_id: 34,
    modulo_id: 19,
    tipo_de_prestacion_id: 11
  },

  # SECCIÓN 2 - Grupo 12

  {
    # id: 123
    nombre: "Búsqueda activa de niños con abandono de controles",
    grupo_pdss_id: 12,
    orden: 1,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 3
  },
  {
    # id: 124
    nombre: "Encuentros para promoción de pautas alimentarias en embarazadas, puérperas y niños menores de 6 años",
    grupo_pdss_id: 12,
    orden: 2,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 125
    nombre: "Encuentros para promoción del desarrollo infantil, prevención de patolog. prevalentes en la infancia, conductas saludables, hábitos de higiene",
    grupo_pdss_id: 12,
    orden: 3,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 126
    nombre: "Examen periódico de salud de niños menores de 1 año",
    grupo_pdss_id: 12,
    orden: 4,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 127
    nombre: "Examen periódico de salud de niños de 1 a 5 años",
    grupo_pdss_id: 12,
    orden: 5,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 128
    nombre: "Consulta buco-dental en salud en niños menores de 6 años",
    grupo_pdss_id: 12,
    orden: 6,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 129
    nombre: "Consulta oftalmológica en niños de 5 años",
    grupo_pdss_id: 12,
    orden: 7,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 130
    nombre: "Inactivación de caries",
    grupo_pdss_id: 12,
    orden: 8,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 131
    nombre: "Dosis aplicada de vacuna triple viral en niños menores de 6 años",
    grupo_pdss_id: 12,
    orden: 9,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 132
    nombre: "Dosis aplicada de Sabín en niños de 2, 4, 6 y 18 meses y 6 años o actualización de esquema",
    grupo_pdss_id: 12,
    orden: 10,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 133
    nombre: "Dosis aplicada de inmunización pentavalente en niños de 2, 4, 6 y 18 meses o actualización de esquema",
    grupo_pdss_id: 12,
    orden: 11,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 134
    nombre: "Dosis aplicada de inmunización cuádruple en niños de 18 meses o actualización de esquema",
    grupo_pdss_id: 12,
    orden: 12,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 135
    nombre: "Dosis aplicada de inmunización para hepatitis A en niños de 12 meses o actualización de esquema",
    grupo_pdss_id: 12,
    orden: 13,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 136
    nombre: "Dosis aplicada de inmunización triple bacteriana celular en niños de 6 años o actualización de esquema",
    grupo_pdss_id: 12,
    orden: 14,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 137
    nombre: "Dosis aplicada de inmunización anti-amarílica en niños de 12 meses en departamentos de riesgo",
    grupo_pdss_id: 12,
    orden: 15,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 138
    nombre: "Dosis aplicada de vacuna doble viral (SR) al ingreso escolar",
    grupo_pdss_id: 12,
    orden: 16,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 139
    nombre: "Dosis aplicada de vacuna antigripal en niños de 6 a 24 meses o en niños mayores con factores de riesgo",
    grupo_pdss_id: 12,
    orden: 17,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 140
    nombre: "Dosis aplicada de vacuna neumococo conjugada",
    grupo_pdss_id: 12,
    orden: 18,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 141
    nombre: "Consultas con pediatras especialistas en cardiología, nefrología, infectología, gastroenterología",
    grupo_pdss_id: 12,
    orden: 19,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 142
    nombre: "Atención ambulatoria con suplementación vitamínica a niños desnutridos menores de 6 años (inicial)",
    grupo_pdss_id: 12,
    orden: 20,
    linea_de_cuidado_id: 35,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 143
    nombre: "Atención ambulatoria con suplementación vitamínica a niños desnutridos menores de 6 años (ulterior)",
    grupo_pdss_id: 12,
    orden: 21,
    linea_de_cuidado_id: 35,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 144
    nombre: "Consulta de niños con especialistas (hipoacusia en lactante \"No pasa\" con Otoemisiones acústicas)",
    grupo_pdss_id: 12,
    orden: 22,
    linea_de_cuidado_id: 27,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 145
    nombre: "Rescreening de hipoacusia en lactante \"No pasa\" con BERA",
    grupo_pdss_id: 12,
    orden: 23,
    linea_de_cuidado_id: 27,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 146
    nombre: "Rescreening de hipoacusia en lactante \"No pasa\" con otoemisiones acústicas",
    grupo_pdss_id: 12,
    orden: 24,
    linea_de_cuidado_id: 27,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 147
    nombre: "Atención ambulatoria de enfermedades diarreicas agudas en niños menores de 6 años (inicial)",
    grupo_pdss_id: 12,
    orden: 25,
    linea_de_cuidado_id: 36,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 148
    nombre: "Atención ambulatoria de enfermedades diarreicas agudas en niños menores de 6 años (ulterior)",
    grupo_pdss_id: 12,
    orden: 26,
    linea_de_cuidado_id: 36,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 149
    nombre: "Posta de rehidratación: diarrea aguda en ambulatorio",
    grupo_pdss_id: 12,
    orden: 27,
    linea_de_cuidado_id: 36,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 150
    nombre: "Atención ambulatoria de infección respiratoria aguda en niños menores de 6 años (inicial)",
    grupo_pdss_id: 12,
    orden: 28,
    linea_de_cuidado_id: 37,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 151
    nombre: "Atención ambulatoria de infección respiratoria aguda en niños menores de 6 años (ulterior)",
    grupo_pdss_id: 12,
    orden: 29,
    linea_de_cuidado_id: 37,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 152
    nombre: "Kinesioterapia ambulatoria en infecciones respiratorias agudas en niños menores de 6 años (5 sesiones)",
    grupo_pdss_id: 12,
    orden: 30,
    linea_de_cuidado_id: 37,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 153
    nombre: "Internación abreviada SBO (prehospitalización en ambulatorio)",
    grupo_pdss_id: 12,
    orden: 31,
    linea_de_cuidado_id: 37,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 154
    nombre: "Internación abreviada SBO (24-48 hs de internación en hospital)",
    grupo_pdss_id: 12,
    orden: 32,
    linea_de_cuidado_id: 37,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 155
    nombre: "Neumonía",
    grupo_pdss_id: 12,
    orden: 33,
    linea_de_cuidado_id: 38,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 156
    nombre: "Consulta pediátrica de menores de 6 años en emergencia hospitalaria",
    grupo_pdss_id: 12,
    orden: 34,
    linea_de_cuidado_id: 39,
    tipo_de_prestacion_id: 4
  },

  # SECCIÓN 2 - Grupo 13

  {
    # id: 157
    nombre: "Informe de comité de auditoría de muerte materna y/o infantil recibido y aprobado por el Ministerio de Salud de la Provincia, según ordenamiento",
    grupo_pdss_id: 13,
    orden: 1,
    tipo_de_prestacion_id: 2
  },

  # SECCIÓN 3 - Grupo 14

  {
    # id: 158
    nombre: "Anemia leve y moderada (inicial)",
    grupo_pdss_id: 14,
    orden: 1,
    linea_de_cuidado_id: 40,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 159
    nombre: "Anemia leve y moderada (ulterior)",
    grupo_pdss_id: 14,
    orden: 2,
    linea_de_cuidado_id: 40,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 160
    nombre: "Asma bronquial (inicial)",
    grupo_pdss_id: 14,
    orden: 3,
    linea_de_cuidado_id: 41,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 161
    nombre: "Asma bronquial (ulterior)",
    grupo_pdss_id: 14,
    orden: 4,
    linea_de_cuidado_id: 41,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 162
    nombre: "Asma bronquial (urgencia)",
    grupo_pdss_id: 14,
    orden: 5,
    linea_de_cuidado_id: 41,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 163
    nombre: "Pautas nutricionales respetando cultura alimentaria de comunidades indígenas",
    grupo_pdss_id: 14,
    orden: 6,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 164
    nombre: "Prevención de accidentes domésticos",
    grupo_pdss_id: 14,
    orden: 7,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 165
    nombre: "Promoción de hábitos saludables: salud bucal, educación alimentaria, pautas de higiene",
    grupo_pdss_id: 14,
    orden: 8,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 166
    nombre: "Búsqueda activa de niños con abandono de controles",
    grupo_pdss_id: 14,
    orden: 9,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 3
  },
  {
    # id: 167
    nombre: "Examen periódico de salud de niños de 6 a 9 años",
    grupo_pdss_id: 14,
    orden: 10,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 168
    nombre: "Control de salud individual para población indígena en terreno",
    grupo_pdss_id: 14,
    orden: 11,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 169
    nombre: "Control odontológico",
    grupo_pdss_id: 14,
    orden: 12,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 170
    nombre: "Control oftalmológico",
    grupo_pdss_id: 14,
    orden: 13,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 171
    nombre: "Consulta  para confirmación diagnóstica en población indígena con riesgo detectado en terreno",
    grupo_pdss_id: 14,
    orden: 14,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 3
  },
  {
    # id: 172
    nombre: "Dosis aplicada de triple viral (actualización de esquema)",
    grupo_pdss_id: 14,
    orden: 15,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 173
    nombre: "Dosis aplicada de sabin oral (actualización de esquema)",
    grupo_pdss_id: 14,
    orden: 16,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 174
    nombre: "Dosis aplicada de dTap triple acelular (actualización de esquema en niños mayores de 7 años)",
    grupo_pdss_id: 14,
    orden: 17,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 175
    nombre: "Dosis aplicada de inmunización anti hepatitis B (actualización de esquema)",
    grupo_pdss_id: 14,
    orden: 18,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 176
    nombre: "Dosis aplicada de vacuna doble viral (SR) al ingreso escolar",
    grupo_pdss_id: 14,
    orden: 19,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 177
    nombre: "Dosis aplicada de vacuna antigripal en personas con factores de riesgo",
    grupo_pdss_id: 14,
    orden: 20,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 178
    nombre: "Sellado de surcos",
    grupo_pdss_id: 14,
    orden: 21,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 179
    nombre: "Barniz fluorado de surcos",
    grupo_pdss_id: 14,
    orden: 22,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 180
    nombre: "Inactivación de caries",
    grupo_pdss_id: 14,
    orden: 23,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 181
    nombre: "Diagnóstica y de seguimiento de leucemia (inicial)",
    grupo_pdss_id: 14,
    orden: 24,
    linea_de_cuidado_id: 42,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 182
    nombre: "Diagnóstica y de seguimiento de leucemia (ulterior)",
    grupo_pdss_id: 14,
    orden: 25,
    linea_de_cuidado_id: 42,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 183
    nombre: "Notificación de inicio de tratamiento en tiempo oportuno (leucemia)",
    grupo_pdss_id: 14,
    orden: 26,
    linea_de_cuidado_id: 42,
    tipo_de_prestacion_id: 12
  },
  {
    # id: 184
    nombre: "Diagnóstica y de seguimiento de linfoma (inicial)",
    grupo_pdss_id: 14,
    orden: 27,
    linea_de_cuidado_id: 43,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 185
    nombre: "Diagnóstica y de seguimiento de linfoma (ulterior)",
    grupo_pdss_id: 14,
    orden: 28,
    linea_de_cuidado_id: 43,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 186
    nombre: "Notificación de inicio de tratamiento en tiempo oportuno (linfoma)",
    grupo_pdss_id: 14,
    orden: 29,
    linea_de_cuidado_id: 43,
    tipo_de_prestacion_id: 12
  },
  {
    # id: 187
    nombre: "Obesidad (inicial)",
    grupo_pdss_id: 14,
    orden: 30,
    linea_de_cuidado_id: 44,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 188
    nombre: "Obesidad (ulterior)",
    grupo_pdss_id: 14,
    orden: 31,
    linea_de_cuidado_id: 44,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 189
    nombre: "Sobrepeso (inicial)",
    grupo_pdss_id: 14,
    orden: 32,
    linea_de_cuidado_id: 45,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 190
    nombre: "Sobrepeso (ulterior)",
    grupo_pdss_id: 14,
    orden: 33,
    linea_de_cuidado_id: 45,
    tipo_de_prestacion_id: 4
  },

  # SECCIÓN 3 - Grupo 15

  {
    # id: 191
    nombre: "Ergometría",
    grupo_pdss_id: 15,
    orden: 1,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 192
    nombre: "Holter de 24 hs",
    grupo_pdss_id: 15,
    orden: 2,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 193
    nombre: "Presurometría",
    grupo_pdss_id: 15,
    orden: 3,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 194
    nombre: "Hemodinamia diagnóstica",
    grupo_pdss_id: 15,
    orden: 4,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 195
    nombre: "Resonancia magnética",
    grupo_pdss_id: 15,
    orden: 5,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 196
    nombre: "Tomografía",
    grupo_pdss_id: 15,
    orden: 6,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 6
  },

  # SECCIÓN 3 - Grupo 16

  {
    # id: 197
    nombre: "Cierre de ductus con cirugía convencional",
    grupo_pdss_id: 16,
    orden: 1,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 198
    nombre: "Reoperación por ductus residual",
    grupo_pdss_id: 16,
    orden: 2,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 199
    nombre: "Corrección de coartación de la aorta con cirugía convencional",
    grupo_pdss_id: 16,
    orden: 3,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 200
    nombre: "Reoperación por coartación de aorta residual",
    grupo_pdss_id: 16,
    orden: 4,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 201
    nombre: "Cierre de ductus con hemodinamia intervencionista",
    grupo_pdss_id: 16,
    orden: 5,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 202
    nombre: "Reintervención por ductus residual con hemodinamia intervencionista",
    grupo_pdss_id: 16,
    orden: 6,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 203
    nombre: "Corrección de coartación de la aorta con hemodinamia intervencionista",
    grupo_pdss_id: 16,
    orden: 7,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 204
    nombre: "Reintervención por recoartación de aorta con hemodinamia intervencionista",
    grupo_pdss_id: 16,
    orden: 8,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 205
    nombre: "Cierre de CIA con hemodinamia intervencionista",
    grupo_pdss_id: 16,
    orden: 9,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 206
    nombre: "Cierre de CIV con hemodinamia intervencionista",
    grupo_pdss_id: 16,
    orden: 10,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 207
    nombre: "Colocación de Stent en ramas pulmonares con hemodinamia intervencionista",
    grupo_pdss_id: 16,
    orden: 11,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 208
    nombre: "Embolización de colaterales de ramas pulmonares con hemodinamia intervencionista",
    grupo_pdss_id: 16,
    orden: 12,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 209
    nombre: "Cirugía de Glenn",
    grupo_pdss_id: 16,
    orden: 13,
    linea_de_cuidado_id: 34,
    modulo_id: 21,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 210
    nombre: "Cierre de CIA con cirugía convencional",
    grupo_pdss_id: 16,
    orden: 14,
    linea_de_cuidado_id: 34,
    modulo_id: 21,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 211
    nombre: "Cirugía correctora de anomalía parcial del retorno venoso pulmonar",
    grupo_pdss_id: 16,
    orden: 15,
    linea_de_cuidado_id: 34,
    modulo_id: 21,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 212
    nombre: "Cirugía correctora de canal A-V parcial",
    grupo_pdss_id: 16,
    orden: 16,
    linea_de_cuidado_id: 34,
    modulo_id: 21,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 213
    nombre: "Cierre de CIV con cirugía convencional",
    grupo_pdss_id: 16,
    orden: 17,
    linea_de_cuidado_id: 34,
    modulo_id: 22,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 3 - Grupo 17

  {
    # id: 214
    nombre: "Óxido nitríco y dispenser para su administración",
    grupo_pdss_id: 17,
    orden: 1,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 215
    nombre: "Levosimendán",
    grupo_pdss_id: 17,
    orden: 2,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 216
    nombre: "Factor VII activado recombinante",
    grupo_pdss_id: 17,
    orden: 3,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 217
    nombre: "Iloprost",
    grupo_pdss_id: 17,
    orden: 4,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 218
    nombre: "Trometanol",
    grupo_pdss_id: 17,
    orden: 5,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 219
    nombre: "Nutrición parenteral total",
    grupo_pdss_id: 17,
    orden: 6,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 220
    nombre: "Prótesis y órtesis",
    grupo_pdss_id: 17,
    orden: 7,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },

  # SECCIÓN 4 - Grupo 18

  {
    # id: 221
    nombre: "Anemia leve y moderada en mujeres (inicial)",
    grupo_pdss_id: 18,
    orden: 1,
    linea_de_cuidado_id: 40,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 222
    nombre: "Anemia leve y moderada en mujeres (ulterior)",
    grupo_pdss_id: 18,
    orden: 2,
    linea_de_cuidado_id: 40,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 223
    nombre: "Asma bronquial (inicial)",
    grupo_pdss_id: 18,
    orden: 3,
    linea_de_cuidado_id: 41,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 224
    nombre: "Asma bronquial (ulterior)",
    grupo_pdss_id: 18,
    orden: 4,
    linea_de_cuidado_id: 41,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 225
    nombre: "Asma bronquial (urgencia)",
    grupo_pdss_id: 18,
    orden: 5,
    linea_de_cuidado_id: 41,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 226
    nombre: "Prevención de comportamientos adictivos: tabaquismo, uso de drogas, alcoholismo",
    grupo_pdss_id: 18,
    orden: 6,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 227
    nombre: "Pautas nutricionales respetando la cultura alimentaria de comunidades indígenas",
    grupo_pdss_id: 18,
    orden: 7,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 228
    nombre: "Prevención de accidentes",
    grupo_pdss_id: 18,
    orden: 8,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 229
    nombre: "Prevención de VIH e infecciones de transmisión sexual",
    grupo_pdss_id: 18,
    orden: 9,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 230
    nombre: "Prevención de violencia de género",
    grupo_pdss_id: 18,
    orden: 10,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 231
    nombre: "Prevención de violencia familiar",
    grupo_pdss_id: 18,
    orden: 11,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 232
    nombre: "Promoción de hábitos saludables: salud bucal, educación alimentaria, pautas de higiene, trastornos de la alimentación",
    grupo_pdss_id: 18,
    orden: 12,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 233
    nombre: "Promoción de pautas alimentarias",
    grupo_pdss_id: 18,
    orden: 13,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 234
    nombre: "Promoción de salud sexual y reproductiva",
    grupo_pdss_id: 18,
    orden: 14,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 235
    nombre: "Salud sexual, confidencialidad, género y derecho (actividad en sala de espera)",
    grupo_pdss_id: 18,
    orden: 15,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 236
    nombre: "Búsqueda activa de adolescentes para valoración integral",
    grupo_pdss_id: 18,
    orden: 16,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 3
  },
  {
    # id: 237
    nombre: "Búsqueda activa de embarazadas adolescentes por agente sanitario y/o personal de salud",
    grupo_pdss_id: 18,
    orden: 17,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 3
  },
  {
    # id: 238
    nombre: "Seguimiento por consumo episódico excesivo de alcohol y/u otras sustancias psicoactivas (inicial)",
    grupo_pdss_id: 18,
    orden: 18,
    linea_de_cuidado_id: 46,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 239
    nombre: "Seguimiento por consumo episódico excesivo de alcohol y/u otras sustancias psicoactivas (ulterior)",
    grupo_pdss_id: 18,
    orden: 19,
    linea_de_cuidado_id: 46,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 240
    nombre: "Consumo episódico excesivo de alcohol y/u otras sustancias psicoactivas (urgencia/consultorio externo)",
    grupo_pdss_id: 18,
    orden: 20,
    linea_de_cuidado_id: 46,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 241
    nombre: "Examen periódico de salud del adolescente",
    grupo_pdss_id: 18,
    orden: 21,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 242
    nombre: "Control de salud individual para población indígena en terreno",
    grupo_pdss_id: 18,
    orden: 22,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 243
    nombre: "Control ginecológico",
    grupo_pdss_id: 18,
    orden: 23,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 244
    nombre: "Control odontológico",
    grupo_pdss_id: 18,
    orden: 24,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 245
    nombre: "Control oftalmológico",
    grupo_pdss_id: 18,
    orden: 25,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 246
    nombre: "Dosis aplicada de doble viral (rubéola + sarampión)",
    grupo_pdss_id: 18,
    orden: 26,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 247
    nombre: "Dosis aplicada de doble adultos en mayores de 16 años",
    grupo_pdss_id: 18,
    orden: 27,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 248
    nombre: "Dosis aplicada de dTap triple acelular (refuerzo a los 11 años)",
    grupo_pdss_id: 18,
    orden: 28,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 249
    nombre: "Dosis aplicada de inmunización anti hepatitis B monovalente (a partir 11 años, no inmunizados previamente)",
    grupo_pdss_id: 18,
    orden: 29,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 250
    nombre: "Dosis aplicada de vacuna antigripal en personas con factores de riesgo",
    grupo_pdss_id: 18,
    orden: 30,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 251
    nombre: "Dosis aplicada vacuna contra VPH en niñas 11 años",
    grupo_pdss_id: 18,
    orden: 31,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 252
    nombre: "Consejería en salud sexual (en terreno)",
    grupo_pdss_id: 18,
    orden: 32,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 15
  },
  {
    # id: 253
    nombre: "Salud sexual en adolescente",
    grupo_pdss_id: 18,
    orden: 33,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 15
  },
  {
    # id: 254
    nombre: "Diagnóstico temprano y confidencial de embarazo en adolescente",
    grupo_pdss_id: 18,
    orden: 34,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 255
    nombre: "Consulta para confirmación diagnóstica en población indígena con riesgo detectado en terreno",
    grupo_pdss_id: 18,
    orden: 35,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 3
  },
  {
    # id: 256
    nombre: "Consejería post-aborto",
    grupo_pdss_id: 18,
    orden: 36,
    linea_de_cuidado_id: 47,
    tipo_de_prestacion_id: 15
  },
  {
    # id: 257
    nombre: "Intento de suicidio (urgencia)",
    grupo_pdss_id: 18,
    orden: 37,
    linea_de_cuidado_id: 48,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 258
    nombre: "Seguimiento por intento de suicidio",
    grupo_pdss_id: 18,
    orden: 38,
    linea_de_cuidado_id: 48,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 259
    nombre: "Diagnóstica y de seguimiento de leucemia (inicial)",
    grupo_pdss_id: 18,
    orden: 39,
    linea_de_cuidado_id: 42,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 260
    nombre: "Diagnóstica y de seguimiento de leucemia (ulterior)",
    grupo_pdss_id: 18,
    orden: 40,
    linea_de_cuidado_id: 42,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 261
    nombre: "Notificación de inicio de tratamiento en tiempo oportuno (leucemia)",
    grupo_pdss_id: 18,
    orden: 41,
    linea_de_cuidado_id: 42,
    tipo_de_prestacion_id: 12
  },
  {
    # id: 262
    nombre: "Diagnóstica y de seguimiento de linfoma (inicial)",
    grupo_pdss_id: 18,
    orden: 42,
    linea_de_cuidado_id: 43,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 263
    nombre: "Diagnóstica y de seguimiento de linfoma (ulterior)",
    grupo_pdss_id: 18,
    orden: 43,
    linea_de_cuidado_id: 43,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 264
    nombre: "Notificación de inicio de tratamiento en tiempo oportuno (linfoma)",
    grupo_pdss_id: 18,
    orden: 44,
    linea_de_cuidado_id: 43,
    tipo_de_prestacion_id: 12
  },
  {
    # id: 265
    nombre: "Obesidad (inicial)",
    grupo_pdss_id: 18,
    orden: 45,
    linea_de_cuidado_id: 44,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 266
    nombre: "Obesidad (ulterior)",
    grupo_pdss_id: 18,
    orden: 46,
    linea_de_cuidado_id: 44,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 267
    nombre: "Sobrepeso (inicial)",
    grupo_pdss_id: 18,
    orden: 47,
    linea_de_cuidado_id: 45,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 268
    nombre: "Sobrepeso (ulterior)",
    grupo_pdss_id: 18,
    orden: 48,
    linea_de_cuidado_id: 45,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 269
    nombre: "Víctima de violencia sexual (urgencia)",
    grupo_pdss_id: 18,
    orden: 49,
    linea_de_cuidado_id: 49,
    tipo_de_prestacion_id: 4
  },

  # SECCIÓN 4 - Grupo 19

  {
    # id: 270
    nombre: "Ergometría",
    grupo_pdss_id: 19,
    orden: 1,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 271
    nombre: "Holter de 24 hs",
    grupo_pdss_id: 19,
    orden: 2,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 272
    nombre: "Presurometría",
    grupo_pdss_id: 19,
    orden: 3,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 273
    nombre: "Hemodinamia diagnóstica",
    grupo_pdss_id: 19,
    orden: 4,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 274
    nombre: "Resonancia magnética",
    grupo_pdss_id: 19,
    orden: 5,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 275
    nombre: "Tomografía",
    grupo_pdss_id: 19,
    orden: 6,
    linea_de_cuidado_id: 34,
    tipo_de_prestacion_id: 6
  },

  # SECCIÓN 4 - Grupo 20

  {
    # id: 276
    nombre: "Cierre de ductus con cirugía convencional",
    grupo_pdss_id: 20,
    orden: 1,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 277
    nombre: "Corrección de coartación de la aorta con cirugía convencional",
    grupo_pdss_id: 20,
    orden: 2,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 278
    nombre: "Reoperación por coartación de aorta residual",
    grupo_pdss_id: 20,
    orden: 3,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 279
    nombre: "Cierre de ductus con hemodinamia intervencionista",
    grupo_pdss_id: 20,
    orden: 4,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 280
    nombre: "Reintervención por ductus residual con hemodinamia intervencionista",
    grupo_pdss_id: 20,
    orden: 5,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 281
    nombre: "Corrección de coartación de la aorta con hemodinamia intervencionista",
    grupo_pdss_id: 20,
    orden: 6,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 282
    nombre: "Reintervención por recoartación de aorta con hemodinamia intervencionista",
    grupo_pdss_id: 20,
    orden: 7,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 283
    nombre: "Cierre de CIA con hemodinamia intervencionista",
    grupo_pdss_id: 20,
    orden: 8,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 284
    nombre: "Cierre de CIV con hemodinamia intervencionista",
    grupo_pdss_id: 20,
    orden: 9,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 285
    nombre: "Colocación de Stent en ramas pulmonares con hemodinamia intervencionista",
    grupo_pdss_id: 20,
    orden: 10,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 286
    nombre: "Embolización de colaterales de ramas pulmonares con hemodinamia intervencionista",
    grupo_pdss_id: 20,
    orden: 11,
    linea_de_cuidado_id: 34,
    modulo_id: 20,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 287
    nombre: "Cierre de CIA con cirugía convencional",
    grupo_pdss_id: 20,
    orden: 12,
    linea_de_cuidado_id: 34,
    modulo_id: 21,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 288
    nombre: "Cirugía correctora de anomalía parcial del retorno venoso pulmonar",
    grupo_pdss_id: 20,
    orden: 13,
    linea_de_cuidado_id: 34,
    modulo_id: 21,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 289
    nombre: "Cirugía correctora de canal A-V parcial",
    grupo_pdss_id: 20,
    orden: 14,
    linea_de_cuidado_id: 34,
    modulo_id: 21,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 290
    nombre: "Cierre de CIV con cirugía convencional",
    grupo_pdss_id: 20,
    orden: 15,
    linea_de_cuidado_id: 34,
    modulo_id: 22,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 4 - Grupo 21

  {
    # id: 291
    nombre: "Óxido nitríco y dispenser para su administración",
    grupo_pdss_id: 21,
    orden: 1,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 292
    nombre: "Levosimendán",
    grupo_pdss_id: 21,
    orden: 2,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 293
    nombre: "Factor VII activado recombinante",
    grupo_pdss_id: 21,
    orden: 3,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 294
    nombre: "Iloprost",
    grupo_pdss_id: 21,
    orden: 4,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 295
    nombre: "Trometanol",
    grupo_pdss_id: 21,
    orden: 5,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 296
    nombre: "Nutrición parenteral total",
    grupo_pdss_id: 21,
    orden: 6,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 297
    nombre: "Prótesis y órtesis",
    grupo_pdss_id: 21,
    orden: 7,
    linea_de_cuidado_id: 34,
    modulo_id: 23,
    tipo_de_prestacion_id: 11
  },

  # SECCIÓN 5 - Grupo 22

  {
    # id: 298
    nombre: "Anemia leve y moderada 20 a 49 años (inicial)",
    grupo_pdss_id: 22,
    orden: 1,
    linea_de_cuidado_id: 50,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 299
    nombre: "Anemia leve y moderada 20 a 49 años (ulterior)",
    grupo_pdss_id: 22,
    orden: 2,
    linea_de_cuidado_id: 50,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 300
    nombre: "Diagnóstica y seguimiento de CA cérvicouterino (inicial)",
    grupo_pdss_id: 22,
    orden: 3,
    linea_de_cuidado_id: 51,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 301
    nombre: "Diagnóstica y seguimiento de CA cérvicouterino (ulterior)",
    grupo_pdss_id: 22,
    orden: 4,
    linea_de_cuidado_id: 51,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 302
    nombre: "Colposcopía de lesión en cuello uterino, realizada por especialista en ASC-H, H-SIL, cáncer (CA cérvicouterino)",
    grupo_pdss_id: 22,
    orden: 5,
    linea_de_cuidado_id: 51,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 303
    nombre: "Biopsia de lesión en cuello uterino, realizada por especialista en ASC-H, H-SIL, cáncer (CA cérvicouterino)",
    grupo_pdss_id: 22,
    orden: 6,
    linea_de_cuidado_id: 51,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 304
    nombre: "Toma de muestra citológica (25 a 64 años) (tamizaje CA cérvicouterino)",
    grupo_pdss_id: 22,
    orden: 7,
    linea_de_cuidado_id: 51,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 305
    nombre: "Diagnóstico por biopsia en laboratorio de anatomía patológica, para aquellas mujeres con citología ASC-H, H-SIL, cáncer (CA cérvicouterino)",
    grupo_pdss_id: 22,
    orden: 8,
    linea_de_cuidado_id: 51,
    tipo_de_prestacion_id: 1
  },
  {
    # id: 306
    nombre: "Lectura de la muestra tomada en mujeres entre 25 y 64 años, en laboratorio de Anatomía Patológica/Citología con diagnóstico firmado por anátomo-patólogo matriculado (tamizaje de CA cérvicouterino)",
    grupo_pdss_id: 22,
    orden: 9,
    linea_de_cuidado_id: 51,
    tipo_de_prestacion_id: 1
  },
  {
    # id: 307
    nombre: "Notificación de caso positivo al responsable del servicio donde se realizó la toma de muestra (PAP) (CA cérvicouterino)",
    grupo_pdss_id: 22,
    orden: 10,
    linea_de_cuidado_id: 51,
    tipo_de_prestacion_id: 12
  },
  {
    # id: 308
    nombre: "Notificación de caso positivo al responsable del servicio donde se realizó la toma de muestra (biopsia) (CA cérvicouterino)",
    grupo_pdss_id: 22,
    orden: 11,
    linea_de_cuidado_id: 51,
    tipo_de_prestacion_id: 12
  },
  {
    # id: 309
    nombre: "Notificación de inicio de tratamiento en tiempo oportuno en ASC-H, H-SIL, cáncer (CA cérvicouterino)",
    grupo_pdss_id: 22,
    orden: 12,
    linea_de_cuidado_id: 51,
    tipo_de_prestacion_id: 12
  },
  {
    # id: 310
    nombre: "Diagnóstica y seguimiento de CA de mama (inicial)",
    grupo_pdss_id: 22,
    orden: 13,
    linea_de_cuidado_id: 52,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 311
    nombre: "Diagnóstica y seguimiento de CA de mama (ulterior)",
    grupo_pdss_id: 22,
    orden: 14,
    linea_de_cuidado_id: 52,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 312
    nombre: "Biopsia para las mujeres con mamografía BIRADS 4 y 5 (CA mama)",
    grupo_pdss_id: 22,
    orden: 15,
    linea_de_cuidado_id: 52,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 313
    nombre: "Mamografía bilateral, craneocaudal y oblicua, con proyección axilar mujeres (en mayores de 49 años cada 2 años con mamografía negativa)",
    grupo_pdss_id: 22,
    orden: 16,
    linea_de_cuidado_id: 52,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 314
    nombre: "Mamografía variedad magnificada",
    grupo_pdss_id: 22,
    orden: 17,
    linea_de_cuidado_id: 52,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 315
    nombre: "Anatomía patológica de biopsia (CA mama)",
    grupo_pdss_id: 22,
    orden: 18,
    linea_de_cuidado_id: 52,
    tipo_de_prestacion_id: 1
  },
  {
    # id: 316
    nombre: "Notificación de inicio de tratamiento en tiempo oportuno (CA mama)",
    grupo_pdss_id: 22,
    orden: 19,
    linea_de_cuidado_id: 52,
    tipo_de_prestacion_id: 12
  },
  {
    # id: 317
    nombre: "Prevención de comportamientos adictivos: tabaquismo, uso de drogas, alcoholismo",
    grupo_pdss_id: 22,
    orden: 20,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 318
    nombre: "Pautas nutricionales respetando cultura alimentaria de comunidades indígenas",
    grupo_pdss_id: 22,
    orden: 21,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 319
    nombre: "Prevención de accidentes",
    grupo_pdss_id: 22,
    orden: 22,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 320
    nombre: "Prevención de VIH e infecciones de transmisión Sexual",
    grupo_pdss_id: 22,
    orden: 23,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 321
    nombre: "Prevención de violencia de género",
    grupo_pdss_id: 22,
    orden: 24,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 322
    nombre: "Prevención de violencia familiar",
    grupo_pdss_id: 22,
    orden: 25,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 323
    nombre: "Promoción de hábitos saludables: salud bucal, educación alimentaria, pautas de higiene, trastornos de la alimentación",
    grupo_pdss_id: 22,
    orden: 26,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 324
    nombre: "Promoción de pautas alimentarias",
    grupo_pdss_id: 22,
    orden: 27,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 325
    nombre: "Promoción de salud sexual y reproductiva",
    grupo_pdss_id: 22,
    orden: 28,
    linea_de_cuidado_id: 4,
    tipo_de_prestacion_id: 16
  },
  {
    # id: 326
    nombre: "Control periódico de salud",
    grupo_pdss_id: 22,
    orden: 29,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 327
    nombre: "Control de salud individual para población indígena en terreno",
    grupo_pdss_id: 22,
    orden: 30,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 328
    nombre: "Control odontológico",
    grupo_pdss_id: 22,
    orden: 31,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 329
    nombre: "Dosis aplicada de doble viral (rubéola + sarampión)",
    grupo_pdss_id: 22,
    orden: 32,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 330
    nombre: "Dosis aplicada de vacuna antigripal en personas con factores de riesgo",
    grupo_pdss_id: 22,
    orden: 33,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 331
    nombre: "Control preconcepcional (inicial)",
    grupo_pdss_id: 22,
    orden: 34,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 332
    nombre: "Control preconcepcional (seguimiento)",
    grupo_pdss_id: 22,
    orden: 35,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 333
    nombre: "Salud sexual y procreación responsable",
    grupo_pdss_id: 22,
    orden: 36,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 15
  },
  {
    # id: 334
    nombre: "Consulta para confirmación diagnóstica en población indígena con riesgo detectado en terreno",
    grupo_pdss_id: 22,
    orden: 37,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 3
  },
  {
    # id: 335
    nombre: "Control ginecológico",
    grupo_pdss_id: 22,
    orden: 38,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 336
    nombre: "Dosis aplicada de doble adultos",
    grupo_pdss_id: 22,
    orden: 39,
    linea_de_cuidado_id: 25,
    tipo_de_prestacion_id: 8
  },
  {
    # id: 337
    nombre: "Consejería post-aborto",
    grupo_pdss_id: 22,
    orden: 40,
    linea_de_cuidado_id: 47,
    tipo_de_prestacion_id: 15
  },
  {
    # id: 338
    nombre: "Víctima de violencia sexual (urgencia)",
    grupo_pdss_id: 22,
    orden: 41,
    linea_de_cuidado_id: 49,
    tipo_de_prestacion_id: 4
  },

  # SECCIÓN 6 - Grupo 23

  {
    # id: 339
    nombre: "Cualquiera de los tipos de atresia esofágica",
    grupo_pdss_id: 23,
    orden: 1,
    linea_de_cuidado_id: 53,
    modulo_id: 24,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 340
    nombre: "Defecto del cierre de la pared abdominal, excluido el onfalocele",
    grupo_pdss_id: 23,
    orden: 2,
    linea_de_cuidado_id: 54,
    modulo_id: 25,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 341
    nombre: "Cuadros de oclusión intestinal en el recién nacido, incluye: atresias intestinales, malrotación intestinal, vólvulo, compresiones externas, hernias y duplicación intestinal (no incluye la aganglionosis intestinal)",
    grupo_pdss_id: 23,
    orden: 3,
    linea_de_cuidado_id: 55,
    modulo_id: 26,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 6 - Grupo 24

  {
    # id: 342
    nombre: "Atención de recién nacido prematuro (500 a 1500 g) durante los primeros días de vida",
    grupo_pdss_id: 24,
    orden: 1,
    linea_de_cuidado_id: 56,
    modulo_id: 27,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 343
    nombre: "Atención de recién nacido prematuro (500 a 1500 g) durante los primeros días de vida, sin requerimiento de ARM ni CPAP",
    grupo_pdss_id: 24,
    orden: 2,
    linea_de_cuidado_id: 56,
    modulo_id: 28,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 6 - Grupo 25

  {
    # id: 344
    nombre: "Corrección de canal AV completo",
    grupo_pdss_id: 25,
    orden: 1,
    linea_de_cuidado_id: 34,
    modulo_id: 29,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 345
    nombre: "Correctora de Fallot",
    grupo_pdss_id: 25,
    orden: 2,
    linea_de_cuidado_id: 34,
    modulo_id: 29,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 346
    nombre: "Correctora de doble salida de VD",
    grupo_pdss_id: 25,
    orden: 3,
    linea_de_cuidado_id: 34,
    modulo_id: 29,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 347
    nombre: "Cirugía de Fontan o by-pass total",
    grupo_pdss_id: 25,
    orden: 4,
    linea_de_cuidado_id: 34,
    modulo_id: 29,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 348
    nombre: "Cierre de CIV y del defecto asociado",
    grupo_pdss_id: 25,
    orden: 5,
    linea_de_cuidado_id: 34,
    modulo_id: 29,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 349
    nombre: "Reemplazo o plástica valvular con prótesis u homoinjerto; cirugía de Ross",
    grupo_pdss_id: 25,
    orden: 6,
    linea_de_cuidado_id: 34,
    modulo_id: 29,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 350
    nombre: "Cirugía de Rastelli",
    grupo_pdss_id: 25,
    orden: 7,
    linea_de_cuidado_id: 34,
    modulo_id: 29,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 351
    nombre: "Switch arterial; Nikeido; doble switch",
    grupo_pdss_id: 25,
    orden: 8,
    linea_de_cuidado_id: 34,
    modulo_id: 30,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 352
    nombre: "Plástica o reemplazo valvular",
    grupo_pdss_id: 25,
    orden: 9,
    linea_de_cuidado_id: 34,
    modulo_id: 30,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 353
    nombre: "Cierre de CIV más colocación de homoinjerto; recambio de homoinjerto; colocación de tubo con unifocalización",
    grupo_pdss_id: 25,
    orden: 10,
    linea_de_cuidado_id: 34,
    modulo_id: 30,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 354
    nombre: "Correctora de tronco arterioso",
    grupo_pdss_id: 25,
    orden: 11,
    linea_de_cuidado_id: 34,
    modulo_id: 30,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 355
    nombre: "Correctora de ATRVP",
    grupo_pdss_id: 25,
    orden: 12,
    linea_de_cuidado_id: 34,
    modulo_id: 30,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 356
    nombre: "Cirugía de Stansel con anastomosis; Glenn o Sano",
    grupo_pdss_id: 25,
    orden: 13,
    linea_de_cuidado_id: 34,
    modulo_id: 30,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 357
    nombre: "Reconstrucción del arco aórtico",
    grupo_pdss_id: 25,
    orden: 14,
    linea_de_cuidado_id: 34,
    modulo_id: 30,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 358
    nombre: "Reimplante o Takeuchi",
    grupo_pdss_id: 25,
    orden: 15,
    linea_de_cuidado_id: 34,
    modulo_id: 30,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 359
    nombre: "Norwood o Sano",
    grupo_pdss_id: 25,
    orden: 16,
    linea_de_cuidado_id: 34,
    modulo_id: 31,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 360
    nombre: "Glenn",
    grupo_pdss_id: 25,
    orden: 17,
    linea_de_cuidado_id: 34,
    modulo_id: 31,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 361
    nombre: "Fontan",
    grupo_pdss_id: 25,
    orden: 18,
    linea_de_cuidado_id: 34,
    modulo_id: 31,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 6 - Grupo 26

  {
    # id: 362
    nombre: "Alprostadil",
    grupo_pdss_id: 26,
    orden: 1,
    linea_de_cuidado_id: 34,
    modulo_id: 32,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 363
    nombre: "Óxido nitríco y dispenser para su administración",
    grupo_pdss_id: 26,
    orden: 2,
    linea_de_cuidado_id: 34,
    modulo_id: 32,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 364
    nombre: "Levosimendán",
    grupo_pdss_id: 26,
    orden: 3,
    linea_de_cuidado_id: 34,
    modulo_id: 32,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 365
    nombre: "Factor VII activado recombinante",
    grupo_pdss_id: 26,
    orden: 4,
    linea_de_cuidado_id: 34,
    modulo_id: 32,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 366
    nombre: "Iloprost",
    grupo_pdss_id: 26,
    orden: 5,
    linea_de_cuidado_id: 34,
    modulo_id: 32,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 367
    nombre: "Trometanol",
    grupo_pdss_id: 26,
    orden: 6,
    linea_de_cuidado_id: 34,
    modulo_id: 32,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 368
    nombre: "Surfactante",
    grupo_pdss_id: 26,
    orden: 7,
    linea_de_cuidado_id: 34,
    modulo_id: 32,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 369
    nombre: "Nutrición parenteral total",
    grupo_pdss_id: 26,
    orden: 8,
    linea_de_cuidado_id: 34,
    modulo_id: 32,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 370
    nombre: "Prótesis y órtesis",
    grupo_pdss_id: 26,
    orden: 9,
    linea_de_cuidado_id: 34,
    modulo_id: 32,
    tipo_de_prestacion_id: 11
  },

  # SECCIÓN 6 - Grupo 27

  {
    # id: 371
    nombre: "Reoperación por residuo en canal AV completo",
    grupo_pdss_id: 27,
    orden: 1,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 372
    nombre: "Correctora de Fallot",
    grupo_pdss_id: 27,
    orden: 2,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 373
    nombre: "Reoperación por residuo en tetralogía de Fallot operada; recambio de homoinjerto; plástica de ramas pulmonares; cierre de CIV residual; obstrucción al tracto de salida VD",
    grupo_pdss_id: 27,
    orden: 3,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 374
    nombre: "Correctora de doble salida VD",
    grupo_pdss_id: 27,
    orden: 4,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 375
    nombre: "Reoperación por residuo en DSVD operada; recambio de homoinjerto; desobstrucción subaórtica",
    grupo_pdss_id: 27,
    orden: 5,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 376
    nombre: "Cirugía de Fontan o by-pass total",
    grupo_pdss_id: 27,
    orden: 6,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 377
    nombre: "Reoperación por fallo del Fontan",
    grupo_pdss_id: 27,
    orden: 7,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 378
    nombre: "Reoperación por residuo en CIV compleja operada",
    grupo_pdss_id: 27,
    orden: 8,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 379
    nombre: "Reemplazo o plástica valvular con prótesis u homoinjerto; cirugía de Ross",
    grupo_pdss_id: 27,
    orden: 9,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 380
    nombre: "Reoperación en patología valvular operada; recambio de válvula u homoinjerto",
    grupo_pdss_id: 27,
    orden: 10,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 381
    nombre: "Reoperación por residuo en TGA o estenosis pulmonar operada",
    grupo_pdss_id: 27,
    orden: 11,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 382
    nombre: "Reoperación por residuo en transposición de los grandes vasos operada",
    grupo_pdss_id: 27,
    orden: 12,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 383
    nombre: "Plástica o reemplazo valvular",
    grupo_pdss_id: 27,
    orden: 13,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 384
    nombre: "Reoperación por residuo en anomalía de Ebstein operada",
    grupo_pdss_id: 27,
    orden: 14,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 385
    nombre: "Reoperación en atresia pulmonar con CIV operada",
    grupo_pdss_id: 27,
    orden: 15,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 386
    nombre: "Reoperación en tronco arterial operado;recambio de homoinjerto",
    grupo_pdss_id: 27,
    orden: 16,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 387
    nombre: "Reoperación en ventrículo único con obstrucción aórtica operado",
    grupo_pdss_id: 27,
    orden: 17,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 388
    nombre: "Reoperación por residuo en interrupción del arco aórtico operada",
    grupo_pdss_id: 27,
    orden: 18,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 389
    nombre: "Reimplante o Takeuchi",
    grupo_pdss_id: 27,
    orden: 19,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },
  {
    # id: 390
    nombre: "Fontan",
    grupo_pdss_id: 27,
    orden: 20,
    linea_de_cuidado_id: 34,
    modulo_id: 33,
    tipo_de_prestacion_id: 9
  },

  # SECCIÓN 6 - Grupo 28

  {
    # id: 391
    nombre: "Óxido nitríco y dispenser para su administración",
    grupo_pdss_id: 28,
    orden: 1,
    linea_de_cuidado_id: 34,
    modulo_id: 36,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 392
    nombre: "Levosimendán",
    grupo_pdss_id: 28,
    orden: 2,
    linea_de_cuidado_id: 34,
    modulo_id: 36,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 393
    nombre: "Factor VII activado recombinante",
    grupo_pdss_id: 28,
    orden: 3,
    linea_de_cuidado_id: 34,
    modulo_id: 36,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 394
    nombre: "Iloprost",
    grupo_pdss_id: 28,
    orden: 4,
    linea_de_cuidado_id: 34,
    modulo_id: 36,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 395
    nombre: "Trometanol",
    grupo_pdss_id: 28,
    orden: 5,
    linea_de_cuidado_id: 34,
    modulo_id: 36,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 396
    nombre: "Nutrición parenteral total",
    grupo_pdss_id: 28,
    orden: 6,
    linea_de_cuidado_id: 34,
    modulo_id: 36,
    tipo_de_prestacion_id: 11
  },
  {
    # id: 397
    nombre: "Prótesis y órtesis",
    grupo_pdss_id: 28,
    orden: 7,
    linea_de_cuidado_id: 34,
    modulo_id: 36,
    tipo_de_prestacion_id: 11
  },

  # SECCIÓN 7 - Grupo 29
  {
    # id: 398
    nombre: "Consulta de trabajador social",
    grupo_pdss_id: 29,
    orden: 1,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 4
  },
  {
    # id: 399
    nombre: "Cateterización",
    grupo_pdss_id: 29,
    orden: 2,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 400
    nombre: "Colocación de DIU",
    grupo_pdss_id: 29,
    orden: 3,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 401
    nombre: "Electrocardiograma",
    grupo_pdss_id: 29,
    orden: 4,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 402
    nombre: "Ergometría",
    grupo_pdss_id: 29,
    orden: 5,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 403
    nombre: "Espirometría",
    grupo_pdss_id: 29,
    orden: 6,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 404
    nombre: "Escisión / Remoción / Toma para biopsia / Punción lumbar",
    grupo_pdss_id: 29,
    orden: 7,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 405
    nombre: "Extracción de sangre",
    grupo_pdss_id: 29,
    orden: 8,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 406
    nombre: "Incisión / Drenaje / Lavado",
    grupo_pdss_id: 29,
    orden: 9,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 407
    nombre: "Inyección / Infiltración local / Venopuntura",
    grupo_pdss_id: 29,
    orden: 10,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 408
    nombre: "Medicina física / Rehabilitación",
    grupo_pdss_id: 29,
    orden: 11,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 409
    nombre: "Pruebas de sensibilización",
    grupo_pdss_id: 29,
    orden: 12,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 410
    nombre: "Registro de trazados eléctricos cerebrales",
    grupo_pdss_id: 29,
    orden: 13,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 411
    nombre: "Oftalmoscopía binocular indirecta (OBI)",
    grupo_pdss_id: 29,
    orden: 14,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 412
    nombre: "Audiometría tonal",
    grupo_pdss_id: 29,
    orden: 15,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 413
    nombre: "Logoaudiometría",
    grupo_pdss_id: 29,
    orden: 16,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 414
    nombre: "Fondo de ojo",
    grupo_pdss_id: 29,
    orden: 17,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 415
    nombre: "Punción de médula ósea",
    grupo_pdss_id: 29,
    orden: 18,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 416
    nombre: "Proteinuria rápida con tira reactiva",
    grupo_pdss_id: 29,
    orden: 19,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 417
    nombre: "Monitoreo fetal anteparto",
    grupo_pdss_id: 29,
    orden: 20,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 13
  },
  {
    # id: 418
    nombre: "Densitometría ósea",
    grupo_pdss_id: 29,
    orden: 21,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 419
    nombre: "Ecocardiograma con fracción de eyección",
    grupo_pdss_id: 29,
    orden: 22,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 420
    nombre: "Eco-Doppler color",
    grupo_pdss_id: 29,
    orden: 23,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 421
    nombre: "Ecografía bilateral de caderas (menores de 2 meses)",
    grupo_pdss_id: 29,
    orden: 24,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 422
    nombre: "Ecografía cerebral",
    grupo_pdss_id: 29,
    orden: 25,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 423
    nombre: "Ecografía de cuello",
    grupo_pdss_id: 29,
    orden: 26,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 424
    nombre: "Ecografía ginecológica",
    grupo_pdss_id: 29,
    orden: 27,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 425
    nombre: "Ecografìa mamaria",
    grupo_pdss_id: 29,
    orden: 28,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 426
    nombre: "Ecografía tiroidea",
    grupo_pdss_id: 29,
    orden: 29,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 427
    nombre: "Fibrocolonoscopía",
    grupo_pdss_id: 29,
    orden: 30,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 428
    nombre: "Fibrogastroscopía",
    grupo_pdss_id: 29,
    orden: 31,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 429
    nombre: "Fibrorrectosigmoideoscopía",
    grupo_pdss_id: 29,
    orden: 32,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 430
    nombre: "Rx de codo, antebrazo, muñeca, mano, dedos, rodilla, pierna, tobillo, pie; total o focalizada (frente y perfil)",
    grupo_pdss_id: 29,
    orden: 33,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 431
    nombre: "Rx de colon por enema, evacuado e insuflado (con o sin doble contraste)",
    grupo_pdss_id: 29,
    orden: 34,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 432
    nombre: "Rx de columna cervical; total o focalizada (frente y perfil)",
    grupo_pdss_id: 29,
    orden: 35,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 433
    nombre: "Rx de columna dorsal; total o focalizada (frente y perfil)",
    grupo_pdss_id: 29,
    orden: 36,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 434
    nombre: "Rx de columna lumbar; total o focalizada (frente y perfil)",
    grupo_pdss_id: 29,
    orden: 37,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 435
    nombre: "Rx de cráneo (frente y perfil); Rx de senos paranasales",
    grupo_pdss_id: 29,
    orden: 38,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 436
    nombre: "Rx, estudio seriado del tránsito esofagogastroduodenal contrastado",
    grupo_pdss_id: 29,
    orden: 39,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 437
    nombre: "Rx, estudio del tránsito de intestino delgado y cecoapendicular",
    grupo_pdss_id: 29,
    orden: 40,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 438
    nombre: "Rx de hombro, húmero, pelvis, cadera y fémur (total o focalizada), frente y perfil",
    grupo_pdss_id: 29,
    orden: 41,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 439
    nombre: "Rx o tele-Rx de tórax (total o focalizada), frente y perfil",
    grupo_pdss_id: 29,
    orden: 42,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 440
    nombre: "Rx sacrococcígea (total o focalizada), frente y perfil",
    grupo_pdss_id: 29,
    orden: 43,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 441
    nombre: "Rx simple de abdomen, frente y perfil",
    grupo_pdss_id: 29,
    orden: 44,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 442
    nombre: "Tomografía axial computada (TAC)",
    grupo_pdss_id: 29,
    orden: 45,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 443
    nombre: "Ecografia obstétrica",
    grupo_pdss_id: 29,
    orden: 46,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 444
    nombre: "Ecografia abdominal",
    grupo_pdss_id: 29,
    orden: 47,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 445
    nombre: "Eco-Doppler fetal",
    grupo_pdss_id: 29,
    orden: 48,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 446
    nombre: "Ecografía renal",
    grupo_pdss_id: 29,
    orden: 49,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 447
    nombre: "Ecocardiograma fetal",
    grupo_pdss_id: 29,
    orden: 50,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 448
    nombre: "Medulograma (recuento diferencial con tinción de MGG)",
    grupo_pdss_id: 29,
    orden: 51,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 6
  },
  {
    # id: 449
    nombre: "Unidad móvil de alta complejidad de adultos",
    grupo_pdss_id: 29,
    orden: 52,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 17
  },
  {
    # id: 450
    nombre: "Unidad móvil de alta complejidad pediátrica/neonatal",
    grupo_pdss_id: 29,
    orden: 53,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 17
  },
  {
    # id: 451
    nombre: "Traslado del RN prematuro de 500 a 1500 gramos, o de un RN con malformación congénita quirúrgica",
    grupo_pdss_id: 29,
    orden: 54,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 17
  },
  {
    # id: 452
    nombre: "Traslado de la gestante con diagnóstico de patología del embarazo; APP o malformación fetal mayor a centro de referencia",
    grupo_pdss_id: 29,
    orden: 55,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 17
  },
  {
    # id: 453
    nombre: "Unidad móvil de baja o mediana complejidad (hasta 50 km)",
    grupo_pdss_id: 29,
    orden: 56,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 17
  },
  {
    # id: 454
    nombre: "Unidad móvil de baja o mediana complejidad (más de 50 km)",
    grupo_pdss_id: 29,
    orden: 57,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 17
  },
  {
    # id: 455
    nombre: "17 Hidroxiprogesterona",
    grupo_pdss_id: 29,
    orden: 58,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 456
    nombre: "Ácido úrico",
    grupo_pdss_id: 29,
    orden: 59,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 457
    nombre: "Ácidos biliares",
    grupo_pdss_id: 29,
    orden: 60,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 458
    nombre: "Amilasa pancreática",
    grupo_pdss_id: 29,
    orden: 61,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 459
    nombre: "Antibiograma micobacterias",
    grupo_pdss_id: 29,
    orden: 62,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 460
    nombre: "Anticuerpos antitreponémicos",
    grupo_pdss_id: 29,
    orden: 63,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 461
    nombre: "Apolipoproteína B",
    grupo_pdss_id: 29,
    orden: 64,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 462
    nombre: "ASTO",
    grupo_pdss_id: 29,
    orden: 65,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 463
    nombre: "Baciloscopía",
    grupo_pdss_id: 29,
    orden: 66,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 464
    nombre: "Bacteriología directa y cultivo",
    grupo_pdss_id: 29,
    orden: 67,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 465
    nombre: "Bilirrubinas totales y fraccionadas",
    grupo_pdss_id: 29,
    orden: 68,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 466
    nombre: "Biotinidasa neonatal",
    grupo_pdss_id: 29,
    orden: 69,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 467
    nombre: "Calcemia",
    grupo_pdss_id: 29,
    orden: 70,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 468
    nombre: "Calciuria",
    grupo_pdss_id: 29,
    orden: 71,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 469
    nombre: "Campo oscuro",
    grupo_pdss_id: 29,
    orden: 72,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 470
    nombre: "Citología",
    grupo_pdss_id: 29,
    orden: 73,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 471
    nombre: "Colesterol",
    grupo_pdss_id: 29,
    orden: 74,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 472
    nombre: "Coprocultivo",
    grupo_pdss_id: 29,
    orden: 75,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 473
    nombre: "CPK",
    grupo_pdss_id: 29,
    orden: 76,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 474
    nombre: "Creatinina en orina",
    grupo_pdss_id: 29,
    orden: 77,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 475
    nombre: "Creatinina sérica",
    grupo_pdss_id: 29,
    orden: 78,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 476
    nombre: "Cuantificación de fibrinógeno",
    grupo_pdss_id: 29,
    orden: 79,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 477
    nombre: "Cultivo Streptococo B hemolítico",
    grupo_pdss_id: 29,
    orden: 80,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 478
    nombre: "Cultivo vaginal / Exudado de flujo",
    grupo_pdss_id: 29,
    orden: 81,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 479
    nombre: "Cultivo y antibiograma general",
    grupo_pdss_id: 29,
    orden: 82,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 480
    nombre: "Electroforesis de proteínas",
    grupo_pdss_id: 29,
    orden: 83,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 481
    nombre: "Eritrosedimentación",
    grupo_pdss_id: 29,
    orden: 84,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 482
    nombre: "Esputo seriado",
    grupo_pdss_id: 29,
    orden: 85,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 483
    nombre: "Estado ácido base",
    grupo_pdss_id: 29,
    orden: 86,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 484
    nombre: "Estudio citoquímico de médula ósea: PAS-Peroxidasa-Esterasas",
    grupo_pdss_id: 29,
    orden: 87,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 485
    nombre: "Estudio citogenético de médula ósea (técnica de bandeo G)",
    grupo_pdss_id: 29,
    orden: 88,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 486
    nombre: "Estudio de genética molecular de médula ósea (BCR/ABL, MLL/AF4 y TEL/AML1 por técnicas de RT-PCR o FISH)",
    grupo_pdss_id: 29,
    orden: 89,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 487
    nombre: "Factor de coagulación 5, 7, 8, 9 y 10",
    grupo_pdss_id: 29,
    orden: 90,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 488
    nombre: "Fenilalanina",
    grupo_pdss_id: 29,
    orden: 91,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 489
    nombre: "Fenilcetonuria",
    grupo_pdss_id: 29,
    orden: 92,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 490
    nombre: "Ferremia",
    grupo_pdss_id: 29,
    orden: 93,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 491
    nombre: "Ferritina",
    grupo_pdss_id: 29,
    orden: 94,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 492
    nombre: "Fosfatasa alcalina y ácida",
    grupo_pdss_id: 29,
    orden: 95,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 493
    nombre: "Fosfatemia",
    grupo_pdss_id: 29,
    orden: 96,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 494
    nombre: "FSH",
    grupo_pdss_id: 29,
    orden: 97,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 495
    nombre: "Galactosemia",
    grupo_pdss_id: 29,
    orden: 98,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 496
    nombre: "Gamma-GT (gamma glutamil transpeptidasa)",
    grupo_pdss_id: 29,
    orden: 99,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 497
    nombre: "Glucemia",
    grupo_pdss_id: 29,
    orden: 100,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 498
    nombre: "Glucosuria",
    grupo_pdss_id: 29,
    orden: 101,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 499
    nombre: "Gonadotrofina coriónica humana en sangre",
    grupo_pdss_id: 29,
    orden: 102,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 500
    nombre: "Gonadotrofina coriónica humana en orina",
    grupo_pdss_id: 29,
    orden: 103,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 501
    nombre: "Grasas en material fecal cualitativa",
    grupo_pdss_id: 29,
    orden: 104,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 502
    nombre: "Grupo y factor",
    grupo_pdss_id: 29,
    orden: 105,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 503
    nombre: "Hbs Ag",
    grupo_pdss_id: 29,
    orden: 106,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 504
    nombre: "HDL y LDL",
    grupo_pdss_id: 29,
    orden: 107,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 505
    nombre: "Hematocrito",
    grupo_pdss_id: 29,
    orden: 108,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 506
    nombre: "Hemocultivo aerobio anaerobio",
    grupo_pdss_id: 29,
    orden: 109,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 507
    nombre: "Hemoglobina",
    grupo_pdss_id: 29,
    orden: 110,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 508
    nombre: "Hemoglobina glicosilada",
    grupo_pdss_id: 29,
    orden: 111,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 509
    nombre: "Hemograma completo",
    grupo_pdss_id: 29,
    orden: 112,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 510
    nombre: "Hepatitis B anti HBS anticore total",
    grupo_pdss_id: 29,
    orden: 113,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 511
    nombre: "Hepatograma",
    grupo_pdss_id: 29,
    orden: 114,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 512
    nombre: "Hidatidosis por hemoaglutinación",
    grupo_pdss_id: 29,
    orden: 115,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 513
    nombre: "Hidatidosis por IFI",
    grupo_pdss_id: 29,
    orden: 116,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 514
    nombre: "Hisopado de fauces",
    grupo_pdss_id: 29,
    orden: 117,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 515
    nombre: "Homocistina",
    grupo_pdss_id: 29,
    orden: 118,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 516
    nombre: "IFI infecciones respiratorias",
    grupo_pdss_id: 29,
    orden: 119,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 517
    nombre: "IFI y hemoaglutinación directa para Chagas",
    grupo_pdss_id: 29,
    orden: 120,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 518
    nombre: "Insulinemia basal",
    grupo_pdss_id: 29,
    orden: 121,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 519
    nombre: "Inmunofenotipo de médula ósea por citometría de flujo",
    grupo_pdss_id: 29,
    orden: 122,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 520
    nombre: "Ionograma plasmático y orina",
    grupo_pdss_id: 29,
    orden: 123,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 521
    nombre: "KPTT",
    grupo_pdss_id: 29,
    orden: 124,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 522
    nombre: "LDH",
    grupo_pdss_id: 29,
    orden: 125,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 523
    nombre: "Leucocitos en material fecal",
    grupo_pdss_id: 29,
    orden: 126,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 524
    nombre: "LH",
    grupo_pdss_id: 29,
    orden: 127,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 525
    nombre: "Lipidograma electroforético",
    grupo_pdss_id: 29,
    orden: 128,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 526
    nombre: "Líquido cefalorraquídeo citoquímico y bacteriológico",
    grupo_pdss_id: 29,
    orden: 129,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 527
    nombre: "Líquido cefalorraquídeo - Recuento celular (cámara), citología (MGG, cytospin) e histoquímica",
    grupo_pdss_id: 29,
    orden: 130,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 528
    nombre: "Micológico",
    grupo_pdss_id: 29,
    orden: 131,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 529
    nombre: "Microalbuminuria",
    grupo_pdss_id: 29,
    orden: 132,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 530
    nombre: "Monotest",
    grupo_pdss_id: 29,
    orden: 133,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 531
    nombre: "Orina completa",
    grupo_pdss_id: 29,
    orden: 134,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 532
    nombre: "Parasitemia para Chagas",
    grupo_pdss_id: 29,
    orden: 135,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 533
    nombre: "Parasitológico de materia fecal",
    grupo_pdss_id: 29,
    orden: 136,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 534
    nombre: "pH en materia fecal",
    grupo_pdss_id: 29,
    orden: 137,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 535
    nombre: "Porcentaje de saturación de hierro funcional",
    grupo_pdss_id: 29,
    orden: 138,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 536
    nombre: "PPD",
    grupo_pdss_id: 29,
    orden: 139,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 537
    nombre: "Productos de degradación del fibrinógeno (PDF)",
    grupo_pdss_id: 29,
    orden: 140,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 538
    nombre: "Progesterona",
    grupo_pdss_id: 29,
    orden: 141,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 539
    nombre: "Prolactina",
    grupo_pdss_id: 29,
    orden: 142,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 540
    nombre: "Proteína C reactiva",
    grupo_pdss_id: 29,
    orden: 143,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 541
    nombre: "Proteínas totales y fraccionadas",
    grupo_pdss_id: 29,
    orden: 144,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 542
    nombre: "Proteinuria",
    grupo_pdss_id: 29,
    orden: 145,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 543
    nombre: "Protoporfirina libre eritrocitaria",
    grupo_pdss_id: 29,
    orden: 146,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 544
    nombre: "Prueba de Coombs directa",
    grupo_pdss_id: 29,
    orden: 147,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 545
    nombre: "Prueba de Coombs indirecta cuantitativa",
    grupo_pdss_id: 29,
    orden: 148,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 546
    nombre: "Prueba de tolerancia a la glucosa",
    grupo_pdss_id: 29,
    orden: 149,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 547
    nombre: "Reacción de Hudleson",
    grupo_pdss_id: 29,
    orden: 150,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 548
    nombre: "Reacción de Widal",
    grupo_pdss_id: 29,
    orden: 151,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 549
    nombre: "Receptores libres de transferrina",
    grupo_pdss_id: 29,
    orden: 152,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 550
    nombre: "Sangre oculta en heces",
    grupo_pdss_id: 29,
    orden: 153,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 551
    nombre: "Serología para Chagas (Elisa)",
    grupo_pdss_id: 29,
    orden: 154,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 552
    nombre: "Serología para hepatitis A IgM",
    grupo_pdss_id: 29,
    orden: 155,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 553
    nombre: "Serología para hepatitis A total",
    grupo_pdss_id: 29,
    orden: 156,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 554
    nombre: "Serología para rubéola IgM",
    grupo_pdss_id: 29,
    orden: 157,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 555
    nombre: "Sideremia",
    grupo_pdss_id: 29,
    orden: 158,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 556
    nombre: "T3",
    grupo_pdss_id: 29,
    orden: 159,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 557
    nombre: "T4 libre",
    grupo_pdss_id: 29,
    orden: 160,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 558
    nombre: "Test de Graham",
    grupo_pdss_id: 29,
    orden: 161,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 559
    nombre: "Test de látex",
    grupo_pdss_id: 29,
    orden: 162,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 560
    nombre: "TIBC",
    grupo_pdss_id: 29,
    orden: 163,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 561
    nombre: "Tiempo de lisis de euglobulina",
    grupo_pdss_id: 29,
    orden: 164,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 562
    nombre: "Toxoplasmosis por IFI",
    grupo_pdss_id: 29,
    orden: 165,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 563
    nombre: "Toxoplasmosis por MEIA",
    grupo_pdss_id: 29,
    orden: 166,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 564
    nombre: "Transaminasas TGO/TGP",
    grupo_pdss_id: 29,
    orden: 167,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 565
    nombre: "Transferrinas",
    grupo_pdss_id: 29,
    orden: 168,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 566
    nombre: "Triglicéridos",
    grupo_pdss_id: 29,
    orden: 169,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 567
    nombre: "Tripsina catiónica inmunorreactiva",
    grupo_pdss_id: 29,
    orden: 170,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 568
    nombre: "TSH",
    grupo_pdss_id: 29,
    orden: 171,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 569
    nombre: "Urea",
    grupo_pdss_id: 29,
    orden: 172,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 570
    nombre: "Urocultivo",
    grupo_pdss_id: 29,
    orden: 173,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 571
    nombre: "VDRL",
    grupo_pdss_id: 29,
    orden: 174,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 572
    nombre: "Vibrio cholerae cultivo e identificación",
    grupo_pdss_id: 29,
    orden: 175,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 573
    nombre: "VIH Elisa",
    grupo_pdss_id: 29,
    orden: 176,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 574
    nombre: "VIH Western Blot",
    grupo_pdss_id: 29,
    orden: 177,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 575
    nombre: "Serología para hepatitis C",
    grupo_pdss_id: 29,
    orden: 178,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 576
    nombre: "Magnesemia",
    grupo_pdss_id: 29,
    orden: 179,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 577
    nombre: "Serología LCR",
    grupo_pdss_id: 29,
    orden: 180,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 578
    nombre: "Recuento plaquetas",
    grupo_pdss_id: 29,
    orden: 181,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 579
    nombre: "Antígeno P24",
    grupo_pdss_id: 29,
    orden: 182,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 580
    nombre: "Hemoaglutinación indirecta Chagas",
    grupo_pdss_id: 29,
    orden: 183,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 581
    nombre: "IgE sérica",
    grupo_pdss_id: 29,
    orden: 184,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 582
    nombre: "Tiempo de coagulación y sangría",
    grupo_pdss_id: 29,
    orden: 185,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 583
    nombre: "Tiempo de protrombina",
    grupo_pdss_id: 29,
    orden: 186,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 584
    nombre: "Tiempo de trombina",
    grupo_pdss_id: 29,
    orden: 187,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 585
    nombre: "Frotis de sangre periférica",
    grupo_pdss_id: 29,
    orden: 188,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 586
    nombre: "Recuento reticulocitario",
    grupo_pdss_id: 29,
    orden: 189,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 587
    nombre: "Fructosamina",
    grupo_pdss_id: 29,
    orden: 190,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 10
  },
  {
    # id: 588
    nombre: "Ronda Sanitaria completa orientada a detección de población de riesgo en área rural",
    grupo_pdss_id: 29,
    orden: 191,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 14
  },
  {
    # id: 589
    nombre: "Ronda Sanitaria completa orientada a detección de población de riesgo en población indígena",
    grupo_pdss_id: 29,
    orden: 192,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 14
  },
  {
    # id: 590
    nombre: "Diagnóstico socio epidemiológico de población en riesgo por efector (informe final de ronda entregado y aprobado)",
    grupo_pdss_id: 29,
    orden: 193,
    linea_de_cuidado_id: nil,
    tipo_de_prestacion_id: 5
  }
])