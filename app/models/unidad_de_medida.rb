# -*- encoding : utf-8 -*-
class UnidadDeMedida < ActiveRecord::Base
  validates_presence_of :nombre
end
