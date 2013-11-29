class ConsolidadoSumar < ActiveRecord::Base
  belongs_to :efector
  belongs_to :firmante, class_name: "Contacto"
  belongs_to :periodo
  belongs_to :liquidacion_sumar

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
      logger.warn "liquidacion n #{liquidacion_sumar.id } - Administrador: #{administrador.inspect} - Efector. #{e.nombre} - #{e.id}"
      
      # Verifico que no haya generado anteriormente el consolidado de este efector administrador
      if c = ConsolidadoSumar.where(efector_id: administrador.id, liquidacion_sumar_id: liquidacion_sumar.id).size > 0
        if c.size > 1 
          logger.warn "Existe más de un consolidado para este efector!! - No se regenerara "
          next
        else
          c_id = c.id
        end
        # Si ya existe el consolidado, regenero el detalle
        
        administrador.efectores_administrados.each do |ea|
        
          # Verifico si existe una cuasifactura para este efector
          if ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0
            monto = ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).first.monto_total
          else
            monto = 0
          end

          cq = CustomQuery.ejecutar({
            sql:  "BEGIN;\n"+
                  "DELETE \n"+
                  "FROM consolidados_sumar_detalles\n"+
                  "WHERE consolidado_sumar_id =  #{c_id};\n"+
                  "\n"+
                  "INSERT INTO  public . consolidados_sumar_detalles  \n"+
                  "( consolidado_sumar_id ,  efector_id ,  convenio_de_administracion_sumar_id ,  convenio_de_gestion_sumar_id ,  total ,  created_at ,  updated_at ) \n"+
                  "VALUES \n"+
                  "(#{c_id}, #{ea.id}, #{ea.convenio_de_administracion_sumar.id}, #{ea.convenio_de_gestion_sumar.id}, #{monto}, now(), now());\n"+
                  "COMMIT;"
          })
          if cq
            logger.warn ("Detalle de consolidado generado")
          else
            logger.warn ("Detalle de consolidado NO generado - liquidacion n #{liquidacion_sumar.id } - Administrador: #{administrador.inspect} - Efector. #{e.nombre} - #{e.id}")
          end
        end
        
 
        next
      end
      # 1) Genero la cabecera del consolidado

      # verifico que tenga referente:
      referente = administrador.referentes.where("(fecha_de_inicio <= '#{liquidacion_sumar.periodo.fecha_cierre}' and fecha_de_finalizacion is null) or '#{liquidacion_sumar.periodo.fecha_cierre}' between fecha_de_inicio and fecha_de_finalizacion").first
      if referente.blank?
        # TODO: ahora le pongo null pero no deberia poder guardar el convenio si no existe el firmante. 
        firmante_id = nil
      else
        firmante_id = referente.contacto.id 
      end

      consolidado = ConsolidadoSumar.create!({
        fecha: Date.today,
        efector_id: administrador.id,
        firmante_id: firmante_id,
        periodo_id: liquidacion_sumar.periodo.id,
        liquidacion_sumar_id: liquidacion_sumar.id
      })

      # 2) Genero el detalle del consolidado
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

    return true

  end

end
