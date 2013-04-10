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

  # Asociaciones
  belongs_to :cuasi_factura
  belongs_to :diagnostico
  belongs_to :efector
  belongs_to :estado_de_la_prestacion
  belongs_to :nomenclador
  belongs_to :prestacion
  has_many :datos_adicionales_asociados
  has_many :datos_adicionales_registrados, :class_name => "DatoAdicional", :through => :datos_adicionales_asociados
  has_many :datos_adicionales_definidos, :class_name => "DatoAdicional", :through => :prestacion

  # Validaciones
  validates_presence_of :clave_de_beneficiario, :efector_id, :estado_de_la_prestacion_id, :fecha_de_la_prestacion
  validates_presence_of :prestacion_id

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

  #
  # Métodos de validación adicionales asociados al modelo de la clase MetodoDeValidacion
  def beneficiaria_mujer?
    @beneficiaria =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not @beneficiaria
      @beneficiaria = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return @beneficiaria.sexo.codigo == "F"
  end

  def beneficiaria_embarazada?
    @beneficiaria =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not @beneficiaria
      @beneficiaria = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return @beneficiaria.estaba_embarazada?(fecha_de_la_prestacion)
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
end
