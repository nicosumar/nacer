# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
TipoDeProceso.create(
  [
    {
      #:id => 1,
      :nombre => "Inscripción masiva de beneficiarios",
      :codigo => "I",
      :modelo_de_datos => "NovedadDelAfiliado"
    },
    {
      #:id => 2,
      :nombre => "Registro masivo de prestaciones",
      :codigo => "P",
      :modelo_de_datos => "PrestacionBrindada"
    }
  ]
)
