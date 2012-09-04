# Datos precargados al inicializar el sistema
TipoDeDocumento.create([
        { #:id => 1,
          :nombre => "Documento nacional de identidad",
          :codigo => "DNI" },
        { #:id => 2,
          :nombre => "Libreta de enrolamiento",
          :codigo => "LE" },
        { #:id => 3,
          :nombre => "Libreta cívica",
          :codigo => "LC" },
        { #:id => 4,
          :nombre => "CI de la Policía Federal",
          :codigo => "PF" },
        { #:id => 5,
          :nombre => "CI de la Provincia de Mendoza",  # Otras provincias deberían cambiar por el código suyo
          :codigo => "C09" },
        { #:id => 6,
          :nombre => "Pasaporte argentino",
          :codigo => "PAS" },
        { #:id => 7,
          :nombre => "Otro",
          :codigo => "OTRO" }
])
