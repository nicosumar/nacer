# -*- encoding : utf-8 -*-
class CuentaBancaria < ActiveRecord::Base
  belongs_to :tipo_de_cuenta_bancaria
  belongs_to :banco
  belongs_to :sucursal_bancaria
  belongs_to :entidad
  
  attr_accessible :cuenta_contable, :denominacion, :numero, :cbu
  attr_accessible :entidad_id, :tipo_de_cuenta_bancaria_id, :banco_id, :sucursal_bancaria_id

  def nombre
  	if self.denominacion.present? 
      self.denominacion + " - Nº: "+ self.numero
  	else
      "Nº: " + self.numero
    end
  end
end
