# -*- encoding : utf-8 -*-
class Prestacion < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :area_de_prestacion_id, :grupo_de_prestaciones_id, :subgrupo_de_prestaciones_id,
                  :codigo, :activa, :nombre, :unidad_de_medida_id, :objeto_de_la_prestacion_id,
                  :created_at, :updated_at, :comunitaria, :otorga_cobertura, :unidades_maximas,
                  :requiere_historia_clinica, :concepto_de_facturacion_id, :tipo_de_tratamiento_id,
                  :dato_reportabl_ids, :modifica_lugar_de_atencion, :diagnostico_ids, :prestaciones_pdss_attributes,
                  :sexo_ids, :grupo_poblacional_ids, :documentacion_respaldatoria_ids, :dato_adicional_ids, 
                  :metodo_de_validacion_ids, :cantidades_de_prestaciones_por_periodo_attributes,
                  :asignaciones_de_precios_attributes, :datos_reportables_requeridos_attributes, :datos_adicionales_attributes

  #Atributos para asignacion masiva vinculados a Liquidaciones
  attr_accessible :conceptos_de_facturacion_id, :es_catastrofica

  belongs_to :objeto_de_la_prestacion
  has_one :tipo_de_prestacion, through: :objeto_de_la_prestacion
  has_and_belongs_to_many :diagnosticos
  belongs_to :unidad_de_medida
  belongs_to :tipo_de_tratamiento
  has_many :datos_adicionales_por_prestacion
  has_many :datos_adicionales, through: :datos_adicionales_por_prestacion
  has_many :cantidades_de_prestaciones_por_periodo
  has_and_belongs_to_many :metodos_de_validacion
  has_and_belongs_to_many :sexos
  has_and_belongs_to_many :grupos_poblacionales

  has_many :datos_reportables_requeridos
  has_many :datos_reportables, through: :datos_reportables_requeridos, source: :dato_reportable
  
  has_many :documentaciones_respaldatorias_prestaciones
  has_many :documentaciones_respaldatorias, through: :documentaciones_respaldatorias_prestaciones
  
  has_and_belongs_to_many :prestaciones_pdss

  # Relaciones para liquidacion
  belongs_to :concepto_de_facturacion
  has_many :asignaciones_de_precios
  has_many :nomencladores, through: :asignaciones_de_precios
  has_many :prestaciones_incluidas
  has_many :prestaciones_autorizadas

  #has_many relaciones para la solicitud de Addenda
  has_many :solicitud_addenda_prestacion_pdss
  
  # Validaciones
  # validates_presence_of :area_de_prestacion_id, :grupo_de_prestaciones_id  # OBSOLETO
  validates_presence_of :codigo, :nombre, :unidad_de_medida_id
  validate :validate_unique_asignaciones_de_precios

  accepts_nested_attributes_for :prestaciones_pdss, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :cantidades_de_prestaciones_por_periodo, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :asignaciones_de_precios, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :datos_reportables_requeridos, reject_if: :all_blank, allow_destroy: false
  accepts_nested_attributes_for :datos_adicionales, reject_if: :all_blank, allow_destroy: false

  before_validation :asignar_attributes_a_prestacion
  before_save :asignar_attributes_a_prestaciones_pdss

  after_initialize :add_cantidades_de_prestaciones_por_periodo
  after_initialize :add_prestaciones_pdss

  scope :listado_permitido, ->(con_eliminadas=false) { where('eliminada IS NULL OR eliminada = false') unless con_eliminadas }
  scope :activas, -> { where(activa: true) }
  scope :like_codigo, ->(codigo) { where("prestaciones.codigo LIKE ?", "%#{codigo.upcase}%") if codigo.present? }
  scope :ordenadas_por_prestaciones_pdss, -> { includes(prestaciones_pdss: [:linea_de_cuidado, grupo_pdss: [:seccion_pdss]]).order("secciones_pdss.orden ASC, grupos_pdss.orden ASC, lineas_de_cuidado.nombre ASC, prestaciones.codigo ASC") }
  scope :by_grupo_pdss, -> (grupo_pdss_id){ includes(prestaciones_pdss: [:grupo_pdss]).where("grupos_pdss.id = ?", grupo_pdss_id) if  grupo_pdss_id.present? }
  scope :by_seccion_pdss, -> (seccion_pdss_id){ includes(prestaciones_pdss: [{ grupo_pdss: [:seccion_pdss]}]).where("secciones_pdss.id = ?", seccion_pdss_id) if  seccion_pdss_id.present? }

  # Devuelve el valor del campo 'nombre', pero truncado a 100 caracteres.
  def nombre_corto
    if nombre.length > 90 then
      nombre.first(67) + "..." + nombre.last(20)
    else
      nombre
    end
  end

  def codigo_de_unidad
    unidad_de_medida.codigo
  end

  # Devuelve las prestaciones que han sido autorizadas para el ID del efector que se pasa
  # como parámetro.
  def self.autorizadas(efector_id)
    Prestacion.find_by_sql("
      SELECT prestaciones.*
        FROM prestaciones
        WHERE id IN (
          SELECT prestacion_id
            FROM prestaciones_autorizadas
            WHERE efector_id = \'#{efector_id}\' AND fecha_de_finalizacion IS NULL)
        ORDER BY codigo;")
  end

  # Devuelve las prestaciones que han sido autorizadas para el ID del efector que se pasa
  # como parámetro.
  def self.autorizadas_sumar(efector_id)
    Prestacion.find_by_sql("
      SELECT prestaciones.*
        FROM prestaciones
        WHERE
          id IN (
            SELECT prestacion_id
              FROM prestaciones_autorizadas
              WHERE efector_id = \'#{efector_id}\' AND fecha_de_finalizacion IS NULL
          )
          AND objeto_de_la_prestacion_id IS NOT NULL
        ORDER BY codigo;")
  end

  # Devuelve las prestaciones que no han sido autorizadas para el ID del efector que se pasa
  # como parámetro.
  def self.no_autorizadas(efector_id)
    Prestacion.find_by_sql("
      SELECT prestaciones.*
        FROM prestaciones
        WHERE id NOT IN (
          SELECT prestacion_id
            FROM prestaciones_autorizadas
            WHERE efector_id = \'#{efector_id}\' AND fecha_de_finalizacion IS NULL)
        ORDER BY codigo;")
  end

  # Devuelve las prestaciones que no han sido autorizadas para el ID del efector que se pasa
  # como parámetro.
  def self.no_autorizadas_sumar(efector_id)
    Prestacion.find_by_sql("
      SELECT prestaciones.*
        FROM prestaciones
        WHERE
          id NOT IN (
            SELECT prestacion_id
              FROM prestaciones_autorizadas
              WHERE efector_id = \'#{efector_id}\' AND fecha_de_finalizacion IS NULL
          )
          AND objeto_de_la_prestacion_id IS NOT NULL
          AND activa
        ORDER BY codigo;")
  end

  # Devuelve las prestaciones que no han sido autorizadas para el ID del efector
  # hasta el dia anterior de la fecha indicada en los parámetros.
  def self.no_autorizadas_antes_del_dia(efector_id, fecha)
    Prestacion.find_by_sql("
      SELECT prestaciones.*
        FROM prestaciones
        WHERE id NOT IN (
          SELECT prestacion_id
            FROM prestaciones_autorizadas
            WHERE efector_id = \'#{efector_id}\' AND fecha_de_inicio < '#{fecha.strftime("%Y-%m-%d")}'
              AND (fecha_de_finalizacion IS NULL OR fecha_de_finalizacion >= '#{fecha.strftime("%Y-%m-%d")}')
        ) ORDER BY codigo;")
  end

  # Devuelve las prestaciones que no han sido autorizadas para el ID del efector
  # hasta el dia anterior de la fecha indicada en los parámetros.
  def self.no_autorizadas_sumar_antes_del_dia(efector_id, fecha)
    Prestacion.find_by_sql("
      SELECT prestaciones.*
        FROM prestaciones
        WHERE
          id NOT IN (
            SELECT prestacion_id
              FROM prestaciones_autorizadas
              WHERE efector_id = \'#{efector_id}\' AND fecha_de_inicio < '#{fecha.strftime("%Y-%m-%d")}'
                AND (fecha_de_finalizacion IS NULL OR fecha_de_finalizacion >= '#{fecha.strftime("%Y-%m-%d")}'
          )
          AND objeto_de_la_prestacion_id IS NOT NULL
        ) ORDER BY codigo;")
  end

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo, afiliado = nil, fecha = nil)
    if codigo.nil? || codigo.strip.empty?
      return nil
    end

    # Buscar el código completo en la tabla y devolver su ID (si existe)
    prestacion = self.find_by_codigo(codigo.strip.upcase.gsub(/ /, ''))
    return prestacion.id unless prestacion.nil?

    # Buscar todas las prestaciones con código coincidente en los primeros 6 caracteres (códigos Sumar)
    prestaciones = self.where(:codigo => codigo.strip.upcase.gsub(/ /, '')[0..5])
    return nil if prestaciones.size < 1
    return prestaciones.first.id if prestaciones.size == 1

    # Nos siguen quedando varias opciones, filtrar de acuerdo al diagnóstico
    diagnostico = Diagnostico.find_by_codigo(codigo.strip.upcase.gsub(/ /, '')[6..-1])
    return nil unless diagnostico.present?
    prestaciones = prestaciones.where("
      EXISTS (
        SELECT *
          FROM \"diagnosticos_prestaciones\"
          WHERE
            \"diagnosticos_prestaciones\".\"diagnostico_id\" = #{diagnostico.id}
            AND \"diagnosticos_prestaciones\".\"prestacion_id\" = \"prestaciones\".\"id\"
      )
    ")
    return nil if prestaciones.size < 1
    return prestaciones.first.id if prestaciones.size == 1

    # Si aún quedan varias opciones, filtrar de acuerdo al sexo y grupo poblacional del beneficiario
    # a la fecha de la prestación
    return nil unless afiliado.present? && afiliado.sexo_id.present? && afiliado.grupo_poblacional_al_dia(fecha).present?
    prestaciones = prestaciones.where("
      EXISTS (
        SELECT *
          FROM \"prestaciones_sexos\"
          WHERE
            \"prestaciones_sexos\".\"sexo_id\" = #{afiliado.sexo_id}
            AND \"prestaciones_sexos\".\"prestacion_id\" = \"prestaciones\".\"id\"
      )
      AND EXISTS (
        SELECT *
          FROM \"grupos_poblacionales_prestaciones\"
          WHERE
            \"grupos_poblacionales_prestaciones\".\"grupo_poblacional_id\" = #{afiliado.grupo_poblacional_al_dia(fecha).id}
            AND \"grupos_poblacionales_prestaciones\".\"prestacion_id\" = \"prestaciones\".\"id\"
      )
    ")
    return nil if prestaciones.size < 1
    return prestaciones.first.id if prestaciones.size == 1

    # Si seguimos teniendo más de un id de prestación posible, revisar el histórico de prestaciones brindadas, para extraer
    # de ahí el ID de prestación (lento)
    pb = VistaGlobalDePrestacionBrindada.where("
      clave_de_beneficiario = '#{afiliado.clave_de_beneficiario}'
      AND fecha_de_la_prestacion = '#{fecha.strftime("%Y-%m-%d")}'
      AND prestacion_id IN (#{prestaciones.collect{|p| p.id}.join(', ')})
      AND estado_de_la_prestacion_id NOT IN (6, 10, 11)" # TODO: ¡HARDCODED ids!
    ).first

    return pb.prestacion_id unless pb.nil?

    return nil

  end

  def self.id_del_codigo!(codigo, afiliado = nil, fecha = nil)
    codigo_id = self.id_del_codigo(codigo, afiliado, fecha)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end

  private

    def asignar_attributes_a_prestacion
      self.codigo = self.objeto_de_la_prestacion.codigo_para_la_prestacion
      datos_reportables_requeridos.map { |drr|
        drr.prestacion = self
      }
    end
    
    def asignar_attributes_a_prestaciones_pdss
      prestaciones_pdss.map { |ppdss| 
        ppdss.nombre = self.nombre 
        ppdss.tipo_de_prestacion_id = self.objeto_de_la_prestacion.tipo_de_prestacion_id
      }
      if new_record? 
        prestaciones_pdss.each_with_index { |ppdss, i| ppdss.orden = PrestacionPdss.last_orden_by_grupo_pdss_id(ppdss.grupo_pdss_id) + (i + 1) }
      end
    end

    def validate_unique_asignaciones_de_precios
      validate_uniqueness_of_in_memory(asignaciones_de_precios, [:nomenclador_id, :dato_reportable_id, :area_de_prestacion_id], 'Asignación de precio duplicada.')
    end

    def add_cantidades_de_prestaciones_por_periodo
      self.cantidades_de_prestaciones_por_periodo << CantidadDePrestacionesPorPeriodo.new if self.cantidades_de_prestaciones_por_periodo.blank?
    end

    def add_prestaciones_pdss
      self.prestaciones_pdss << PrestacionPdss.new if self.prestaciones_pdss.blank?
    end

end
