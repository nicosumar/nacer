# -*- encoding : utf-8 -*-
class ConsolidadoSumar < ActiveRecord::Base
  belongs_to :efector
  belongs_to :firmante, class_name: "Contacto"
  belongs_to :periodo
  belongs_to :liquidacion_sumar

  has_many :consolidados_sumar_detalles
  attr_accessible :fecha, :numero_de_consolidado, :efector_id, :firmante_id, :periodo_id, :liquidacion_sumar_id

  def self.generar_desde_liquidacion!(liquidacion_sumar, documento_generable)

    return false if not (liquidacion_sumar.is_a?(LiquidacionSumar) and documento_generable.is_a?(DocumentoGenerablePorConcepto) )
      
    return false  if LiquidacionSumarCuasifactura.where(liquidacion_sumar_id: liquidacion_sumar.id).size == 0 # devuelve falso si no se generaron las cuasifacturas de esta liquidación

    ActiveRecord::Base.transaction do
      begin
        documento_generable.tipo_de_agrupacion.iterar_efectores_y_prestaciones_de(liquidacion_sumar) do |e, pliquidadas |

          # Busco el administrador
          if e.es_administrado? 
            administrador = e.administrador_sumar
          elsif e.es_autoadministrado?
            next
          else
            administrador = e
          end

          logger.warn "LOG INFO - LIQUIDACION_SUMAR: Creando Consolidado para efector #{e.nombre} - Liquidacion #{liquidacion_sumar.id} "
          
          # Verifico que no haya generado anteriormente el consolidado de este efector administrador
          c = ConsolidadoSumar.where(efector_id: administrador.id, liquidacion_sumar_id: liquidacion_sumar.id)
          
          case c.size
          
          when 0 #No existe un consolidado para este efector administrador y esta liquidación
            referente = administrador.referentes.where(["(fecha_de_inicio <= ? and fecha_de_finalizacion is null) or ? between fecha_de_inicio and fecha_de_finalizacion",
                                                    liquidacion_sumar.periodo.fecha_cierre,
                                                    liquidacion_sumar.periodo.fecha_cierre
                                                    ]).first
            
            # TODO: ahora le pongo null pero no deberia poder guardar el convenio si no existe el firmante. 
            firmante_id = referente.blank? ? nil : referente.contacto.id 

            # Genero el detalle y cabecera si la suma de las cuasifacturas de los administrados es mayor a cero
            total_consolidado = 0
            
            total_cuasifactura_administrador = 0
            if administrador.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0
              total_cuasifactura_administrador += administrador.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).first.monto_total
            end

            total_cuasifactura_administrados = 0
            administrador.efectores_administrados.each do |ea|
              if ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0
                total_cuasifactura_administrados += ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).first.monto_total
              end
            end

            total_consolidado = total_cuasifactura_administrador + total_cuasifactura_administrados
           
            # Si el administrador ha facturado pero ningun administrado lo ha hecho, solo creo la cabecera
            if total_consolidado > 0
              #Verifico que exista la secuencia para los consolidados. Sino que la cree
              self.generar_secuencia administrador

              consolidado = ConsolidadoSumar.create!({
                fecha: Date.today,
                efector_id: administrador.id,
                firmante_id: firmante_id,
                periodo_id: liquidacion_sumar.periodo.id,
                liquidacion_sumar_id: liquidacion_sumar.id
              })
              consolidado.numero_de_consolidado = documento_generable.obtener_numeracion(consolidado.id)
              consolidado.save
                          
              # Genero el detalle del consolidado
              administrador.efectores_administrados.each do |ea|
                
                # Verifico si existe una cuasifactura para este efector
                if ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0
                  monto = ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).first.monto_total
                else
                  monto = 0
                end
                
                cq = CustomQuery.ejecutar({
                  sql:  "INSERT INTO  public . consolidados_sumar_detalles  \n"+
                        "( consolidado_sumar_id ,  efector_id ,  convenio_de_administracion_sumar_id ,  convenio_de_gestion_sumar_id ,  total ,  created_at ,  updated_at ) \n"+
                        "VALUES \n"+
                        "(#{consolidado.id}, #{ea.id}, #{ea.convenio_de_administracion_sumar.id}, #{ea.convenio_de_gestion_sumar.id}, #{monto}, now(), now());"
                })
                if cq
                  logger.warn ("Detalle de consolidado generado")
                else
                  logger.warn ("Detalle de consolidado NO generado - liquidacion n #{liquidacion_sumar.id } - Administrador: #{administrador.inspect} - Efector. #{e.nombre} - #{e.id}")
                end
              end
            end

          when 1 # Ya existe el consolidado. Regenera el detalle y el actualiza el firmante
            referente = administrador.referentes.where(["(fecha_de_inicio <= ? and fecha_de_finalizacion is null) or ? between fecha_de_inicio and fecha_de_finalizacion",
                                                    liquidacion_sumar.periodo.fecha_cierre,
                                                    liquidacion_sumar.periodo.fecha_cierre
                                                    ]).first

            # TODO: ahora le pongo null pero no deberia poder guardar el convenio si no existe el firmante. 
            firmante_id = referente.blank? ? nil : referente.contacto.id 

            c_id = c.first.id
            begin
              ActiveRecord::Base.transaction do

                c.first.update_attributes(firmante_id: firmante_id)
                cq = CustomQuery.ejecutar({
                  sql:  "DELETE \n"+
                        "FROM consolidados_sumar_detalles\n"+
                        "WHERE consolidado_sumar_id =  #{c_id};\n"
                })

                administrador.efectores_administrados.each do |ea|
                  # Verifico si existe una cuasifactura para este efector
                  if ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0
                    monto = ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).first.monto_total
                  else
                    monto = 0
                  end

                  cq = CustomQuery.ejecutar({
                    sql:  "INSERT INTO  public . consolidados_sumar_detalles  \n"+
                          "( consolidado_sumar_id ,  efector_id ,  convenio_de_administracion_sumar_id ,  convenio_de_gestion_sumar_id ,  total ,  created_at ,  updated_at ) \n"+
                          "VALUES \n"+
                          "(#{c_id}, #{ea.id}, #{ea.convenio_de_administracion_sumar.id}, #{ea.convenio_de_gestion_sumar.id}, #{monto}, now(), now());\n"
                  })
                end #end each
              end #end transaction
            rescue Exception => e
              logger.warn "Ocurrio un error al regenerar el consolidado. Detalles: #{e.message}"
              return false
            end #end try catch

          else
            logger.warn "Existe más de un consolidado para el efector: #{administrador.nombre} - No se regenerara el consolidado"
            next
          end

        end # end itera segun agrupacion
      rescue Exception => e
        raise "Ocurrio un problema: #{e.message}"
        return false
      end #en begin/rescue
    end #End active base transaction
    return true
  end

  private 

  def self.existe_secuencia? arg_efector
    if arg_efector.is_a? (Efector)
      cq = CustomQuery.buscar (
          {
            sql: "SELECT * \n"+
                 "FROM pg_class \n"+
                 "where relname = 'consolidado_sumar_seq_efector_id_#{arg_efector.id}'" ,
          }) 
      return true if cq.size > 0
    end
    return false
  end

  def self.generar_secuencia arg_efector
    if arg_efector.is_a? Efector and !existe_secuencia? arg_efector
      ActiveRecord::Base.connection.execute ""+
        "CREATE SEQUENCE public.consolidado_sumar_seq_efector_id_#{arg_efector.id}\n"+
        " INCREMENT 1\n"+
        " MINVALUE 1\n"+
        " MAXVALUE 9223372036854775807;\n"+
        "ALTER TABLE public.consolidado_sumar_seq_efector_id_#{arg_efector.id} OWNER TO nacer_adm;"
    end
  end

end
