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
    :nombre => "Verificar si el beneficiario tiene 5 años",
    :metodo => "mayor_de_53_meses?",
    :mensaje => "La prestación debería haberse brindado a los cinco años.",
    :genera_error => false
  },
  { #:id => 8,
    :nombre => "Verificar que el beneficiario haya declarado ser indígena",
    :metodo => "beneficiario_indigena?",
    :mensaje => "La prestación debería haberse brindado a un beneficiario o beneficiaria que haya declarado pertenecer a un pueblo originario.",
    :genera_error => false
  },
  { #:id => 9,
    :nombre => "Verificar que la beneficiaria sea menor de 50 años",
    :metodo => "beneficiaria_menor_de_50_anios?",
    :mensaje => "La prestación debería haberse brindado a una beneficiaria que sea menor de 50 años.",
    :genera_error => false
  },
  { #:id => 10,
    :nombre => "Verificar que la beneficiaria sea mayor de 24 años",
    :metodo => "beneficiaria_mayor_de_24_anios?",
    :mensaje => "La prestación debería haberse brindado a una beneficiaria que sea mayor de 24 años.",
    :genera_error => false
  },
  { #:id => 11,
    :nombre => "Verificar que la beneficiaria sea mayor de 49 años",
    :metodo => "beneficiaria_mayor_de_49_anios?",
    :mensaje => "La prestación debería haberse brindado a una beneficiaria que sea mayor de 49 años.",
    :genera_error => false
  }
])
