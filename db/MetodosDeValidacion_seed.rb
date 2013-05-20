# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
MetodoDeValidacion.create([
  { #:id => 1,
    :nombre => "Verificar que la beneficiaria estuvo embarazada",
    :metodo => "beneficiaria_embarazada?",
    :mensaje => "La prestación es para embarazadas o puérperas y la beneficiaria no posee datos de embarazo o están desactualizados",
    :genera_error => false
  },
  { #:id => 2,
    :nombre => "Verificar que la embarazada fue diagnosticada en el primer trimestre",
    :metodo => "diagnostico_de_embarazo_del_primer_trimestre?",
    :mensaje => "La prestación es para embarazadas diagnosticadas en el primer trimestre y los datos de la beneficiaria no indican la edad gestacional al diagnóstico o es posterior a las 14 semanas",
    :genera_error => false
  },
  { #:id => 3,
    :nombre => "Verificar que la tensión arterial sistólica es mayor a la diastólica",
    :metodo => "tension_arterial_valida?",
    :mensaje => "La tensión arterial sistólica no puede ser inferior a la diastólica",
    :genera_error => true
  },
  { #:id => 4,
    :nombre => "Verificar que el número de dientes con caries, perdidos y obturados no superan los 32",
    :metodo => "indice_cpod_valido?",
    :mensaje => "En el índice CPOD la suma de la cantidad de dientes cariados, perdidos y obturados no puede superar los 32",
    :genera_error => true
  },
  { #:id => 5,
    :nombre => "Verificar si el beneficiario o la beneficiaria tienen menos de 48 horas de nacidos",
    :metodo => "recien_nacido?",
    :mensaje => "La prestación debería haberse brindado dentro de las primeras 48 horas de vida.",
    :genera_error => false
  },
  { #:id => 6,
    :nombre => "Verificar si el beneficiario o la beneficiaria tienen menos de un año de vida",
    :metodo => "menor_de_un_anio?",
    :mensaje => "La prestación debería haberse brindado dentro del primer año de vida.",
    :genera_error => false
  },
  { #:id => 7,
    :nombre => "Verificar que se haya completado el detalle de los días de internación en CC y que no exceda el máximo establecido",
    :metodo => "detalle_de_la_internacion_cc_valido?",
    :mensaje => "Los campos no puede estar en blanco",
    :genera_error => true
  }
])
