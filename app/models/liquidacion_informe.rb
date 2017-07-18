class LiquidacionInforme < ActiveRecord::Base

  belongs_to :liquidacion_sumar
  belongs_to :liquidacion_sumar_cuasifactura
  belongs_to :liquidacion_sumar_anexo_administrativo
  belongs_to :liquidacion_sumar_anexo_medico
  belongs_to :estado_del_proceso
  belongs_to :efector
  belongs_to :expediente_sumar

  attr_accessible :observaciones, :liquidacion_sumar, :estado_del_proceso, :expediente_sumar, :liquidacion_sumar_cuasifactura
  attr_accessible :efector_id, :liquidacion_sumar_cuasifactura_id, :liquidacion_sumar_id, :expediente_sumar_id, :estado_del_proceso_id

  # Atributos de resumen
  attr_accessible :monto_aprobado, :devueltos_administracion_monto, :devueltos_administracion_cantidad, :devueltos_medica_monto
  attr_accessible :devueltos_medica_cantidad, :rechazos_administracion_monto, :rechazos_administracion_cantidad
  attr_accessible :rechazos_medica_monto, :rechazos_medica_cantidad, :aprobados_administracion_cantidad, :aprobados_administracion_monto
  attr_accessible :aprobados_medica_cantidad, :aprobados_medica_monto

  # nested attributes
  attr_accessible :liquidacion_sumar_cuasifactura_attributes, :expediente_sumar_attributes

  accepts_nested_attributes_for :liquidacion_sumar_cuasifactura
  validates_associated :liquidacion_sumar_cuasifactura, on: :update, if: Proc.new { |l| l.requiere_numero_de_cuasi? }

  accepts_nested_attributes_for :expediente_sumar
  validates_associated :expediente_sumar, on: :update, if: Proc.new { |l| l.requiere_numero_de_expediente? }

  # 
  # Genera los informes de liquidacion para los efectores de una liquidación dada
  # @param  liquidacion_sumar [LiquidacionSumar] Liquidacion desde la cual debe generar las cuasifacturas
  # @param  documento_generable [DocumentoGenerablePorConcepto] Especificación de la generación del documento
  # 
  # @return [Boolean] confirmación de la generación de las cuasifacturas
  def self.generar_desde_liquidacion!(liquidacion_sumar, documento_generable)

    return false if not (liquidacion_sumar.is_a?(LiquidacionSumar) and documento_generable.is_a?(DocumentoGenerablePorConcepto) )
      
    return false  if LiquidacionSumarCuasifactura.where(liquidacion_sumar_id: liquidacion_sumar.id).size == 0 # devuelve falso si no se generaron las cuasifacturas de esta liquidación

    ActiveRecord::Base.transaction do
      begin
        documento_generable.tipo_de_agrupacion.iterar_efectores_y_prestaciones_de(liquidacion_sumar) do |e, pliquidadas |
          # Si el efector no liquido prestaciones
          next if pliquidadas.size == 0

          logger.warn "LOG INFO - LIQUIDACION_SUMAR: Creando informe para efector #{e.nombre} - Liquidacion #{liquidacion_sumar.id} "
          
          
          # Solo los efectores administradores o autoadministrados generan expediente
          # por lo que en el informe debe asignarse expediente del administrador a los efectores administrados
          if e.es_administrador? or e.es_autoadministrado?

            # Si solo hay un expediente, generado, todos los informes llevan ese numero
            if ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.id} "]).size == 1
              expediente_sumar_id = ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.id} "]).first.id
            else
              expediente_sumar_id = ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.id} " +
                                                            "AND id not in (SELECT expediente_sumar_id from liquidaciones_informes) "]).first.id
            end
          else
            if ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.administrador_sumar.id} "]).size == 1
              expediente_sumar_id = ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.administrador_sumar.id} "]).first.id
            else
              expediente_sumar_id = ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.administrador_sumar.id} " +
                                                            "AND id not in (SELECT expediente_sumar_id from liquidaciones_informes) "]).first.id
            end
          end

          cuasifactura_id = LiquidacionSumarCuasifactura.joins(:liquidaciones_sumar_cuasifacturas_detalles).
                                                         where(liquidaciones_sumar_cuasifacturas_detalles: {prestacion_liquidada_id: pliquidadas.first.id}).first.id

          # 1) Creo la cabecera del informe de liquidacion
          liquidacion = LiquidacionInforme.create!(
            { 
              efector_id: e.id,
              liquidacion_sumar_id: liquidacion_sumar.id,
              liquidacion_sumar_cuasifactura_id: cuasifactura_id, 
              expediente_sumar_id: expediente_sumar_id,
              estado_del_proceso_id: EstadoDelProceso.where(codigo: 'N').first.id #estado No iniciado
          })
          liquidacion.save

        end # end itera segun agrupacion
      rescue Exception => e
        raise "Ocurrio un problema: #{e.message}"
        return false
      end #en begin/rescue
    end #End active base transaction
    return true
  end

  # 
  # Buscar las prestaciones que son comunes a ambos anexos (medico y administrativo)
  # (en realidad son solo las mencionadas en el anexo administrativo)
  # Las comparo, si una tiene estado de rechazo en algun anexo , dejo ese estado
  # 
  # El query toma como idea que el id del estado de la prestacion, mientras es mayor, el motivo de rechazo es mas negativo
  # 
  # @return [type] [description]
  def cerrar
    
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
                "  JOIN anexos_medicos_prestaciones amp ON amp.liquidacion_sumar_anexo_medico_id = li.liquidacion_sumar_anexo_medico_id\n"+
                "  LEFT JOIN anexos_administrativos_prestaciones aap ON amp.prestacion_liquidada_id = aap.prestacion_liquidada_id\n"+
                "WHERE prestaciones_liquidadas.id = amp.prestacion_liquidada_id \n"+
                "AND li.id = #{self.id}"
        })

        cq = CustomQuery.buscar({
          sql:  "SELECT distinct pl.esquema\n"+
                "FROM prestaciones_liquidadas pl \n"+
                " JOIN liquidaciones_informes li on pl.liquidacion_id = li.liquidacion_sumar_id\n"+
                " JOIN anexos_medicos_prestaciones amp ON amp.liquidacion_sumar_anexo_medico_id = li.liquidacion_sumar_anexo_medico_id\n"+
                "  LEFT JOIN anexos_administrativos_prestaciones aap ON amp.prestacion_liquidada_id = aap.prestacion_liquidada_id\n"+
                "WHERE pl.id = amp.prestacion_liquidada_id \n"+
                "AND li.id = #{self.id}"
         })

        cq.each do |r|
          raise ActiveRecord::Rollback, "No se encontraron esquemas para la actualizacion de prestaciones brindadas." if r[:esquema].blank?

          upd = CustomQuery.ejecutar({
              sql:  "UPDATE #{r[:esquema]}.prestaciones_brindadas \n "+
                    "SET estado_de_la_prestacion_id = p.estado_de_la_prestacion_liquidada_id, \n "+
                    "    updated_at = NOW()\n"+
                    "FROM prestaciones_liquidadas p \n "+
                    " JOIN anexos_medicos_prestaciones amp on amp.prestacion_liquidada_id = p.id \n"+
                    "WHERE #{r[:esquema]}.prestaciones_brindadas.id = p.prestacion_brindada_id\n"+  # filtro para el update
                    "AND p.liquidacion_id = #{self.liquidacion_sumar.id} \n "+    # La liquidacion en la que se genero esta prestacion
                    "AND p.efector_id = #{self.efector.id}\n "+                     # El efector al cual corresponde este informe de liquidacion
                    "AND p.esquema = '#{r[:esquema ]}'"
            })
        end #end each

        # Calculo los totales aprobados y resumenes para este informe
        r = ActiveRecord::Base.connection.exec_query <<-SQL
          select  sum(CASE WHEN ( 
                                  COALESCE(amp.estado_de_la_prestacion_id, 5) = 5 
                                  and COALESCE(aap.estado_de_la_prestacion_id, 5) = 5 
                                  and not ( amp.estado_de_la_prestacion_id is null AND 
                                            aap.estado_de_la_prestacion_id is null )  
                                )
                                 THEN pl.monto
                                 ELSE 0::NUMERIC
                            END 
                                      ) monto_aprobado,
                        sum(CASE WHEN aap.estado_de_la_prestacion_id = 7 THEN pl.monto ELSE 0::numeric END) "Devueltos Administracion ($)",
                        sum(CASE WHEN aap.estado_de_la_prestacion_id = 7 THEN 1 ELSE 0::numeric END) "Devueltos Administracion (cant.)",
                        sum(CASE WHEN amp.estado_de_la_prestacion_id = 7 THEN pl.monto ELSE 0::numeric END) "Devueltos Medicos($)",
                        sum(CASE WHEN amp.estado_de_la_prestacion_id = 7 THEN 1 ELSE 0::numeric END) "Devueltos Medicos(cant.)",
                        sum(CASE WHEN aap.estado_de_la_prestacion_id in(6,10, 11) THEN pl.monto ELSE 0::numeric END) "Rechazos Administracion($)",
                        sum(CASE WHEN aap.estado_de_la_prestacion_id in(6,10, 11) THEN 1 ELSE 0::numeric END) "Rechazos Administracion(cant.)",
                        sum(CASE WHEN amp.estado_de_la_prestacion_id in(6,10, 11) THEN pl.monto ELSE 0::numeric END) "Rechazos Medicos($)", 
                        sum(CASE WHEN amp.estado_de_la_prestacion_id in(6,10, 11) THEN 1 ELSE 0::numeric END) "Rechazos Medicos(cant.)",
                        sum(CASE WHEN aap.estado_de_la_prestacion_id = 5 THEN 1 ELSE 0::numeric END) "Aprobados Administracion(cant.)",
                        sum(CASE WHEN aap.estado_de_la_prestacion_id = 5 THEN pl.monto ELSE 0::numeric END) "Aprobado Administracion($)",
                        sum(CASE WHEN amp.estado_de_la_prestacion_id = 5 THEN 1 ELSE 0::numeric END) "Aprobado Medicos(cant.)",
                        sum(CASE WHEN amp.estado_de_la_prestacion_id = 5 THEN pl.monto ELSE 0::numeric END) "Aprobado Medica($)"
          from liquidaciones_sumar l
            join liquidaciones_sumar_cuasifacturas c on c.liquidacion_sumar_id = l.id
            join efectores e on e.id  = c.efector_id
            join liquidaciones_informes li on li.efector_id = e.id and li.liquidacion_sumar_id = l.id 
            join estados_de_los_procesos estados on estados.id = li.estado_del_proceso_id
            join prestaciones_liquidadas pl ON pl.liquidacion_id = l.id and pl.efector_id = e.id 
            join expedientes_sumar es on es.id = li.expediente_sumar_id
            left join anexos_medicos_prestaciones amp ON amp.prestacion_liquidada_id = pl.id 
            left JOIN anexos_administrativos_prestaciones aap ON aap.prestacion_liquidada_id = pl.id
          where li.id = #{li.id}
          group by es.numero, e.cuie, c.monto_total, estados.id
        SQL

        self.update_attributes( monto_aprobado: r.rows[0][0].to_f,
                              devueltos_administracion_monto: r.rows[0][1].to_f,
                              devueltos_administracion_cantidad: r.rows[0][2].to_i,
                              devueltos_medica_monto: r.rows[0][3].to_f,
                              devueltos_medica_cantidad: r.rows[0][4].to_i,
                              rechazos_administracion_monto: r.rows[0][5].to_f,
                              rechazos_administracion_cantidad: r.rows[0][6].to_i,
                              rechazos_medica_monto: r.rows[0][7].to_f,
                              rechazos_medica_cantidad: r.rows[0][8].to_i,
                              aprobados_administracion_cantidad: r.rows[0][9].to_i,
                              aprobados_administracion_monto: r.rows[0][10].to_f,
                              aprobados_medica_cantidad: r.rows[0][11].to_i,
                              aprobados_medica_monto: r.rows[0][12].to_f,
                              estado_del_proceso_id: EstadoDelProceso.where(codigo: "B").first.id # Estado de finalizado y cerrado
                              )
        self.save        
      end #end transaction
    end #end if
    return cq
  end

  def requiere_numero_de_cuasi?
    if LiquidacionInforme.find(self.id).liquidacion_sumar_cuasifactura.numero_cuasifactura.blank? 
      return true
    else
      return false
    end
  end

  def requiere_numero_de_expediente?
    if LiquidacionInforme.find(self.id).expediente_sumar.numero.blank?
      return true
    else
      return false
    end
  end

  def generar_anexos(aprobado)
    transaction do
      self.aprobado = aprobado
      self.estado_del_proceso_id = 2 # Estado en curso
      self.save

      # Si se aprueba la cuasifactura, los anexos administrativos pasan a estado "En Curso"
      # de otra manera, ambos se cierran y las prestaciones se devuelven para refacturar
      LiquidacionSumarAnexoAdministrativo.generar_anexo_administrativo(self, aprobado)
      LiquidacionSumarAnexoMedico.generar_anexo_medico(self, aprobado)

      if aprobado
        if self.liquidacion_sumar_anexo_medico.anexos_medicos_prestaciones.size == 0
          self.liquidacion_sumar_anexo_medico.finalizar_anexo
        end

        if self.liquidacion_sumar_anexo_administrativo.anexos_administrativos_prestaciones.size == 0
          self.liquidacion_sumar_anexo_administrativo.finalizar_anexo
        end
      else
        self.cerrar 
      end # end if aprobado

    end # end transaction
  end

end
