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

    if arg_liquidacion_sumar.class == LiquidacionSumar 
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
  end

  def cerrar
    # Buscar las prestaciones que son comunes a ambos anexos (medico y administrativo)
    # (en realidad son solo las mencionadas en el anexo administrativo)
    # Las comparo, si una tiene estado de rechazo en algun anexo , dejo ese estado
    # 
    # El query toma como idea que el id del estado de la prestacion, mientras es mayor, el motivo de rechazo es mas negativo

    # Actualizo el estado a la liquidada y de ahi la brindada
    
    estado_finalizado = EstadoDelProceso.find(3) 
    cq = false
    
    if self.liquidacion_sumar_anexo_administrativo.estado_del_proceso.id == estado_finalizado.id and self.liquidacion_sumar_anexo_medico.estado_del_proceso.id == estado_finalizado.id 

      ActiveRecord::Base.transaction do
        cq = CustomQuery.ejecutar(
        {
          sql:  "UPDATE prestaciones_liquidadas\n"+
                "SET estado_de_la_prestacion_liquidada_id = CASE\n"+
                " WHEN aap.estado_de_la_prestacion_id > amp.estado_de_la_prestacion_id THEN aap.estado_de_la_prestacion_id\n"+
                " WHEN aap.estado_de_la_prestacion_id < amp.estado_de_la_prestacion_id THEN amp.estado_de_la_prestacion_id\n"+
                " WHEN aap.estado_de_la_prestacion_id IS NULL THEN  amp.estado_de_la_prestacion_id\n"+
                " ELSE  aap.estado_de_la_prestacion_id\n"+
                "END\n"+
                "FROM  liquidaciones_informes li\n"+
                " JOIN anexos_medicos_prestaciones amp ON amp.liquidacion_sumar_anexo_medico_id = li.liquidacion_sumar_anexo_medico_id\n"+
                "LEFT JOIN anexos_administrativos_prestaciones aap ON amp.prestacion_liquidada_id = aap.prestacion_liquidada_id\n"+
                "WHERE prestaciones_liquidadas.id = amp.prestacion_liquidada_id \n"+
                "AND li.id = #{self.id}"
        })

        esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: self.efector.id))
        cq = CustomQuery.ejecutar ({
          esquemas: esquemas,
          sql:  "UPDATE prestaciones_brindadas \n "+
                "   SET estado_de_la_prestacion_id = p.estado_de_la_prestacion_liquidada_id \n "+
                "FROM prestaciones_liquidadas p \n "+
                " JOIN anexos_medicos_prestaciones amp on amp.prestacion_liquidada_id = p.id "
                "WHERE p.efector_id in (select ef.id \n "+
                "                                      FROM efectores ef \n "+
                "                                         JOIN unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n "+
                "                                      WHERE 'uad_' ||  u.codigo = current_schema() )\n "+
                "AND prestaciones_brindadas.id = p.prestacion_brindada_id\n"+  # filtro para el update
                "AND  p.liquidacion_id = #{self.liquidacion_sumar.id} \n "+    # La liquidacion en la que se genero esta prestacion
                "AND p.efector_id = #{self.efector.id}\n "                     # El efector al cual corresponde este informe de liquidacion
          })

        estado_cerrado = EstadoDelProceso.where(codigo: "B").first # Estado de finalizado y cerrado

        self.estado_del_proceso = estado_cerrado
        self.save
        
      end
    end
    return cq


    
  end
end
