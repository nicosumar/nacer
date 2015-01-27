# -*- encoding : utf-8 -*-
class NotaDeDebito < ActiveRecord::Base
  belongs_to :efector
  belongs_to :concepto_de_facturacion
  belongs_to :tipo_de_nota_debito
  has_many   :aplicaciones_de_notas_de_debito
  
  attr_accessible :monto, :numero, :observaciones, :remanente, :reservado
  attr_accessible :efector_id, :concepto_de_facturacion_id, :tipo_de_nota_debito_id 

  validates :monto, presence: true
  validates :observaciones, presence: true

  def disponible_para_aplicacion
    self.remanente - self.reservado
  end

  # 
  # Genera una nota de debito desde un informe de debito prestacional
  # @param arg_InformeDeDebito InformeDebitoPrestacional 
  # 
  # @return [NotaDeDebito] [Nota de debito creada]
  def self.nueva_desde_informe(arg_InformeDeDebito)

  	if arg_InformeDeDebito.class != InformeDebitoPrestacional
  		return false
  	end

  	NotaDeDebito.create([
          { 
            efector_id: arg_InformeDeDebito.efector.id ,
            concepto_de_facturacion_id: arg_InformeDeDebito.concepto_de_facturacion.id,
            tipo_de_nota_debito_id: 1, #Debito prestacional
            observaciones: "Generado a partir del informe de debito N° #{arg_InformeDeDebito.id}" ,
            monto: (InformeDebitoPrestacional.joins(detalles_de_debitos_prestacionales: :prestacion_liquidada ).where(id: arg_InformeDeDebito.id).sum(:monto) ).to_f
          }
        ])
  end

  def self.disponibles_para_aplicacion
    where("notas_de_debito.remanente - notas_de_debito.reservado > 0")
  end

  # 
  # Devuelve las notas de credito disponibles para un efector. 
  # Si el efector es administrador, incluye las ND disponibles para sus administrados
  # @param efector [Efector] Efector por el cual realizar el filtro
  # @param incluir_administrados = false [Boolean] [Indica si incluye o no las nd de sus administrados]
  # 
  # @return [type] [description]
  def self.por_efector(efector, incluir_administrados = false)
    return false unless efector.is_a?(Efector)
    efectores = []
    
    if incluir_administrados and efector.es_administrador? 
      efectores = efector.efectores_administrados.map { |e| e.id }
      efectores << efector.id
    else
      efectores << efector.id
    end
    return where(efector_id: efectores)
  end # end por_efector

end
