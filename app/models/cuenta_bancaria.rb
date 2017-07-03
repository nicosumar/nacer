# -*- encoding : utf-8 -*-
class CuentaBancaria < ActiveRecord::Base
  belongs_to :tipo_de_cuenta_bancaria
  belongs_to :banco
  belongs_to :sucursal_bancaria
  belongs_to :entidad
  has_many   :destinos, class_name: "MovimientoBancarioAutorizado", foreign_key: :cuenta_bancaria_destino_id
  has_many   :origenes, class_name: "MovimientoBancarioAutorizado", foreign_key: :cuenta_bancaria_origen_id
  has_many   :pagos_sumar_recibidos, class_name: "PagoSumar", foreign_key: :cuenta_bancaria_destino_id
  has_many   :pagos_sumar_enviados, class_name: "PagoSumar", foreign_key: :cuenta_bancaria_origen_id
  
  attr_accessible :cuenta_contable, :denominacion, :numero, :cbu
  attr_accessible :entidad_id, :tipo_de_cuenta_bancaria_id, :banco_id, :sucursal_bancaria_id

  def nombre
  	if self.denominacion.present? 
      self.denominacion + " - Nº: "+ self.numero
  	else
      "Nº: " + self.numero
    end
  end

  # 
  # Devuelve las cuentas bancarias destino de fondos para un concepto de facturacion
  # @param concepto [ConceptoDeFacturacion] Concepto de facturacion para el cual existen cuentas permeables de recibir fondos
  # 
  # @return [ActiveRecord::Relation] CuentaBancaria
  def self.destinos_autorizado_para_el_concepto(concepto)
    return false unless concepto.is_a? ConceptoDeFacturacion
    joins(:destinos).where("movimientos_bancarios_autorizados.concepto_de_facturacion_id = ? ",concepto.id)
    
  end

  # 
  # Devuelve las cuentas bancarias destino de fondos para una cuenta bancaria origen
  # @param cuenta_bancaria [CuentaBancaria] Cuenta bancaria origen de fondos
  # 
  # @return [ActiveRecord::Relation] CuentaBancaria
  def self.destinos_autorizados_desde_cuenta(cuenta_bancaria)
    return false unless cuenta_bancaria.is_a? CuentaBancaria
    joins(:destinos).
    where("movimientos_bancarios_autorizados.cuenta_bancaria_origen_id = ?", cuenta_bancaria.id)
  end

  # 
  # Devuelve las cuentas bancarias destino de fondos pertenecientes a una entidad dada
  # @param entidad [Entidad] Entidad receptora de fondos
  # 
  # @return [ActiveRecord::Relation] CuentaBancaria
  def self.destino_autorizadas_para(entidad)
    return false unless entidad.is_a? Entidad
    joins(:destinos).
    where(["movimientos_bancarios_autorizados.cuenta_bancaria_destino_id in (?)", entidad.cuenta_bancaria_ids  ])
  end

end
