class ExpedienteSumar < ActiveRecord::Base

  belongs_to :tipo_de_expediente
  belongs_to :efector
  belongs_to :periodo
  belongs_to :liquidacion_sumar_cuasifactura
  belongs_to :consolidado_sumar
  belongs_to :liquidacion_sumar

  attr_accessible :numero, :tipo_de_expediente, :efector, :periodo, :liquidacion_sumar_cuasifactura, :consolidado_sumar, :liquidacion_sumar

  def self.generar_expedientes_desde_liquidacion(arg_LiquidacionSumar)
  	if arg_LiquidacionSumar.class != LiquidacionSumar
  		raise "ERROR: El argumento debe ser de tipo: LiquidacionSumar"
  		return nil
  	end

  	# Los informes que no tienen expedientes, se les generan
    li = LiquidacionInforme.where(liquidacion_sumar_id: arg_LiquidacionSumar.id).includes(:liquidacion_sumar, :efector)
    tipo = TipoDeExpediente.find(1)
    li.each do |l|
      ex = ExpedienteSumar.where( liquidacion_sumar_id: l.liquidacion_sumar.id, 
                                  tipo_de_expediente_id: 1,
                                  efector_id: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar.id : l.efector.id)
      if ex.size == 0
        e = ExpedienteSumar.create({  tipo_de_expediente: tipo,
                                      liquidacion_sumar: l.liquidacion_sumar,
                                      efector: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar : l.efector,
                                      periodo: l.liquidacion_sumar.periodo,
                                      liquidacion_sumar_cuasifactura: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar.cuasifactura_de_periodo(l.liquidacion_sumar.periodo)
                                                                                                       : l.efector.cuasifactura_de_periodo(l.liquidacion_sumar.periodo),
                                      consolidado_sumar: l.efector.administrador_sumar.present? ? l.efector.administrador_sumar.consolidado_de_periodo(l.liquidacion_sumar.periodo) : nil
          })
        e.save
        l.expediente_sumar = e
        l.save
      elsif ex.size > 0
        l.expediente_sumar = ex.first
        l.save
      end
    end
    return true
  end

end
