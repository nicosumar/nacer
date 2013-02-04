# -*- encoding : utf-8 -*-
class TipoDePrestacion < ActiveRecord::Base
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre

  # Asociaciones
end
