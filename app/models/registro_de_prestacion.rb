# -*- encoding : utf-8 -*-
class RegistroDePrestacion < ActiveRecord::Base
  # Seguridad de asignaciones masivas
  attr_accessible :fecha_de_prestacion, :apellido, :nombre, :clase_de_documento_id, :tipo_de_documento_id, :numero_de_documento
  attr_accessible :codigo_de_prestacion_informado, :prestacion_id, :cantidad, :historia_clinica, :estado_de_la_prestacion_id
  attr_accessible :motivo_de_rechazo_id, :cuasi_factura_id, :nomenclador_id, :afiliado_id, :observaciones

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
