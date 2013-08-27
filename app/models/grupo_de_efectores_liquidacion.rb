# -*- encoding : utf-8 -*-
class GrupoDeEfectoresLiquidacion < ActiveRecord::Base
  has_many :efectores
  attr_accessible :descripcion, :grupo
end
