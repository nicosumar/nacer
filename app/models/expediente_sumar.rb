# -*- encoding : utf-8 -*-
class ExpedienteSumar < ActiveRecord::Base

  belongs_to :tipo_de_expediente
  belongs_to :efector
  belongs_to :liquidacion_sumar
  belongs_to :pago_sumar
  has_many   :liquidaciones_informes
  
  attr_accessible :numero, :tipo_de_expediente, :efector, :liquidacion_sumar, :liquidacion_sumar_id
  attr_accessible :pago_sumar_id, :pago_sumar

  validates :numero, presence: true, on: :update 

  scope :impagos, where(tipo_de_expediente_id: [1,2,3], pago_sumar_id: nil)
  
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
          
          # 1) Creo la cabecera del expediente
          exp = ExpedienteSumar.create!({ tipo_de_expediente: liquidacion_sumar.concepto_de_facturacion.tipo_de_expediente,
                                         liquidacion_sumar: liquidacion_sumar,
                                         efector: e})
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

  # 
  # Devuelve si el expediente es un expediente de pago
  # 
  def es_de_pago?
    [1,2,3].include? self.tipo_de_expediente_id
  end

  def monto_aprobado
    return 0 unless self.es_de_pago? 

      r = ActiveRecord::Base.connection.exec_query <<-SQL
        select sum(aprobado) aprobado
        FROM
        (
          select c.monto_total - (sum(CASE WHEN amp.estado_de_la_prestacion_id in(6,10, 11) THEN pl.monto ELSE 0::numeric END) + 
                      sum(CASE WHEN aap.estado_de_la_prestacion_id in(6,10, 11) THEN pl.monto ELSE 0::numeric END) ) "aprobado"
          from liquidaciones_sumar l
            join liquidaciones_sumar_cuasifacturas c on c.liquidacion_sumar_id = l.id
            join efectores e on e.id  = c.efector_id
            join liquidaciones_informes li on li.efector_id = e.id and li.liquidacion_sumar_id = l.id 
            join prestaciones_liquidadas pl ON pl.liquidacion_id = l.id and pl.efector_id = e.id 
            join expedientes_sumar es on es.id = li.expediente_sumar_id
            left join anexos_medicos_prestaciones amp ON amp.prestacion_liquidada_id = pl.id 
            left JOIN anexos_administrativos_prestaciones aap ON aap.prestacion_liquidada_id = pl.id
          where es.id = #{self.id}
          group by  es.numero, e.cuie, e.nombre,  c.monto_total 
        ) a
      SQL
      r.rows[0][0].to_f
  end

  # 
  # Devuelve los expedientes impagos por efector
  # @param efector [Efector] Efector que posee los expedientes
  # 
  # @return [ActiveRecord::Relation] Expedientes de pago, impagos para un efector dado
  def self.impagos_por_efector(efector)
    return false unless efector.is_a?(Efector)
    ExpedienteSumar.includes(:liquidaciones_informes).
                    where(efector_id: efector.id, tipo_de_expediente_id: [1,2,3]).
                    where("expedientes_sumar.pago_sumar_id is null")
  end

  # 
  # Devuelve los expedientes para un concepto de facturacion
  # @param concepto_de_facturacion [ConceptoDeFacturacion] Concepto de facturacion sobre el cual se filtra
  # 
  # @return [ActiveRecord::Relation] [description]
  def self.del_concepto_de_facturacion(concepto_de_facturacion)
    return false unless concepto_de_facturacion.is_a?(ConceptoDeFacturacion)

    expediente_a_concepto = case concepto_de_facturacion.id
      when 1 # Paquete Basico
        1 # expedientes paquete basico
      when 2..3 # PPAC
        3 # expedientes ppac 
      when 4..5  # Cardiopatias
        2 # expedientes cardiopatias
      end

    where(tipo_de_expediente_id: expediente_a_concepto)
  end
end
