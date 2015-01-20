# -*- encoding : utf-8 -*-
class OrganismoGubernamental < ActiveRecord::Base
  
  after_create :crear_entidad

  # Asociaciones: 
  belongs_to :provincia
  belongs_to :departamento
  belongs_to :distrito
  has_one    :entidad, as: :entidad
  has_many   :cuentas_bancarias, through: :entidad
  
  attr_accessible :codigo_postal, :domicilio, :email, :nombre, :telefonos
  attr_accessible :provincia_id, :departamento_id, :distrito_id

  scope :gestionables, where(gestionable: true)

  private

  def crear_entidad
    Entidad.create({entidad: self}, :without_protection => true)
  end
  
end
