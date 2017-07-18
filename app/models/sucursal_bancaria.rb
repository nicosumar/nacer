# -*- encoding : utf-8 -*-
class SucursalBancaria < ActiveRecord::Base

  belongs_to :banco
  belongs_to :pais
  belongs_to :provincia
  belongs_to :departamento
  belongs_to :distrito
  
  attr_accessible :nombre, :numero, :observaciones
  attr_accessible :banco_id, :pais_id, :provincia_id, :departamento_id, :distrito_id

  validates :numero, uniqueness: {scope: :banco_id, message: "La sucursal ya existe para el banco seleccionado." } 

end
