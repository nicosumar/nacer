# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
EstadoSolicitudAddenda.create([
  { #:id => 1,
    :nombre => "Registrada",
    :codigo => "R",
    :pendiente => false,
    :indexable => false },
  { #:id => 2,
    :nombre => "En Revision Tecnica",
    :codigo => "RT",
    :pendiente => false,
    :indexable => false },
  { #:id => 3,
    :nombre => "Enviada al efector",
    :codigo => "EF",
    :pendiente => false,
    :indexable => false },
  { #:id => 4,
    :nombre => "En Revision Legal",
    :codigo => "RL",
    :pendiente => false,
    :indexable => false },
  { #:id => 5,
    :nombre => "Aprobada",
    :codigo => "AP",
    :pendiente => false,
    :indexable => false },
  { #:id => 6,
    :nombre => "Anulada por efector",
    :codigo => "AE",
    :pendiente => false,
    :indexable => false },
  { #:id => 7,
    :nombre => "Anulada por Técnica",
    :codigo => "AT",
    :pendiente => false,
    :indexable => false }
])


#INSERT INTO estados_solicitudes_addendas(
#             nombre, codigo, pendiente, indexable)
#    VALUES 
#
#    ( 'Registrada', 'R', 't', 't'),
#    ( 'Revision Tecnica', 'RT', 't', 't'),
#    ( 'Enviada al efector', 'EF', 't', 't'),
#    ( 'En Revision Legal', 'RL', 't', 't'),
#    ( 'Aprobada', 'AP', 't', 't'),
#    ( 'Anulada por efector', 'AT', 't', 't'),
#    ( 'Anulada por Técnica', 'AE', 't', 't')
#
#    ;
