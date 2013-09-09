class LiquidacionSumar < ActiveRecord::Base
  belongs_to :grupo_de_efectores_liquidacion
  belongs_to :concepto_de_facturacion
  belongs_to :periodo
  belongs_to :plantilla_de_reglas
  belongs_to :parametro_liquidacion_sumar


  attr_accessible :descripcion, :grupo_de_efectores_liquidacion_id, :concepto_de_facturacion_id, :periodo_id, :plantilla_de_reglas_id, :parametro_liquidacion_sumar_id

  validates_presence_of :descripcion, :grupo_de_efectores_liquidacion, :concepto_de_facturacion, :periodo, :parametro_liquidacion_sumar_id
  
  private 

  def generar_prestaciones_incluidas

  	#Traigo Grupo de efectores y nomenclador
  	efectores =  self.grupo_de_efectores_liquidacion.efectores
    nomenclador = self.parametro_liquidacion_sumar.nomenclador
    vigencia_perstaciones = self.parametro_liquidacion_sumar.dias_de_prestacion
    
  	#nomenclador 


  end

end
