# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
TipoDeDocumento.create(
  [
    {
      #:id => 1,
      :nombre => "Documento nacional de identidad",
      :codigo => "DNI"
    },
    {
      #:id => 2,
      :nombre => "Libreta de enrolamiento",
      :codigo => "LE"
    },
    {
      #:id => 3,
      :nombre => "Libreta cívica",
      :codigo => "LC"
    },
    {
      #:id => 4,
      :nombre => "Cédula de identidad",
      :codigo => "CI"
    },
    {
      #:id => 5,
      :nombre => "Pasaporte argentino",
      :codigo => "PAS"
    },
    # Añadidos para la versión 4.7 del sistema de gestión
    {
      #:id => 6,
      :nombre => "Certificado migratorio",
      :codigo => "CM"
    },
    {
      #:id => 7,
      :nombre => "Otro",
      :codigo => "OTRO"
    }
  ]
)
