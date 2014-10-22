# -*- encoding : utf-8 -*-
class OrganismoGubernamental < ActiveRecord::Base
  
  # Asociaciones: 
  belongs_to :provincia
  belongs_to :departamento
  belongs_to :distrito
  has_one    :entidad
  
  attr_accessible :codigo_postal, :domicilio, :email, :nombre, :telefonos
  attr_accessible :provincia_id, :departamento_id, :distrito_id
  
end
