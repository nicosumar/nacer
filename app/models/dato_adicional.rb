# -*- encoding : utf-8 -*-
class DatoAdicional < ActiveRecord::Base
  has_many :datos_adicionales_por_prestacion
  has_many :prestaciones, :through => :datos_adicionales_por_prestacion

  attr_accessible :nombre, :tipo_postgres, :tipo_ruby, :enumerable, :clase_para_enumeracion
end
