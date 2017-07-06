# -*- encoding : utf-8 -*-
class LiquidacionSumarCuasifactura < ActiveRecord::Base
  
  belongs_to :liquidacion_sumar
  belongs_to :efector
  belongs_to :concepto_de_facturacion
  has_many :liquidaciones_sumar_cuasifacturas_detalles, foreign_key: :liquidaciones_sumar_cuasifacturas_id
  has_one :liquidacion_informe

  scope :para, lambda {|efector, liquidacion| where(efector_id: efector.id, liquidacion_id: liquidacion.id)}

  attr_accessible :monto_total, :numero_cuasifactura, :observaciones, :liquidacion_sumar, :efector, :liquidacion_id, :efector_id
  attr_accessible :concepto_de_facturacion, :concepto_de_facturacion_id
  attr_accessible :cuasifactura_escaneada

  validates :concepto_de_facturacion, presence: true
  validates :numero_cuasifactura, presence: true, on: :update, if: Proc.new { |c| c.numero_cuasifactura.blank?  } 
  validates :cuasifactura_escaneada, presence: true, on: :update, if: Proc.new { |c| c.numero_cuasifactura.blank? }

  has_attached_file :cuasifactura_escaneada, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :cuasifactura_escaneada, :content_type => /\Aimage\/.*\Z/

    
  # 
  # Genera las cuasifacturas desde una liquidación dada
  # @param  liquidacion_sumar [LiquidacionSumar] Liquidacion desde la cual debe generar las cuasifacturas
  # @param  documento_generable [DocumentoGenerablePorConcepto] Especificación de la generación del documento
  # 
  # @return [Boolean] confirmación de la generación de las cuasifacturas
  def self.generar_desde_liquidacion!(liquidacion_sumar, documento_generable)

    return false if not (liquidacion_sumar.is_a?(LiquidacionSumar) and documento_generable.is_a?(DocumentoGenerablePorConcepto) )
      
    return false  if LiquidacionSumarCuasifactura.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0 # devuelve falso si ya se generaron las cuasifacturas de esta liquidación

    ActiveRecord::Base.transaction do
      begin
        documento_generable.tipo_de_agrupacion.iterar_efectores_y_prestaciones_de(liquidacion_sumar) do |e, pliquidadas |

          logger.warn "LOG INFO - LIQUIDACION_SUMAR: Creando cuasifactura para efector #{e.nombre} - Liquidacion #{liquidacion_sumar.id} "

          # 1) Creo la cabecera de la cuasifactura
          total_cuasifactura = pliquidadas.sum(:monto)
          
          # Si el monto de la cuasi es cero, sigo con el prox efector
          next if total_cuasifactura == 0
          
          cuasifactura = LiquidacionSumarCuasifactura.create!( liquidacion_sumar: liquidacion_sumar, 
                                                              efector: e, 
                                                              monto_total: total_cuasifactura, 
                                                              concepto_de_facturacion: liquidacion_sumar.concepto_de_facturacion)
          
          # 2) Obtengo el numero de cuasifactura si corresponde para este tipo de documento
          cuasifactura.numero_cuasifactura = documento_generable.obtener_numeracion(cuasifactura.id)
          cuasifactura.save!(validate: false)

          # 3) Creo el detalle para esta cuasifactura
          ActiveRecord::Base.connection.execute "--Creo el detalle para esta cuasifactura\n"+
            "INSERT INTO public.liquidaciones_sumar_cuasifacturas_detalles  \n"+
             "(liquidaciones_sumar_cuasifacturas_id, prestacion_incluida_id, estado_de_la_prestacion_id, monto, prestacion_liquidada_id, observaciones, created_at, updated_at)  \n"+
             pliquidadas.select(["#{cuasifactura.id}", :prestacion_incluida_id, :estado_de_la_prestacion_liquidada_id, :monto, :id, :observaciones, "now() as created_at", "now() as updated_at"]).to_sql

        end # end itera segun agrupacion
        logger.warn  "Se generaron las cuasifacturas"
      rescue Exception => e
        raise "Ocurrio un problema: #{e.message}"
        return false
      end #en begin/rescue
    end #End active base transaction
    return true
  end

  def get_cabecera
    sql_cabecera =  "select c.numero_cuasifactura cuasifactura_numero,\n"+
                    "       to_char(date(p.fecha_cierre), 'DD/MM/YYYY') cuasifactura_fecha,    --fecha de cuasifactura\n"+
                    "       e.cuit efector_cuit,\n"+
                    "       e.condicion_iva efector_iva ,\n"+
                    "       e.fecha_inicio_de_actividades efector_inicio_actividades,\n"+
                    "       e.condicion_iibb efector_iibb,\n"+
                    "       e.datos_bancarios efector_datos_bancarios,\n"+
                    "       e.cuie efector_codigo,\n"+
                    "       convenios.numero efector_contrato,\n"+
                    "       co.mostrado sello_mostrado,\n"+
                    "       co.firma_primera_linea,\n"+
                    "       co.firma_segunda_linea,\n"+
                    "       co.firma_tercera_linea,\n"+
                    "       EXTRACT(YEAR FROM p.fecha_recepcion - p.dias_de_prestacion)||'-'||to_char(EXTRACT(MONTH FROM p.fecha_recepcion - p.dias_de_prestacion), '00') ||' a '|| EXTRACT(YEAR FROM p.fecha_limite_prestaciones)||'-'||to_char(EXTRACT(MONTH FROM p.fecha_limite_prestaciones), '00') liquidacion_periodos,\n"+
                    "       cf.concepto concepto_facturacion, \n"+
                    "       e.id, e.nombre "+
                    "from liquidaciones_sumar_cuasifacturas c\n"+
                    "   join liquidaciones_sumar l on l.id = c.liquidacion_sumar_id\n"+
                    "   join efectores e on e.id = c.efector_id\n"+
                    "   join convenios_de_gestion_sumar convenios on ( convenios.efector_id = e.id )\n"+
                    "   join referentes r on ( r.efector_id = e.id   )\n"+
                    "   join contactos co on r.contacto_id = co.id \n"+
                    "   join parametros_liquidaciones_sumar pl on pl.id = l.parametro_liquidacion_sumar_id\n"+
                    "   join periodos p on p.id = l.periodo_id\n"+
                    "   join conceptos_de_facturacion cf on cf.id = p.concepto_de_facturacion_id\n"+
                    "where l.id = ? \n"+
                    "and c.id = ? \n"+
                    "and (p.fecha_cierre BETWEEN r.fecha_de_inicio and r.fecha_de_finalizacion\n"+
                    "     or \n"+
                    "    (p.fecha_cierre >= r.fecha_de_inicio and r.fecha_de_finalizacion is null)\n"+
                    "    )"


    cq_cabecera = CustomQuery.buscar (
    {
      :sql => sql_cabecera,
      values: [self.liquidacion_sumar.id,self.id ]
    })
    cabecera = cq_cabecera.first
    return cabecera
  end

  def get_detalles
    sql_detalle = "select row_number() OVER () as no, * from ( \n"+
                  "select  \n"+
                  "       p.prestacion_nombre prestacion_nombre,\n"+
                  "       p.prestacion_codigo prestacion_codigo,\n"+
                  "       sum(dc.monto) cantidad, \n"+
                  "       count(p.prestacion_nombre) cant \n "+
                  "from liquidaciones_sumar_cuasifacturas c\n"+
                  "        join liquidaciones_sumar_cuasifacturas_detalles dc on dc.liquidaciones_sumar_cuasifacturas_id = c.id\n"+
                  "        join prestaciones_incluidas p on p.id = dc.prestacion_incluida_id\n"+
                  "        join prestaciones pp on pp.id = p.prestacion_id\n"+
                  "        join objetos_de_las_prestaciones op on op.id = pp.objeto_de_la_prestacion_id \n"+
                  " where c.id = ? \n "+
                  " group by p.prestacion_nombre,p.prestacion_codigo\n "+
                  " order by 2,1,3 \n " +
                  " ) as det "

    cq_detalle = CustomQuery.buscar (
    {
      sql: sql_detalle,
      values: [self.id]
    })
    return cq_detalle
  end

  def get_detalles_with_subdetalles
    sql_detalle = "select \n " +
      "pp.id prestacion_id, \n " +
      "p.prestacion_codigo prestacion_codigo, \n " +
      "p.prestacion_nombre prestacion_nombre,   \n " +
      "COALESCE(pld.dato_reportable_id, 0) dato_reportable_id, \n " +
      "pld.dato_reportable_nombre, \n " +
      "pld.precio_por_unidad, \n " +
      "COALESCE(pld.valor_integer, pl.cantidad_de_unidades) cantidad, \n " +
      "pld.precio_por_unidad * COALESCE(pld.valor_integer, pl.cantidad_de_unidades) subtotal     \n " +
    "from liquidaciones_sumar_cuasifacturas c \n " +
      "join liquidaciones_sumar_cuasifacturas_detalles dc on dc.liquidaciones_sumar_cuasifacturas_id = c.id \n " +
      "join prestaciones_liquidadas_datos pld on pld.prestacion_liquidada_id = dc.prestacion_liquidada_id \n " +
      "join prestaciones_liquidadas pl on pld.prestacion_liquidada_id = pl.id \n " +
      "join prestaciones_incluidas p on p.id = dc.prestacion_incluida_id \n " +
      "join prestaciones pp on pp.id = p.prestacion_id \n " +
      "join objetos_de_las_prestaciones op on op.id = pp.objeto_de_la_prestacion_id  \n " +
     "where c.id = ? \n " +
     "order by pp.id, dato_reportable_id ASC"
    cq_detalle = CustomQuery.buscar (
    {
      sql: sql_detalle,
      values: [self.id]
    })
    return cq_detalle
  end
end
