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
  }
])
