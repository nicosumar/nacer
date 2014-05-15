# -*- encoding : utf-8 -*-
class LiquidacionSumarCuasifactura < ActiveRecord::Base
  
  belongs_to :liquidacion_sumar
  belongs_to :efector
  has_one :expediente_sumar

  scope :para, lambda {|efector, liquidacion| where(efector_id: efector.id, liquidacion_id: liquidacion.id)}

  attr_accessible :monto_total, :numero_cuasifactura, :observaciones

  # 
  # Genera las cuasifacturas desde una liquidación dada
  # @param  liquidacion_sumar [LiquidacionSumar] Liquidacion desde la cual debe generar las cuasifacturas
  # 
  # @return [Boolean] confirmación de la generación de las cuasifacturas
  def self.generar_desde_liquidacion(liquidacion_sumar, agrupacion)

    if not (liquidacion_sumar.is_a?(LiquidacionSumar) and agrupacion.is_a?(TipoDeAgrupacion) )
      return false
    end

    cabeceras = []
    detalles = []
    ActiveRecord::Base.transaction do
      agrupacion.iterar_efectores_y_prestaciones_de(liquidacion_sumar) do |e, p, cabecera |
        if cabecera 
          #"INSERT INTO public.liquidaciones_sumar_cuasifacturas  \n"+
          #"(liquidacion_sumar_id, efector_id, created_at, updated_at)
          cabeceras.push "(#{liquidacion_sumar.id}, #{e.id}, now(), now())"
        end
        #"INSERT INTO public.liquidaciones_sumar_cuasifacturas_detalles  \n"+
        # "(liquidaciones_sumar_cuasifacturas_id, prestacion_incluida_id, estado_de_la_prestacion_id, monto, prestacion_liquidada_id, observaciones, created_at, updated_at)  \n"+
        detalles.push "(#{liquidacion_sumar.id})"

      end
    end
    



    documento_generable = liquidacion_sumar.concepto_de_facturacion
                                           .documentos_generables_por_conceptos
                                           .where(documento_generable_id: DocumentoGenerable.where(modelo: self.class.to_s).first.id)

    

    ActiveRecord::Base.transaction do

      estado_rechazada = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_rechazada.id
      estado_aceptada  = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_aceptada.id

      # 1) Genero las cabeceras
      cq = CustomQuery.ejecutar ({
        sql:  "INSERT INTO public.liquidaciones_sumar_cuasifacturas  \n"+
              "(liquidacion_sumar_id, efector_id, monto_total, created_at, updated_at)  \n"+
              "select liquidacion_id, efector_id, sum(monto), now(), now() \n"+
              "from prestaciones_liquidadas \n"+
              "where liquidacion_id = #{self.id} \n"+
              "and   estado_de_la_prestacion_liquidada_id != #{estado_rechazada} \n"+
              "group by liquidacion_id, efector_id"
                    })
      if cq
        logger.warn ("Tabla de cuasifacturas generada")
      else
        logger.warn ("Tabla de cuasifacturas NO generada")
        return false
      end

      # 2) Insertar las que tienen advertencias salvadas por una regla con su observacion -- id 5: Aprobada para liquidación
      cq = CustomQuery.ejecutar ({
        sql:  "INSERT INTO public.liquidaciones_sumar_cuasifacturas_detalles  \n"+
              "(liquidaciones_sumar_cuasifacturas_id, prestacion_incluida_id, estado_de_la_prestacion_id, monto, prestacion_liquidada_id, observaciones, created_at, updated_at)  \n"+
              "select lsc.id , p.prestacion_incluida_id, p.estado_de_la_prestacion_liquidada_id, p.monto, p.id, 
               'Observaciones de la prestacion: ' ||p.observaciones || '\\n Observaciones de liquidacion: '|| p.observaciones_liquidacion
                , now(),now() \n"+
              "from prestaciones_liquidadas p \n"+
              " join liquidaciones_sumar_cuasifacturas lsc on (lsc.liquidacion_sumar_id = p.liquidacion_id and lsc.efector_id = p.efector_id ) \n"+
              "where p.liquidacion_id = #{self.id} \n"+
              "and   p.estado_de_la_prestacion_liquidada_id != #{estado_rechazada}"
        })

      if cq
        logger.warn ("Tabla de detalle de cuasifacturas generada")
      else
        logger.warn ("Tabla de detalle de cuasifacturas NO generada")
        return false
      end
    end
  end
end
