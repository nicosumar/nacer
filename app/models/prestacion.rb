# -*- encoding : utf-8 -*-
class Prestacion < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :area_de_prestacion_id, :grupo_de_prestaciones_id, :subgrupo_de_prestaciones_id
  attr_accessible :codigo, :activa, :nombre, :unidad_de_medida_id, :tipo_de_prestacion_id
  attr_accessible :agrupacion_de_beneficiarios_id

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :codigo

  # Asociaciones
  #belongs_to :area_de_prestacion         # OBSOLETO en el nuevo nomenclador
  #belongs_to :grupo_de_prestaciones      # OBSOLETO en el nuevo nomenclador
  #belongs_to :subgrupo_de_prestaciones   # OBSOLETO en el nuevo nomenclador
  #has_and_belongs_to_many :categorias_de_afiliados   # OBSOLETO: ya no existen categorías

  belongs_to :objeto_de_la_prestacion
  has_one :tipo_de_prestacion, :through => :objeto_de_la_prestacion
  belongs_to :agrupacion_de_beneficiarios
  has_and_belongs_to_many :diagnosticos
  belongs_to :unidad_de_medida
  has_many :datos_adicionales_por_prestacion
  has_many :datos_adicionales, :through => :datos_adicionales_por_prestacion

  # Validaciones
  #validates_presence_of :area_de_prestacion_id, :grupo_de_prestaciones_id  # OBSOLETO
  validates_presence_of :codigo, :nombre, :unidad_de_medida_id

  # En forma predeterminada, sólo se devuelven los registros activos
  default_scope where(:activa => true)

  # Devuelve el valor del campo 'nombre', pero truncado a 80 caracteres.
  def nombre_corto
    if nombre.length > 80 then
      nombre.first(62) + "..." + nombre.last(15)
    else
      nombre
    end
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

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    prestacion = self.find_by_codigo(codigo.strip.upcase.gsub(/ /, ''))

    if prestacion
      return prestacion.id
    else
      logger.warn "ADVERTENCIA: No se encontró la prestación '#{codigo.strip.upcase.gsub(/ /, '')}'."
      return nil
    end
  end

end
