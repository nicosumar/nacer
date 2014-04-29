# -*- encoding : utf-8 -*-
class ConsolidadoSumar < ActiveRecord::Base
  belongs_to :efector
  belongs_to :firmante, class_name: "Contacto"
  belongs_to :periodo
  belongs_to :liquidacion_sumar
  has_one :expediente_sumar

  has_many :consolidados_sumar_detalles
  attr_accessible :fecha, :numero_de_consolidado, :efector_id, :firmante_id, :periodo_id, :liquidacion_sumar_id

  def self.generar_consolidados liquidacion_sumar
    
    if liquidacion_sumar.class != LiquidacionSumar
    	raise "El argumento de generar consolidado debe ser de tipo LiquidacionSumar y el tipo es #{liquidacion_sumar.class}"
    end

    # Traigo todos los efectores que son administrados y existen en el grupo de liquidación de la liquidación indicada
    efectores =  Efector.efectores_administrados
                        .joins(:grupo_de_efectores_liquidacion)
                        .where(grupos_de_efectores_liquidaciones: {id: liquidacion_sumar.grupo_de_efectores_liquidacion.id})
    fecha_de_cierre = liquidacion_sumar.periodo.fecha_cierre 
    
    efectores.each do |e|
      # Busco el administrador
      administrador = e.administrador_sumar
      
      # Verifico que no haya generado anteriormente el consolidado de este efector administrador

      c = ConsolidadoSumar.where(efector_id: administrador.id, liquidacion_sumar_id: liquidacion_sumar.id)
      if c.size > 0
        
        if c.size > 1 
          logger.warn "Existe más de un consolidado para el efector: #{administrador.nombre} - No se regenerara el consolidado"
          next
        end
        
        # Si ya existe el consolidado, regenero el detalle y actualizo el firmante

        
        # verifico que tenga referente:
        referente = administrador.referentes.where(["(fecha_de_inicio <= ? and fecha_de_finalizacion is null) or ? between fecha_de_inicio and fecha_de_finalizacion",
                                                    liquidacion_sumar.periodo.fecha_cierre,
                                                    liquidacion_sumar.periodo.fecha_cierre
                                                    ]).first
        if referente.blank?
          # TODO: ahora le pongo null pero no deberia poder guardar el convenio si no existe el firmante. 
          firmante_id = nil
        else
          firmante_id = referente.contacto.id 
        end
        # 1) Traigo el id de convenio
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
 
      else #Si no he generado el consolidado.

        # 1) Genero la cabecera del consolidado

        # verifico que tenga referente:
        referente = administrador.referentes.where(["(fecha_de_inicio <= ? and fecha_de_finalizacion is null) or ? between fecha_de_inicio and fecha_de_finalizacion",
                                                    liquidacion_sumar.periodo.fecha_cierre,
                                                    liquidacion_sumar.periodo.fecha_cierre
                                                    ]).first
        if referente.blank?
          # TODO: ahora le pongo null pero no deberia poder guardar el convenio si no existe el firmante. 
          firmante_id = nil
        else
          firmante_id = referente.contacto.id 
        end

        # 2) Genero el detalle y cabecera si la suma de las cuasifacturas de los administrados es mayor a cero
        total_consolidado = 0
        administrador.efectores_administrados.each do |ea|
          if ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0
            total_consolidado += ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).first.monto_total
          end
        end
        if total_consolidado == 0 
          logger.warn "El consolidado para el efector #{administrador.nombre} es cero. No se generará el consolidado"
          next
        end

        #Verifico que exista la secuencia para los consolidados. Sino que la cree
        self.generar_secuencia administrador

        consolidado = ConsolidadoSumar.create!({
          fecha: Date.today,
          efector_id: administrador.id,
          firmante_id: firmante_id,
          periodo_id: liquidacion_sumar.periodo.id,
          liquidacion_sumar_id: liquidacion_sumar.id
        })

        # 3) Genero el detalle del consolidado
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

    end
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
