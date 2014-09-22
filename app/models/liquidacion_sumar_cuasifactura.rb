# -*- encoding : utf-8 -*-
class LiquidacionSumarCuasifactura < ActiveRecord::Base
  
  belongs_to :liquidacion_sumar
  belongs_to :efector
  belongs_to :concepto_de_facturacion
  has_many :liquidaciones_sumar_cuasifacturas_detalles, foreign_key: :liquidaciones_sumar_cuasifacturas_id

  scope :para, lambda {|efector, liquidacion| where(efector_id: efector.id, liquidacion_id: liquidacion.id)}

  attr_accessible :monto_total, :numero_cuasifactura, :observaciones, :liquidacion_sumar, :efector, :liquidacion_id, :efector_id
  attr_accessible :concepto_de_facturacion, :concepto_de_facturacion_id
  attr_accessible :cuasifactura_escaneada

  validates :concepto_de_facturacion, presence: true
  validates :numero_cuasifactura, presence: true, on: :update 
  validates :cuasifactura_escaneada, presence: true, on: :update 

  has_attached_file :cuasifactura_escaneada, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :cuasifactura_escaneada, :content_type => /\Aimage\/.*\Z/
    
  # 
  # Genera las cuasifacturas desde una liquidación dada
  # @param  liquidacion_sumar [LiquidacionSumar] Liquidacion desde la cual debe generar las cuasifacturas
  # @param  documento_generable [DocumentoGenerablePorConcepto] Especificación de la generación del documento
  # 
  # @return [Boolean] confirmación de la generación de las cuasifacturas
  def self.generar_desde_liquidacion!(liquidacion_sumar, documento_generable)

    return false if not (liquidacion_sumar.is_a?(LiquidacionSumar) and documento_generable.is_a?(DocumentoGenerablePorConcepto) )
      
    return false  if LiquidacionSumarCuasifactura.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0 # devuelve falso si ya se generaron las cuasifacturas de esta liquidación

    ActiveRecord::Base.transaction do
      begin
        documento_generable.tipo_de_agrupacion.iterar_efectores_y_prestaciones_de(liquidacion_sumar) do |e, pliquidadas |

          # 1) Creo la cabecera de la cuasifactura
          total_cuasifactura = pliquidadas.sum(:monto)
          
          # Si el monto de la cuasi es cero, sigo con el prox efector
          next if total_cuasifactura == 0
          
          cuasifactura = LiquidacionSumarCuasifactura.create!( liquidacion_sumar: liquidacion_sumar, 
                                                              efector: e, 
                                                              monto_total: total_cuasifactura, 
                                                              concepto_de_facturacion: liquidacion_sumar.concepto_de_facturacion)
          
          # 2) Obtengo el numero de cuasifactura si corresponde para este tipo de documento
          cuasifactura.numero_cuasifactura = documento_generable.obtener_numeracion(cuasifactura.id)
          cuasifactura.save!(validate: false)

          # 3) Creo el detalle para esta cuasifactura
          ActiveRecord::Base.connection.execute "--Creo el detalle para esta cuasifactura\n"+
            "INSERT INTO public.liquidaciones_sumar_cuasifacturas_detalles  \n"+
             "(liquidaciones_sumar_cuasifacturas_id, prestacion_incluida_id, estado_de_la_prestacion_id, monto, prestacion_liquidada_id, observaciones, created_at, updated_at)  \n"+
             pliquidadas.select(["#{cuasifactura.id}", :prestacion_incluida_id, :estado_de_la_prestacion_liquidada_id, :monto, :id, :observaciones, "now() as created_at", "now() as updated_at"]).to_sql

        end # end itera segun agrupacion
        logger.warn  "Se generaron las cuasifacturas"
      rescue Exception => e
        raise "Ocurrio un problema: #{e.message}"
        return false
      end #en begin/rescue
    end #End active base transaction
    return true
  end

end
