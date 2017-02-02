# -*- encoding : utf-8 -*-
class MotivoDeRechazo < ActiveRecord::Base

  has_many :anexos_administrativos_prestaciones
  has_many :detalle_de_debito_prestacional
  attr_accessible :categoria, :nombre, :detalle_de_debito_prestacional
  
end
