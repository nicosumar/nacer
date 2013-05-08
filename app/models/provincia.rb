# -*- encoding : utf-8 -*-
class Provincia < ActiveRecord::Base
  belongs_to :paises
  has_many :departamentos

  validates_presence_of :nombre
end
