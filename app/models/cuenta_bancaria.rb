# -*- encoding : utf-8 -*-
class CuentaBancaria < ActiveRecord::Base
  belongs_to :tipo_de_cuenta_bancaria
  belongs_to :banco
  belongs_to :sucursal_bancaria
  belongs_to :entidad
  has_many   :destinos, class_name: "MovimientoBancarioAutorizado", foreign_key: :cuenta_bancaria_destino_id
  
  attr_accessible :cuenta_contable, :denominacion, :numero, :cbu
  attr_accessible :entidad_id, :tipo_de_cuenta_bancaria_id, :banco_id, :sucursal_bancaria_id

  def nombre
  	if self.denominacion.present? 
      self.denominacion + " - Nº: "+ self.numero
  	else
      "Nº: " + self.numero
    end
  end

  def self.destinos_autorizado_para_el_concepto(concepto)
    return false unless concepto.is_a? ConceptoDeFacturacion
    destinos.where(concepto_de_facturacion_id: concepto.id)
  end
end
