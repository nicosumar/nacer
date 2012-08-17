# Datos precargados al inicializar el sistema
ClaseDeDocumento.create([
        { #:id => 1,
          :nombre => "Propio",
          :codigo_para_prestaciones => "R",
          :codigo_para_inscripciones => "P" },
        { #:id => 2,
          :nombre => "Ajeno (de la madre)",
          :codigo_para_prestaciones => "M",
          :codigo_para_inscripciones => "A" },
        { #:id => 3,
          :nombre => "Ajeno (del padre)",
          :codigo_para_prestaciones => "P",
          :codigo_para_inscripciones => "A" },
        { #:id => 4,
          :nombre => "Ajeno: (del tutor/a)",
          :codigo_para_prestaciones => "T",
          :codigo_para_inscripciones => "A" }
])
