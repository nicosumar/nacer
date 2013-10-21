# -*- encoding : utf-8 -*-
class MotivoDeRechazo < ActiveRecord::Base

  has_many :anexos_administrativos_prestaciones
  attr_accessible :categoria, :nombre
  
end
