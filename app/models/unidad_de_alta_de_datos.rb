# -*- encoding : utf-8 -*-
class UnidadDeAltaDeDatos < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre, :inscripcion, :facturacion, :activa, :observaciones, :efector_id

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :codigo

  # Asociaciones
  has_and_belongs_to_many :centros_de_inscripcion
  has_many :unidades_de_alta_de_datos_users
  has_many :users, :through => :unidades_de_alta_de_datos_users
  has_many :efectores
  has_many :informes_uads
  has_many :informes, :through => :informes_uads
  has_many :prestaciones_liquidadas
  belongs_to  :efector

  # En forma predeterminada, sólo se devuelven los registros activos
  default_scope where(:activa => true)

  # Validaciones
  validates_presence_of :nombre, :codigo, :efector, :efector_id
  validates_uniqueness_of :codigo
  validates_length_of :codigo, :is => 3

  #
  # cantidad_de_novedades_para_procesar
  # Devuelve la cantidad de novedades de los afiliados registradas en esta UAD
  # con fecha anterior al parámetro
  def cantidad_de_novedades_para_procesar(fecha_limite = Date.today + 1.day)
    ActiveRecord::Base.connection.exec_query("
      SELECT COUNT(na.id)
        FROM uad_#{codigo}.novedades_de_los_afiliados na
          LEFT JOIN estados_de_las_novedades en
            ON (en.id = na.estado_de_la_novedad_id)
          LEFT JOIN tipos_de_novedades tn
            ON (tn.id = na.tipo_de_novedad_id)
        WHERE
          en.codigo = 'R'
          AND tn.codigo != 'B'
          AND na.fecha_de_la_novedad < '#{fecha_limite.strftime('%Y-%m-%d')}';
    ").rows[0][0].to_i || 0
  end

  #
  # centros_de_inscripcion_con_novedades
  # Devuelve una lista de códigos de centros de inscripcion dependientes de esta UAD
  # que tienen novedades de los afiliados registradas con fecha anterior al parámetro
  def codigos_de_CIs_con_novedades(fecha_limite = Date.today + 1.day)
    ActiveRecord::Base.connection.exec_query("
      SELECT DISTINCT ci.codigo
        FROM uad_#{codigo}.novedades_de_los_afiliados na
          LEFT JOIN estados_de_las_novedades en
            ON (en.id = na.estado_de_la_novedad_id)
          LEFT JOIN centros_de_inscripcion ci
            ON (ci.id = na.centro_de_inscripcion_id)
          LEFT JOIN tipos_de_novedades tn
            ON (tn.id = na.tipo_de_novedad_id)
        WHERE
          en.codigo = 'R'
          AND tn.codigo != 'B'
          AND na.fecha_de_la_novedad < '#{fecha_limite.strftime('%Y-%m-%d')}';
    ").rows.flatten || []
  end

  #
  # self.id_del_codigo
  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    unidad_de_alta_de_datos = self.find_by_codigo(codigo.strip.upcase)
    if unidad_de_alta_de_datos
      return unidad_de_alta_de_datos.id
    else
      return nil
    end
  end
  def self.id_del_codigo!(codigo)
    codigo_id = self.id_del_codigo(codigo)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end

end
