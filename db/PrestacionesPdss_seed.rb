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
    # :id => 1
    :nombre => "Atención y tratamiento ambulatorio de anemia grave del embarazo (no incluye hemoderivados)",
    :grupo_pdss_id => 1,
    :orden => 1,
    :linea_de_cuidado_id => 1,
    :tipo_de_prestacion_id => 4,
  },
  {
    # :id => 2
    :nombre => "Atención y tratamiento ambulatorio de anemia leve del embarazo (inicial)",
    :grupo_pdss_id => 1,
    :orden => 2,
    :linea_de_cuidado_id => 2,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 3
    :nombre => "Atención y tratamiento ambulatorio de anemia leve del embarazo (ulterior)",
    :grupo_pdss_id => 1,
    :orden => 3,
    :linea_de_cuidado_id => 2,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 4
    :nombre => "Tratamiento ambulatorio de complicaciones de parto en puerperio inmediato (inicial)",
    :grupo_pdss_id => 1,
    :orden => 4,
    :linea_de_cuidado_id => 3,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 5
    :nombre => "Tratamiento ambulatorio de complicaciones de parto en puerperio inmediato (ulterior)",
    :grupo_pdss_id => 1,
    :orden => 5,
    :linea_de_cuidado_id => 3,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 6
    :nombre => "Búsqueda activa de embarazadas en el primer trimestre por agente sanitario y/o personal de salud",
    :grupo_pdss_id => 1,
    :orden => 6,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 3
  },
  {
    # :id => 7
    :nombre => "Búsqueda activa de embarazadas con abandono de controles, por agente sanitario y/o personal de salud",
    :grupo_pdss_id => 1,
    :orden => 7,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 3
  },
  {
    # :id => 8
    :nombre => "Encuentros para promoción del desarrollo infantil, prevención de patologías prevalentes en la infancia, conductas saludables, hábitos de higiene",
    :grupo_pdss_id => 1,
    :orden => 8,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 16
  },
  {
    # :id => 9
    :nombre => "Encuentros para promoción de pautas alimentarias en embarazadas, puérperas y niños menores de 6 años",
    :grupo_pdss_id => 1,
    :orden => 9,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 16
  },
  {
    # :id => 10
    :nombre => "Encuentros para promoción de salud sexual y reproductiva, conductas saludables, hábitos de higiene",
    :grupo_pdss_id => 1,
    :orden => 10,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 16
  },
  {
    # :id => 11
    :nombre => "Tratamiento de la hemorragia del 1er trimestre",
    :grupo_pdss_id => 1,
    :orden => 11,
    :linea_de_cuidado_id => 5,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 12
    :nombre => "Tratamiento de la hemorragia del 1er trimestre (clínica obstétrica)",
    :grupo_pdss_id => 1,
    :orden => 12,
    :linea_de_cuidado_id => 5,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 13
    :nombre => "Tratamiento de la hemorragia del 1er trimestre (quirúrgica)",
    :grupo_pdss_id => 1,
    :orden => 13,
    :linea_de_cuidado_id => 5,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 14
    :nombre => "Tratamiento de la hemorragia del 2do trimestre (clínica obstétrica)",
    :grupo_pdss_id => 1,
    :orden => 14,
    :linea_de_cuidado_id => 6,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 15
    :nombre => "Tratamiento de la hemorragia del 2do trimestre (quirúrgica)",
    :grupo_pdss_id => 1,
    :orden => 15,
    :linea_de_cuidado_id => 6,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 16
    :nombre => "Tratamiento de la hemorragia del 3er trimestre (clínica obstétrica)",
    :grupo_pdss_id => 1,
    :orden => 16,
    :linea_de_cuidado_id => 7,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 17
    :nombre => "Tratamiento de la hemorragia del 3er trimestre (quirúrgica)",
    :grupo_pdss_id => 1,
    :orden => 17,
    :linea_de_cuidado_id => 7,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 18
    :nombre => "Atención y tratamiento ambulatorio de infección urinaria en embarazada",
    :grupo_pdss_id => 1,
    :orden => 18,
    :linea_de_cuidado_id => 8,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 19
    :nombre => "Cesárea y atención del recién nacido",
    :grupo_pdss_id => 1,
    :orden => 19,
    :linea_de_cuidado_id => 9,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 20
    :nombre => "Atención de parto y recién nacido",
    :grupo_pdss_id => 1,
    :orden => 20,
    :linea_de_cuidado_id => 10,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 21
    :nombre => "Control prenatal de 1ra vez",
    :grupo_pdss_id => 1,
    :orden => 21,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 22
    :nombre => "Ulterior de control prenatal",
    :grupo_pdss_id => 1,
    :orden => 22,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 23
    :nombre => "Odontológica prenatal - profilaxis",
    :grupo_pdss_id => 1,
    :orden => 23,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 24
    :nombre => "Control odontológico en el tratamiento de gingivitis y enfermedad periodontal leve",
    :grupo_pdss_id => 1,
    :orden => 24,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 25
    :nombre => "Toma de muestra para PAP (incluye material descartable)",
    :grupo_pdss_id => 1,
    :orden => 25,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 26
    :nombre => "Colposcopía en control de embarazo (incluye material descartable)",
    :grupo_pdss_id => 1,
    :orden => 26,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 27
    :nombre => "Tartrectomía y cepillado mecánico",
    :grupo_pdss_id => 1,
    :orden => 27,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 28
    :nombre => "Inactivación de caries",
    :grupo_pdss_id => 1,
    :orden => 28,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 29
    :nombre => "Carta de derechos de la mujer embarazada indígena",
    :grupo_pdss_id => 1,
    :orden => 29,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 15
  },
  {
    # :id => 30
    :nombre => "Educación para la salud en embarazo (bio-psico-social)",
    :grupo_pdss_id => 1,
    :orden => 30,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 15
  },
  {
    # :id => 31
    :nombre => "Lectura de la muestra tomada en mujeres embarazadas, en laboratorio de Anatomía patológica/Citología con diagnóstico firmado por anátomo-patólogo matriculado (CA cérvicouterino)",
    :grupo_pdss_id => 1,
    :orden => 31,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 1
  },
  {
    # :id => 32
    :nombre => "Control prenatal de embarazo de alto riesgo",
    :grupo_pdss_id => 1,
    :orden => 32,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 33
    :nombre => "Dosis aplicada de vacuna triple bacteriana acelular (dTpa)",
    :grupo_pdss_id => 1,
    :orden => 33,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 34
    :nombre => "Inmunización doble adulto en embarazo",
    :grupo_pdss_id => 1,
    :orden => 34,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 35
    :nombre => "Dosis aplicada de vacuna antigripal en embarazo o puerperio",
    :grupo_pdss_id => 1,
    :orden => 35,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 36
    :nombre => "Puerperio inmediato",
    :grupo_pdss_id => 1,
    :orden => 36,
    :linea_de_cuidado_id => 12,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 37
    :nombre => "Dosis aplicada de vacuna antigripal en embarazo o puerperio",
    :grupo_pdss_id => 1,
    :orden => 37,
    :linea_de_cuidado_id => 12,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 38
    :nombre => "Inmunización puerperal doble viral (rubéola)",
    :grupo_pdss_id => 1,
    :orden => 38,
    :linea_de_cuidado_id => 12,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 39
    :nombre => "Consejería puerperal en SS y R; lactancia materna y puericultura (prevención de muerte súbita y signos de alarma)",
    :grupo_pdss_id => 1,
    :orden => 39,
    :linea_de_cuidado_id => 12,
    :tipo_de_prestacion_id => 15
  },
  {
    # :id => 40
    :nombre => "Atención y tratamiento ambulatorio de sífilis e ITS en embarazo",
    :grupo_pdss_id => 1,
    :orden => 40,
    :linea_de_cuidado_id => 13,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 41
    :nombre => "Atención y tratamiento ambulatorio de VIH en la embarazada",
    :grupo_pdss_id => 1,
    :orden => 41,
    :linea_de_cuidado_id => 14,
    :tipo_de_prestacion_id => 4
  },

  # SECCIÓN 1 - Grupo 2

  {
    # :id => 42
    :nombre => "Consulta seguimiento post alta",
    :grupo_pdss_id => 2,
    :orden => 1,
    :linea_de_cuidado_id => 15,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 43
    :nombre => "Ref. por embarazo de alto riesgo de Nivel 2 ó 3 a niveles de complejidad sup.",
    :grupo_pdss_id => 2,
    :orden => 2,
    :linea_de_cuidado_id => 16,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 44
    :nombre => "Consulta inicial de diabetes gestacional",
    :grupo_pdss_id => 2,
    :orden => 3,
    :linea_de_cuidado_id => 17,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 45
    :nombre => "Consulta de seguimiento de diabetes gestacional",
    :grupo_pdss_id => 2,
    :orden => 4,
    :linea_de_cuidado_id => 17,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 46
    :nombre => "Consulta con oftalmología",
    :grupo_pdss_id => 2,
    :orden => 5,
    :linea_de_cuidado_id => 17,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 47
    :nombre => "Consulta con cardiología",
    :grupo_pdss_id => 2,
    :orden => 6,
    :linea_de_cuidado_id => 17,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 48
    :nombre => "Consulta con endocrinólogo",
    :grupo_pdss_id => 2,
    :orden => 7,
    :linea_de_cuidado_id => 17,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 49
    :nombre => "Consulta con nutricionista",
    :grupo_pdss_id => 2,
    :orden => 8,
    :linea_de_cuidado_id => 17,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 50
    :nombre => "Consulta seguimiento puerperio paciente con diabetes gestacional",
    :grupo_pdss_id => 2,
    :orden => 9,
    :linea_de_cuidado_id => 17,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 51
    :nombre => "Consulta puerperio con nutricionista",
    :grupo_pdss_id => 2,
    :orden => 10,
    :linea_de_cuidado_id => 17,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 52
    :nombre => "Consulta seguimiento puerperio en hemorragia posparto",
    :grupo_pdss_id => 2,
    :orden => 11,
    :linea_de_cuidado_id => 18,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 53
    :nombre => "Consulta inicial de la embarazada con hipertensión crónica",
    :grupo_pdss_id => 2,
    :orden => 12,
    :linea_de_cuidado_id => 19,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 54
    :nombre => "Consulta de seguimiento de la embarazada con hipertensión crónica",
    :grupo_pdss_id => 2,
    :orden => 13,
    :linea_de_cuidado_id => 19,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 55
    :nombre => "Consulta con oftalmología",
    :grupo_pdss_id => 2,
    :orden => 14,
    :linea_de_cuidado_id => 19,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 56
    :nombre => "Consulta con nefrología",
    :grupo_pdss_id => 2,
    :orden => 15,
    :linea_de_cuidado_id => 19,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 57
    :nombre => "Consulta con cardiología",
    :grupo_pdss_id => 2,
    :orden => 16,
    :linea_de_cuidado_id => 19,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 58
    :nombre => "Consulta seguimiento puerperio de paciente con hipertensión",
    :grupo_pdss_id => 2,
    :orden => 17,
    :linea_de_cuidado_id => 19,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 59
    :nombre => "Consulta inicial de hipertensión gestacional",
    :grupo_pdss_id => 2,
    :orden => 18,
    :linea_de_cuidado_id => 20,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 60
    :nombre => "Consulta de seguimiento de la hipertensión gestacional",
    :grupo_pdss_id => 2,
    :orden => 19,
    :linea_de_cuidado_id => 20,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 61
    :nombre => "Consulta con cardiología",
    :grupo_pdss_id => 2,
    :orden => 20,
    :linea_de_cuidado_id => 20,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 62
    :nombre => "Consulta seguimiento puerperio de paciente con hipertensión",
    :grupo_pdss_id => 2,
    :orden => 21,
    :linea_de_cuidado_id => 20,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 63
    :nombre => "Notificación de factores de riesgo",
    :grupo_pdss_id => 2,
    :orden => 22,
    :linea_de_cuidado_id => 11,
    :tipo_de_prestacion_id => 4
  },

  # SECCIÓN 1 - Grupo 3

  {
    # :id => 64
    :nombre => "Internación por preeclampsia grave, eclampsia o sindrome Hellp",
    :grupo_pdss_id => 3,
    :orden => 1,
    :linea_de_cuidado_id => 21,
    :modulo_id => 1,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 65
    :nombre => "Internación por amenaza de parto prematuro",
    :grupo_pdss_id => 3,
    :orden => 2,
    :linea_de_cuidado_id => 15,
    :modulo_id => 2,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 66
    :nombre => "Hemorragia posparto con histerectomía",
    :grupo_pdss_id => 3,
    :orden => 3,
    :linea_de_cuidado_id => 18,
    :modulo_id => 3,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 67
    :nombre => "Hemorragia posparto sin histerectomía",
    :grupo_pdss_id => 3,
    :orden => 4,
    :linea_de_cuidado_id => 18,
    :modulo_id => 4,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 68
    :nombre => "Diabetes gestacional sin requerimiento de insulina",
    :grupo_pdss_id => 3,
    :orden => 5,
    :linea_de_cuidado_id => 17,
    :modulo_id => 5,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 69
    :nombre => "Diabetes gestacional con requerimiento de insulina",
    :grupo_pdss_id => 3,
    :orden => 6,
    :linea_de_cuidado_id => 17,
    :modulo_id => 6,
    :tipo_de_prestacion_id => 9
  },

  # SECCIÓN 1 - Grupo 4

  {
    # :id => 70
    :nombre => "Diabetes gestacional",
    :grupo_pdss_id => 4,
    :orden => 1,
    :linea_de_cuidado_id => 17,
    :modulo_id => 7,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 71
    :nombre => "Hipertensión en embarazo",
    :grupo_pdss_id => 4,
    :orden => 2,
    :linea_de_cuidado_id => 22,
    :modulo_id => 8,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 72
    :nombre => "Restricción del crecimiento intrauterino: pequeño para edad gestacional",
    :grupo_pdss_id => 4,
    :orden => 3,
    :linea_de_cuidado_id => 23,
    :modulo_id => 9,
    :tipo_de_prestacion_id => 9
  },

  # SECCIÓN 1 - Grupo 5

  {
    # :id => 73
    :nombre => "Informe de comité de auditoría de muerte materna y/o infantil recibido y aprobado por el Ministerio de Salud de la Provincia, según ordenamiento",
    :grupo_pdss_id => 5,
    :orden => 1,
    :linea_de_cuidado_id => nil,
    :tipo_de_prestacion_id => 2
  },

  # SECCIÓN 2 - Grupo 6

  {
    # :id => 74
    :nombre => "Tratamiento inmediato de Chagas congénito",
    :grupo_pdss_id => 6,
    :orden => 1,
    :linea_de_cuidado_id => 24,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 75
    :nombre => "Inmunización de recién nacido (BCG antes del alta y Hepatitis B en primeras 12 hs de vida)",
    :grupo_pdss_id => 6,
    :orden => 2,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 76
    :nombre => "Oftalmoscopía binocular indirecta (OBI) a todo niño de riesgo (pesquisa de la retinopatía del prematuro)",
    :grupo_pdss_id => 6,
    :orden => 3,
    :linea_de_cuidado_id => 26,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 77
    :nombre => "Otoemisiones acústicas para detección temprana de hipoacusia en RN",
    :grupo_pdss_id => 6,
    :orden => 4,
    :linea_de_cuidado_id => 27,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 78
    :nombre => "Tratamiento inmediato de sífilis congénita en RN",
    :grupo_pdss_id => 6,
    :orden => 5,
    :linea_de_cuidado_id => 28,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 79
    :nombre => "Incubadora hasta 48 hs en RN",
    :grupo_pdss_id => 6,
    :orden => 6,
    :linea_de_cuidado_id => 29,
    :tipo_de_prestacion_id => 7
  },
  {
    # :id => 80
    :nombre => "Tratamiento inmediato de trastornos metabólicos (estado ácido base y electrolitos) en RN",
    :grupo_pdss_id => 6,
    :orden => 7,
    :linea_de_cuidado_id => 30,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 81
    :nombre => "Atención de RN con condición grave al nacer (tratamiento pre-referencia)",
    :grupo_pdss_id => 6,
    :orden => 8,
    :linea_de_cuidado_id => 30,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 82
    :nombre => "Tratamiento inmediato de transmisión vertical de VIH en RN",
    :grupo_pdss_id => 6,
    :orden => 9,
    :linea_de_cuidado_id => 31,
    :tipo_de_prestacion_id => 9
  },

  # SECCIÓN 2 - Grupo 7

  {
    # :id => 83
    :nombre => "Ano imperforado alto o bajo",
    :grupo_pdss_id => 7,
    :orden => 1,
    :linea_de_cuidado_id => 32,
    :modulo_id => 10,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 84
    :nombre => "Mielomeningocele",
    :grupo_pdss_id => 7,
    :orden => 2,
    :linea_de_cuidado_id => 32,
    :modulo_id => 11,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 85
    :nombre => "Hidrocefalia",
    :grupo_pdss_id => 7,
    :orden => 3,
    :linea_de_cuidado_id => 32,
    :modulo_id => 12,
    :tipo_de_prestacion_id => 9
  },

  # SECCIÓN 2 - Grupo 8

  {
    # :id => 86
    :nombre => "Ingreso",
    :grupo_pdss_id => 8,
    :orden => 1,
    :linea_de_cuidado_id => 33,
    :modulo_id => 13,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 87
    :nombre => "Egreso",
    :grupo_pdss_id => 8,
    :orden => 2,
    :linea_de_cuidado_id => 33,
    :modulo_id => 14,
    :tipo_de_prestacion_id => 4
  },

  # SECCIÓN 2 - Grupo 9

  {
    # :id => 88
    :nombre => "Ergometría",
    :grupo_pdss_id => 9,
    :orden => 1,
    :linea_de_cuidado_id => 34,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 89
    :nombre => "Holter de 24 hs",
    :grupo_pdss_id => 9,
    :orden => 2,
    :linea_de_cuidado_id => 34,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 90
    :nombre => "Presurometría",
    :grupo_pdss_id => 9,
    :orden => 3,
    :linea_de_cuidado_id => 34,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 91
    :nombre => "Hemodinamia diagnóstica",
    :grupo_pdss_id => 9,
    :orden => 4,
    :linea_de_cuidado_id => 34,
    :tipo_de_prestacion_id => 6
  },
  {
    # :id => 92
    :nombre => "Resonancia magnética",
    :grupo_pdss_id => 9,
    :orden => 5,
    :linea_de_cuidado_id => 34,
    :tipo_de_prestacion_id => 6
  },
  {
    # :id => 93
    :nombre => "Tomografía",
    :grupo_pdss_id => 9,
    :orden => 6,
    :linea_de_cuidado_id => 34,
    :tipo_de_prestacion_id => 6
  },

  # SECCIÓN 2 - Grupo 10

  {
    # :id => 94
    :nombre => "Cierre de ductus con cirugía convencional",
    :grupo_pdss_id => 10,
    :orden => 1,
    :linea_de_cuidado_id => 34,
    :modulo_id => 15,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 95
    :nombre => "Cerclaje de arteria pulmonar con cirugía convencional",
    :grupo_pdss_id => 10,
    :orden => 2,
    :linea_de_cuidado_id => 34,
    :modulo_id => 15,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 96
    :nombre => "Anastomosis subclavio-pulmonar con cirugía convencional",
    :grupo_pdss_id => 10,
    :orden => 3,
    :linea_de_cuidado_id => 34,
    :modulo_id => 15,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 97
    :nombre => "Corrección de coartación de la aorta con cirugía convencional",
    :grupo_pdss_id => 10,
    :orden => 4,
    :linea_de_cuidado_id => 34,
    :modulo_id => 15,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 98
    :nombre => "Cierre de ductus con hemodinamia intervencionista",
    :grupo_pdss_id => 10,
    :orden => 5,
    :linea_de_cuidado_id => 34,
    :modulo_id => 15,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 99
    :nombre => "Corrección de coartación de la aorta con hemodinamia intervencionista",
    :grupo_pdss_id => 10,
    :orden => 6,
    :linea_de_cuidado_id => 34,
    :modulo_id => 15,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 100
    :nombre => "Cierre de CIA con hemodinamia intervencionista",
    :grupo_pdss_id => 10,
    :orden => 7,
    :linea_de_cuidado_id => 34,
    :modulo_id => 15,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 101
    :nombre => "Cierre de CIV con hemodinamia intervencionista",
    :grupo_pdss_id => 10,
    :orden => 8,
    :linea_de_cuidado_id => 34,
    :modulo_id => 15,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 102
    :nombre => "Colocación de Stent en ramas pulmonares con hemodinamia intervencionista",
    :grupo_pdss_id => 10,
    :orden => 9,
    :linea_de_cuidado_id => 34,
    :modulo_id => 15,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 103
    :nombre => "Embolización de colaterales de ramas pulmonares con hemodinamia intervencionista",
    :grupo_pdss_id => 10,
    :orden => 10,
    :linea_de_cuidado_id => 34,
    :modulo_id => 15,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 104
    :nombre => "Cierre de ductus",
    :grupo_pdss_id => 10,
    :orden => 11,
    :linea_de_cuidado_id => 34,
    :modulo_id => 16,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 105
    :nombre => "Cerclaje de arteria pulmonar",
    :grupo_pdss_id => 10,
    :orden => 12,
    :linea_de_cuidado_id => 34,
    :modulo_id => 16,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 106
    :nombre => "Anastomosis subclavio-pulmonar",
    :grupo_pdss_id => 10,
    :orden => 13,
    :linea_de_cuidado_id => 34,
    :modulo_id => 16,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 107
    :nombre => "Corrección de coartación de la aorta",
    :grupo_pdss_id => 10,
    :orden => 14,
    :linea_de_cuidado_id => 34,
    :modulo_id => 16,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 108
    :nombre => "Cirugía de Glenn",
    :grupo_pdss_id => 10,
    :orden => 15,
    :linea_de_cuidado_id => 34,
    :modulo_id => 17,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 109
    :nombre => "Cierre de CIA con cirugía convencional",
    :grupo_pdss_id => 10,
    :orden => 16,
    :linea_de_cuidado_id => 34,
    :modulo_id => 17,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 110
    :nombre => "Cirugía correctora",
    :grupo_pdss_id => 10,
    :orden => 17,
    :linea_de_cuidado_id => 34,
    :modulo_id => 17,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 111
    :nombre => "Correctora de ventana aortopulmonar",
    :grupo_pdss_id => 10,
    :orden => 18,
    :linea_de_cuidado_id => 34,
    :modulo_id => 17,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 112
    :nombre => "Correctora de canal A-V parcial",
    :grupo_pdss_id => 10,
    :orden => 19,
    :linea_de_cuidado_id => 34,
    :modulo_id => 17,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 113
    :nombre => "Cierre de CIV con cirugía convencional",
    :grupo_pdss_id => 10,
    :orden => 20,
    :linea_de_cuidado_id => 34,
    :modulo_id => 18,
    :tipo_de_prestacion_id => 9
  },

  # SECCIÓN 2 - Grupo 11

  {
    # :id => 114
    :nombre => "Alprostadil",
    :grupo_pdss_id => 11,
    :orden => 1,
    :linea_de_cuidado_id => 34,
    :modulo_id => 19,
    :tipo_de_prestacion_id => 11
  },
  {
    # :id => 115
    :nombre => "Óxido nitríco y dispenser para su administración",
    :grupo_pdss_id => 11,
    :orden => 2,
    :linea_de_cuidado_id => 34,
    :modulo_id => 19,
    :tipo_de_prestacion_id => 11
  },
  {
    # :id => 116
    :nombre => "Levosimendán",
    :grupo_pdss_id => 11,
    :orden => 3,
    :linea_de_cuidado_id => 34,
    :modulo_id => 19,
    :tipo_de_prestacion_id => 11
  },
  {
    # :id => 117
    :nombre => "Factor VII activado recombinante",
    :grupo_pdss_id => 11,
    :orden => 4,
    :linea_de_cuidado_id => 34,
    :modulo_id => 19,
    :tipo_de_prestacion_id => 11
  },
  {
    # :id => 118
    :nombre => "Iloprost",
    :grupo_pdss_id => 11,
    :orden => 5,
    :linea_de_cuidado_id => 34,
    :modulo_id => 19,
    :tipo_de_prestacion_id => 11
  },
  {
    # :id => 119
    :nombre => "Trometanol",
    :grupo_pdss_id => 11,
    :orden => 6,
    :linea_de_cuidado_id => 34,
    :modulo_id => 19,
    :tipo_de_prestacion_id => 11
  },
  {
    # :id => 120
    :nombre => "Surfactante",
    :grupo_pdss_id => 11,
    :orden => 7,
    :linea_de_cuidado_id => 34,
    :modulo_id => 19,
    :tipo_de_prestacion_id => 11
  },
  {
    # :id => 121
    :nombre => "Nutrición parenteral total",
    :grupo_pdss_id => 11,
    :orden => 8,
    :linea_de_cuidado_id => 34,
    :modulo_id => 19,
    :tipo_de_prestacion_id => 11
  },
  {
    # :id => 122
    :nombre => "Prótesis y órtesis",
    :grupo_pdss_id => 11,
    :orden => 9,
    :linea_de_cuidado_id => 34,
    :modulo_id => 19,
    :tipo_de_prestacion_id => 11
  },

  # SECCIÓN 2 - Grupo 12

  {
    # :id => 123
    :nombre => "Búsqueda activa de niños con abandono de controles",
    :grupo_pdss_id => 12,
    :orden => 1,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 3
  },
  {
    # :id => 124
    :nombre => "Encuentros para promoción de pautas alimentarias en embarazadas, puérperas y niños menores de 6 años",
    :grupo_pdss_id => 12,
    :orden => 2,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 16
  },
  {
    # :id => 125
    :nombre => "Encuentros para promoción del desarrollo infantil, prevención de patolog. prevalentes en la infancia, conductas saludables, hábitos de higiene",
    :grupo_pdss_id => 12,
    :orden => 3,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 16
  },
  {
    # :id => 126
    :nombre => "Examen periódico de salud de niños menores de 1 año",
    :grupo_pdss_id => 12,
    :orden => 4,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 127
    :nombre => "Examen periódico de salud de niños de 1 a 5 años",
    :grupo_pdss_id => 12,
    :orden => 5,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 128
    :nombre => "Consulta buco-dental en salud en niños menores de 6 años",
    :grupo_pdss_id => 12,
    :orden => 6,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 129
    :nombre => "Consulta oftalmológica en niños de 5 años",
    :grupo_pdss_id => 12,
    :orden => 7,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 130
    :nombre => "Inactivación de caries",
    :grupo_pdss_id => 12,
    :orden => 8,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 131
    :nombre => "Dosis aplicada de vacuna triple viral en niños menores de 6 años",
    :grupo_pdss_id => 12,
    :orden => 9,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 132
    :nombre => "Dosis aplicada de Sabín en niños de 2, 4, 6 y 18 meses y 6 años o actualización de esquema",
    :grupo_pdss_id => 12,
    :orden => 10,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 133
    :nombre => "Dosis aplicada de inmunización pentavalente en niños de 2, 4, 6 y 18 meses o actualización de esquema",
    :grupo_pdss_id => 12,
    :orden => 11,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 134
    :nombre => "Dosis aplicada de inmunización cuádruple en niños de 18 meses o actualización de esquema",
    :grupo_pdss_id => 12,
    :orden => 12,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 135
    :nombre => "Dosis aplicada de inmunización para hepatitis A en niños de 12 meses o actualización de esquema",
    :grupo_pdss_id => 12,
    :orden => 13,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 136
    :nombre => "Dosis aplicada de inmunización triple bacteriana celular en niños de 6 años o actualización de esquema",
    :grupo_pdss_id => 12,
    :orden => 14,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 137
    :nombre => "Dosis aplicada de inmunización anti-amarílica en niños de 12 meses en departamentos de riesgo",
    :grupo_pdss_id => 12,
    :orden => 15,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 138
    :nombre => "Dosis aplicada de vacuna doble viral (SR) al ingreso escolar",
    :grupo_pdss_id => 12,
    :orden => 16,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 139
    :nombre => "Dosis aplicada de vacuna antigripal en niños de 6 a 24 meses o en niños mayores con factores de riesgo",
    :grupo_pdss_id => 12,
    :orden => 17,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 140
    :nombre => "Dosis aplicada de vacuna neumococo conjugada",
    :grupo_pdss_id => 12,
    :orden => 18,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 141
    :nombre => "Consultas con pediatras especialistas en cardiología, nefrología, infectología, gastroenterología",
    :grupo_pdss_id => 12,
    :orden => 19,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 142
    :nombre => "Atención ambulatoria con suplementación vitamínica a niños desnutridos menores de 6 años (inicial)",
    :grupo_pdss_id => 12,
    :orden => 20,
    :linea_de_cuidado_id => 35,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 143
    :nombre => "Atención ambulatoria con suplementación vitamínica a niños desnutridos menores de 6 años (ulterior)",
    :grupo_pdss_id => 12,
    :orden => 21,
    :linea_de_cuidado_id => 35,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 144
    :nombre => "Consulta de niños con especialistas (hipoacusia en lactante \"No pasa\" con Otoemisiones acústicas)",
    :grupo_pdss_id => 12,
    :orden => 22,
    :linea_de_cuidado_id => 27,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 145
    :nombre => "Rescreening de hipoacusia en lactante \"No pasa\" con BERA",
    :grupo_pdss_id => 12,
    :orden => 23,
    :linea_de_cuidado_id => 27,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 146
    :nombre => "Rescreening de hipoacusia en lactante \"No pasa\" con otoemisiones acústicas",
    :grupo_pdss_id => 12,
    :orden => 24,
    :linea_de_cuidado_id => 27,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 147
    :nombre => "Atención ambulatoria de enfermedades diarreicas agudas en niños menores de 6 años (inicial)",
    :grupo_pdss_id => 12,
    :orden => 25,
    :linea_de_cuidado_id => 36,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 148
    :nombre => "Atención ambulatoria de enfermedades diarreicas agudas en niños menores de 6 años (ulterior)",
    :grupo_pdss_id => 12,
    :orden => 26,
    :linea_de_cuidado_id => 36,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 149
    :nombre => "Posta de rehidratación: diarrea aguda en ambulatorio",
    :grupo_pdss_id => 12,
    :orden => 27,
    :linea_de_cuidado_id => 36,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 150
    :nombre => "Atención ambulatoria de infección respiratoria aguda en niños menores de 6 años (inicial)",
    :grupo_pdss_id => 12,
    :orden => 28,
    :linea_de_cuidado_id => 37,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 151
    :nombre => "Atención ambulatoria de infección respiratoria aguda en niños menores de 6 años (ulterior)",
    :grupo_pdss_id => 12,
    :orden => 29,
    :linea_de_cuidado_id => 37,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 152
    :nombre => "Kinesioterapia ambulatoria en infecciones respiratorias agudas en niños menores de 6 años (5 sesiones)",
    :grupo_pdss_id => 12,
    :orden => 30,
    :linea_de_cuidado_id => 37,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 153
    :nombre => "Internación abreviada SBO (prehospitalización en ambulatorio)",
    :grupo_pdss_id => 12,
    :orden => 31,
    :linea_de_cuidado_id => 37,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 154
    :nombre => "Internación abreviada SBO (24-48 hs de internación en hospital)",
    :grupo_pdss_id => 12,
    :orden => 32,
    :linea_de_cuidado_id => 37,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 155
    :nombre => "Neumonía",
    :grupo_pdss_id => 12,
    :orden => 33,
    :linea_de_cuidado_id => 38,
    :tipo_de_prestacion_id => 9
  },
  {
    # :id => 156
    :nombre => "Consulta pediátrica de menores de 6 años en emergencia hospitalaria",
    :grupo_pdss_id => 12,
    :orden => 34,
    :linea_de_cuidado_id => 39,
    :tipo_de_prestacion_id => 4
  },

  # SECCIÓN 2 - Grupo 13

  {
    # :id => 157
    :nombre => "Informe de comité de auditoría de muerte materna y/o infantil recibido y aprobado por el Ministerio de Salud de la Provincia, según ordenamiento",
    :grupo_pdss_id => 13,
    :orden => 1,
    :tipo_de_prestacion_id => 2
  },

  # SECCIÓN 3 - Grupo 14

  {
    # :id => 158
    :nombre => "Anemia leve y moderada (inicial)",
    :grupo_pdss_id => 14,
    :orden => 1,
    :linea_de_cuidado_id => 40,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 159
    :nombre => "Anemia leve y moderada (ulterior)",
    :grupo_pdss_id => 14,
    :orden => 2,
    :linea_de_cuidado_id => 40,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 160
    :nombre => "Asma bronquial (inicial)",
    :grupo_pdss_id => 14,
    :orden => 3,
    :linea_de_cuidado_id => 41,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 161
    :nombre => "Asma bronquial (ulterior)",
    :grupo_pdss_id => 14,
    :orden => 4,
    :linea_de_cuidado_id => 41,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 162
    :nombre => "Asma bronquial (urgencia)",
    :grupo_pdss_id => 14,
    :orden => 5,
    :linea_de_cuidado_id => 41,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 163
    :nombre => "Pautas nutricionales respetando cultura alimentaria de comunidades indígenas",
    :grupo_pdss_id => 14,
    :orden => 6,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 16
  },
  {
    # :id => 164
    :nombre => "Prevención de accidentes domésticos",
    :grupo_pdss_id => 14,
    :orden => 7,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 16
  },
  {
    # :id => 165
    :nombre => "Promoción de hábitos saludables: salud bucal, educación alimentaria, pautas de higiene",
    :grupo_pdss_id => 14,
    :orden => 8,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 16
  },
  {
    # :id => 166
    :nombre => "Búsqueda activa de niños con abandono de controles",
    :grupo_pdss_id => 14,
    :orden => 9,
    :linea_de_cuidado_id => 4,
    :tipo_de_prestacion_id => 3
  },
  {
    # :id => 167
    :nombre => "Examen periódico de salud de niños de 6 a 9 años",
    :grupo_pdss_id => 14,
    :orden => 10,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 168
    :nombre => "Control de salud individual para población indígena en terreno",
    :grupo_pdss_id => 14,
    :orden => 11,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 169
    :nombre => "Control odontológico",
    :grupo_pdss_id => 14,
    :orden => 12,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 170
    :nombre => "Control oftalmológico",
    :grupo_pdss_id => 14,
    :orden => 13,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 4
  },
  {
    # :id => 171
    :nombre => "Consulta  para confirmación diagnóstica en población indígena con riesgo detectado en terreno",
    :grupo_pdss_id => 14,
    :orden => 14,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 3
  },
  {
    # :id => 172
    :nombre => "Dosis aplicada de triple viral (actualización de esquema)",
    :grupo_pdss_id => 14,
    :orden => 15,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 173
    :nombre => "Dosis aplicada de sabin oral (actualización de esquema)",
    :grupo_pdss_id => 14,
    :orden => 16,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 174
    :nombre => "Dosis aplicada de dTap triple acelular (actualización de esquema en niños mayores de 7 años)",
    :grupo_pdss_id => 14,
    :orden => 17,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 175
    :nombre => "Dosis aplicada de inmunización anti hepatitis B (actualización de esquema)",
    :grupo_pdss_id => 14,
    :orden => 18,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 176
    :nombre => "Dosis aplicada de vacuna doble viral (SR) al ingreso escolar",
    :grupo_pdss_id => 14,
    :orden => 19,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 177
    :nombre => "Dosis aplicada de vacuna antigripal en personas con factores de riesgo",
    :grupo_pdss_id => 14,
    :orden => 20,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 8
  },
  {
    # :id => 178
    :nombre => "Sellado de surcos",
    :grupo_pdss_id => 14,
    :orden => 21,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 179
    :nombre => "Barniz fluorado de surcos",
    :grupo_pdss_id => 14,
    :orden => 22,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 180
    :nombre => "Inactivación de caries",
    :grupo_pdss_id => 14,
    :orden => 23,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 181
    :nombre => "Diagnóstica y de seguimiento de leucemia (inicial)",
    :grupo_pdss_id => 14,
    :orden => 23,
    :linea_de_cuidado_id => 25,
    :tipo_de_prestacion_id => 13
  },
  {
    # :id => 251
    :nombre => "Diagnóstica y de seguimiento de leucemia (ulterior)",
    :codigo => "CTC002",
    :orden => 27,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 252
    :nombre => "Diagnóstica y de seguimiento de linfoma (inicial)",
    :codigo => "CTC001",
    :orden => 28,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 253
    :nombre => "Diagnóstica y de seguimiento de linfoma (ulterior)",
    :codigo => "CTC002",
    :orden => 29,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 254
    :nombre => "Obesidad (inicial)",
    :codigo => "CTC001",
    :orden => 30,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => 17,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 255
    :nombre => "Obesidad (ulterior)",
    :codigo => "CTC002",
    :orden => 31,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => 17,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 256
    :nombre => "Sobrepeso (inicial)",
    :codigo => "CTC001",
    :orden => 32,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => 17,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 257
    :nombre => "Sobrepeso (ulterior)",
    :codigo => "CTC002",
    :orden => 33,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => 17,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },












  {
    # :id => 15
    :nombre => "Laboratorio prueba de embarazo",
    :codigo => "LBLxxx",
    :orden => 15,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 16
    :nombre => "Lab. Ctrol. prenatal  de 1ra. Vez (incluye: grupo y factor, hemoglobina, glucemia, orina completa, VDRL, Chagas, VIH, toxoplasmosis y Hbs antígeno).",
    :codigo => "LBLxxx",
    :orden => 16,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 17
    :nombre => "Laboratorio Ulterior de Control Prenatal  (Incluye Hemoglobina, Glucemia, Orina Completa, VDRL, VIH)",
    :codigo => "LBLxxx",
    :orden => 17,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 21
    :nombre => "Ronda Sanit. Compl. orientada a detecc. población de riesgo en área rural.",
    :codigo => "ROX001",
    :orden => 21,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 22
    :nombre => "Ronda Sanit. Compl. orientada a detecc. población de riesgo en pobl. indígena.",
    :codigo => "ROX002",
    :orden => 22,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 23
    :nombre => "Diagnóstico socio-epidemiológico de población en riesgo por efector, (Informe final de ronda entregado y aprobado)",
    :codigo => "DSY001",
    :orden => 23,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 5,
    :rural => true
  },
  {
    # :id => 48
    :nombre => "Electrocardiograma en embarazo",
    :codigo => "PRP004",
    :orden => 48,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 49
    :nombre => "Transp. por ref. de zona A  de emb. y niños menores de 6 años hasta 50 km",
    :codigo => "TLM081",
    :orden => 49,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 17,
    :rural => true
  },
  {
    # :id => 50
    :nombre => "Transp. por ref. de zona B  de emb. y niños menores de 6 años (+ de 50 km)",
    :codigo => "TLM082",
    :orden => 50,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 17,
    :rural => true
  },
  {
    # :id => 51
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION.",
    :codigo => "LBLxxx",
    :orden => 51,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 52
    :nombre => "Ecografía en control prenatal",
    :codigo => "IGR031",
    :orden => 52,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 53
    :nombre => "Rx de cráneo F y P en embarazadas",
    :codigo => "IGR022",
    :orden => 53,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 1,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 63
    :nombre => "Proteinuria rápida con tira reactiva",
    :codigo => "PRP030",
    :orden => 10,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 64
    :nombre => "Hemograma completo",
    :codigo => "LBL057",
    :orden => 11,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 65
    :nombre => "Coagulograma con fibrinógeno: KPTT",
    :codigo => "LBL069",
    :orden => 12,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 66
    :nombre => "Coagulograma con fibrinógeno: Tiempo de protrombina",
    :codigo => "LBL131",
    :orden => 13,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 67
    :nombre => "Coagulograma con fibrinógeno: Cuantificación de fibrinógeno",
    :codigo => "LBL023",
    :orden => 14,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 68
    :nombre => "Coagulograma con fibrinógeno: Tiempo de trombina",
    :codigo => "LBL132",
    :orden => 15,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 69
    :nombre => "Glucemia",
    :codigo => "LBL045",
    :orden => 16,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 70
    :nombre => "Uricemia",
    :codigo => "LBL002",
    :orden => 17,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 71
    :nombre => "Creatinina sérica",
    :codigo => "LBL022",
    :orden => 18,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 72
    :nombre => "Creatinina urinaria (24 hs)",
    :codigo => "LBL021",
    :orden => 19,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 73
    :nombre => "Proteinuria (24hs)",
    :codigo => "LBL090",
    :orden => 20,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 74
    :nombre => "Enzimas hepáticas: Transaminasas",
    :codigo => "LBL112",
    :orden => 21,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 75
    :nombre => "Enzimas hepáticas: Fosfatasa alcalina",
    :codigo => "LBL040",
    :orden => 22,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 76
    :nombre => "Enzimas hepáticas: Gamma GT",
    :codigo => "LBL044",
    :orden => 23,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 77
    :nombre => "Bilirrubina",
    :codigo => "LBL012",
    :orden => 24,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 78
    :nombre => "HDL y LDL",
    :codigo => "LBL052",
    :orden => 25,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 79
    :nombre => "Orina Completa",
    :codigo => "LBL079",
    :orden => 26,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 80
    :nombre => "Ecografía Obstétrica",
    :codigo => "IGR031",
    :orden => 27,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 81
    :nombre => "Eco doppler Fetal",
    :codigo => "IGR037",
    :orden => 28,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 82
    :nombre => "Ecografía Renal",
    :codigo => "IGR038",
    :orden => 29,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 83
    :nombre => "Monitoreo fetal ante parto",
    :codigo => "PRP031",
    :orden => 30,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 10,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 91
    :nombre => "Hemograma completo",
    :codigo => "LBL057",
    :orden => 38,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 92
    :nombre => "Coagulograma: KPTT",
    :codigo => "LBL069",
    :orden => 39,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 93
    :nombre => "Coagulograma: Tiempo de protrombina",
    :codigo => "LBL131",
    :orden => 40,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 94
    :nombre => "Coagulograma: Tiempo de trombina",
    :codigo => "LBL132",
    :orden => 41,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 95
    :nombre => "Hemoglobina glicosilada",
    :codigo => "LBL056",
    :orden => 42,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 96
    :nombre => "Fructosamina",
    :codigo => "LBL135",
    :orden => 43,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 97
    :nombre => "Urea",
    :codigo => "LBL117",
    :orden => 44,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 98
    :nombre => "Ácido úrico",
    :codigo => "LBL002",
    :orden => 45,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 99
    :nombre => "Creatinina sérica",
    :codigo => "LBL022",
    :orden => 46,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 100
    :nombre => "Creatinina en orina",
    :codigo => "LBL021",
    :orden => 47,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 101
    :nombre => "Proteinuria (24hs)",
    :codigo => "LBL090",
    :orden => 48,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 102
    :nombre => "Urocultivo",
    :codigo => "LBL118",
    :orden => 49,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 103
    :nombre => "Prueba de tolerancia a la glucosa",
    :codigo => "LBL094",
    :orden => 50,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 104
    :nombre => "Ecografía Obstétrica",
    :codigo => "IGR031",
    :orden => 51,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 105
    :nombre => "Ecocardiograma fetal",
    :codigo => "IGR039",
    :orden => 52,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 106
    :nombre => "Monitoreo fetal ante parto",
    :codigo => "PRP031",
    :orden => 53,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 107
    :nombre => "Electrocardiograma",
    :codigo => "PRP004",
    :orden => 54,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 11,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 111
    :nombre => "Ecografía ginecológica",
    :codigo => "IGR008",
    :orden => 58,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 12,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 112
    :nombre => "Hemograma",
    :codigo => "LBL057",
    :orden => 59,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 12,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 114
    :nombre => "Ecografía Obstétrica",
    :codigo => "IGR031",
    :orden => 61,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 13,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 115
    :nombre => "Electrocardiograma",
    :codigo => "PRP004",
    :orden => 62,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 13,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 116
    :nombre => "Monitoreo fetal ante parto",
    :codigo => "PRP031",
    :orden => 63,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 1,
    :nosologia_id => 13,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },







  {
    # :id => 126
    :nombre => "Traslado de la gestante con diagnóstico de patología del embarazo; APP o malformación fetal mayor a centro de referencia",
    :codigo => "TLM041",
    :orden => 1,
    :grupo_pdss_id => 1,
    :subgrupo_pdss_id => 2,
    :apartado_pdss_id => 4,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 9,
    :rural => false
  },
  {
    # :id => 142
    :nombre => "Traslado del RN prematuro de 500 a 1500 gramos, o de un RN con malformación congénita quirúrgica",
    :codigo => "TLM040",
    :orden => 1,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 6,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 17,
    :rural => false
  },











  {
    # :id => 191
    :nombre => "Ronda Sanit. completa orientada a detección de población de riesgo en área rural",
    :codigo => "ROX001",
    :orden => 14,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 192
    :nombre => "Ronda Sanit. Compl. orientada a detecc. de población de riesgo en pobl. indígena",
    :codigo => "ROX002",
    :orden => 15,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 193
    :nombre => "Diagnóstico socio-epidemiológico de población en riesgo por efector, (Informe final de ronda entregado y aprobado)",
    :codigo => "DSY001",
    :orden => 16,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 5,
    :rural => true
  },





  {
    # :id => 197
    :nombre => "Informe de comité de auditoría de muerte materna y/o infantil recibido y aprobado por el Ministerio de Salud de la Provincia, según ordenamiento",
    :codigo => "AUH002",
    :orden => 20,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 2,
    :rural => false
  },






  {
    # :id => 214
    :nombre => "Electrocardiograma en niños menores de 6 años",
    :codigo => "PRP004",
    :orden => 37,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },




  {
    # :id => 216
    :nombre => "Transp. por ref. de zona A de emb. y niños menores de 6 años hasta 50 km",
    :codigo => "TLM081",
    :orden => 39,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 17,
    :rural => true
  },
  {
    # :id => 217
    :nombre => "Transp. por ref. de zona B de emb. y niños menores de 6 años (+ de 50 km)",
    :codigo => "TLM082",
    :orden => 40,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 17,
    :rural => true
  },
  {
    # :id => 218
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION",
    :codigo => "LBLxxx",
    :orden => 41,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 219
    :nombre => "Eco. bilateral de caderas en niños menores de 2 meses",
    :codigo => "IGR005",
    :orden => 42,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 220
    :nombre => "Rx de tórax Fy P en niños menores de 6 años",
    :codigo => "IGR026",
    :orden => 43,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 221
    :nombre => "Rx de cráneo F y P en niños menores de 6 años",
    :codigo => "IGR022",
    :orden => 44,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 222
    :nombre => "Rx de huesos cortos en niños menores de 6 años c/patología prevalente",
    :codigo => "IGR017",
    :orden => 45,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 223
    :nombre => "Rx de huesos largos en niños menores de 6 años c/patología prevalente",
    :codigo => "IGR025",
    :orden => 46,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 224
    :nombre => "Eco-doppler en niños menores de 6 años",
    :codigo => "IGR004",
    :orden => 47,
    :grupo_pdss_id => 2,
    :subgrupo_pdss_id => 10,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },



  {
    # :id => 232
    :nombre => "Ronda Sanit. completa orientada a detección de población de riesgo en área rural",
    :codigo => "ROX001",
    :orden => 8,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 233
    :nombre => "Ronda Sanit. completa orientada a detección de pobl. de riesgo en población indígena",
    :codigo => "ROX002",
    :orden => 9,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },










  {
    # :id => 258
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION",
    :codigo => "PRPxxx",
    :orden => 34,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 259
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION",
    :codigo => "LBLxxx",
    :orden => 35,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 260
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION",
    :codigo => "IGRxxx",
    :orden => 36,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 261
    :nombre => "Notificación de inicio de tratamiento en tiempo oportuno (leucemia-linfoma)",
    :codigo => "NTN002",
    :orden => 37,
    :grupo_pdss_id => 3,
    :subgrupo_pdss_id => 11,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 12,
    :rural => false
  },
  {
    # :id => 262
    :nombre => "Examen periódico de salud del adolescente",
    :codigo => "CTC001",
    :orden => 1,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 1,
    :tipo_de_prestacion_id => 4,
    :rural => true
  },
  {
    # :id => 263
    :nombre => "Control de salud individual para población indígena en terreno",
    :codigo => "CTC009",
    :orden => 2,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 1,
    :tipo_de_prestacion_id => 4,
    :rural => true
  },
  {
    # :id => 264
    :nombre => "Control ginecológico",
    :codigo => "CTC008",
    :orden => 3,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 1,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 265
    :nombre => "Control odontológico",
    :codigo => "CTC010",
    :orden => 4,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 1,
    :tipo_de_prestacion_id => 4,
    :rural => true
  },
  {
    # :id => 266
    :nombre => "Control oftalmológico",
    :codigo => "CTC011",
    :orden => 5,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 1,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 267
    :nombre => "Doble viral (rubéola + sarampión)",
    :codigo => "IMV011",
    :orden => 6,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 8,
    :rural => true
  },
  {
    # :id => 268
    :nombre => "Dosis aplicada de doble adultos > 16 años",
    :codigo => "IMV010",
    :orden => 7,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 8,
    :rural => true
  },
  {
    # :id => 269
    :nombre => "Dosis aplicada de dTap triple acelular (refuerzo a los 11 años)",
    :codigo => "IMV008",
    :orden => 8,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 8,
    :rural => true
  },
  {
    # :id => 270
    :nombre => "Dosis apl. inmuniz. anti hepatitis B monovalente (a partir 11 años no inmuniz. prev.)",
    :codigo => "IMV009",
    :orden => 9,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 8,
    :rural => true
  },
  {
    # :id => 271
    :nombre => "Dosis aplicada de vacuna antigripal en personas con factores de riesgo",
    :codigo => "IMV013",
    :orden => 10,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 8,
    :rural => true
  },
  {
    # :id => 272
    :nombre => "Dosis aplicada vacuna contra VPH en niñas 11 años",
    :codigo => "IMV014",
    :orden => 11,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 8,
    :rural => true
  },
  {
    # :id => 273
    :nombre => "Prevención de comportamientos adictivos: tabaquismo, uso de drogas, alcoholismo",
    :codigo => "TAT010",
    :orden => 12,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 274
    :nombre => "Pautas nutricionales respetando cultura alimentaria de comunidades indígenas",
    :codigo => "TAT004",
    :orden => 13,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 275
    :nombre => "Prevención de accidentes",
    :codigo => "TAT005",
    :orden => 14,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 276
    :nombre => "Prevención de VIH e infecciones de transmisión Sexual",
    :codigo => "TAT007",
    :orden => 15,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 277
    :nombre => "Prevención de violencia de género",
    :codigo => "TAT008",
    :orden => 16,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 278
    :nombre => "Prevención violencia familiar",
    :codigo => "TAT009",
    :orden => 17,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 279
    :nombre => "Prom. Háb. saludables: salud bucal, educ. alim., pautas de higiene, trast. de la alim.",
    :codigo => "TAT011",
    :orden => 18,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 280
    :nombre => "Promoción de pautas alimentarias",
    :codigo => "TAT012",
    :orden => 19,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 281
    :nombre => "Promoción de salud sexual y reproductiva",
    :codigo => "TAT013",
    :orden => 20,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 282
    :nombre => "Salud sexual, confidencialidad, género y derecho (actividad en sala de espera)",
    :codigo => "TAT014",
    :orden => 21,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 283
    :nombre => "Ronda Sanit. Compl. orientada a detección de población de riesgo en área rural",
    :codigo => "ROX001",
    :orden => 22,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 284
    :nombre => "Ronda Sanit. Compl. orientada a detección de pobl. de riesgo en pobl. indígena",
    :codigo => "ROX002",
    :orden => 23,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 285
    :nombre => "Post-aborto",
    :codigo => "COT018",
    :orden => 24,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 15,
    :rural => true
  },
  {
    # :id => 286
    :nombre => "Salud Sexual (terreno)",
    :codigo => "COT016",
    :orden => 25,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 15,
    :rural => true
  },
  {
    # :id => 287
    :nombre => "Salud sexual en adolescente",
    :codigo => "COT015",
    :orden => 26,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 15,
    :rural => true
  },
  {
    # :id => 288
    :nombre => "Búsqueda activa de adolescentes para valoración integral",
    :codigo => "CAW005",
    :orden => 27,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 3,
    :rural => true
  },
  {
    # :id => 289
    :nombre => "Búsq. activa de emb. adolescentes por agente sanitario y/o personal de salud",
    :codigo => "CAW004",
    :orden => 28,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 3,
    :rural => true
  },
  {
    # :id => 290
    :nombre => "Consulta p/ conf. diagnóstica en Población Indígena con riesgo detectado en terreno",
    :codigo => "CAW006",
    :orden => 29,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 3,
    :rural => false
  },
  {
    # :id => 291
    :nombre => "Anemia leve y moderada en mujeres (inicial)",
    :codigo => "CTC001",
    :orden => 30,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 3,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 292
    :nombre => "Anemia leve y moderada en mujeres (ulterior)",
    :codigo => "CTC002",
    :orden => 31,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 3,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 293
    :nombre => "Asma bronquial (urgencia)",
    :codigo => "CTC012",
    :orden => 32,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 20,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 294
    :nombre => "Asma bronquial (inicial)",
    :codigo => "CTC001",
    :orden => 33,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 20,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 295
    :nombre => "Asma bronquial (ulterior)",
    :codigo => "CTC002",
    :orden => 34,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 20,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 296
    :nombre => "Consumo episódico exc. alcohol y/o otras sust. psicoact. (urgencia/consult. ext.)",
    :codigo => "CTC012",
    :orden => 35,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 23,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 297
    :nombre => "Intento de suicidio (urgencia)",
    :codigo => "CTC012",
    :orden => 36,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 23,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 298
    :nombre => "Víctima de violencia sexual (urgencia)",
    :codigo => "CTC012",
    :orden => 37,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 23,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 299
    :nombre => "Diagnóstica y de seguimiento de leucemia (inicial)",
    :codigo => "CTC001",
    :orden => 38,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 300
    :nombre => "Diagnóstica y de seguimiento de leucemia (ulterior)",
    :codigo => "CTC002",
    :orden => 39,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 301
    :nombre => "Diagnóstica y de seguimiento de linfoma (inicial)",
    :codigo => "CTC001",
    :orden => 40,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 302
    :nombre => "Diagnóstica y de seguimiento de linfoma (ulterior)",
    :codigo => "CTC002",
    :orden => 41,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 303
    :nombre => "Diagnóstico temprano y confidencial de embarazo en adolescente",
    :codigo => "CTC003",
    :orden => 42,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 24,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 304
    :nombre => "Seg. por consumo episódico exc. alcohol y/o otras sust. psicoactivas (inicial)",
    :codigo => "CTC001",
    :orden => 43,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 25,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 305
    :nombre => "Seg. por consumo episódico exc. alcohol y/o otras sust. psicoactivas (ulterior)",
    :codigo => "CTC002",
    :orden => 44,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 25,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 306
    :nombre => "Seguimiento por intento de suicidio",
    :codigo => "CTC001",
    :orden => 45,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 25,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 307
    :nombre => "Obesidad (inicial)",
    :codigo => "CTC001",
    :orden => 46,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 17,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 308
    :nombre => "Obesidad (ulterior)",
    :codigo => "CTC002",
    :orden => 47,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 17,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 309
    :nombre => "Sobrepeso (inicial)",
    :codigo => "CTC001",
    :orden => 48,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 17,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 310
    :nombre => "Sobrepeso (ulterior)",
    :codigo => "CTC002",
    :orden => 49,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 17,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 311
    :nombre => "Colocación de DIU",
    :codigo => "PRP003",
    :orden => 50,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 312
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION",
    :codigo => "PRPxxx",
    :orden => 51,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 313
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION",
    :codigo => "LBLxxx",
    :orden => 52,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 314
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION",
    :codigo => "IGRxxx",
    :orden => 53,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 315
    :nombre => "Notificación de inicio de tratamiento en tiempo oportuno (leucemia-linfoma)",
    :codigo => "NTN002",
    :orden => 54,
    :grupo_pdss_id => 4,
    :subgrupo_pdss_id => 12,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 12,
    :rural => false
  },
  {
    # :id => 316
    :nombre => "Examen periódico de salud",
    :codigo => "CTC001",
    :orden => 1,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 1,
    :tipo_de_prestacion_id => 4,
    :rural => true
  },
  {
    # :id => 317
    :nombre => "Control de salud individual para población indígena en terreno",
    :codigo => "CTC009",
    :orden => 2,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 1,
    :tipo_de_prestacion_id => 4,
    :rural => true
  },
  {
    # :id => 318
    :nombre => "Control ginecológico",
    :codigo => "CTC008",
    :orden => 3,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 1,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 319
    :nombre => "Control odontológico",
    :codigo => "CTC010",
    :orden => 4,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 1,
    :tipo_de_prestacion_id => 4,
    :rural => true
  },
  {
    # :id => 320
    :nombre => "Dosis aplicada de Doble adultos (dT)",
    :codigo => "IMV010",
    :orden => 5,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 8,
    :rural => true
  },
  {
    # :id => 321
    :nombre => "Dosis aplicada de doble viral",
    :codigo => "IMV011",
    :orden => 6,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 8,
    :rural => true
  },
  {
    # :id => 322
    :nombre => "Dosis aplicada de vacuna antrigripal en personas con factores de riesgo",
    :codigo => "IMV013",
    :orden => 7,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 8,
    :rural => true
  },
  {
    # :id => 323
    :nombre => "Control preconcepcional (inicial)",
    :codigo => "CTC004",
    :orden => 8,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 324
    :nombre => "Control preconcepcional (seguimiento)",
    :codigo => "CTC013",
    :orden => 9,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 325
    :nombre => "Post-aborto",
    :codigo => "COT018",
    :orden => 10,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 15,
    :rural => true
  },
  {
    # :id => 326
    :nombre => "Salud sexual y procreación responsable",
    :codigo => "COT020",
    :orden => 11,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 15,
    :rural => true
  },
  {
    # :id => 327
    :nombre => "Prevención de comportamientos adictivos: tabaquismo, uso de drogas, alcoholismo.",
    :codigo => "TAT010",
    :orden => 12,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 328
    :nombre => "Pautas nutricionales respetando cultura alimentaria de comunidades indígenas",
    :codigo => "TAT004",
    :orden => 13,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 329
    :nombre => "Prevención de accidentes",
    :codigo => "TAT005",
    :orden => 14,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 330
    :nombre => "Prevención de VIH e infecciones de transmisión sexual",
    :codigo => "TAT007",
    :orden => 15,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 331
    :nombre => "Prevención de violencia de género",
    :codigo => "TAT008",
    :orden => 16,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 332
    :nombre => "Prevención violencia familiar",
    :codigo => "TAT009",
    :orden => 17,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 333
    :nombre => "Promoción de hábitos saludables: salud bucal, educación alimentaria, pautas de higiene, trastornos de la alimentación.",
    :codigo => "TAT011",
    :orden => 18,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 334
    :nombre => "Promoción de pautas alimentarias",
    :codigo => "TAT012",
    :orden => 19,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 335
    :nombre => "Promoción de salud sexual y reproductiva",
    :codigo => "TAT013",
    :orden => 20,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 16,
    :rural => true
  },
  {
    # :id => 336
    :nombre => "Ronda sanitaria completa orientada a detección de población de riesgo en área rural",
    :codigo => "ROX001",
    :orden => 21,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 337
    :nombre => "Ronda sanit. compl. orientada a detección de población de riesgo en pobl. indígena",
    :codigo => "ROX002",
    :orden => 22,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 338
    :nombre => "Consulta  p/conf. diagnóstico en población indígena con riesgo detectado en terreno",
    :codigo => "CAW006",
    :orden => 23,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 2,
    :tipo_de_prestacion_id => 3,
    :rural => false
  },
  {
    # :id => 339
    :nombre => "Anemia leve y moderada 20 a 49 años (inicial)",
    :codigo => "CTC001",
    :orden => 24,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 3,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 340
    :nombre => "Anemia leve y moderada 20 a 49 años (ulterior)",
    :codigo => "CTC002",
    :orden => 25,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 3,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 341
    :nombre => "Víctima de violencia sexual (urgencia)",
    :codigo => "CTC012",
    :orden => 26,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 23,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 342
    :nombre => "Diagnóstica y seguimiento de CA cérvicouterino (inicial)",
    :codigo => "CTC001",
    :orden => 27,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 343
    :nombre => "Diagnóstica y seguimiento de CA cérvicouterino (ulterior)",
    :codigo => "CTC002",
    :orden => 28,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 344
    :nombre => "Diagnóstica y seguimiento de CA de mama (inicial)",
    :codigo => "CTC001",
    :orden => 29,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 345
    :nombre => "Diagnóstica y seguimiento de CA de mama (ulterior)",
    :codigo => "CTC002",
    :orden => 30,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 346
    :nombre => "Biopsia para las mujeres con mamografía BIRADS 4 y 5 (CA mama)",
    :codigo => "PRP007",
    :orden => 31,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 347
    :nombre => "Colposcopía de lesión en cuello uterino, realizada por especialista en ASC-H, H-SIL, cáncer (CA cérvicouterino)",
    :codigo => "PRP002",
    :orden => 32,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 348
    :nombre => "Biopsia de lesión en cuello uterino, realizada por especialista en ASC-H, H-SIL, cáncer (CA cérvicouterino)",
    :codigo => "PRP007",
    :orden => 33,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 349
    :nombre => "Toma de muestra citológica (25 a 64 años) (tamizaje CA cérvicouterino)",
    :codigo => "PRP018",
    :orden => 34,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 13,
    :rural => true
  },
  {
    # :id => 350
    :nombre => "Mamografía bilateral, craneocaudal y oblicua, con proyección axilar mujeres (en mayores de 49 años cada 2 años con mamografía negativa)",
    :codigo => "IGR014",
    :orden => 35,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 351
    :nombre => "Mamografía variedad magnificada",
    :codigo => "IGR015",
    :orden => 36,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 352
    :nombre => "Anatomía patológica de biopsia (CA mama)",
    :codigo => "APA002",
    :orden => 37,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 1,
    :rural => false
  },
  {
    # :id => 353
    :nombre => "Diagnóstico por biopsia en laboratorio de anatomía patológica, para aquellas mujeres con citología ASC-H, H-SIL, cáncer (CA cérvicouterino)",
    :codigo => "APA002",
    :orden => 38,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 1,
    :rural => false
  },
  {
    # :id => 354
    :nombre => "Lectura de la muestra tomada en mujeres entre 25 y 64 años, en laboratorio de Anatomía Patológica/Citología con diagnóstico firmado por anátomo-patólogo matriculado (tamizaje de CA cérvicouterino)",
    :codigo => "APA001",
    :orden => 39,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 1,
    :rural => false
  },
  {
    # :id => 355
    :nombre => "Notificación de caso positivo al responsable del servicio donde se realizó la toma de muestra (PAP) (CA cérvicouterino)",
    :codigo => "NTN001",
    :orden => 40,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 12,
    :rural => false
  },
  {
    # :id => 356
    :nombre => "Notificación de caso positivo al responsable del servicio donde se realizó la toma de muestra (biopsia) (CA cérvicouterino)",
    :codigo => "NTN003",
    :orden => 41,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 12,
    :rural => false
  },
  {
    # :id => 357
    :nombre => "Notif. inicio de tratam. en tiempo oport. ASC-H, H-SIL, cáncer  (CA cérvicouterino)",
    :codigo => "NTN002",
    :orden => 42,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 12,
    :rural => false
  },
  {
    # :id => 358
    :nombre => "Notificación de inicio de tratamiento en tiempo oportuno (CA mama)",
    :codigo => "NTN002",
    :orden => 43,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => 6,
    :tipo_de_prestacion_id => 12,
    :rural => false
  },
  {
    # :id => 359
    :nombre => "Colocación DIU",
    :codigo => "PRP003",
    :orden => 44,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 360
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION",
    :codigo => "PRPxxx",
    :orden => 45,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 361
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION",
    :codigo => "LBLxxx",
    :orden => 46,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 362
    :nombre => "Ver en Matriz de codificación, II - OBJETO DE LA PRESTACION",
    :codigo => "IGRxxx",
    :orden => 47,
    :grupo_pdss_id => 5,
    :subgrupo_pdss_id => 13,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 363
    :nombre => "Consulta trabajador social",
    :codigo => "CTC015",
    :orden => 1,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 4,
    :rural => false
  },
  {
    # :id => 364
    :nombre => "Cateterización",
    :codigo => "PRP001",
    :orden => 2,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 365
    :nombre => "Colocación de DIU",
    :codigo => "PRP003",
    :orden => 3,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => true
  },
  {
    # :id => 366
    :nombre => "Electrocardiograma",
    :codigo => "PRP004",
    :orden => 4,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => true
  },
  {
    # :id => 367
    :nombre => "Ergometría",
    :codigo => "PRP005",
    :orden => 5,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 368
    :nombre => "Espirometría",
    :codigo => "PRP006",
    :orden => 6,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 369
    :nombre => "Escisión/remoción/toma para biopsia/punción lumbar",
    :codigo => "PRP007",
    :orden => 7,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 370
    :nombre => "Extracción de sangre",
    :codigo => "PRP008",
    :orden => 8,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => true
  },
  {
    # :id => 371
    :nombre => "Incisión/drenaje/lavado",
    :codigo => "PRP009",
    :orden => 9,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => true
  },
  {
    # :id => 372
    :nombre => "Inyección/infiltración local/venopuntura",
    :codigo => "PRP010",
    :orden => 10,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => true
  },
  {
    # :id => 373
    :nombre => "Medicina física/rehabilitación",
    :codigo => "PRP011",
    :orden => 11,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 374
    :nombre => "Pruebas de sensibilización",
    :codigo => "PRP014",
    :orden => 12,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 375
    :nombre => "Registro de trazados eléctricos cerebrales",
    :codigo => "PRP016",
    :orden => 13,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 376
    :nombre => "Oftalmoscopía binocular indirecta (OBI)",
    :codigo => "PRP017",
    :orden => 14,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 377
    :nombre => "Audiometría tonal",
    :codigo => "PRP019",
    :orden => 15,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 378
    :nombre => "Logoaudiometría",
    :codigo => "PRP020",
    :orden => 16,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 379
    :nombre => "Inactivación de caries",
    :codigo => "PRP026",
    :orden => 17,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 380
    :nombre => "Fondo de ojo",
    :codigo => "PRP028",
    :orden => 18,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 381
    :nombre => "Punción de médula ósea",
    :codigo => "PRP029",
    :orden => 19,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 382
    :nombre => "Proteinuria rápida con tira reactiva",
    :codigo => "PRP030",
    :orden => 20,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => true
  },
  {
    # :id => 383
    :nombre => "Monitoreo fetal anteparto",
    :codigo => "PRP031",
    :orden => 21,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 384
    :nombre => "Tartrectomía y cepillado mecánico",
    :codigo => "PRP033",
    :orden => 22,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 13,
    :rural => false
  },
  {
    # :id => 385
    :nombre => "Densitometría ósea",
    :codigo => "IGR002",
    :orden => 23,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 386
    :nombre => "Ecocardiograma con fracción de eyección",
    :codigo => "IGR003",
    :orden => 24,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 387
    :nombre => "Eco-Doppler color",
    :codigo => "IGR004",
    :orden => 25,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 388
    :nombre => "Ecografía bilateral de caderas (menores de 2 meses)",
    :codigo => "IGR005",
    :orden => 26,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 389
    :nombre => "Ecografía cerebral",
    :codigo => "IGR006",
    :orden => 27,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 390
    :nombre => "Ecografía de cuello",
    :codigo => "IGR007",
    :orden => 28,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 391
    :nombre => "Ecografía ginecológica",
    :codigo => "IGR008",
    :orden => 29,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 392
    :nombre => "Ecografìa mamaria",
    :codigo => "IGR009",
    :orden => 30,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 393
    :nombre => "Ecografía tiroidea",
    :codigo => "IGR010",
    :orden => 31,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 394
    :nombre => "Fibrocolonoscopía",
    :codigo => "IGR011",
    :orden => 32,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 395
    :nombre => "Fibrogastroscopía",
    :codigo => "IGR012",
    :orden => 33,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 396
    :nombre => "Fibrorectosigmoideoscopía",
    :codigo => "IGR013",
    :orden => 34,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 397
    :nombre => "Rx codo, antebrazo, muñeca, mano, dedos, rodilla, pierna, tobillo, pie (total o focalizada) (fte. y perf.)",
    :codigo => "IGR017",
    :orden => 35,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 398
    :nombre => "Rx colon por enema, evacuado e insuflado (con o sin doble contraste)",
    :codigo => "IGR018",
    :orden => 36,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 399
    :nombre => "Rx columna cervical (total o focalizada) (fte. y perf.)",
    :codigo => "IGR019",
    :orden => 37,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 400
    :nombre => "Rx columna dorsal (total o focalizada) (fte. y perf.)",
    :codigo => "IGR020",
    :orden => 38,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 401
    :nombre => "Rx columna lumbar (total o focalizada) (fte. y perf.)",
    :codigo => "IGR021",
    :orden => 39,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 402
    :nombre => "Rx cráneo (fte. y perfil), Rx senos paranasales",
    :codigo => "IGR022",
    :orden => 40,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 403
    :nombre => "Rx estudio seriado tránsito esofagogastroduodenal contrastado",
    :codigo => "IGR023",
    :orden => 41,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 404
    :nombre => "Rx estudio tránsito de intestino delgado y cecoapendicular",
    :codigo => "IGR024",
    :orden => 42,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 405
    :nombre => "Rx hombro, húmero, pelvis, cadera y fémur (total o focalizada) (fte. y perf.)",
    :codigo => "IGR025",
    :orden => 43,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 406
    :nombre => "Rx o TeleRx tórax (total o focalizada) (fte. y perf.)",
    :codigo => "IGR026",
    :orden => 44,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 407
    :nombre => "Rx sacrococcígea (total o focalizada) (fte. y perf.)",
    :codigo => "IGR028",
    :orden => 45,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 408
    :nombre => "Rx simple de abdomen (fte. y perf.)",
    :codigo => "IGR029",
    :orden => 46,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 409
    :nombre => "Tomografía axial computada (TAC) (cerebro-espinal)",
    :codigo => "IGR030",
    :orden => 47,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 410
    :nombre => "Ecografia obstétrica",
    :codigo => "IGR031",
    :orden => 48,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => true
  },
  {
    # :id => 411
    :nombre => "Ecografia abdominal",
    :codigo => "IGR032",
    :orden => 49,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 412
    :nombre => "Eco doppler fetal",
    :codigo => "IGR037",
    :orden => 50,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 413
    :nombre => "Ecografía renal",
    :codigo => "IGR038",
    :orden => 51,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 414
    :nombre => "Ecocardiograma fetal",
    :codigo => "IGR039",
    :orden => 52,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 6,
    :rural => false
  },
  {
    # :id => 415
    :nombre => "Medulograma (recuento diferencial con tinción de MGG)",
    :codigo => "APA003",
    :orden => 53,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 1,
    :rural => false
  },
  {
    # :id => 416
    :nombre => "Ronda Sanitaria completa orientada a detección de población de riesgo en área rural",
    :codigo => "ROX001",
    :orden => 54,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 417
    :nombre => "Ronda Sanitaria completa orientada a detección de población de riesgo en población indígena",
    :codigo => "ROX002",
    :orden => 55,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 14,
    :rural => true
  },
  {
    # :id => 418
    :nombre => "Unidad móvil de alta complejidad adultos",
    :codigo => "TLM020",
    :orden => 56,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 17,
    :rural => true
  },
  {
    # :id => 419
    :nombre => "Unidad móvil de alta complejidad pediátrica/neonatal",
    :codigo => "TLM030",
    :orden => 57,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 17,
    :rural => true
  },
  {
    # :id => 420
    :nombre => "Unidad móvil de baja o mediana complejidad (hasta 50 km)",
    :codigo => "TLM081",
    :orden => 58,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 17,
    :rural => true
  },
  {
    # :id => 421
    :nombre => "Unidad móvil de baja o mediana complejidad (más de 50 km)",
    :codigo => "TLM082",
    :orden => 59,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 17,
    :rural => true
  },
  {
    # :id => 422
    :nombre => "Materna",
    :codigo => "AUH001",
    :orden => 60,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 2,
    :rural => false
  },
  {
    # :id => 423
    :nombre => "Infantil",
    :codigo => "AUH002",
    :orden => 61,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 2,
    :rural => false
  },
  {
    # :id => 424
    :nombre => "Diagnóstico socio-epidemiológico de población en riesgo por efector, (Informe final de ronda entregado y aprobado)",
    :codigo => "DSY001",
    :orden => 62,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 5,
    :rural => true
  },
  {
    # :id => 425
    :nombre => "17 Hidroxiprogesterona",
    :codigo => "LBL001",
    :orden => 63,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 426
    :nombre => "Ácido úrico",
    :codigo => "LBL002",
    :orden => 64,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 427
    :nombre => "Ácidos biliares",
    :codigo => "LBL003",
    :orden => 65,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 428
    :nombre => "Amilasa pancreática",
    :codigo => "LBL004",
    :orden => 66,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 429
    :nombre => "Antibiograma micobacterias",
    :codigo => "LBL005",
    :orden => 67,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 430
    :nombre => "Anticuerpos antitreponémicos",
    :codigo => "LBL006",
    :orden => 68,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 431
    :nombre => "Apolipoproteína B",
    :codigo => "LBL008",
    :orden => 69,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 432
    :nombre => "ASTO",
    :codigo => "LBL009",
    :orden => 70,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 433
    :nombre => "Baciloscopía",
    :codigo => "LBL010",
    :orden => 71,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 434
    :nombre => "Bacteriología directa y cultivo",
    :codigo => "LBL011",
    :orden => 72,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 435
    :nombre => "Bilirrubinas totales y fraccionadas",
    :codigo => "LBL012",
    :orden => 73,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 436
    :nombre => "Biotinidasa neonatal",
    :codigo => "LBL013",
    :orden => 74,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 437
    :nombre => "Calcemia",
    :codigo => "LBL014",
    :orden => 75,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 438
    :nombre => "Calciuria",
    :codigo => "LBL015",
    :orden => 76,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 439
    :nombre => "Campo oscuro",
    :codigo => "LBL016",
    :orden => 77,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 440
    :nombre => "Citología",
    :codigo => "LBL017",
    :orden => 78,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 441
    :nombre => "Colesterol",
    :codigo => "LBL018",
    :orden => 79,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 442
    :nombre => "Coprocultivo",
    :codigo => "LBL019",
    :orden => 80,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 443
    :nombre => "CPK",
    :codigo => "LBL020",
    :orden => 81,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 444
    :nombre => "Creatinina en orina",
    :codigo => "LBL021",
    :orden => 82,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 445
    :nombre => "Creatinina sérica",
    :codigo => "LBL022",
    :orden => 83,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 446
    :nombre => "Cuantificación fibrinógeno",
    :codigo => "LBL023",
    :orden => 84,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 447
    :nombre => "Cultivo Streptococo B hemolítico",
    :codigo => "LBL024",
    :orden => 85,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 448
    :nombre => "Cultivo vaginal exudado flujo",
    :codigo => "LBL025",
    :orden => 86,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 449
    :nombre => "Cultivo y antibiograma general",
    :codigo => "LBL026",
    :orden => 87,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 450
    :nombre => "Electroforesis de proteínas",
    :codigo => "LBL027",
    :orden => 88,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 451
    :nombre => "Eritrosedimentación",
    :codigo => "LBL028",
    :orden => 89,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 452
    :nombre => "Esputo seriado",
    :codigo => "LBL029",
    :orden => 90,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 453
    :nombre => "Estado ácido base",
    :codigo => "LBL030",
    :orden => 91,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 454
    :nombre => "Estudio citoquímico de médula ósea: PAS-Peroxidasa-Esterasas",
    :codigo => "LBL031",
    :orden => 92,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 455
    :nombre => "Estudio citogenético de médula ósea (técnica de bandeo G)",
    :codigo => "LBL032",
    :orden => 93,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 456
    :nombre => "Estudio de genética molecular de médula ósea (BCR/ABL, MLL/AF4 y TEL/AML1 por técnicas de RT-PCR o FISH)",
    :codigo => "LBL033",
    :orden => 94,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 457
    :nombre => "Factor de coagulación 5, 7, 8, 9 y 10",
    :codigo => "LBL034",
    :orden => 95,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 458
    :nombre => "Fenilalanina",
    :codigo => "LBL035",
    :orden => 96,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 459
    :nombre => "Fenilcetonuria",
    :codigo => "LBL036",
    :orden => 97,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 460
    :nombre => "Ferremia",
    :codigo => "LBL037",
    :orden => 98,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 461
    :nombre => "Ferritina",
    :codigo => "LBL038",
    :orden => 99,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 462
    :nombre => "Fosfatasa alcalina y ácida",
    :codigo => "LBL040",
    :orden => 100,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 463
    :nombre => "Fosfatemia",
    :codigo => "LBL041",
    :orden => 101,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 464
    :nombre => "FSH",
    :codigo => "LBL042",
    :orden => 102,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 465
    :nombre => "Galactosemia",
    :codigo => "LBL043",
    :orden => 103,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 466
    :nombre => "Gamma-GT (gamma glutamil transpeptidasa)",
    :codigo => "LBL044",
    :orden => 104,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 467
    :nombre => "Glucemia",
    :codigo => "LBL045",
    :orden => 105,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 468
    :nombre => "Glucosuria",
    :codigo => "LBL046",
    :orden => 106,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 469
    :nombre => "Gonadotrofina coriónica humana en sangre",
    :codigo => "LBL047",
    :orden => 107,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 470
    :nombre => "Gonadotrofina coriónica humana en orina",
    :codigo => "LBL048",
    :orden => 108,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 471
    :nombre => "Grasas en material fecal cualitativa",
    :codigo => "LBL049",
    :orden => 109,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 472
    :nombre => "Grupo y factor",
    :codigo => "LBL050",
    :orden => 110,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 473
    :nombre => "Hbs Ag",
    :codigo => "LBL051",
    :orden => 111,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 474
    :nombre => "HDL y LDL",
    :codigo => "LBL052",
    :orden => 112,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 475
    :nombre => "Hematocrito",
    :codigo => "LBL053",
    :orden => 113,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 476
    :nombre => "Hemocultivo aerobio anaerobio",
    :codigo => "LBL054",
    :orden => 114,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 477
    :nombre => "Hemoglobina",
    :codigo => "LBL055",
    :orden => 115,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 478
    :nombre => "Hemoglobina glicosilada",
    :codigo => "LBL056",
    :orden => 116,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 479
    :nombre => "Hemograma completo",
    :codigo => "LBL057",
    :orden => 117,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 480
    :nombre => "Hepatitis B anti HBS anticore total",
    :codigo => "LBL058",
    :orden => 118,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 481
    :nombre => "Hepatograma",
    :codigo => "LBL059",
    :orden => 119,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 482
    :nombre => "Hidatidosis por hemoaglutinación",
    :codigo => "LBL060",
    :orden => 120,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 483
    :nombre => "Hidatidosis por IFI",
    :codigo => "LBL061",
    :orden => 121,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 484
    :nombre => "Hisopado de fauces",
    :codigo => "LBL062",
    :orden => 122,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 485
    :nombre => "Homocistina",
    :codigo => "LBL063",
    :orden => 123,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 486
    :nombre => "IFI infecciones respiratorias",
    :codigo => "LBL064",
    :orden => 124,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 487
    :nombre => "IFI y hemoaglutinación directa para Chagas",
    :codigo => "LBL065",
    :orden => 125,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 488
    :nombre => "Insulinemia basal",
    :codigo => "LBL066",
    :orden => 126,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 489
    :nombre => "Inmunofenotipo de médula ósea por citometría de flujo",
    :codigo => "LBL067",
    :orden => 127,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 490
    :nombre => "Ionograma plasmático y orina",
    :codigo => "LBL068",
    :orden => 128,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 491
    :nombre => "KPTT",
    :codigo => "LBL069",
    :orden => 129,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 492
    :nombre => "LDH",
    :codigo => "LBL070",
    :orden => 130,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 493
    :nombre => "Leucocitos en material fecal",
    :codigo => "LBL071",
    :orden => 131,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 494
    :nombre => "LH",
    :codigo => "LBL072",
    :orden => 132,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 495
    :nombre => "Lipidograma electroforético",
    :codigo => "LBL073",
    :orden => 133,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 496
    :nombre => "Líquido cefalorraquídeo citoquímico y bacteriológico",
    :codigo => "LBL074",
    :orden => 134,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 497
    :nombre => "Líquido cefalorraquídeo - Recuento celular (cámara), citología (MGG, cytospin) e histoquímica",
    :codigo => "LBL075",
    :orden => 135,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 498
    :nombre => "Micológico",
    :codigo => "LBL076",
    :orden => 136,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 499
    :nombre => "Microalbuminuria",
    :codigo => "LBL077",
    :orden => 137,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 500
    :nombre => "Monotest",
    :codigo => "LBL078",
    :orden => 138,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 501
    :nombre => "Orina completa",
    :codigo => "LBL079",
    :orden => 139,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 502
    :nombre => "Parasitemia para Chagas",
    :codigo => "LBL080",
    :orden => 140,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 503
    :nombre => "Parasitológico de materia fecal",
    :codigo => "LBL081",
    :orden => 141,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 504
    :nombre => "pH en materia fecal",
    :codigo => "LBL082",
    :orden => 142,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 505
    :nombre => "Porcentaje de saturación de hierro funcional",
    :codigo => "LBL083",
    :orden => 143,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 506
    :nombre => "PPD",
    :codigo => "LBL084",
    :orden => 144,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 507
    :nombre => "Productos de degradación del fibrinógeno (PDF)",
    :codigo => "LBL085",
    :orden => 145,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 508
    :nombre => "Progesterona",
    :codigo => "LBL086",
    :orden => 146,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 509
    :nombre => "Prolactina",
    :codigo => "LBL087",
    :orden => 147,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 510
    :nombre => "Proteína C reactiva",
    :codigo => "LBL088",
    :orden => 148,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 511
    :nombre => "Proteínas totales y fraccionadas",
    :codigo => "LBL089",
    :orden => 149,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 512
    :nombre => "Proteinuria",
    :codigo => "LBL090",
    :orden => 150,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 513
    :nombre => "Protoporfirina libre eritrocitaria",
    :codigo => "LBL091",
    :orden => 151,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 514
    :nombre => "Prueba de Coombs directa",
    :codigo => "LBL092",
    :orden => 152,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 515
    :nombre => "Prueba de Coombs indirecta cuantitativa",
    :codigo => "LBL093",
    :orden => 153,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 516
    :nombre => "Prueba de tolerancia a la glucosa",
    :codigo => "LBL094",
    :orden => 154,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 517
    :nombre => "Reacción de Hudleson",
    :codigo => "LBL095",
    :orden => 155,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 518
    :nombre => "Reacción de Widal",
    :codigo => "LBL096",
    :orden => 156,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 519
    :nombre => "Receptores libres de transferrina",
    :codigo => "LBL097",
    :orden => 157,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 520
    :nombre => "Sangre oculta en heces",
    :codigo => "LBL098",
    :orden => 158,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 521
    :nombre => "Serología para Chagas (Elisa)",
    :codigo => "LBL099",
    :orden => 159,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 522
    :nombre => "Serología para hepatitis A IgM",
    :codigo => "LBL100",
    :orden => 160,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 523
    :nombre => "Serología para hepatitis A total",
    :codigo => "LBL101",
    :orden => 161,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 524
    :nombre => "Serología para rubéola IgM",
    :codigo => "LBL102",
    :orden => 162,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 525
    :nombre => "Sideremia",
    :codigo => "LBL103",
    :orden => 163,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 526
    :nombre => "T3",
    :codigo => "LBL104",
    :orden => 164,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 527
    :nombre => "T4 libre",
    :codigo => "LBL105",
    :orden => 165,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 528
    :nombre => "Test de Graham",
    :codigo => "LBL106",
    :orden => 166,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 529
    :nombre => "Test de látex",
    :codigo => "LBL107",
    :orden => 167,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 530
    :nombre => "TIBC",
    :codigo => "LBL108",
    :orden => 168,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 531
    :nombre => "Tiempo de lisis de euglobulina",
    :codigo => "LBL109",
    :orden => 169,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 532
    :nombre => "Toxoplasmosis por IFI",
    :codigo => "LBL110",
    :orden => 170,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 533
    :nombre => "Toxoplasmosis por MEIA",
    :codigo => "LBL111",
    :orden => 171,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 534
    :nombre => "Transaminasas TGO/TGP",
    :codigo => "LBL112",
    :orden => 172,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 535
    :nombre => "Transferrinas",
    :codigo => "LBL113",
    :orden => 173,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 536
    :nombre => "Triglicéridos",
    :codigo => "LBL114",
    :orden => 174,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 537
    :nombre => "Tripsina catiónica inmunorreactiva",
    :codigo => "LBL115",
    :orden => 175,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 538
    :nombre => "TSH",
    :codigo => "LBL116",
    :orden => 176,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 539
    :nombre => "Urea",
    :codigo => "LBL117",
    :orden => 177,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 540
    :nombre => "Urocultivo",
    :codigo => "LBL118",
    :orden => 178,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 541
    :nombre => "VDRL",
    :codigo => "LBL119",
    :orden => 179,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 542
    :nombre => "Vibrio cholerae cultivo e identificación",
    :codigo => "LBL120",
    :orden => 180,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 543
    :nombre => "VIH Elisa",
    :codigo => "LBL121",
    :orden => 181,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 544
    :nombre => "VIH Western Blot",
    :codigo => "LBL122",
    :orden => 182,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 545
    :nombre => "Serología para hepatitis C",
    :codigo => "LBL123",
    :orden => 183,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 546
    :nombre => "Magnesemia",
    :codigo => "LBL124",
    :orden => 184,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 547
    :nombre => "Serología LCR",
    :codigo => "LBL125",
    :orden => 185,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 548
    :nombre => "Recuento plaquetas",
    :codigo => "LBL126",
    :orden => 186,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 549
    :nombre => "Antígeno P24",
    :codigo => "LBL127",
    :orden => 187,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => false
  },
  {
    # :id => 550
    :nombre => "Hemoaglutinación indirecta Chagas",
    :codigo => "LBL128",
    :orden => 188,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 551
    :nombre => "IgE sérica",
    :codigo => "LBL129",
    :orden => 189,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 552
    :nombre => "Tiempo de coagulación y sangría",
    :codigo => "LBL130",
    :orden => 190,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 553
    :nombre => "Tiempo de protrombina",
    :codigo => "LBL131",
    :orden => 191,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 554
    :nombre => "Tiempo de trombina",
    :codigo => "LBL132",
    :orden => 192,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 555
    :nombre => "Frotis de sangre periférica",
    :codigo => "LBL133",
    :orden => 193,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 556
    :nombre => "Recuento reticulocitario",
    :codigo => "LBL134",
    :orden => 194,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  },
  {
    # :id => 557
    :nombre => "Fructosamina",
    :codigo => "LBL135",
    :orden => 195,
    :grupo_pdss_id => 6,
    :subgrupo_pdss_id => nil,
    :apartado_pdss_id => nil,
    :nosologia_id => nil,
    :tipo_de_prestacion_id => 10,
    :rural => true
  }
])

PrestacionPdss.find(1).prestaciones << [Prestacion.find(258)]
PrestacionPdss.find(2).prestaciones << [Prestacion.find(259)]
PrestacionPdss.find(3).prestaciones << [Prestacion.find(260)]
PrestacionPdss.find(4).prestaciones << [Prestacion.find(261)]
PrestacionPdss.find(5).prestaciones << [Prestacion.find(262)]
PrestacionPdss.find(6).prestaciones << [Prestacion.find(263)]
PrestacionPdss.find(7).prestaciones << [Prestacion.find(764)]
PrestacionPdss.find(8).prestaciones << [Prestacion.find(264)]
PrestacionPdss.find(9).prestaciones << [Prestacion.find(265)]
PrestacionPdss.find(10).prestaciones << [Prestacion.find(266)]
PrestacionPdss.find(11).prestaciones << [Prestacion.find(267)]
PrestacionPdss.find(12).prestaciones << [Prestacion.find(268)]
PrestacionPdss.find(13).prestaciones << [Prestacion.find(269)]
PrestacionPdss.find(14).prestaciones << [Prestacion.find(270)]
PrestacionPdss.find(15).prestaciones << Prestacion.find([271, 272])
PrestacionPdss.find(16).prestaciones << Prestacion.find([273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286])
PrestacionPdss.find(17).prestaciones << Prestacion.find([287, 288, 289, 290, 291, 292])
PrestacionPdss.find(18).prestaciones << [Prestacion.find(293)]
PrestacionPdss.find(19).prestaciones << [Prestacion.find(294)]
PrestacionPdss.find(20).prestaciones << [Prestacion.find(295)]
PrestacionPdss.find(21).prestaciones << [Prestacion.find(592)]
PrestacionPdss.find(22).prestaciones << [Prestacion.find(593)]
PrestacionPdss.find(23).prestaciones << [Prestacion.find(607)]
PrestacionPdss.find(24).prestaciones << [Prestacion.find(296)]
PrestacionPdss.find(25).prestaciones << [Prestacion.find(297)]
PrestacionPdss.find(26).prestaciones << [Prestacion.find(594)]
PrestacionPdss.find(27).prestaciones << [Prestacion.find(595)]
PrestacionPdss.find(28).prestaciones << [Prestacion.find(596)]
PrestacionPdss.find(29).prestaciones << [Prestacion.find(298)]
PrestacionPdss.find(30).prestaciones << [Prestacion.find(299)]
PrestacionPdss.find(31).prestaciones << [Prestacion.find(300)]
PrestacionPdss.find(32).prestaciones << [Prestacion.find(301)]
PrestacionPdss.find(33).prestaciones << [Prestacion.find(302)]
PrestacionPdss.find(34).prestaciones << [Prestacion.find(303)]
PrestacionPdss.find(35).prestaciones << [Prestacion.find(304)]
PrestacionPdss.find(36).prestaciones << [Prestacion.find(305)]
PrestacionPdss.find(37).prestaciones << [Prestacion.find(306)]
PrestacionPdss.find(38).prestaciones << [Prestacion.find(307)]
PrestacionPdss.find(39).prestaciones << [Prestacion.find(308)]
PrestacionPdss.find(40).prestaciones << [Prestacion.find(309)]
PrestacionPdss.find(41).prestaciones << [Prestacion.find(310)]
PrestacionPdss.find(42).prestaciones << [Prestacion.find(311)]
PrestacionPdss.find(43).prestaciones << [Prestacion.find(312)]
PrestacionPdss.find(44).prestaciones << [Prestacion.find(313)]
PrestacionPdss.find(45).prestaciones << [Prestacion.find(314)]
PrestacionPdss.find(46).prestaciones << [Prestacion.find(315)]
PrestacionPdss.find(47).prestaciones << [Prestacion.find(316)]
PrestacionPdss.find(48).prestaciones << [Prestacion.find(317)]
PrestacionPdss.find(49).prestaciones << [Prestacion.find(318)]
PrestacionPdss.find(50).prestaciones << [Prestacion.find(319)]
PrestacionPdss.find(51)
PrestacionPdss.find(52).prestaciones << [Prestacion.find(320)]
PrestacionPdss.find(53).prestaciones << [Prestacion.find(321)]
PrestacionPdss.find(54).prestaciones << [Prestacion.find(322)]
PrestacionPdss.find(55).prestaciones << [Prestacion.find(323)]
PrestacionPdss.find(56).prestaciones << [Prestacion.find(324)]
PrestacionPdss.find(57).prestaciones << [Prestacion.find(325)]
PrestacionPdss.find(58).prestaciones << [Prestacion.find(326)]
PrestacionPdss.find(59).prestaciones << [Prestacion.find(327)]
PrestacionPdss.find(60).prestaciones << [Prestacion.find(328)]
PrestacionPdss.find(61).prestaciones << [Prestacion.find(329)]
PrestacionPdss.find(62).prestaciones << [Prestacion.find(330)]
PrestacionPdss.find(63).prestaciones << [Prestacion.find(331)]
PrestacionPdss.find(64).prestaciones << [Prestacion.find(332)]
PrestacionPdss.find(65).prestaciones << [Prestacion.find(333)]
PrestacionPdss.find(66).prestaciones << [Prestacion.find(334)]
PrestacionPdss.find(67).prestaciones << [Prestacion.find(336)]
PrestacionPdss.find(68).prestaciones << [Prestacion.find(335)]
PrestacionPdss.find(69).prestaciones << [Prestacion.find(337)]
PrestacionPdss.find(70).prestaciones << [Prestacion.find(338)]
PrestacionPdss.find(71).prestaciones << [Prestacion.find(339)]
PrestacionPdss.find(72).prestaciones << [Prestacion.find(340)]
PrestacionPdss.find(73).prestaciones << [Prestacion.find(341)]
PrestacionPdss.find(74).prestaciones << [Prestacion.find(342)]
PrestacionPdss.find(75).prestaciones << [Prestacion.find(343)]
PrestacionPdss.find(76).prestaciones << [Prestacion.find(344)]
PrestacionPdss.find(77).prestaciones << [Prestacion.find(345)]
PrestacionPdss.find(78).prestaciones << [Prestacion.find(346)]
PrestacionPdss.find(79).prestaciones << [Prestacion.find(347)]
PrestacionPdss.find(80).prestaciones << [Prestacion.find(348)]
PrestacionPdss.find(81).prestaciones << [Prestacion.find(349)]
PrestacionPdss.find(82).prestaciones << [Prestacion.find(350)]
PrestacionPdss.find(83).prestaciones << [Prestacion.find(351)]
PrestacionPdss.find(84).prestaciones << [Prestacion.find(352)]
PrestacionPdss.find(85).prestaciones << [Prestacion.find(353)]
PrestacionPdss.find(86).prestaciones << [Prestacion.find(354)]
PrestacionPdss.find(87).prestaciones << [Prestacion.find(355)]
PrestacionPdss.find(88).prestaciones << [Prestacion.find(356)]
PrestacionPdss.find(89).prestaciones << [Prestacion.find(357)]
PrestacionPdss.find(90).prestaciones << [Prestacion.find(358)]
PrestacionPdss.find(91).prestaciones << [Prestacion.find(332)]
PrestacionPdss.find(92).prestaciones << [Prestacion.find(333)]
PrestacionPdss.find(93).prestaciones << [Prestacion.find(334)]
PrestacionPdss.find(94).prestaciones << [Prestacion.find(335)]
PrestacionPdss.find(95).prestaciones << [Prestacion.find(359)]
PrestacionPdss.find(96).prestaciones << [Prestacion.find(360)]
PrestacionPdss.find(97).prestaciones << [Prestacion.find(361)]
PrestacionPdss.find(98).prestaciones << [Prestacion.find(338)]
PrestacionPdss.find(99).prestaciones << [Prestacion.find(339)]
PrestacionPdss.find(100).prestaciones << [Prestacion.find(340)]
PrestacionPdss.find(101).prestaciones << [Prestacion.find(341)]
PrestacionPdss.find(102).prestaciones << [Prestacion.find(362)]
PrestacionPdss.find(103).prestaciones << [Prestacion.find(363)]
PrestacionPdss.find(104).prestaciones << [Prestacion.find(348)]
PrestacionPdss.find(105).prestaciones << [Prestacion.find(364)]
PrestacionPdss.find(106).prestaciones << [Prestacion.find(351)]
PrestacionPdss.find(107).prestaciones << [Prestacion.find(317)]
PrestacionPdss.find(108).prestaciones << [Prestacion.find(365)]
PrestacionPdss.find(109).prestaciones << [Prestacion.find(366)]
PrestacionPdss.find(110).prestaciones << [Prestacion.find(367)]
PrestacionPdss.find(111).prestaciones << [Prestacion.find(368)]
PrestacionPdss.find(112).prestaciones << [Prestacion.find(332)]
PrestacionPdss.find(113).prestaciones << [Prestacion.find(369)]
PrestacionPdss.find(114).prestaciones << [Prestacion.find(348)]
PrestacionPdss.find(115).prestaciones << [Prestacion.find(317)]
PrestacionPdss.find(116).prestaciones << [Prestacion.find(351)]
PrestacionPdss.find(117).prestaciones << [Prestacion.find(370)]
PrestacionPdss.find(118).prestaciones << [Prestacion.find(371)]
PrestacionPdss.find(119).prestaciones << [Prestacion.find(372)]
PrestacionPdss.find(120).prestaciones << [Prestacion.find(373)]
PrestacionPdss.find(121).prestaciones << [Prestacion.find(374)]
PrestacionPdss.find(122).prestaciones << [Prestacion.find(375)]
PrestacionPdss.find(123).prestaciones << [Prestacion.find(376)]
PrestacionPdss.find(124).prestaciones << [Prestacion.find(377)]
PrestacionPdss.find(125).prestaciones << [Prestacion.find(378)]
PrestacionPdss.find(126).prestaciones << [Prestacion.find(379)]
PrestacionPdss.find(127).prestaciones << Prestacion.find([380, 381])
PrestacionPdss.find(128).prestaciones << [Prestacion.find(382)]
PrestacionPdss.find(129).prestaciones << [Prestacion.find(383)]
PrestacionPdss.find(130).prestaciones << [Prestacion.find(384)]
PrestacionPdss.find(131).prestaciones << [Prestacion.find(385)]
PrestacionPdss.find(132).prestaciones << [Prestacion.find(386)]
PrestacionPdss.find(133).prestaciones << [Prestacion.find(387)]
PrestacionPdss.find(134).prestaciones << [Prestacion.find(390)]
PrestacionPdss.find(135).prestaciones << [Prestacion.find(391)]
PrestacionPdss.find(136).prestaciones << [Prestacion.find(392)]
PrestacionPdss.find(137).prestaciones << [Prestacion.find(396)]
PrestacionPdss.find(138).prestaciones << [Prestacion.find(397)]
PrestacionPdss.find(139).prestaciones << [Prestacion.find(398)]
PrestacionPdss.find(140).prestaciones << [Prestacion.find(399)]
PrestacionPdss.find(141).prestaciones << [Prestacion.find(400)]
PrestacionPdss.find(142).prestaciones << [Prestacion.find(401)]
PrestacionPdss.find(143).prestaciones << [Prestacion.find(402)]
PrestacionPdss.find(144).prestaciones << [Prestacion.find(403)]
PrestacionPdss.find(145).prestaciones << [Prestacion.find(404)]
PrestacionPdss.find(146).prestaciones << [Prestacion.find(405)]
PrestacionPdss.find(147).prestaciones << [Prestacion.find(406)]
PrestacionPdss.find(148).prestaciones << [Prestacion.find(407)]
PrestacionPdss.find(149).prestaciones << [Prestacion.find(408)]
PrestacionPdss.find(150).prestaciones << [Prestacion.find(409)]
PrestacionPdss.find(151).prestaciones << [Prestacion.find(410)]
PrestacionPdss.find(152).prestaciones << [Prestacion.find(411)]
PrestacionPdss.find(153).prestaciones << [Prestacion.find(412)]
PrestacionPdss.find(154).prestaciones << [Prestacion.find(413)]
PrestacionPdss.find(155).prestaciones << [Prestacion.find(414)]
PrestacionPdss.find(156).prestaciones << [Prestacion.find(415)]
PrestacionPdss.find(157).prestaciones << [Prestacion.find(416)]
PrestacionPdss.find(158).prestaciones << [Prestacion.find(417)]
PrestacionPdss.find(159).prestaciones << [Prestacion.find(418)]
PrestacionPdss.find(160).prestaciones << [Prestacion.find(419)]
PrestacionPdss.find(161).prestaciones << [Prestacion.find(420)]
PrestacionPdss.find(162).prestaciones << [Prestacion.find(421)]
PrestacionPdss.find(163).prestaciones << [Prestacion.find(422)]
PrestacionPdss.find(164).prestaciones << [Prestacion.find(423)]
PrestacionPdss.find(165).prestaciones << [Prestacion.find(424)]
PrestacionPdss.find(166).prestaciones << [Prestacion.find(425)]
PrestacionPdss.find(167).prestaciones << [Prestacion.find(426)]
PrestacionPdss.find(168).prestaciones << [Prestacion.find(427)]
PrestacionPdss.find(169).prestaciones << [Prestacion.find(446)]
PrestacionPdss.find(170).prestaciones << [Prestacion.find(447)]
PrestacionPdss.find(171).prestaciones << [Prestacion.find(448)]
PrestacionPdss.find(172).prestaciones << [Prestacion.find(449)]
PrestacionPdss.find(173).prestaciones << [Prestacion.find(450)]
PrestacionPdss.find(174).prestaciones << [Prestacion.find(451)]
PrestacionPdss.find(175).prestaciones << [Prestacion.find(452)]
PrestacionPdss.find(176).prestaciones << [Prestacion.find(453)]
PrestacionPdss.find(177).prestaciones << [Prestacion.find(454)]
PrestacionPdss.find(178).prestaciones << [Prestacion.find(455)]
PrestacionPdss.find(179).prestaciones << [Prestacion.find(456)]
PrestacionPdss.find(180).prestaciones << [Prestacion.find(457)]
PrestacionPdss.find(181).prestaciones << [Prestacion.find(458)]
PrestacionPdss.find(182).prestaciones << [Prestacion.find(459)]
PrestacionPdss.find(183).prestaciones << [Prestacion.find(460)]
PrestacionPdss.find(184).prestaciones << [Prestacion.find(461)]
PrestacionPdss.find(185).prestaciones << [Prestacion.find(462)]
PrestacionPdss.find(186).prestaciones << [Prestacion.find(463)]
PrestacionPdss.find(187).prestaciones << [Prestacion.find(464)]
PrestacionPdss.find(188).prestaciones << [Prestacion.find(465)]
PrestacionPdss.find(189).prestaciones << [Prestacion.find(765)]
PrestacionPdss.find(190).prestaciones << [Prestacion.find(466)]
PrestacionPdss.find(191).prestaciones << [Prestacion.find(592)]
PrestacionPdss.find(192).prestaciones << [Prestacion.find(593)]
PrestacionPdss.find(193).prestaciones << [Prestacion.find(607)]
PrestacionPdss.find(194).prestaciones << [Prestacion.find(467)]
PrestacionPdss.find(195).prestaciones << [Prestacion.find(595)]
PrestacionPdss.find(196).prestaciones << [Prestacion.find(594)]
PrestacionPdss.find(197).prestaciones << [Prestacion.find(382)]
PrestacionPdss.find(198).prestaciones << [Prestacion.find(468)]
PrestacionPdss.find(199).prestaciones << [Prestacion.find(469)]
PrestacionPdss.find(200).prestaciones << [Prestacion.find(470)]
PrestacionPdss.find(201).prestaciones << [Prestacion.find(471)]
PrestacionPdss.find(202).prestaciones << [Prestacion.find(472)]
PrestacionPdss.find(203).prestaciones << [Prestacion.find(473)]
PrestacionPdss.find(204).prestaciones << [Prestacion.find(474)]
PrestacionPdss.find(205).prestaciones << [Prestacion.find(475)]
PrestacionPdss.find(206).prestaciones << [Prestacion.find(476)]
PrestacionPdss.find(207).prestaciones << [Prestacion.find(477)]
PrestacionPdss.find(208).prestaciones << [Prestacion.find(478)]
PrestacionPdss.find(209).prestaciones << [Prestacion.find(479)]
PrestacionPdss.find(210).prestaciones << [Prestacion.find(480)]
PrestacionPdss.find(211).prestaciones << [Prestacion.find(608)]
PrestacionPdss.find(212).prestaciones << [Prestacion.find(481)]
PrestacionPdss.find(213).prestaciones << [Prestacion.find(482)]
PrestacionPdss.find(214).prestaciones << [Prestacion.find(483)]
PrestacionPdss.find(215).prestaciones << [Prestacion.find(484)]
PrestacionPdss.find(216).prestaciones << [Prestacion.find(485)]
PrestacionPdss.find(217).prestaciones << [Prestacion.find(486)]
PrestacionPdss.find(218)
PrestacionPdss.find(219).prestaciones << [Prestacion.find(487)]
PrestacionPdss.find(220).prestaciones << [Prestacion.find(488)]
PrestacionPdss.find(221).prestaciones << [Prestacion.find(489)]
PrestacionPdss.find(222).prestaciones << [Prestacion.find(490)]
PrestacionPdss.find(223).prestaciones << [Prestacion.find(491)]
PrestacionPdss.find(224).prestaciones << [Prestacion.find(492)]
PrestacionPdss.find(225).prestaciones << [Prestacion.find(493)]
PrestacionPdss.find(226).prestaciones << [Prestacion.find(494)]
PrestacionPdss.find(227).prestaciones << [Prestacion.find(495)]
PrestacionPdss.find(228).prestaciones << [Prestacion.find(496)]
PrestacionPdss.find(229).prestaciones << [Prestacion.find(597)]
PrestacionPdss.find(230).prestaciones << [Prestacion.find(609)]
PrestacionPdss.find(231).prestaciones << [Prestacion.find(603)]
PrestacionPdss.find(232).prestaciones << [Prestacion.find(592)]
PrestacionPdss.find(233).prestaciones << [Prestacion.find(593)]
PrestacionPdss.find(234).prestaciones << [Prestacion.find(497)]
PrestacionPdss.find(235).prestaciones << [Prestacion.find(498)]
PrestacionPdss.find(236).prestaciones << [Prestacion.find(499)]
PrestacionPdss.find(237).prestaciones << [Prestacion.find(500)]
PrestacionPdss.find(238).prestaciones << [Prestacion.find(501)]
PrestacionPdss.find(239).prestaciones << [Prestacion.find(502)]
PrestacionPdss.find(240).prestaciones << [Prestacion.find(765)]
PrestacionPdss.find(241).prestaciones << [Prestacion.find(503)]
PrestacionPdss.find(242).prestaciones << [Prestacion.find(504)]
PrestacionPdss.find(243).prestaciones << [Prestacion.find(505)]
PrestacionPdss.find(244).prestaciones << [Prestacion.find(506)]
PrestacionPdss.find(245).prestaciones << [Prestacion.find(507)]
PrestacionPdss.find(246).prestaciones << [Prestacion.find(508)]
PrestacionPdss.find(247).prestaciones << [Prestacion.find(509)]
PrestacionPdss.find(248).prestaciones << [Prestacion.find(510)]
PrestacionPdss.find(249).prestaciones << [Prestacion.find(511)]
PrestacionPdss.find(250).prestaciones << [Prestacion.find(512)]
PrestacionPdss.find(251).prestaciones << [Prestacion.find(513)]
PrestacionPdss.find(252).prestaciones << [Prestacion.find(514)]
PrestacionPdss.find(253).prestaciones << [Prestacion.find(515)]
PrestacionPdss.find(254).prestaciones << [Prestacion.find(516)]
PrestacionPdss.find(255).prestaciones << [Prestacion.find(517)]
PrestacionPdss.find(256).prestaciones << [Prestacion.find(518)]
PrestacionPdss.find(257).prestaciones << [Prestacion.find(519)]
PrestacionPdss.find(258)
PrestacionPdss.find(259)
PrestacionPdss.find(260)
PrestacionPdss.find(261).prestaciones << [Prestacion.find(520)]
PrestacionPdss.find(262).prestaciones << [Prestacion.find(521)]
PrestacionPdss.find(263).prestaciones << [Prestacion.find(522)]
PrestacionPdss.find(264).prestaciones << [Prestacion.find(523)]
PrestacionPdss.find(265).prestaciones << [Prestacion.find(524)]
PrestacionPdss.find(266).prestaciones << [Prestacion.find(525)]
PrestacionPdss.find(267).prestaciones << [Prestacion.find(526)]
PrestacionPdss.find(268).prestaciones << [Prestacion.find(527)]
PrestacionPdss.find(269).prestaciones << [Prestacion.find(528)]
PrestacionPdss.find(270).prestaciones << [Prestacion.find(529)]
PrestacionPdss.find(271).prestaciones << [Prestacion.find(530)]
PrestacionPdss.find(272).prestaciones << [Prestacion.find(531)]
PrestacionPdss.find(273).prestaciones << [Prestacion.find(598)]
PrestacionPdss.find(274).prestaciones << [Prestacion.find(597)]
PrestacionPdss.find(275).prestaciones << [Prestacion.find(600)]
PrestacionPdss.find(276).prestaciones << [Prestacion.find(599)]
PrestacionPdss.find(277).prestaciones << [Prestacion.find(601)]
PrestacionPdss.find(278).prestaciones << [Prestacion.find(602)]
PrestacionPdss.find(279).prestaciones << [Prestacion.find(603)]
PrestacionPdss.find(280).prestaciones << [Prestacion.find(604)]
PrestacionPdss.find(281).prestaciones << [Prestacion.find(605)]
PrestacionPdss.find(282).prestaciones << [Prestacion.find(606)]
PrestacionPdss.find(283).prestaciones << [Prestacion.find(592)]
PrestacionPdss.find(284).prestaciones << [Prestacion.find(593)]
PrestacionPdss.find(285).prestaciones << [Prestacion.find(532)]
PrestacionPdss.find(286).prestaciones << [Prestacion.find(533)]
PrestacionPdss.find(287).prestaciones << [Prestacion.find(534)]
PrestacionPdss.find(288).prestaciones << [Prestacion.find(535)]
PrestacionPdss.find(289).prestaciones << [Prestacion.find(536)]
PrestacionPdss.find(290).prestaciones << [Prestacion.find(537)]
PrestacionPdss.find(291).prestaciones << [Prestacion.find(538)]
PrestacionPdss.find(292).prestaciones << [Prestacion.find(539)]
PrestacionPdss.find(293).prestaciones << [Prestacion.find(540)]
PrestacionPdss.find(294).prestaciones << [Prestacion.find(541)]
PrestacionPdss.find(295).prestaciones << [Prestacion.find(542)]
PrestacionPdss.find(296).prestaciones << [Prestacion.find(543)]
PrestacionPdss.find(297).prestaciones << [Prestacion.find(544)]
PrestacionPdss.find(298).prestaciones << [Prestacion.find(545)]
PrestacionPdss.find(299).prestaciones << [Prestacion.find(546)]
PrestacionPdss.find(300).prestaciones << [Prestacion.find(547)]
PrestacionPdss.find(301).prestaciones << [Prestacion.find(548)]
PrestacionPdss.find(302).prestaciones << [Prestacion.find(549)]
PrestacionPdss.find(303).prestaciones << [Prestacion.find(550)]
PrestacionPdss.find(304).prestaciones << [Prestacion.find(551)]
PrestacionPdss.find(305).prestaciones << [Prestacion.find(552)]
PrestacionPdss.find(306).prestaciones << [Prestacion.find(553)]
PrestacionPdss.find(307).prestaciones << [Prestacion.find(554)]
PrestacionPdss.find(308).prestaciones << [Prestacion.find(555)]
PrestacionPdss.find(309).prestaciones << [Prestacion.find(556)]
PrestacionPdss.find(310).prestaciones << [Prestacion.find(557)]
PrestacionPdss.find(311).prestaciones << [Prestacion.find(558)]
PrestacionPdss.find(312)
PrestacionPdss.find(313)
PrestacionPdss.find(314)
PrestacionPdss.find(315).prestaciones << [Prestacion.find(559)]
PrestacionPdss.find(316).prestaciones << [Prestacion.find(560)]
PrestacionPdss.find(317).prestaciones << [Prestacion.find(561)]
PrestacionPdss.find(318).prestaciones << [Prestacion.find(562)]
PrestacionPdss.find(319).prestaciones << [Prestacion.find(563)]
PrestacionPdss.find(320).prestaciones << [Prestacion.find(564)]
PrestacionPdss.find(321).prestaciones << [Prestacion.find(565)]
PrestacionPdss.find(322).prestaciones << [Prestacion.find(566)]
PrestacionPdss.find(323).prestaciones << [Prestacion.find(567)]
PrestacionPdss.find(324).prestaciones << [Prestacion.find(568)]
PrestacionPdss.find(325).prestaciones << [Prestacion.find(569)]
PrestacionPdss.find(326).prestaciones << [Prestacion.find(570)]
PrestacionPdss.find(327).prestaciones << [Prestacion.find(598)]
PrestacionPdss.find(328).prestaciones << [Prestacion.find(597)]
PrestacionPdss.find(329).prestaciones << [Prestacion.find(600)]
PrestacionPdss.find(330).prestaciones << [Prestacion.find(599)]
PrestacionPdss.find(331).prestaciones << [Prestacion.find(601)]
PrestacionPdss.find(332).prestaciones << [Prestacion.find(602)]
PrestacionPdss.find(333).prestaciones << [Prestacion.find(603)]
PrestacionPdss.find(334).prestaciones << [Prestacion.find(604)]
PrestacionPdss.find(335).prestaciones << [Prestacion.find(605)]
PrestacionPdss.find(336).prestaciones << [Prestacion.find(592)]
PrestacionPdss.find(337).prestaciones << [Prestacion.find(593)]
PrestacionPdss.find(338).prestaciones << [Prestacion.find(571)]
PrestacionPdss.find(339).prestaciones << [Prestacion.find(572)]
PrestacionPdss.find(340).prestaciones << [Prestacion.find(573)]
PrestacionPdss.find(341).prestaciones << [Prestacion.find(574)]
PrestacionPdss.find(342).prestaciones << [Prestacion.find(575)]
PrestacionPdss.find(343).prestaciones << [Prestacion.find(576)]
PrestacionPdss.find(344).prestaciones << [Prestacion.find(577)]
PrestacionPdss.find(345).prestaciones << [Prestacion.find(578)]
PrestacionPdss.find(346).prestaciones << [Prestacion.find(579)]
PrestacionPdss.find(347).prestaciones << [Prestacion.find(580)]
PrestacionPdss.find(348).prestaciones << [Prestacion.find(581)]
PrestacionPdss.find(349).prestaciones << [Prestacion.find(582)]
PrestacionPdss.find(350).prestaciones << [Prestacion.find(583)]
PrestacionPdss.find(351).prestaciones << [Prestacion.find(584)]
PrestacionPdss.find(352).prestaciones << [Prestacion.find(585)]
PrestacionPdss.find(353).prestaciones << [Prestacion.find(586)]
PrestacionPdss.find(354).prestaciones << [Prestacion.find(587)]
PrestacionPdss.find(355).prestaciones << [Prestacion.find(588)]
PrestacionPdss.find(356).prestaciones << [Prestacion.find(589)]
PrestacionPdss.find(357).prestaciones << [Prestacion.find(590)]
PrestacionPdss.find(358).prestaciones << [Prestacion.find(591)]
PrestacionPdss.find(359).prestaciones << [Prestacion.find(558)]
PrestacionPdss.find(360)
PrestacionPdss.find(361)
PrestacionPdss.find(362)
PrestacionPdss.find(363).prestaciones << [Prestacion.find(619)]
PrestacionPdss.find(364).prestaciones << [Prestacion.find(620)]
PrestacionPdss.find(365).prestaciones << [Prestacion.find(558)]
PrestacionPdss.find(366).prestaciones << Prestacion.find([621, 767, 768])
PrestacionPdss.find(367).prestaciones << [Prestacion.find(622)]
PrestacionPdss.find(368).prestaciones << [Prestacion.find(623)]
PrestacionPdss.find(369).prestaciones << [Prestacion.find(624)]
PrestacionPdss.find(370).prestaciones << [Prestacion.find(625)]
PrestacionPdss.find(371).prestaciones << [Prestacion.find(626)]
PrestacionPdss.find(372).prestaciones << [Prestacion.find(627)]
PrestacionPdss.find(373).prestaciones << [Prestacion.find(628)]
PrestacionPdss.find(374).prestaciones << [Prestacion.find(629)]
PrestacionPdss.find(375).prestaciones << [Prestacion.find(630)]
PrestacionPdss.find(376).prestaciones << [Prestacion.find(631)]
PrestacionPdss.find(377).prestaciones << [Prestacion.find(632)]
PrestacionPdss.find(378).prestaciones << [Prestacion.find(633)]
PrestacionPdss.find(379).prestaciones << Prestacion.find([484, 505])
PrestacionPdss.find(380).prestaciones << [Prestacion.find(634)]
PrestacionPdss.find(381).prestaciones << [Prestacion.find(635)]
PrestacionPdss.find(382).prestaciones << [Prestacion.find(636)]
PrestacionPdss.find(383).prestaciones << [Prestacion.find(351)]
PrestacionPdss.find(384).prestaciones << [Prestacion.find(269)]
PrestacionPdss.find(385).prestaciones << [Prestacion.find(637)]
PrestacionPdss.find(386).prestaciones << Prestacion.find([638, 769, 770])
PrestacionPdss.find(387).prestaciones << [Prestacion.find(492)]
PrestacionPdss.find(388).prestaciones << [Prestacion.find(487)]
PrestacionPdss.find(389).prestaciones << [Prestacion.find(639)]
PrestacionPdss.find(390).prestaciones << Prestacion.find([640, 771, 772])
PrestacionPdss.find(391).prestaciones << Prestacion.find([641, 773, 774])
PrestacionPdss.find(392).prestaciones << Prestacion.find([642, 775, 776])
PrestacionPdss.find(393).prestaciones << Prestacion.find([643, 777])
PrestacionPdss.find(394).prestaciones << [Prestacion.find(644)]
PrestacionPdss.find(395).prestaciones << Prestacion.find([645, 778])
PrestacionPdss.find(396).prestaciones << [Prestacion.find(646)]
PrestacionPdss.find(397).prestaciones << [Prestacion.find(779)]
PrestacionPdss.find(398).prestaciones << [Prestacion.find(647)]
PrestacionPdss.find(399).prestaciones << [Prestacion.find(648)]
PrestacionPdss.find(400).prestaciones << [Prestacion.find(649)]
PrestacionPdss.find(401).prestaciones << [Prestacion.find(650)]
PrestacionPdss.find(402).prestaciones << [Prestacion.find(780)]
PrestacionPdss.find(403).prestaciones << [Prestacion.find(651)]
PrestacionPdss.find(404).prestaciones << [Prestacion.find(652)]
PrestacionPdss.find(405).prestaciones << [Prestacion.find(781)]
PrestacionPdss.find(406).prestaciones << [Prestacion.find(653)]
PrestacionPdss.find(407).prestaciones << [Prestacion.find(654)]
PrestacionPdss.find(408).prestaciones << [Prestacion.find(655)]
PrestacionPdss.find(409).prestaciones << Prestacion.find([656, 782])
PrestacionPdss.find(410).prestaciones << [Prestacion.find(320)]
PrestacionPdss.find(411).prestaciones << Prestacion.find([657, 783, 784])
PrestacionPdss.find(412).prestaciones
PrestacionPdss.find(413).prestaciones
PrestacionPdss.find(414).prestaciones
PrestacionPdss.find(415).prestaciones << Prestacion.find([658, 785])
PrestacionPdss.find(416).prestaciones << [Prestacion.find(592)]
PrestacionPdss.find(417).prestaciones << [Prestacion.find(593)]
PrestacionPdss.find(418).prestaciones << [Prestacion.find(659)]
PrestacionPdss.find(419).prestaciones << [Prestacion.find(660)]
PrestacionPdss.find(420).prestaciones << [Prestacion.find(485)]
PrestacionPdss.find(421).prestaciones << [Prestacion.find(486)]
PrestacionPdss.find(422).prestaciones << [Prestacion.find(298)]
PrestacionPdss.find(423).prestaciones << [Prestacion.find(382)]
PrestacionPdss.find(424).prestaciones << [Prestacion.find(607)]
PrestacionPdss.find(425).prestaciones << [Prestacion.find(661)]
PrestacionPdss.find(426).prestaciones << [Prestacion.find(662)]
PrestacionPdss.find(427).prestaciones << [Prestacion.find(663)]
PrestacionPdss.find(428).prestaciones << [Prestacion.find(664)]
PrestacionPdss.find(429).prestaciones << [Prestacion.find(665)]
PrestacionPdss.find(430).prestaciones << [Prestacion.find(666)]
PrestacionPdss.find(431).prestaciones << [Prestacion.find(667)]
PrestacionPdss.find(432).prestaciones << [Prestacion.find(668)]
PrestacionPdss.find(433).prestaciones << [Prestacion.find(669)]
PrestacionPdss.find(434).prestaciones << [Prestacion.find(670)]
PrestacionPdss.find(435).prestaciones << [Prestacion.find(786)]
PrestacionPdss.find(436).prestaciones << [Prestacion.find(671)]
PrestacionPdss.find(437).prestaciones << [Prestacion.find(672)]
PrestacionPdss.find(438).prestaciones << [Prestacion.find(673)]
PrestacionPdss.find(439).prestaciones << [Prestacion.find(674)]
PrestacionPdss.find(440).prestaciones << [Prestacion.find(675)]
PrestacionPdss.find(441).prestaciones << [Prestacion.find(676)]
PrestacionPdss.find(442).prestaciones << [Prestacion.find(677)]
PrestacionPdss.find(443).prestaciones << [Prestacion.find(678)]
PrestacionPdss.find(444).prestaciones << [Prestacion.find(787)]
PrestacionPdss.find(445).prestaciones << [Prestacion.find(788)]
PrestacionPdss.find(446).prestaciones << [Prestacion.find(789)]
PrestacionPdss.find(447).prestaciones << [Prestacion.find(679)]
PrestacionPdss.find(448).prestaciones << [Prestacion.find(680)]
PrestacionPdss.find(449).prestaciones << [Prestacion.find(681)]
PrestacionPdss.find(450).prestaciones << [Prestacion.find(682)]
PrestacionPdss.find(451).prestaciones << [Prestacion.find(683)]
PrestacionPdss.find(452).prestaciones << [Prestacion.find(684)]
PrestacionPdss.find(453).prestaciones << [Prestacion.find(685)]
PrestacionPdss.find(454).prestaciones << Prestacion.find([686, 790])
PrestacionPdss.find(455).prestaciones << Prestacion.find([687, 791])
PrestacionPdss.find(456).prestaciones << Prestacion.find([688, 792])
PrestacionPdss.find(457).prestaciones << [Prestacion.find(689)]
PrestacionPdss.find(458).prestaciones << [Prestacion.find(690)]
PrestacionPdss.find(459).prestaciones << [Prestacion.find(691)]
PrestacionPdss.find(460).prestaciones << [Prestacion.find(692)]
PrestacionPdss.find(461).prestaciones << [Prestacion.find(693)]
PrestacionPdss.find(462).prestaciones << [Prestacion.find(793)]
PrestacionPdss.find(463).prestaciones << [Prestacion.find(694)]
PrestacionPdss.find(464).prestaciones << [Prestacion.find(695)]
PrestacionPdss.find(465).prestaciones << [Prestacion.find(696)]
PrestacionPdss.find(466).prestaciones << [Prestacion.find(794)]
PrestacionPdss.find(467).prestaciones << [Prestacion.find(697)]
PrestacionPdss.find(468).prestaciones << [Prestacion.find(698)]
PrestacionPdss.find(469).prestaciones << [Prestacion.find(271)]
PrestacionPdss.find(470).prestaciones << [Prestacion.find(272)]
PrestacionPdss.find(471).prestaciones << [Prestacion.find(699)]
PrestacionPdss.find(472).prestaciones << [Prestacion.find(700)]
PrestacionPdss.find(473).prestaciones << [Prestacion.find(286)]
PrestacionPdss.find(474).prestaciones << [Prestacion.find(795)]
PrestacionPdss.find(475).prestaciones << [Prestacion.find(701)]
PrestacionPdss.find(476).prestaciones << [Prestacion.find(702)]
PrestacionPdss.find(477).prestaciones << [Prestacion.find(703)]
PrestacionPdss.find(478)
PrestacionPdss.find(479).prestaciones << [Prestacion.find(704)]
PrestacionPdss.find(480).prestaciones << [Prestacion.find(705)]
PrestacionPdss.find(481).prestaciones << [Prestacion.find(706)]
PrestacionPdss.find(482).prestaciones << [Prestacion.find(707)]
PrestacionPdss.find(483).prestaciones << [Prestacion.find(708)]
PrestacionPdss.find(484).prestaciones << [Prestacion.find(709)]
PrestacionPdss.find(485).prestaciones << [Prestacion.find(710)]
PrestacionPdss.find(486).prestaciones << [Prestacion.find(711)]
PrestacionPdss.find(487).prestaciones << [Prestacion.find(796)]
PrestacionPdss.find(488).prestaciones << [Prestacion.find(712)]
PrestacionPdss.find(489).prestaciones << Prestacion.find([713, 797])
PrestacionPdss.find(490).prestaciones << [Prestacion.find(714)]
PrestacionPdss.find(491).prestaciones << [Prestacion.find(798)]
PrestacionPdss.find(492).prestaciones << [Prestacion.find(715)]
PrestacionPdss.find(493).prestaciones << [Prestacion.find(716)]
PrestacionPdss.find(494).prestaciones << [Prestacion.find(717)]
PrestacionPdss.find(495).prestaciones << [Prestacion.find(718)]
PrestacionPdss.find(496).prestaciones << [Prestacion.find(719)]
PrestacionPdss.find(497).prestaciones << [Prestacion.find(720)]
PrestacionPdss.find(498).prestaciones << [Prestacion.find(721)]
PrestacionPdss.find(499).prestaciones << [Prestacion.find(722)]
PrestacionPdss.find(500).prestaciones << [Prestacion.find(723)]
PrestacionPdss.find(501).prestaciones << [Prestacion.find(724)]
PrestacionPdss.find(502).prestaciones << [Prestacion.find(799)]
PrestacionPdss.find(503).prestaciones << [Prestacion.find(725)]
PrestacionPdss.find(504).prestaciones << [Prestacion.find(726)]
PrestacionPdss.find(505).prestaciones << [Prestacion.find(727)]
PrestacionPdss.find(506).prestaciones << [Prestacion.find(728)]
PrestacionPdss.find(507).prestaciones << [Prestacion.find(729)]
PrestacionPdss.find(508).prestaciones << [Prestacion.find(730)]
PrestacionPdss.find(509).prestaciones << [Prestacion.find(731)]
PrestacionPdss.find(510).prestaciones << [Prestacion.find(732)]
PrestacionPdss.find(511).prestaciones << [Prestacion.find(733)]
PrestacionPdss.find(512).prestaciones << [Prestacion.find(800)]
PrestacionPdss.find(513).prestaciones << [Prestacion.find(734)]
PrestacionPdss.find(514).prestaciones << [Prestacion.find(735)]
PrestacionPdss.find(515).prestaciones << [Prestacion.find(736)]
PrestacionPdss.find(516).prestaciones << [Prestacion.find(801)]
PrestacionPdss.find(517).prestaciones << [Prestacion.find(737)]
PrestacionPdss.find(518).prestaciones << [Prestacion.find(738)]
PrestacionPdss.find(519).prestaciones << [Prestacion.find(739)]
PrestacionPdss.find(520).prestaciones << [Prestacion.find(740)]
PrestacionPdss.find(521).prestaciones << [Prestacion.find(802)]
PrestacionPdss.find(522).prestaciones << [Prestacion.find(741)]
PrestacionPdss.find(523).prestaciones << [Prestacion.find(742)]
PrestacionPdss.find(524).prestaciones << [Prestacion.find(743)]
PrestacionPdss.find(525).prestaciones << [Prestacion.find(744)]
PrestacionPdss.find(526).prestaciones << [Prestacion.find(745)]
PrestacionPdss.find(527).prestaciones << [Prestacion.find(746)]
PrestacionPdss.find(528).prestaciones << [Prestacion.find(747)]
PrestacionPdss.find(529).prestaciones << [Prestacion.find(748)]
PrestacionPdss.find(530).prestaciones << [Prestacion.find(749)]
PrestacionPdss.find(531).prestaciones << [Prestacion.find(750)]
PrestacionPdss.find(532).prestaciones << [Prestacion.find(803)]
PrestacionPdss.find(533).prestaciones << [Prestacion.find(804)]
PrestacionPdss.find(534).prestaciones << [Prestacion.find(805)]
PrestacionPdss.find(535).prestaciones << [Prestacion.find(751)]
PrestacionPdss.find(536).prestaciones << [Prestacion.find(752)]
PrestacionPdss.find(537).prestaciones << [Prestacion.find(753)]
PrestacionPdss.find(538).prestaciones << [Prestacion.find(754)]
PrestacionPdss.find(539).prestaciones << [Prestacion.find(806)]
PrestacionPdss.find(540).prestaciones << [Prestacion.find(807)]
PrestacionPdss.find(541).prestaciones << [Prestacion.find(808)]
PrestacionPdss.find(542).prestaciones << [Prestacion.find(755)]
PrestacionPdss.find(543).prestaciones << [Prestacion.find(809)]
PrestacionPdss.find(544).prestaciones << [Prestacion.find(810)]
PrestacionPdss.find(545).prestaciones << [Prestacion.find(756)]
PrestacionPdss.find(546).prestaciones << [Prestacion.find(757)]
PrestacionPdss.find(547).prestaciones << [Prestacion.find(758)]
PrestacionPdss.find(548).prestaciones << [Prestacion.find(759)]
PrestacionPdss.find(549).prestaciones << [Prestacion.find(760)]
PrestacionPdss.find(550).prestaciones << [Prestacion.find(811)]
PrestacionPdss.find(551).prestaciones << [Prestacion.find(761)]
PrestacionPdss.find(552).prestaciones << [Prestacion.find(762)]
PrestacionPdss.find(553).prestaciones << [Prestacion.find(812)]
PrestacionPdss.find(554).prestaciones << [Prestacion.find(813)]
PrestacionPdss.find(555).prestaciones << [Prestacion.find(814)]
PrestacionPdss.find(556).prestaciones << [Prestacion.find(763)]
PrestacionPdss.find(557).prestaciones << [Prestacion.find(766)]

# Revisión general de prestaciones surgidas de la evaluación a partir de la incorporación de los modelos PDSS


# Logoaudiometría (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(:codigo => "PRP020").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find([1, 2])
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Monotest (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(:codigo => "LBL078").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Reacción de Widal (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(:codigo => "LBL096").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Receptores libres de transferrinas (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(:codigo => "LBL097").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Sangre oculta en heces (faltó definir los grupos poblacionales habilitados)
prestacion = Prestacion.where(:codigo => "LBL098").first
prestacion.sexos << Sexo.find(:all)
prestacion.grupos_poblacionales << GrupoPoblacional.find(:all)
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97") # Sin enfermedad

# Cambio la descripción del código LBL112
Prestacion.where(:id => 342, :codigo => "LBL112").first.update_attributes({:nombre => "Enzimas hepáticas: Transaminasas TGO/TGP (embarazo de alto riesgo)"})

# Falta el método de validación de "beneficiaria_embarazada?" en la prestación "Ecografía renal"
Prestacion.find(350).metodos_de_validacion << [MetodoDeValidacion.find(1)]

# Falta el método de validación de "beneficiaria_embarazada?" en la prestación "Monitoreo fetal anteparto"
Prestacion.find(351).metodos_de_validacion << [MetodoDeValidacion.find(1)]

# Cambio la descripción del código IMV008 / Añado métodos de validación faltantes
prestacion = Prestacion.where(:id => 764, :codigo => "IMV008").first
prestacion.update_attributes({:nombre => "Dosis aplicada de vacuna triple bacteriana acelular (dTpa) en el embarazo"})
CantidadDePrestacionesPorPeriodo.create!(
  {
    :prestacion_id => prestacion.id,
    :cantidad_maxima => 2,
    :periodo => "9.months",
    :intervalo => "1.month"
  }
)
prestacion.metodos_de_validacion << MetodoDeValidacion.find([1, 15])

# Traslado en unidad móvil de alta complejidad para adultos (faltó definir los grupos poblacionales habilitados y diagnósticos)
prestacion = Prestacion.where(:codigo => "TLM020").first
prestacion.sexos << [Sexo.find_by_codigo!("F")]
prestacion.grupos_poblacionales << [GrupoPoblacional.find_by_codigo("D")]
prestacion.diagnosticos << Diagnostico.find_by_codigo!("A98") # Medicina preventiva
