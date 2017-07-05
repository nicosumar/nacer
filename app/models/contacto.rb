# -*- encoding : utf-8 -*-
class Contacto < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Seguridad de asignaciones masivas
  attr_accessible :nombres, :apellidos, :mostrado, :sexo_id, :dni, :domicilio, :email, :email_adicional
  attr_accessible :telefono, :telefono_movil, :observaciones, :tipo_de_documento_id, :firma_primera_linea
  attr_accessible :firma_segunda_linea, :firma_tercera_linea,:eliminado

  # Asociaciones
  belongs_to :sexo
  belongs_to :tipo_de_documento
  has_many   :consolidados_sumar
  has_many :referentes


  scope :activo, -> { where(eliminado: false) }

  # Validaciones
  validates_presence_of :mostrado, :nombres, :apellidos, :sexo_id,:dni,:email,:tipo_de_documento_id, :firma_primera_linea,:firma_segunda_linea, :firma_tercera_linea


  def can_remove?

    !(self.consolidados_sumar.exists?) 

  end


end


