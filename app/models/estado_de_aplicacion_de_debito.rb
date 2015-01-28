# -*- encoding : utf-8 -*-
class EstadoDeAplicacionDeDebito < ActiveRecord::Base
  has_many :aplicaciones_de_notas_de_debito
      
  attr_accessible :codigo, :nombre
end
