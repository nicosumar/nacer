class ExpedienteSumar < ActiveRecord::Base

  belongs_to :tipo_de_expediente
  belongs_to :efector
  belongs_to :liquidacion_sumar
  
  attr_accessible :numero, :tipo_de_expediente, :efector, :liquidacion_sumar, :liquidacion_sumar_id

  validates :numero, presence: true, on: :update 

  # 
  # Genera los expedientes para los efectores de una liquidación dada
  # @param  liquidacion_sumar [LiquidacionSumar] Liquidacion desde la cual debe generar las cuasifacturas
  # @param  documento_generable [DocumentoGenerablePorConcepto] Especificación de la generación del documento
  # 
  # @return [Boolean] confirmación de la generación de las cuasifacturas
  def self.generar_desde_liquidacion!(liquidacion_sumar, documento_generable)

    return false if not (liquidacion_sumar.is_a?(LiquidacionSumar) and documento_generable.is_a?(DocumentoGenerablePorConcepto) )
      
    ActiveRecord::Base.transaction do
      begin
        documento_generable.tipo_de_agrupacion.iterar_efectores_y_prestaciones_de(liquidacion_sumar) do |e, pliquidadas|

          # Si el efector administrador no posee prestaciones para liquidar, lo omito
          next if pliquidadas.sum(:monto) == 0

          logger.warn "LOG INFO - LIQUIDACION_SUMAR: Creando cuasifactura para efector #{e.nombre} - Liquidacion #{liquidacion_sumar.id} "
          
          # 1) Creo la cabecera del expediente
          exp = ExpedienteSumar.where({ tipo_de_expediente_id: liquidacion_sumar.concepto_de_facturacion.tipo_de_expediente,
                                         liquidacion_sumar_id: liquidacion_sumar,
                                         efector_id: e}).first
          if exp.blank?
            exp = ExpedienteSumar.create({ tipo_de_expediente: liquidacion_sumar.concepto_de_facturacion.tipo_de_expediente,
                                           liquidacion_sumar: liquidacion_sumar,
                                           efector: e})
          end
          exp.numero = documento_generable.obtener_numeracion(exp.id)
          exp.save!(validate: false)
        end # end itera segun agrupacion
      rescue Exception => e
        raise "Ocurrio un problema: #{e.message}"
        return false
      end #en begin/rescue
    end #End active base transaction
    return true
  end

end
