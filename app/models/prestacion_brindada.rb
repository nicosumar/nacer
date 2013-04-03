# -*- encoding : utf-8 -*-
class PrestacionBrindada < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Advertencias generadas por las validaciones
  attr_accessor :advertencias

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :cantidad_de_unidades, :clave_de_beneficiario, :cuasi_factura_id, :diagnostico_id, :efector_id
  attr_accessible :estado_de_la_prestacion_id, :fecha_de_la_prestacion, :fecha_del_debito, :mensaje_de_la_baja
  attr_accessible :monto_facturado, :monto_liquidado, :nomenclador_id, :observaciones, :prestacion_id

  # Asociaciones
  belongs_to :cuasi_factura
  belongs_to :diagnostico
  belongs_to :efector
  belongs_to :estado_de_la_prestacion
  belongs_to :nomenclador
  belongs_to :prestacion
  has_many :datos_adicionales_asociados
  has_many :datos_adicionales_utilizados, :class_name => "DatoAdicional", :through => :datos_adicionales_asociados
  has_many :datos_adicionales_definidos, :class_name => "DatoAdicional", :through => :prestacion

  # Validaciones
  validates_presence_of :clave_de_beneficiario, :efector_id, :estado_de_la_prestacion_id, :fecha_de_la_prestacion
  validates_presence_of :prestacion_id

  # Objeto para guardar las advertencias
  @advertencias

  #
  # self.con_estado
  # Devuelve los registros filtrados de acuerdo con el ID de estado pasado como parámetro
  def self.con_estado(id_de_estado)
    where(:estado_de_la_prestacion_id => id_de_estado)
  end

  #
  # pendiente?
  # Indica si la prestación brindada está pendiente (aún no ha sido facturada ni anulada).
  def pendiente?
    estado_de_la_prestacion && estado_de_la_prestacion.pendiente
  end

end
