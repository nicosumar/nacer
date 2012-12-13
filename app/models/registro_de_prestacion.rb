# -*- encoding : utf-8 -*-
class RegistroDePrestacion < ActiveRecord::Base
  # Seguridad de asignaciones masivas
  attr_protected nil

  # Asociaciones
  belongs_to :clase_de_documento
  belongs_to :tipo_de_documento
  belongs_to :prestacion
  belongs_to :estado_de_la_prestacion
  belongs_to :motivo_de_rechazo
  belongs_to :cuasi_factura
  belongs_to :nomenclador
  belongs_to :afiliado

end
