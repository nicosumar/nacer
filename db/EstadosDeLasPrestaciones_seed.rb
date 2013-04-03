# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
EstadoDeLaPrestacion.create([
  { #:id => 1,
    :nombre => "Registrada, pero incompleta",
    :codigo => "I",
    :pendiente => true,
    :indexable => true },
  { #:id => 2,
    :nombre => "Registrada, pero faltan atributos",
    :codigo => "F",
    :pendiente => true,
    :indexable => true },
  { #:id => 3,
    :nombre => "Registrada, aún no se ha facturado",
    :codigo => "R",
    :pendiente => true,
    :indexable => true },
  { #:id => 4,
    :nombre => "Facturada, en proceso de liquidación",
    :codigo => "P",
    :pendiente => false,
    :indexable => true },
  { #:id => 5,
    :nombre => "Aprobada y liquidada",
    :codigo => "L",
    :pendiente => false,
    :indexable => false },
  { #:id => 6,
    :nombre => "Rechazada por la UGSP",
    :codigo => "Z",
    :pendiente => false,
    :indexable => false },
  { #:id => 7,
    :nombre => "Debitada por auditoría interna",
    :codigo => "D",
    :pendiente => false,
    :indexable => false },
  { #:id => 8,
    :nombre => "Debitada por auditoría externa",
    :codigo => "X",
    :pendiente => false,
    :indexable => false },
  { #:id => 9,
    :nombre => "Anulada por el usuario",
    :codigo => "U",
    :pendiente => false,
    :indexable => false },
  { #:id => 10,
    :nombre => "Anulada por el sistema",
    :codigo => "S",
    :pendiente => false,
    :indexable => false }
])
