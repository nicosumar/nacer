class LiquidacionInforme < ActiveRecord::Base
  
  belongs_to :liquidacion_sumar
  belongs_to :liquidacion_sumar_cuasifactura
  belongs_to :liquidacion_sumar_anexo_administrativo
  belongs_to :liquidacion_sumar_anexo_medico
  belongs_to :estado_del_proceso
  belongs_to :efector
  
  attr_accessible :numero_de_expediente, :observaciones

  validates_presence_of :numero_de_expediente

  # Genera los informes de liquidacion por cada cuasifactura generada en la liquidacion dada
  def self.generar_informes_de_liquidacion(arg_liquidacion_sumar)
  	cq = CustomQuery.ejecutar(
    {
      sql:  "INSERT INTO \"public\".\"liquidaciones_informes\" \n"+
            "( \"efector_id\", \"liquidacion_sumar_id\", \"liquidacion_sumar_cuasifactura_id\", \"estado_del_proceso_id\", \"created_at\", \"updated_at\") \n"+
            "SELECT\n"+
            " lc.efector_id, ls.id liquidacion_sumar_id, lc.id iquidacion_sumar_cuasifactura_id, ( SELECT ID FROM estados_de_los_procesos WHERE codigo = 'N'  ) estado_del_proceso_id,  now(),  now()\n"+
            "FROM\n"+
            " liquidaciones_sumar ls\n"+
            "JOIN liquidaciones_sumar_cuasifacturas lc ON lc.liquidacion_sumar_id = ls.ID\n"+
            "JOIN grupos_de_efectores_liquidaciones g ON g.id = ls.grupo_de_efectores_liquidacion_id\n"+
            "JOIN efectores e ON e.grupo_de_efectores_liquidacion_id = g.id AND lc.efector_id = e.ID\n"+
            "where ls.id = #{arg_liquidacion_sumar.id}"
      })
    return cq
  end

  def self.cerrar_informe
    # Buscar las prestaciones que son comunes a ambos anexos (medico y administrativo)
    # (en ralidad son solo las mencionadas en el anexo administrativo)

    # Las comparo, si una tiene estado de rechazo en algun anexo , dejo ese estado

    # Actualizo el estado a la brindada y a la liquidada
    
  end
end
