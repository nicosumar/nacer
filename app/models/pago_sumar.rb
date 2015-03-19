# -*- encoding : utf-8 -*-
class PagoSumar < ActiveRecord::Base
  belongs_to :efector
  belongs_to :concepto_de_facturacion
  belongs_to :cuenta_bancaria_origen, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_origen_id'
  belongs_to :cuenta_bancaria_destino, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_destino_id'
  belongs_to :estado_del_proceso
  has_many   :expedientes_sumar
  has_many   :aplicaciones_de_notas_de_debito

  # Atributos a ser inicializados/completados deforma automatica
  attr_accessible :fecha_de_proceso, :fecha_informado_sirge, :informado_sirge, :monto
  # Fecha de proceso: Fecha en la que se inicio el proceso
  
  # Atributos a ser completados por el usuario
  attr_accessible :cuenta_bancaria_origen_id, :cuenta_bancaria_destino_id, :efector_id, :concepto_de_facturacion_id
  attr_accessible :nota_de_debito_ids, :expediente_sumar_ids
  
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

  def nota_de_debito_ids=(value_ids)
    unless value_ids.is_a? Array
      return nil 
      raise ArgumentError
    end

    value_ids.each do |id|
      if id.is_a? Fixnum
        # ver si hay una nueva o modificar
        
        self.aplicaciones_de_notas_de_debito.build(nota_de_debito_id: id)
      else
        self.aplicaciones_de_notas_de_debito.clear 
        errors.add(:aplicaciones_de_notas_de_debito, "Uno de los ids de notas de debito no es valido - ID: #{id}")
        raise ArgumentError 
      end
    end
  end

  def nota_de_debito_ids
    self.aplicaciones_de_notas_de_debito.map { |e| e.nota_de_debito_id } 
  end

  def expediente_sumar_ids=(value_ids)
    unless value_ids.is_a? Array
      return nil 
      raise ArgumentError
    end

    value_ids.reject! { |x| !(x.is_a? Fixnum)}
    # Borro los seleccionados y agrego nuevamente
    ActiveRecord::Base.transaction do 
      self.expedientes_sumar.clear
      self.expedientes_sumar << ExpedienteSumar.find(value_ids)
    end
  end

  def numero_de_proceso
    "%07d" % self.id    
  end
end