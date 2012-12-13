# -*- encoding : utf-8 -*-
class RegistroDeDatoAdicional < ActiveRecord::Base
  belongs_to :registro_de_prestacion
  belongs_to :dato_adicional

  validates_presence_of :registro_de_prestacion_id, :dato_adicional_id, :valor

end
