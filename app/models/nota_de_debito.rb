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

end
