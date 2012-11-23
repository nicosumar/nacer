class Efector < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo_de_efector_sissa, :codigo_de_efector_bio, :nombre, :domicilio, :departamento_id, :distrito_id
  attr_accessible :codigo_postal, :latitud, :longitud, :telefonos, :email, :grupo_de_efectores_id, :area_de_prestacion_id
  attr_accessible :camas_de_internacion, :ambientes, :dependencia_administrativa_id, :integrante, :observaciones, :alto_impacto
  attr_accessible :perinatal_de_alta_complejidad, :addenda_perinatal, :fecha_de_addenda_perinatal

  # Atributos protegidos
  # attr_protected :cuie

  # Asociaciones
  has_one :convenio_de_gestion
  belongs_to :departamento
  belongs_to :distrito
  belongs_to :grupo_de_efectores
  belongs_to :area_de_prestacion
  belongs_to :dependencia_administrativa
  has_one :convenio_de_administracion
  has_one :administrador, :through => :convenio_de_administracion
  has_many :prestaciones_autorizadas
  has_many :asignaciones_de_nomenclador
  has_many :referentes

  # En forma predeterminada siempre se filtran los efectores que no figuran como integrantes
  default_scope where(:integrante => true)

  # Validaciones
  validates_presence_of :nombre
  validates_uniqueness_of :cuie, :allow_nil => true
  validates_uniqueness_of :codigo_de_efector_sissa, :allow_nil => true
  validates_uniqueness_of :codigo_de_efector_bio, :allow_nil => true

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
    return convenio_de_gestion ? true : false
  end

  # nombre_corto
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

  # nombre_corto
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

  # nombre_corto
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
