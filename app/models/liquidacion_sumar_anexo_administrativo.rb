class LiquidacionSumarAnexoAdministrativo < ActiveRecord::Base
  
  belongs_to :estado_del_proceso
  has_one :liquidacion_informe
  has_many :anexos_administrativos_prestaciones

  attr_accessible :fecha_de_finalizacion, :fecha_de_inicio, :estado_del_proceso

  def self.generar_anexo_administrativo(arg_informe_de_liquidacion, aprobado)
    #Verifico los parametros
  	return false unless arg_informe_de_liquidacion.is_a?(LiquidacionInforme)
    documento_generable = DocumentoGenerable.where(modelo: LiquidacionInforme.to_s).first
    return false unless documento_generable.present?

    # Seteo las variables de creación de la cabecera y anexos
    estado_del_proceso = EstadoDelProceso.where(codigo: "C").first # En curso
    agrega_estado_insert = ""
    agrega_estado_dato = ""

    unless aprobado
      agrega_estado_insert = ", estado_de_la_prestacion_id, motivo_de_rechazo_id "
      agrega_estado_dato = " , #{EstadoDeLaPrestacion.find(7).id}, #{MotivoDeRechazo.find(6).id} " #7: devuelta para refacturar - 6: Falta doc reespaldatoria
    end

    transaction do 
      # Creo la cabecera 
      anexo = LiquidacionSumarAnexoAdministrativo.create!(
        estado_del_proceso: estado_del_proceso,
        fecha_de_inicio:  DateTime.now()
        )
      arg_informe_de_liquidacion.liquidacion_sumar_anexo_administrativo = anexo
      arg_informe_de_liquidacion.save!

      # solo las prestaciones liquidadas que se correspondan a esta cuasifactura
      documento_generable.iterar(arg_informe_de_liquidacion.liquidacion_sumar) do |e, p_aceptadas|
      
        # Creo el detalle del anexo. Si no fue aprobado el anexo, guarda las prestaciones como "Devueltas para refacturar"
        ActiveRecord::Base.connection.execute "--Creo el detalle del anexo\n"+
          "INSERT INTO \"public\".\"anexos_administrativos_prestaciones\" \n"+
          "(  \"liquidacion_sumar_anexo_administrativo_id\",  \"prestacion_liquidada_id\", \"created_at\",  \"updated_at\" "+agrega_estado_insert+")\n"+
          p_aceptadas.select([anexo.id, "prestaciones_liquidadas.id", "now() as created_at", "now() as updated_at" + agrega_estado_dato ]).
                      joins("JOIN prestaciones_incluidas pi ON pi.id = prestaciones_liquidadas.prestacion_incluida_id\n"+ #  Joins para incluir las tablas de
                            "JOIN prestaciones pr ON pr.id = pi.prestacion_id\n"+                                         # documentación respaldatoria
                            "JOIN documentaciones_respaldatorias_prestaciones drp ON drp.prestacion_id = pr.id\n").
                      where(  "prestaciones_liquidadas.id IN (\n"+ #  Verifica que las prestaciones incluidas en el anexo sean las de la 
                              "    SELECT\n"+                      # cuasifactura que corresponde a este informe de liquidacion   
                              "      d.prestacion_liquidada_id\n"+
                              "    FROM\n"+
                              "      liquidaciones_sumar_cuasifacturas c\n"+
                              "   join liquidaciones_sumar_cuasifacturas_detalles d on c.id = d.liquidaciones_sumar_cuasifacturas_id\n"+
                              "    WHERE\n"+
                              "      c.id = #{arg_informe_de_liquidacion.liquidacion_sumar_cuasifactura_id}\n"+
                              "  )").
                      where( " prestaciones_liquidadas.fecha_de_la_prestacion BETWEEN drp.fecha_de_inicio\n"+ #  Filtra que solo incluya las prestaciones
                             " AND drp.fecha_de_finalizacion\n"+                                              # que requieren documentación respaldatoria 
                             " OR (\n"+
                             "   prestaciones_liquidadas.fecha_de_la_prestacion >= drp.fecha_de_inicio\n"+
                             "   AND drp.fecha_de_finalizacion IS NULL\n"+
                             " )\n").
                      where(" prestaciones_liquidadas.efector_id = #{arg_informe_de_liquidacion.liquidacion_sumar_cuasifactura.efector_id }"). # Filtra el efector (x si las moscas)
                      to_sql
      end # end itera
      unless aprobado
         anexo.finalizar_anexo
      end 
    end

    return true
  end

  # 
  # Finaliza el anexo. Las prestaciones a las que no se les indico el
  # estado de aceptación son guardadas como "Aceptadas pendientes de pago"
  # 
  # @return [type] [description]
  def finalizar_anexo
    # busco el estado de finalizado. TODO: Ver de parametrizar estos estados por algun lado
    estado_del_proceso = EstadoDelProceso.find(3) # Finalizado

    # Establezco el estado de "Aceptada para liquidación en el estado de las prestaciones que no se ha definido estado"
    # TODO: Ver de parametrizar estos estados por algun lado
    estado_por_omision = EstadoDeLaPrestacion.find(5) # Aprobada pendiente de pago
    estado_por_defecto = EstadoDeLaPrestacion.find(4) #estado en el que esta la prestación al momento de generarse la cuasifactura (aca el estado es facturada, en proceso de liquidacion)

    transaction do
      
      self.anexos_administrativos_prestaciones.each do |prestacion|
        if prestacion.estado_de_la_prestacion.blank? || prestacion.estado_de_la_prestacion == estado_por_defecto
          prestacion.estado_de_la_prestacion = estado_por_omision
          prestacion.save!
        end
      end
      self.estado_del_proceso = estado_del_proceso
      self.fecha_de_finalizacion = Time.new
      self.save!
    end
  end

  # 
  # Cambia el estado del anexo a cerrado. Esta situación se da al cerrar el informe.
  # 
  # @return [type] [description]
  def cerrar_anexo
    #busco el estado de finalizado. TODO: Ver de parametrizar estos estados por algun lado
    estado_del_proceso = EstadoDelProceso.find(4)

    self.estado_del_proceso = estado_del_proceso
    self.save!
  end
  
end
