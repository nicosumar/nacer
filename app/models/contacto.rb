# -*- encoding : utf-8 -*-
class Contacto < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Seguridad de asignaciones masivas
  attr_accessible :nombres, :apellidos, :mostrado, :sexo_id, :dni, :domicilio, :email, :email_adicional
  attr_accessible :telefono, :telefono_movil, :observaciones, :tipo_de_documento_id, :firma_primera_linea
  attr_accessible :firma_segunda_linea, :firma_tercera_linea

  # Asociaciones
  belongs_to :sexo
  belongs_to :tipo_de_documento
  has_many   :consolidados_sumar

  # Validaciones
  validates_presence_of :mostrado
end
