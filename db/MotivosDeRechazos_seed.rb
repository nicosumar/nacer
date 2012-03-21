# Datos precargados al inicializar el sistema
MotivoDeRechazo.create([
        { #:id => 1,
          :nombre => "Baja algebraica: la cuasi-factura informa menos prestaciones que las digitalizadas." },
        { #:id => 2,
          :nombre => "Baja formal: no existe la prestación." },
        { #:id => 3,
          :nombre => "Baja formal: la prestación no está autorizada para este efector." },
        { #:id => 4,
          :nombre => "Baja formal: ..." },
        { #:id => 5,
          :nombre => "Baja técnica: falta información mínima obligatoria." }
])
