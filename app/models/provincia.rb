# -*- encoding : utf-8 -*-
class Provincia < ActiveRecord::Base
  
  #relaciones
  belongs_to :pais
  has_many :departamentos
  has_many :efectores
  has_many :sucursales_bancarias

  #atributos
  attr_accessible :nombre, :provincia_bio_id, :pais_id

  #validaciones 
  validates_presence_of :nombre
  

end
