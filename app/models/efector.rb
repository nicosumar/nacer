# -*- encoding : utf-8 -*-
class Efector < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo_de_efector_sissa, :codigo_de_efector_bio, :nombre, :domicilio, :departamento_id, :distrito_id
  attr_accessible :codigo_postal, :latitud, :longitud, :telefonos, :email, :grupo_de_efectores_id, :area_de_prestacion_id
  attr_accessible :camas_de_internacion, :ambientes, :dependencia_administrativa_id, :integrante, :observaciones, :alto_impacto
  attr_accessible :perinatal_de_alta_complejidad, :addenda_perinatal, :fecha_de_addenda_perinatal, :unidad_de_alta_de_datos_id
  attr_accessible :cuit, :condicion_iva, :fecha_inicio_de_actividades, :condicion_iibb, :datos_bancarios, :banco_cuenta_principal
  attr_accessible :numero_de_cuenta_principal, :denominacion_cuenta_principal, :sucursal_cuenta_principal, :banco_cuenta_secundaria
  attr_accessible :numero_de_cuenta_secundaria, :denominacion_cuenta_secundaria, :sucursal_cuenta_secundaria

 # Atributos protegidos
  # attr_protected :cuie

  # Asociaciones
  has_one :convenio_de_gestion
  has_one :convenio_de_gestion_sumar
  belongs_to :departamento
  belongs_to :distrito
  belongs_to :grupo_de_efectores
  belongs_to :area_de_prestacion
  belongs_to :dependencia_administrativa
  has_one :convenio_de_administracion
  has_one :convenio_de_administracion_sumar
  has_one :administrador, :through => :convenio_de_administracion
  has_one :administrador_sumar, :through => :convenio_de_administracion_sumar, :source => "administrador"
  has_many :prestaciones_autorizadas
  has_many :asignaciones_de_nomenclador
  has_many :referentes
  # Asociaciones referentes a la liquidacion
  belongs_to :unidad_de_alta_de_datos
  belongs_to :grupo_de_efectores_liquidacion
  has_many :reglas
  has_many :prestaciones_liquidadas
  has_many :liquidaciones_informes
  has_many :cuasifacturas, class_name: "LiquidacionSumarCuasifactura"
  has_many :consolidados_sumar
  has_one  :unidad_de_alta_de_datos_administrada, class_name: "UnidadDeAltaDeDatos"

  # En forma predeterminada siempre se filtran los efectores que no figuran como integrantes
  # default_scope where("integrante = ?", true)
  scope :efectores_administrados, joins("JOIN convenios_de_administracion_sumar ca ON ca.efector_id = efectores.id")

  # Validaciones
  validates_presence_of :nombre
  validates_uniqueness_of :cuie, :allow_nil => true

  # nombre_corto
  # Devuelve el nombre acortado a 80 caracteres (útil para listas desplegables)
  def nombre_corto
    if nombre.length > 80 then
      nombre.first(77) + "..."
    else
      nombre
    end
  end

  # convenio?
  # Indica si el efector tiene un convenio de gestión firmado
  def tiene_convenio?
    return (convenio_de_gestion_sumar || convenio_de_gestion) ? true : false
  end

  # actualizar_informacion_de_busqueda
  # Ejecuta una actualización superflua en la base de datos para disparar el trigger que actualiza
  # la información para búsquedas FTS.
  def actualizar_informacion_de_busqueda
    ActiveRecord::Base.connection.execute "UPDATE efectores SET id = id WHERE id = '#{id}';"
  end

  # prestaciones_autorizadas_al_dia
  # Devuelve el listado de prestaciones autorizadas al día indicado en el parámetro.
  def prestaciones_autorizadas_al_dia(fecha = Date.today)
    prestaciones_autorizadas.where("
      fecha_de_inicio <= '#{fecha.strftime("%Y-%m-%d")}'
      AND (
        fecha_de_finalizacion IS NULL
        OR fecha_de_finalizacion > '#{fecha.strftime("%Y-%m-%d")}'
      )
    ")
  end

  # prestaciones_comunitarias_autorizadas_al_dia
  # Devuelve el listado de prestaciones autorizadas al día indicado en el parámetro.
  def prestaciones_comunitarias_autorizadas_al_dia(fecha = Date.today)
    prestaciones_autorizadas.where("
      fecha_de_inicio <= '#{fecha.strftime("%Y-%m-%d")}'
      AND (
        fecha_de_finalizacion IS NULL
        OR fecha_de_finalizacion > '#{fecha.strftime("%Y-%m-%d")}'
      )
      AND comunitaria
    ")
  end

  def fecha_de_inicio_del_convenio_actual
    convenio_actual = (convenio_de_gestion_sumar || convenio_de_gestion)

    return nil unless convenio_actual
    convenio_actual.fecha_de_inicio
  end

  def es_administrado?
    return administrador_sumar.present? if convenio_de_gestion_sumar.present?
    return administrador.present? if convenio_de_gestion.present?
  end

  # 
  # Devuelve los efectores que administra
  # 
  # @return [Array<Efector>] Array de efectores administrados
  def efectores_administrados
    Efector.joins("JOIN convenios_de_administracion_sumar ca ON ca.efector_id = efectores.id").where(["administrador_id = ?",self.id])
  end
 
  #
  # Devuelve si el efector es administrador. Considera administrador al efector si:
  # Tiene al menos un efector con convenio de administracion asociado a el como administrador
  #
  # @return [boolean] Verdadero si es administrador, falso en caso que no cumpla alguna de las dos condiciones
  def es_administrador?
    # Tiene al menos un efector con convenio de administracion asociado a el como administrador
    return false if self.efectores_administrados.size < 1
   
    return true
  end

  #
  # Devuelve el consolidado de un periodo dado
  #
  # @return [LiquidacionSumarCuasifactura] 
  def consolidado_de_periodo(argPeriodo)
    self.consolidados_sumar.where(periodo_id: argPeriodo.id).first
  end

  #
  # Devuelve el consolidado de un periodo dado
  #
  # @return [LiquidacionSumarCuasifactura] 
  def cuasifactura_de_periodo(argPeriodo)
    self.cuasifacturas.joins(:liquidacion_sumar).where(liquidaciones_sumar: {periodo_id: argPeriodo.id}).first
  end

  #--------------------------------------------------------------
  #                   Metodos de clase
  #--------------------------------------------------------------

  # self.que_no_tengan_convenio
  # Devuelve los efectores que no tienen convenio de gestión
  def self.que_no_tengan_convenio
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND NOT EXISTS (
          SELECT *
            FROM convenios_de_gestion
            WHERE convenios_de_gestion.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  # self.que_no_tengan_convenio_sumar
  # Devuelve los efectores que no tienen convenio de gestión sumar
  def self.que_no_tengan_convenio
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND NOT EXISTS (
          SELECT *
            FROM convenios_de_gestion_sumar
            WHERE convenios_de_gestion_sumar.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  # self.que_tengan_convenio
  # Devuelve los efectores que tienen convenio de gestión
  def self.que_tengan_convenio
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrente = TRUE) AND EXISTS (
          SELECT *
            FROM convenios_de_gestion
            WHERE convenios_de_gestion.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  # self.que_tengan_convenio_sumar
  # Devuelve los efectores que tienen convenio de gestión sumar
  def self.que_tengan_convenio_sumar
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrente = TRUE) AND EXISTS (
          SELECT *
            FROM convenios_de_gestion_sumar
            WHERE convenios_de_gestion_sumar.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  # self.que_no_son_administrados
  # Devuelve los efectores que no tienen convenio de administración firmado
  def self.que_no_son_administrados
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND NOT EXISTS (
          SELECT *
            FROM convenios_de_administracion
            WHERE convenios_de_administracion.efector_id = efectores.id
              OR convenios_de_administracion.administrador_id = efectores.id)
        ORDER BY nombre;")
  end

  # self.sumar_que_no_son_administrados
  # Devuelve los efectores que no tienen convenio de administración firmado
  def self.sumar_que_no_son_administrados
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND NOT EXISTS (
          SELECT *
            FROM convenios_de_administracion_sumar
            WHERE
              convenios_de_administracion_sumar.efector_id = efectores.id
              OR convenios_de_administracion_sumar.administrador_id = efectores.id
        )
        ORDER BY nombre;")
  end

  # self.del_administrador_sin_liquidar
  # Devuelve los efectores que pertenecen al administrador con ID 'administrador_id' y que no tienen
  # cargada una cuasifactura para la liquidación con ID 'liquidacion_id'.
  def self.del_administrador_sin_liquidar(administrador_id, liquidacion_id)
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE integrante = TRUE
          AND EXISTS (
            SELECT *
              FROM convenios_de_gestion
              WHERE convenios_de_gestion.efector_id = efectores.id)
          AND (
            EXISTS (
              SELECT *
                FROM convenios_de_administracion
                WHERE convenios_de_administracion.administrador_id = '#{administrador_id}'
                  AND convenios_de_administracion.efector_id = efectores.id)
            OR efectores.id = '#{administrador_id}')
          AND NOT EXISTS (
            SELECT *
              FROM cuasi_facturas
              WHERE liquidacion_id = '#{liquidacion_id}'
                AND cuasi_facturas.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  # self.que_son_administrados
  # Devuelve los efectores que tienen un convenio de administración.
  def self.que_son_administrados
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND EXISTS (
          SELECT *
            FROM convenios_de_administracion
            WHERE convenios_de_administracion.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  # self.sumar_que_son_administrados
  # Devuelve los efectores que tienen un convenio de administración.
  def self.que_son_administrados
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND EXISTS (
          SELECT *
            FROM convenios_de_administracion_sumar
            WHERE convenios_de_administracion_sumar.efector_id = efectores.id)
        ORDER BY nombre;")
  end

  # self.administradores_y_no_administrados
  # Devuelve los efectores que administran a otros, o bien que no tienen suscrito un convenio de administración.
  def self.administradores_y_no_administrados
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND NOT EXISTS (
          SELECT *
            FROM convenios_de_administracion
            WHERE convenios_de_administracion.efector_id = efectores.id)
        ORDER BY EXISTS (
          SELECT *
            FROM convenios_de_administracion
            WHERE convenios_de_administracion.administrador_id = efectores.id) DESC,
          nombre;")
  end

  # self.administradores_y_autoadministrados
  # Devuelve los efectores que administran a otros, o bien que tienen suscrito un convenio de gestión y no son administrados
  # por un tercero.
  def self.administradores_y_autoadministrados
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE (integrante = TRUE) AND
          EXISTS (
            SELECT *
              FROM convenios_de_administracion
              WHERE convenios_de_administracion.administrador_id = efectores.id
          ) OR (
          NOT EXISTS (
            SELECT *
              FROM convenios_de_administracion
              WHERE convenios_de_administracion.efector_id = efectores.id
          ) AND (
            EXISTS (
              SELECT *
                FROM convenios_de_gestion
                WHERE convenios_de_gestion.efector_id = efectores.id
          ))) ORDER BY nombre;")
  end

  # Devuelve el id asociado con el CUIE pasado
  def self.id_del_cuie(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    efector = self.find_by_cuie(codigo.strip.upcase)

    if efector
      return efector.id
    else
      logger.warn "ADVERTENCIA: No se encontró un efector con CUIE '#{codigo.strip}'."
      return nil
    end
  end

  # ordenados_por_frecuencia
  # Devuelve un vector con los elementos de la tabla asociada ordenados de acuerdo con la frecuencia
  # de uso del ID del elemento en la columna de la tabla pasados como parámetros
  def self.ordenados_por_frecuencia(tabla, columna)
    Efector.find_by_sql("
      SELECT
        efectores.id,
        (
          CASE
            WHEN length(efectores.nombre) > 80 THEN
              SUBSTRING(efectores.nombre FROM 1 FOR 77) || '...'::text
            ELSE
              efectores.nombre
          END
        ) AS \"nombre\",
        count(efectores.id) AS \"frecuencia\"
        FROM
          efectores
          LEFT JOIN \"#{tabla.to_s}\"
            ON (efectores.id = \"#{tabla.to_s}\".\"#{columna.to_s}\")
        WHERE integrante
        GROUP BY efectores.id, efectores.nombre
        ORDER BY \"frecuencia\" DESC, efectores.nombre ASC;
    ")
  end



end
