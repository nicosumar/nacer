# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
MotivoDeRechazo.create([
        { #:id => 6,
          nombre: "La prestación no se acompañó por la documentación respaldatoria requerida",
          categoria: "Administrativa" },
        { #:id => 7,
          :nombre => "La documentación respaldatoria se encuentra incompleta",
          categoria: "Administrativa"  },
        { #:id => 8,
          :nombre => "La documentación respaldatoria no se encuentra autorizada por el responsable",
          categoria: "Administrativa"  },
        { #:id => 9,
          :nombre => "Los datos de la documentación respaldatoria no condicen con los registrados",
          categoria: "Administrativa"  },
        { #:id => 10,
          :nombre => "La prestación no es elegible para su pago",
          categoria: "Administrativa"  },
        { #:id => 11,
          :nombre => "Rechazada por imprecedente",
          categoria: "Administrativa"  },
])
