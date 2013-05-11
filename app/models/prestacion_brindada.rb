# -*- encoding : utf-8 -*-
class PrestacionBrindada < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Advertencias generadas por las validaciones
  attr_accessor :advertencias

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :cantidad_de_unidades, :clave_de_beneficiario, :cuasi_factura_id, :diagnostico_id, :efector_id
  attr_accessible :es_catastrofica, :estado_de_la_prestacion_id, :fecha_de_la_prestacion, :fecha_del_debito, :mensaje_de_la_baja
  attr_accessible :monto_facturado, :monto_liquidado, :nomenclador_id, :observaciones, :prestacion_id
  attr_accessible :datos_reportables_asociados_attributes

  # Asociaciones
  belongs_to :cuasi_factura
  belongs_to :diagnostico
  belongs_to :efector
  belongs_to :estado_de_la_prestacion
  belongs_to :nomenclador
  belongs_to :prestacion
  has_many :datos_reportables_asociados
  has_many :datos_reportables_informados, :class_name => "DatoAdicional", :through => :datos_reportables_asociados
  has_many :datos_reportables_requeridos, :class_name => "DatoAdicional", :through => :prestacion
  accepts_nested_attributes_for :datos_reportables_asociados

  # Validaciones
  validates_presence_of :clave_de_beneficiario, :efector_id, :estado_de_la_prestacion_id, :fecha_de_la_prestacion
  validates_presence_of :prestacion_id
  validates_numericality_of :cantidad_de_unidades
  validate :cantidad_de_unidades_correcta?
  validate :pasa_validaciones_especificas?

  # Objeto para guardar las advertencias
  @advertencias

  #
  # self.con_estado
  # Devuelve los registros filtrados de acuerdo con el ID de estado pasado como parámetro
  def self.con_estado(id_de_estado)
    where(:estado_de_la_prestacion_id => id_de_estado)
  end

  #
  # pendiente?
  # Indica si la prestación brindada está pendiente (aún no ha sido facturada ni anulada).
  def pendiente?
    estado_de_la_prestacion && estado_de_la_prestacion.pendiente
  end

  #
  # verificacion_correcta?
  # Indica si se han completado todos los campos obligatorios de la primera etapa en la carga de la prestación
  def verificacion_correcta?

    # Verificamos que se hayan completado los campos obligatorios del formulario
    campo_obligatorio_vacio = false

    if clave_de_beneficiario.blank?
      errors.add(:clave_de_beneficiario, 'no puede estar en blanco')
      campo_obligatorio_vacio = true
    end
    if !efector_id || efector_id < 1
      errors.add(:efector_id, 'no puede estar en blanco')
      campo_obligatorio_vacio = true
    end
    if !fecha_de_la_prestacion
      errors.add(:fecha_de_la_prestacion, 'no puede estar en blanco')
      campo_obligatorio_vacio = true
    end

    return !campo_obligatorio_vacio
  end

  def pasa_validaciones_especificas?

    error_generado = false
    self.prestacion.metodos_de_validacion.where(:genera_error => true).each do |mv|
      if !eval('self.' + mv.nombre)
        error_generado = true
        errors.add(:global, mv.mensaje)
      end
    end

    return !error_generado
  end

  #
  # Métodos de validación adicionales asociados al modelo de la clase MetodoDeValidacion
  def beneficiaria_embarazada?
    beneficiaria =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiaria
      beneficiaria = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return beneficiaria.estaba_embarazada?(fecha_de_la_prestacion)
  end

  def diagnostico_de_embarazo_del_primer_trimestre?
    @beneficiaria =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not @beneficiaria
      @beneficiaria = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return false unless @beneficiaria.embarazo_actual && @beneficiaria.semanas_de_embarazo

    return (@beneficiaria.semanas_de_embarazo < 20)
  end

  def cantidad_de_unidades_correcta?
    (1..self.prestacion.unidades_maximas) === cantidad_de_unidades
  end

  def tension_arterial_valida?
    self.datos_reportables_asociados.each do |dr|
      if dr.dato_reportable.codigo = 'TAD'
        tad = dr.valor.to_f
      end
      if dr.dato_reportable.codigo = 'TAS'
        tas = dr.valor.to_f
      end
    end

    if tas && tad
      return tas > tad
    else
      return false
    end

  end

  def indice_cpod_valido?
    self.datos_reportables_asociados.each do |dr|
      if dr.dato_reportable.codigo = 'CPOD_C'
        cpod_c = dr.valor.to_i
      end
      if dr.dato_reportable.codigo = 'CPOD_P'
        cpod_p = dr.valor.to_i
      end
      if dr.dato_reportable.codigo = 'CPOD_O'
        cpod_o = dr.valor.to_i
      end
    end

    if cpod_c && cpod_p && cpod_o
      return (cpod_c + cpod_p + cpod_o) <= 32
    else
      return false
    end

  end

  def ingreso_la_cantidad_de_dias_en_uti?
    self.datos_reportables_asociados.each do |dr|
      if dr.dato_reportable.codigo = 'UTI'
        uti = dr.valor.gsub(/^([[:blank:]-]+)([[:digit:]]+)([^[:digit:]]*)/, '\2')
        return !uti.blank?
      end
    end
  end

  def ingreso_la_cantidad_de_dias_en_sala?
    self.datos_reportables_asociados.each do |dr|
      if dr.dato_reportable.codigo = 'SC'
        sc = dr.valor.gsub(/^([[:blank:]-]+)([[:digit:]]+)([^[:digit:]]*)/, '\2')
        return !sc.blank?
      end
    end
  end

  def recien_nacido?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return (beneficiario.edad_en_dias(fecha_de_la_prestacion) || 0) < 3
  end

  def menor_de_un_anio?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return (beneficiario.edad_en_anios(fecha_de_la_prestacion) || 0) < 1
  end

end
