# Datos precargados al inicializar el sistema
ClaseDeDocumento.create([
        { #:id => 1,
          :nombre => "Propio",
          :codigo_para_prestaciones => "R",
          :codigo_para_inscripciones => "P" },
        { #:id => 2,
          :nombre => "Ajeno: Documento de la madre",
          :codigo_para_prestaciones => "M",
          :codigo_para_inscripciones => "A" },
        { #:id => 3,
          :nombre => "Ajeno: Documento del padre",
          :codigo_para_prestaciones => "P",
          :codigo_para_inscripciones => "A" },
        { #:id => 4,
          :nombre => "Ajeno: Documento del tutor legal",
          :codigo_para_prestaciones => "T",
          :codigo_para_inscripciones => "A" }
])
