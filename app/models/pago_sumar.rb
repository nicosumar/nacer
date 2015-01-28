# -*- encoding : utf-8 -*-
class PagoSumar < ActiveRecord::Base
  belongs_to :efector
  belongs_to :concepto_de_facturacion
  belongs_to :cuenta_bancaria_origen, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_origen_id'
  belongs_to :cuenta_bancaria_destino, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_origen_id'
  belongs_to :estado_del_proceso
  has_many   :expedientes_sumar
  has_many   :aplicaciones_de_notas_de_debito

  # Atributos a ser inicializados/completados deforma automatica
  attr_accessible :fecha_de_proceso, :fecha_informado_sirge, :informado_sirge, :monto
  # Atributos a ser completados por el usuario
  attr_accessible :cuenta_bancaria_origen_id, :cuenta_bancaria_destino_id, :efector_id, :concepto_de_facturacion_id
  # Atributos solo actualizable luego de ser creado
  attr_accessible :notificado, :fecha_de_notificacion

  accepts_nested_attributes_for :expedientes_sumar
  attr_accessible :expedientes_sumar_attributes

  accepts_nested_attributes_for :aplicaciones_de_notas_de_debito
  attr_accessible :aplicaciones_de_notas_de_debito_attributes  

  after_initialize :init
  before_create :calcular_monto_a_pagar


  def init
    # o el valor de la base, o q busque el estado 2
    self.estado_del_proceso ||= EstadoDelProceso.find(2) # "En Curso"
    self.fecha_de_proceso ||= Date.today
  end

  def calcular_monto_a_pagar
    total_aprobado = 0.0
    total_de_debitos = 0.0
    
    self.expedientes_sumar.each do |exp|
      total_aprobado = exp.monto_aprobado
    end

    total_de_debitos = self.aplicaciones_de_notas_de_debito.sum(:monto)
    self.monto = total_aprobado - total_de_debitos

  end


end