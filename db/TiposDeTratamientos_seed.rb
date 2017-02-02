# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
TipoDeTratamiento.create!(
  [
    {
      #:id => 1,
      :nombre => "Ambulatorio",
      :codigo => "A"
    },
    {
      #:id => 2,
      :nombre => "Internación",
      :codigo => "I"
    },
    {
      #:id => 3,
      :nombre => "Quirúrgico",
      :codigo => "Q"
    }
  ]
)
