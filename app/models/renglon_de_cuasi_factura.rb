# -*- encoding : utf-8 -*-
class RenglonDeCuasiFactura < ActiveRecord::Base
  # Seguridad de asignaciones múltiples
  attr_protected nil

  # Asociaciones
  belongs_to :cuasi_factura
  belongs_to :prestacion

  # Validaciones
  validates_presence_of :cuasi_factura_id

end
