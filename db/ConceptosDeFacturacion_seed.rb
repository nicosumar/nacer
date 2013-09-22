# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
ConceptoDeFacturacion.create!(
  [
    {
      #:id => 1,
      :concepto => "Paquete básico",
      :codigo => "BAS",
      :descripcion => "Prestaciones de baja y mediana complejidad, para centros de atención primaria de la salud."
    },
    {
      #:id => 2,
      :concepto => "Paquete perinatal de alta complejidad, módulos no catastróficos",
      :codigo => "PPN",
      :descripcion => "Prestaciones de alta complejidad obstétrica y neonatal, para establecimientos de nivel IIIa. Prestaciones financiadas por el SPS."
    },
    {
      #:id => 3,
      :concepto => "Paquete perinatal de alta complejidad, módulos catastróficos",
      :codigo => "PPC",
      :descripcion => "Prestaciones de alta complejidad obstétrica y neonatal, para establecimientos de nivel IIIb. Prestaciones financiadas por el FRS."
    },
    {
      #:id => 4,
      :concepto => "Cirugía en cardiopatías congénitas, módulos no catastróficos",
      :codigo => "CCN",
      :descripcion => "Cirugías de cardiopatías congénitas de baja y mediana complejidad, para establecimientos de nivel IIIb. Prestaciones financiadas por el SPS."
    },
    {
      #:id => 5,
      :concepto => "Cirugía en cardiopatías congénitas, módulos catastróficos",
      :codigo => "CCC",
      :descripcion => "Cirugías de cardiopatías congénitas de alta complejidad, para establecimientos de nivel IIIb. Prestaciones financiadas por el FRS."
    }
  ]
)
