# -*- encoding : utf-8 -*-
class Prestacion < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :area_de_prestacion_id, :grupo_de_prestaciones_id, :subgrupo_de_prestaciones_id
  attr_accessible :codigo, :activa, :nombre, :unidad_de_medida_id, :objeto_de_la_prestacion_id
  attr_accessible :created_at, :updated_at, :comunitaria, :otorga_cobertura, :unidades_maximas
  attr_accessible :requiere_historia_clinica, :concepto_de_facturacion_id, :tipo_de_tratamiento_id
  #Atributos para asignacion masiva vinculados a Liquidaciones
  attr_accessible :conceptos_de_facturacion_id, :es_catastrofica

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :codigo

  # Asociaciones
  #belongs_to :area_de_prestacion         # OBSOLETO en el nuevo nomenclador
  #belongs_to :grupo_de_prestaciones      # OBSOLETO en el nuevo nomenclador
  #belongs_to :subgrupo_de_prestaciones   # OBSOLETO en el nuevo nomenclador
  #has_and_belongs_to_many :categorias_de_afiliados   # OBSOLETO: ya no existen categorías

  belongs_to :objeto_de_la_prestacion
  has_one :tipo_de_prestacion, :through => :objeto_de_la_prestacion
  has_and_belongs_to_many :diagnosticos
  belongs_to :unidad_de_medida
  has_many :datos_adicionales_por_prestacion
  has_many :datos_adicionales, :through => :datos_adicionales_por_prestacion
  has_and_belongs_to_many :metodos_de_validacion
  has_and_belongs_to_many :sexos
  has_and_belongs_to_many :grupos_poblacionales
  has_many :datos_reportables_requeridos
  has_many :datos_reportables, :through => :datos_reportables_requeridos, source: :dato_reportable
  has_and_belongs_to_many :documentaciones_respaldatorias
  # Relaciones para liquidacion
  belongs_to :concepto_de_facturacion
  has_many :asignaciones_de_precios
  has_many :nomencladores, through: :asignaciones_de_precios
  has_many :prestaciones_incluidas
  has_many :prestaciones_autorizadas
  has_and_belongs_to_many :prestaciones_pdss

  # Validaciones
  # validates_presence_of :area_de_prestacion_id, :grupo_de_prestaciones_id  # OBSOLETO
  validates_presence_of :codigo, :nombre, :unidad_de_medida_id

  # En forma predeterminada, sólo se devuelven los registros activos
  #default_scope where(:activa => true)

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

# TODO: cleanup
# La 'catastroficidad' se define ahora por prestación, y no en el objeto de la prestación asociado
#  def define_si_es_catastrofica
#    objeto_de_la_prestacion ? objeto_de_la_prestacion.define_si_es_catastrofica : true
#  end
#  def es_catastrofica
#    define_si_es_catastrofica && (objeto_de_la_prestacion ? objeto_de_la_prestacion.es_catastrofica : false)
#  end

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

end
