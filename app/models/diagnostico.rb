# -*- encoding : utf-8 -*-
class Diagnostico < ActiveRecord::Base
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre

end
