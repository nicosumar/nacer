# -*- encoding : utf-8 -*-
class DatoAdicional < ActiveRecord::Base
  has_many :datos_adicionales_por_prestacion
  has_many :prestaciones, :through => :datos_adicionales_por_prestacion
end
