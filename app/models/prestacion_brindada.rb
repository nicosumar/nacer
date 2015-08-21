# -*- encoding : utf-8 -*-
class PrestacionBrindada < ActiveRecord::Base

  has_one :prestacion_liquidada #solo agregada por referencia para simplificar los querys
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # CAMBIADO POR UNA ASOCIACIÓN AL MODELO DE MÉTODOS DE VALIDACIÓN (LOS MÉTODOS DE VALIDACIÓN FALLADOS SE PERSISTEN A LA BB.DD.)
  # Advertencias generadas por las validaciones
  #attr_accessor :advertencias, :datos_reportables_incompletos

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :cantidad_de_unidades, :clave_de_beneficiario, :cuasi_factura_id, :diagnostico_id, :efector_id
  attr_accessible :es_catastrofica, :estado_de_la_prestacion_id, :fecha_de_la_prestacion, :fecha_del_debito, :mensaje_de_la_baja
  attr_accessible :monto_facturado, :monto_liquidado, :nomenclador_id, :observaciones, :prestacion_id
  attr_accessible :datos_reportables_asociados_attributes, :historia_clinica, :datos_reportables_asociados

  # Los atributos siguientes solo pueden establecerse durante la creación
  attr_readonly :clave_de_beneficiario, :efector_id, :fecha_de_la_prestacion, :prestacion_id

  # Asociaciones
  belongs_to :cuasi_factura
  belongs_to :diagnostico
  belongs_to :efector
  belongs_to :estado_de_la_prestacion
  belongs_to :estado_de_la_prestacion_liquidada, class_name: "EstadoDeLaPrestacion"
  belongs_to :nomenclador
  belongs_to :prestacion
  belongs_to :creator, :class_name => "User"
  belongs_to :updater, :class_name => "User"
  has_many :datos_reportables_asociados, :inverse_of => :prestacion_brindada, :order => :id
  has_many :metodos_de_validacion_fallados, :inverse_of => :prestacion_brindada
  has_many :metodos_de_validacion, :through => :metodos_de_validacion_fallados

  # Atributos anidados
  accepts_nested_attributes_for :datos_reportables_asociados

  # Validaciones
  validates_presence_of :efector_id, :estado_de_la_prestacion_id, :fecha_de_la_prestacion, :prestacion_id
  validates_presence_of :diagnostico_id, :if => :requiere_diagnostico?
  validates_presence_of :historia_clinica, :if => :requiere_historia_clinica?
  validates_presence_of :clave_de_beneficiario, :unless => :prestacion_comunitaria?
  # TODO: cleanup, reemplazado por un método de validación ad-hoc
  #validates_uniqueness_of(:prestacion_id,
  #                        :scope => [:efector_id, :fecha_de_la_prestacion, :clave_de_beneficiario],
  #                        :message => "crearía una prestación duplicada. Ya se registró una prestación con estos mismos datos.")
  validate :pasa_validaciones_especificas?
  validate :validar_asociacion
  validate :sin_duplicados

  # DESACTIVO LA FORMA DE GENERAR ADVERTENCIAS PARA DEJARLAS REGISTRADAS EN UNA TABLA LOCAL DEL ESQUEMA
  # Variable de instancia para guardar las advertencias. TODO: cleanup
  #@advertencias = {}
  #@datos_reportables_incompletos = false

  #
  # self.con_estado
  # Devuelve los registros filtrados de acuerdo con el ID de estado pasado como parámetro
  def self.con_estado(id_de_estado)
    where(:estado_de_la_prestacion_id => id_de_estado)
  end

  def self.vencidas
    where(estado_de_la_prestacion_id: 11,
          estado_de_la_prestacion_liquidada_id: 13)
  end

  #
  # self.del_beneficiario
  # Devuelve los registros filtrados de acuerdo con la clave de beneficiario pasada como parámetro
  def self.del_beneficiario(clave_de_beneficiario)
    where(:clave_de_beneficiario => clave_de_beneficiario)
  end

  #
  # self.sin_advertencias
  # Devuelve los registros filtrados en estado aún no se ha facturado, o que tienen advertencias que no son visibles para
  # el usuario
  def self.sin_advertencias
    where('
      estado_de_la_prestacion_id = 3
      OR estado_de_la_prestacion_id = 2 AND NOT EXISTS (
        SELECT *
          FROM
            metodos_de_validacion_fallados mvf
            JOIN metodos_de_validacion mv ON (mvf.metodo_de_validacion_id = mv.id)
          WHERE
            mvf.prestacion_brindada_id = prestaciones_brindadas.id
            AND mv.visible
      )'
    )
  end

  #
  # self.con_advertencias_visibles
  # Devuelve los registros filtrados cuando tienen advertencias que son visibles para el usuario
  def self.con_advertencias_visibles
    where(:estado_de_la_prestacion_id => 2).joins(:metodos_de_validacion).where('"metodos_de_validacion"."visible"').uniq
  end

  #
  # datos_reportables_asociados_attributes (reader)
  # Devuelve un array con los atributos de los datos reportables asociados para serialización
  def datos_reportables_asociados_attributes
    datos_reportables_asociados.collect do |dra|
      dra.attributes.keep_if do |k,v|
        %w(dato_reportable_requerido_id valor_integer valor_big_decimal valor_date valor_string).member? k
      end
    end
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
    datos_erroneos = false

    # Verificar que se haya seleccionado un efector
    if !efector_id || efector_id < 1
      errors.add(:efector_id, 'no puede estar en blanco')
      campo_obligatorio_vacio = true
    end

    # Verificar que se haya indicado la fecha de la prestación
    if !fecha_de_la_prestacion
      errors.add(:fecha_de_la_prestacion, 'no puede estar en blanco')
      campo_obligatorio_vacio = true
    end

    # Verificar que la fecha de la prestación no sea una fecha futura
    if fecha_de_la_prestacion && fecha_de_la_prestacion > Date.today
      errors.add(:fecha_de_la_prestacion, 'no puede ser una fecha futura.')
      datos_erroneos = true
    end

    # Verificar que la fecha de la prestación sea posterior al inicio del convenio
    if efector && fecha_de_la_prestacion
      if efector.fecha_de_inicio_del_convenio_actual && fecha_de_la_prestacion < efector.fecha_de_inicio_del_convenio_actual
        errors.add(
          :fecha_de_la_prestacion,
          'no puede ser anterior al inicio del convenio (' +
          efector.fecha_de_inicio_del_convenio_actual.strftime("%d/%m/%Y") + ')'
        )
        datos_erroneos = true
      end
    end

    if clave_de_beneficiario
      # Verificar que la fecha de la prestación sea posterior a la inscripción del beneficiario
      beneficiario =
        NovedadDelAfiliado.where(
          :clave_de_beneficiario => clave_de_beneficiario,
          :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
          :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
        ).first
      if !beneficiario || beneficiario.tipo_de_novedad.codigo == "M"
        beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
        inscripcion = beneficiario.fecha_de_inscripcion
      else
        inscripcion = beneficiario.fecha_de_la_novedad
      end
      if inscripcion && fecha_de_la_prestacion && fecha_de_la_prestacion < inscripcion
        errors.add(
          :fecha_de_la_prestacion,
          'no puede ser anterior a la fecha de inscripción ' +
          (beneficiario.sexo.codigo == "F" ? 'de la beneficiaria' : 'del beneficiario') + ' (' +
          inscripcion.strftime("%d/%m/%Y") + ')'
        )
        datos_erroneos = true
      end
      if (
            beneficiario.present? && beneficiario.fecha_de_nacimiento.present? &&
            fecha_de_la_prestacion && !beneficiario.grupo_poblacional_al_dia(fecha_de_la_prestacion)
         )
        errors.add(
          :global,
          'A la fecha de la prestación ' +
          (beneficiario.sexo.codigo == "F" ? 'la beneficiaria' : 'el beneficiario') +
          ' ya no pertenecía a un grupo poblacional elegible para el Programa Sumar (tenía ' +
          beneficiario.edad_en_anios(fecha_de_la_prestacion).to_s + ' años)'
        )
        datos_erroneos = true
      end
    end

    return !campo_obligatorio_vacio && !datos_erroneos
  end

  def pasa_validaciones_especificas?

    error_generado = false

    return true unless prestacion

    if prestacion.unidad_de_medida.codigo != "U"
      if cantidad_de_unidades.blank?
        error_generado = true
        errors.add(:cantidad_de_unidades, "El valor del campo \"Cantidad de " +
          prestacion.unidad_de_medida.nombre.mb_chars.downcase.to_s + "\" no puede estar en blanco"
        )
      elsif cantidad_de_unidades.to_f <= 0.0
        error_generado = true
        errors.add(:cantidad_de_unidades, "El valor del campo \"Cantidad de " +
          prestacion.unidad_de_medida.nombre.mb_chars.downcase.to_s + "\" tiene que ser un número mayor que cero"
        )
      elsif cantidad_de_unidades.to_f > prestacion.unidades_maximas
        error_generado = true
        errors.add(:cantidad_de_unidades, "El valor del campo \"Cantidad de " +
          prestacion.unidad_de_medida.nombre.mb_chars.downcase.to_s + "\" no puede ser mayor que " +
          ('%0.2f' % prestacion.unidades_maximas.to_f)
        )
      end
    end

    prestacion.metodos_de_validacion.where(:genera_error => true).each do |mv|
      if !eval('self.' + mv.metodo)
        error_generado = true
        errors.add(:global, mv.mensaje)
      end
    end

    return !error_generado
  end

  #
  # Verifica que no exista otra prestación igual para el mismo beneficiario en la misma fecha, que no esté anulada
  def sin_duplicados

    estados_no_anulados = EstadoDeLaPrestacion.where("codigo NOT IN (?)", %w( U S )).collect{|e| e.id}

    return true unless (
      clave_de_beneficiario.present? &&
      fecha_de_la_prestacion.present? &&
      prestacion_id.present? && (1
        !estado_de_la_prestacion_id.present? ||
        estados_no_anulados.member?(estado_de_la_prestacion_id)
      )
    )

    if self.persisted?
      duplicados = PrestacionBrindada.where(
        "clave_de_beneficiario = ?
         AND fecha_de_la_prestacion = ?
         AND prestacion_id = ?
         AND estado_de_la_prestacion_id IN (?)
         AND id <> ?",
         clave_de_beneficiario,
         fecha_de_la_prestacion,
         prestacion_id,
         estados_no_anulados,
         self.id
      ).size
    else
      duplicados = PrestacionBrindada.where(
        "clave_de_beneficiario = ?
         AND fecha_de_la_prestacion = ?
         AND prestacion_id = ?
         AND estado_de_la_prestacion_id IN (?)",
         clave_de_beneficiario,
         fecha_de_la_prestacion,
         prestacion_id,
         estados_no_anulados,
      ).size
    end

    if duplicados > 0
      errors.add(:global, "No se puede guardar la prestación porque se duplicaría el registro, esta prestación ya fue registrada")
      return false
    else
      return true
    end

  end

  #
  # Métodos de validación adicionales asociados al modelo de la clase MetodoDeValidacion
  def beneficiaria_embarazada?
    beneficiaria =
    NovedadDelAfiliado.where(
      :clave_de_beneficiario => clave_de_beneficiario,
      :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
      :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
    ).first
    if not beneficiaria.present?
      beneficiaria = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiaria.present?

    return beneficiaria.estaba_embarazada?(fecha_de_la_prestacion)
  end

  def diagnostico_de_embarazo_del_primer_trimestre?
    beneficiaria =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiaria
      beneficiaria = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiaria.present?

    return false unless beneficiaria.embarazo_actual && beneficiaria.semanas_de_embarazo

    return (beneficiaria.semanas_de_embarazo < 20)
  end

  def tension_arterial_valida?
    tas = nil
    tad = nil
    self.datos_reportables_asociados.each do |dra|
      if dra.dato_reportable_requerido.dato_reportable.codigo == 'TAS'
        tas = dra.valor_integer
      end
      if dra.dato_reportable_requerido.dato_reportable.codigo == 'TAD'
        tad = dra.valor_integer
      end
    end

    if tas && tad
      return (tas > tad)
    else
      return true
    end

  end

  def indice_cpod_valido?
    self.datos_reportables_asociados.each do |dra|
      if dra.dato_reportable_requerido.dato_reportable.codigo = 'CPOD_C'
        cpod_c = dra.valor_integer
      end
      if dra.dato_reportable_requerido.dato_reportable.codigo = 'CPOD_P'
        cpod_p = dra.valor_integer
      end
      if dra.dato_reportable_requerido.dato_reportable.codigo = 'CPOD_O'
        cpod_o = dra.valor_integer
      end
    end

    if cpod_c && cpod_p && cpod_o
      return (cpod_c + cpod_p + cpod_o) <= 32
    else
    return false
    end

  end

  def recien_nacido?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return (beneficiario.edad_en_dias(fecha_de_la_prestacion) || 0) < 7
  end

  def neonato?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return (beneficiario.edad_en_dias(fecha_de_la_prestacion) || 0) < 28
  end

  def antes_del_mes?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return (beneficiario.edad_en_dias(fecha_de_la_prestacion) || 0) <= 30
  end

  def menor_de_un_anio?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return (beneficiario.edad_en_anios(fecha_de_la_prestacion) || 2) < 1
  end

  def de_un_anio_o_mas?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return (beneficiario.edad_en_anios(fecha_de_la_prestacion) || 0) >= 1
  end

  def mayor_de_53_meses?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return (beneficiario.edad_en_meses(fecha_de_la_prestacion) || 0) > 53
  end

  def beneficiario_indigena?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return beneficiario.se_declara_indigena
  end

  def beneficiaria_menor_de_50_anios?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return (beneficiario.edad_en_anios(fecha_de_la_prestacion) || 51) < 50
  end

  def beneficiaria_mayor_de_49_anios?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return (beneficiario.edad_en_anios(fecha_de_la_prestacion) || 48) > 49
  end

  def beneficiaria_mayor_de_24_anios?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return (beneficiario.edad_en_anios(fecha_de_la_prestacion) || 23) > 24
  end

  def menor_de_tres_meses?
    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    return (beneficiario.edad_en_meses(fecha_de_la_prestacion) || 4) < 3
  end

  def total_de_dias_postquirurgicos_valido?
    self.datos_reportables_asociados.each do |dra|
      if dra.dato_reportable_requerido.dato_reportable.codigo = 'DEPOSTQU'
        postq_uti = dra.valor_integer
      end
      if dra.dato_reportable_requerido.dato_reportable.codigo = 'DMPOSTQ'
        postq_med = dra.valor_integer
      end
      if dra.dato_reportable_requerido.dato_reportable.codigo = 'DEPOSTQUM'
        postq_uti_med = dra.valor_integer
      end
      if dra.dato_reportable_requerido.dato_reportable.codigo = 'DEPOSTQSC'
        postq_sala = dra.valor_integer
      end
    end

    # *** CONTINUAR AQUÍ ***
  end

  #
  # Métodos de validación asociados con tasas de uso
  def no_excede_la_cantidad_de_prestaciones_por_periodo?
    return true unless prestacion_id.present? && fecha_de_la_prestacion.present?
    return true if !prestacion.comunitaria? && clave_de_beneficiario.nil?
    return true if prestacion.comunitaria? && efector_id.nil?

    tasa_de_uso = CantidadDePrestacionesPorPeriodo.find_by_prestacion_id(prestacion_id)

    if prestacion.comunitaria?
      return self.verificar_tasa_de_uso_por_efector(tasa_de_uso.cantidad_maxima, tasa_de_uso.periodo, tasa_de_uso.intervalo)
    else
      return self.verificar_tasa_de_uso_por_beneficiario(tasa_de_uso.cantidad_maxima, tasa_de_uso.periodo, tasa_de_uso.intervalo)
    end
  end

  def control_pediatrico_no_excede_la_cantidad_de_prestaciones_por_periodo?
    return true unless prestacion_id.present? && clave_de_beneficiario.present? && fecha_de_la_prestacion.present?

    beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not beneficiario
      beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return true unless beneficiario.present?

    if beneficiario.edad_en_meses(self.fecha_de_la_prestacion) == 0
      cantidad_maxima = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_cantidad_maxima_menores_de_1_mes)
      intervalo = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_intervalo_menores_de_1_mes)
      periodo = (self.fecha_de_la_prestacion - beneficiario.fecha_de_nacimiento).to_i.to_s + ".days"
    elsif beneficiario.edad_en_meses(self.fecha_de_la_prestacion) < 6
      cantidad_maxima = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_cantidad_maxima_de_1_a_6_meses)
      intervalo = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_intervalo_de_1_a_6_meses)
      periodo = (self.fecha_de_la_prestacion - (beneficiario.fecha_de_nacimiento + 1.months)).to_i.to_s + ".days"
    elsif beneficiario.edad_en_meses(self.fecha_de_la_prestacion) < 12
      cantidad_maxima = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_cantidad_maxima_de_6_a_12_meses)
      intervalo = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_intervalo_de_6_a_12_meses)
      periodo = (self.fecha_de_la_prestacion - (beneficiario.fecha_de_nacimiento + 6.months)).to_i.to_s + ".days"
    elsif beneficiario.edad_en_meses(self.fecha_de_la_prestacion) < 18
      cantidad_maxima = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_cantidad_maxima_de_12_a_18_meses)
      intervalo = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_intervalo_de_12_a_18_meses)
      periodo = (self.fecha_de_la_prestacion - (beneficiario.fecha_de_nacimiento + 1.year)).to_i.to_s + ".days"
    elsif beneficiario.edad_en_meses(self.fecha_de_la_prestacion) < 36
      cantidad_maxima = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_cantidad_maxima_de_18_a_36_meses)
      intervalo = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_intervalo_de_18_a_36_meses)
      periodo = (self.fecha_de_la_prestacion - (beneficiario.fecha_de_nacimiento + 18.months)).to_i.to_s + ".days"
    elsif beneficiario.edad_en_meses(self.fecha_de_la_prestacion) < 72
      cantidad_maxima = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_cantidad_maxima_de_36_a_72_meses)
      intervalo = Parametro.valor_del_parametro(:tasa_de_uso_control_pediatrico_intervalo_de_36_a_72_meses)
      periodo = (self.fecha_de_la_prestacion - (beneficiario.fecha_de_nacimiento + 3.years)).to_i.to_s + ".days"
    else
      return true # ¿Qué mierda? No debería pasar...
    end

    return self.verificar_tasa_de_uso_por_beneficiario(cantidad_maxima, periodo, intervalo)
  end

  def verificar_tasa_de_uso_por_beneficiario(cantidad_maxima, periodo = nil, intervalo = nil)

    # Verificar si la cantidad de prestaciones en el periodo definido superan el máximo permitido
    sql_where = "
      prestacion_id = #{self.prestacion_id}
      AND clave_de_beneficiario = '#{self.clave_de_beneficiario}'
      AND estado_de_la_prestacion_id IN (3, 4, 5, 12)
    "
    if periodo.present?
      sql_where += "
        AND fecha_de_la_prestacion >= '#{(self.fecha_de_la_prestacion - eval(periodo)).strftime("%Y-%m-%d")}'
      "
    end
    if self.persisted?
      sql_where += "
        AND NOT (
          esquema = '#{ActiveRecord::Base::connection.exec_query("SELECT current_schema();").rows[0][0]}'
          AND id = '#{self.id}'
        )
      "
    end
    return false if VistaGlobalDePrestacionBrindada.where(sql_where).size >= cantidad_maxima

    # Si se ha definido un intervalo mínimo entre prestaciones, verificar que se haya cumplido
    if intervalo.present?
      if periodo.present? && eval(periodo) < eval(intervalo)
        sql_where = "
          prestacion_id = #{self.prestacion_id}
          AND clave_de_beneficiario = '#{self.clave_de_beneficiario}'
          AND estado_de_la_prestacion_id IN (3, 4, 5, 12)
          AND fecha_de_la_prestacion BETWEEN
            '#{(self.fecha_de_la_prestacion - eval(periodo)).strftime("%Y-%m-%d")}'
            AND '#{(self.fecha_de_la_prestacion + eval(intervalo)).strftime("%Y-%m-%d")}'
        "
      else
        sql_where = "
          prestacion_id = #{self.prestacion_id}
          AND clave_de_beneficiario = '#{self.clave_de_beneficiario}'
          AND estado_de_la_prestacion_id IN (3, 4, 5, 12)
          AND fecha_de_la_prestacion BETWEEN
            '#{(self.fecha_de_la_prestacion - eval(intervalo)).strftime("%Y-%m-%d")}'
            AND '#{(self.fecha_de_la_prestacion + eval(intervalo)).strftime("%Y-%m-%d")}'
        "
      end
      if self.persisted?
        sql_where += "
          AND NOT (
            esquema = '#{ActiveRecord::Base::connection.exec_query("SELECT current_schema();").rows[0][0]}'
            AND id = '#{self.id}'
          )
        "
      end
      return false if VistaGlobalDePrestacionBrindada.where(sql_where).size > 0
    end

    return true
  end

  def verificar_tasa_de_uso_por_efector(cantidad_maxima, periodo = nil, intervalo = nil)

    # Verificar si la cantidad de prestaciones en el periodo definido superan el máximo permitido
    sql_where = "
      prestacion_id = #{self.prestacion_id}
      AND efector_id = '#{self.efector_id}'
      AND estado_de_la_prestacion_id IN (3, 4, 5, 12)
    "
    if periodo.present?
      sql_where += "
        AND fecha_de_la_prestacion >= '#{(self.fecha_de_la_prestacion - eval(periodo)).strftime("%Y-%m-%d")}'
      "
    end
    if self.persisted?
      sql_where += "
        AND NOT (
          esquema = '#{ActiveRecord::Base::connection.exec_query("SELECT current_schema();").rows[0][0]}'
          AND id = '#{self.id}'
        )
      "
    end
    return false if VistaGlobalDePrestacionBrindada.where(sql_where).size > cantidad_maxima

    # Si se ha definido un intervalo mínimo entre prestaciones, verificar que se haya cumplido
    if intervalo.present?
      if periodo.present? && eval(periodo) < eval(intervalo)
        sql_where = "
          prestacion_id = #{self.prestacion_id}
          AND efector_id = '#{self.efector_id}'
          AND estado_de_la_prestacion_id IN (3, 4, 5, 12)
          AND fecha_de_la_prestacion BETWEEN
            '#{(self.fecha_de_la_prestacion - eval(periodo)).strftime("%Y-%m-%d")}'
            AND '#{(self.fecha_de_la_prestacion + eval(intervalo)).strftime("%Y-%m-%d")}'
        "
      else
        sql_where = "
          prestacion_id = #{self.prestacion_id}
          AND efector_id = '#{self.efector_id}'
          AND estado_de_la_prestacion_id IN (3, 4, 5, 12)
          AND fecha_de_la_prestacion BETWEEN
            '#{(self.fecha_de_la_prestacion - eval(intervalo)).strftime("%Y-%m-%d")}'
            AND '#{(self.fecha_de_la_prestacion + eval(intervalo)).strftime("%Y-%m-%d")}'
        "
      end
      if self.persisted?
        sql_where += "
          AND NOT (
            esquema = '#{ActiveRecord::Base::connection.exec_query("SELECT current_schema();").rows[0][0]}'
            AND id = '#{self.id}'
          )
        "
      end
      return false if VistaGlobalDePrestacionBrindada.where(sql_where).size > 0
    end

    return true
  end

  # Verifica si hay datos reportables asociados obligatorios que estén incompletos
  def datos_reportables_asociados_completos?
    datos_reportables_asociados.all?{ |dra| !dra.hay_advertencias? }
  end

  # Verifica si al día de hoy, la prestación se encuentra vigente
  def prestacion_vigente?
    return fecha_de_la_prestacion >= (Date.today - (Parametro.valor_del_parametro(:vigencia_de_las_prestaciones) || 120).days)
  end

  # Verifica el estado de actividad del beneficiario para la fecha de prestación
  def beneficiario_activo?
    # Obtener el beneficiario
    beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)

    # Se considera activo si la clave corresponde a un alta que aún no se encuentra en el padrón definitivo
    return true unless beneficiario

    return beneficiario.activo?(fecha_de_la_prestacion)
  end

  def requiere_diagnostico?
    if prestacion
      prestacion.objeto_de_la_prestacion && !prestacion.comunitaria
    else
      false
    end
  end

  def requiere_historia_clinica?
    prestacion && !prestacion.comunitaria
  end

  def validar_asociacion
    datos_reportables_asociados.all?{ |dra| dra.valid? }
  end

  # Verifica si existen métodos de validación que generan advertencias y actualiza la tabla de metodos de validación
  # fallados en forma acorde
  def actualizar_metodos_de_validacion_fallados
    return true unless prestacion_id.present?

    metodos_fallados = []
    prestacion.metodos_de_validacion.where(:genera_error => false).each do |mv|
      if !eval('self.' + mv.metodo)
        metodos_fallados << mv
      end
    end

    self.metodos_de_validacion = metodos_fallados

    return (metodos_fallados.size > 0 ? true : false)
  end

  # Indica si la prestación brindada falló algún método de validación
  def con_advertencias?
    metodos_de_validacion.size > 0
  end

  def prestacion_comunitaria?
    return true unless prestacion
    prestacion.comunitaria
  end

  #
  # Busca todas las prestaciones sin facturar y vencidas al periodo indicado y las marca como vencidas
  # @param periodo [LiquidacionSumar] Liquidacion en la cual se estan venciendo las prestaciones
  #
  # @return [Fixnum] Cantidad de prestaciones vencidas
  def self.marcar_prestaciones_vencidas(liquidacion)

    vigencia_perstaciones = liquidacion.periodo.dias_de_prestacion
    fecha_de_recepcion = liquidacion.periodo.fecha_recepcion.to_s
    fecha_limite_prestaciones = liquidacion.periodo.fecha_limite_prestaciones.to_s
    prestaciones_ids = liquidacion.periodo.concepto_de_facturacion.prestaciones.collect {|r| r.id }.join(", ")
    efectores = liquidacion.grupo_de_efectores_liquidacion.efectores.collect {|e| e.id}.join(", ")

    cq = CustomQuery.buscar({
        sql:  "SELECT DISTINCT vpb.esquema\n"+
              "FROM vista_global_de_prestaciones_brindadas vpb\n"+
              "WHERE  vpb.fecha_de_la_prestacion < (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') -  #{vigencia_perstaciones})\n"+
              "AND  vpb.prestacion_id in (#{prestaciones_ids} ) \n"+
              "AND vpb.efector_id in (#{efectores})\n"+
              "and vpb.estado_de_la_prestacion_id in (1,2,3,7)"
      })

    cq.each do |r|
        upd = CustomQuery.ejecutar({
            sql:  "UPDATE #{r[:esquema]}.prestaciones_brindadas \n"+
                  "SET estado_de_la_prestacion_id = 11, \n"+
                  "    estado_de_la_prestacion_liquidada_id = 13, \n"+
                  "    observaciones_de_liquidacion = CASE WHEN #{r[:esquema]}.prestaciones_brindadas.observaciones_de_liquidacion IS NULL THEN 'La prestación se encuentra vencida al periodo #{liquidacion.periodo.periodo};' \n"+
                  "                                        ELSE #{r[:esquema]}.prestaciones_brindadas.observaciones_de_liquidacion ||  'La prestación se encuentra vencida al periodo #{liquidacion.periodo.periodo} ;' \n"+
                  "                                   END \n"+
                  "FROM vista_global_de_prestaciones_brindadas vpb \n"+
                  "WHERE  vpb.fecha_de_la_prestacion < (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') -  #{vigencia_perstaciones})\n"+
                  "AND vpb.prestacion_id in (#{prestaciones_ids} ) \n"+
                  "AND vpb.estado_de_la_prestacion_id in (1,2,3,7) \n"+
                  "AND vpb.efector_id in (#{efectores})\n"+
                  "AND vpb.esquema = '#{r[:esquema]}' \n"+
                  "AND #{r[:esquema]}.prestaciones_brindadas.id = vpb.id "
          })
    end
    #a.cmd_tuples
  end

  #
  # Marca las prestaciones brindadas que no posean asignacion de precio para el efector
  # que la brindo
  # @param periodo [LiquidacionSumar] Liquidacion en la cual se estan venciendo las prestaciones
  #
  # @return [Fixnum] Cantidad de prestaciones vencidas
  def self.marcar_prestaciones_sin_asignacion_de_precio(liquidacion)

    cq = CustomQuery.buscar({
        sql:  "SELECT DISTINCT vpb.esquema\n"+
              "FROM vista_global_de_prestaciones_brindadas vpb\n"+
              " JOIN prestaciones p ON p.id = vpb.prestacion_id\n"+
              " JOIN efectores e ON e.id = vpb.efector_id\n"+
              "WHERE vpb.estado_de_la_prestacion_id IN (1, 2,3,7)\n"+
              "AND p.area_de_prestacion_id is null\n"+
              "AND not exists ( SELECT ap.id \n"+
              "                   FROM asignaciones_de_precios ap \n"+
              "                 WHERE ap.area_de_prestacion_id = e.area_de_prestacion_id\n"+
              "                 AND vpb.prestacion_id = ap.prestacion_id \n"+
              "                 AND ap.nomenclador_id =     \n"+
              "                                        ( select id from nomencladores \n"+
              "                                           where activo = 't' \n"+
              "                                          and nomenclador_sumar = 't' \n"+
              "                                          and (vpb.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion\n"+
              "                                          or  \n"+
              "                                         (vpb.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )\n"+
              "                                         limit 1\n"+
              "                                        )\n"+
              "                )"
      })
    ActiveRecord::Base.transaction do
      cq.each do |r|
        ActiveRecord::Base.connection.schema_search_path = "#{r[:esquema]}, public"
        puts "puso el esquema #{ActiveRecord::Base.connection.schema_search_path}"
        upd = CustomQuery.ejecutar({
            sql:  "UPDATE #{r[:esquema]}.prestaciones_brindadas \n"+
                  "SET estado_de_la_prestacion_liquidada_id = 15, \n"+
                  "    observaciones_de_liquidacion = CASE WHEN #{r[:esquema]}.prestaciones_brindadas.observaciones_de_liquidacion IS NULL THEN 'La Prestación no cuenta con asignacion de precios en este nomenclador #{liquidacion.periodo.periodo}' \n"+
                  "                                        ELSE #{r[:esquema]}.prestaciones_brindadas.observaciones_de_liquidacion ||  (E' \\n La Prestación no cuenta con asignacion de precios en este nomenclador #{liquidacion.periodo.periodo}') \n"+
                  "                                   END \n"+
                  "FROM vista_global_de_prestaciones_brindadas vpb\n"+
                  " JOIN prestaciones p ON p.id = vpb.prestacion_id\n"+
                  " JOIN efectores e ON e.id = vpb.efector_id\n"+
                  "WHERE vpb.estado_de_la_prestacion_id IN (1, 2,3,7)\n"+
                  "AND p.area_de_prestacion_id is null\n"+
                  "AND not exists ( SELECT ap.id \n"+
                  "                   FROM asignaciones_de_precios ap \n"+
                  "                 WHERE ap.area_de_prestacion_id = e.area_de_prestacion_id\n"+
                  "                 AND vpb.prestacion_id = ap.prestacion_id \n"+
                  "                 AND ap.nomenclador_id =     \n"+
                  "                                        ( select id from nomencladores \n"+
                  "                                           where activo = 't' \n"+
                  "                                          and nomenclador_sumar = 't' \n"+
                  "                                          and (vpb.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion\n"+
                  "                                          or  \n"+
                  "                                         (vpb.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )\n"+
                  "                                         limit 1\n"+
                  "                                        )\n"+
                  "                )\n"+
                  "and vpb.esquema = '#{r[:esquema]}'\n"+
                  "AND #{r[:esquema]}.prestaciones_brindadas.id = vpb.id"
          })
      end
    end # end transaction
  end

  #
  # Marca las prestaciones brindadas de baja cuyo beneficiario no presentara periodo de actividad al momento de tomar la prestación.
  # @param periodo [LiquidacionSumar] Liquidacion en la cual se verifican los periodos de actividad
  #
  # @return [Fixnum] Cantidad de prestaciones vencidas
  def self.marcar_prestaciones_sin_periodo_de_actividad(liquidacion)

    vigencia_perstaciones = liquidacion.periodo.dias_de_prestacion
    fecha_de_recepcion = liquidacion.periodo.fecha_recepcion.to_s
    fecha_limite_prestaciones = liquidacion.periodo.fecha_limite_prestaciones.to_s
    efectores = liquidacion.grupo_de_efectores_liquidacion.efectores.collect {|e| e.id}.join(", ")
    prestaciones_ids = liquidacion.periodo.concepto_de_facturacion.prestaciones.collect {|r| r.id }.join(", ")

    cq = CustomQuery.buscar({
      sql:  "SELECT DISTINCT esquema \n"+
            "FROM vista_global_de_prestaciones_brindadas vpb\n"+
            " INNER JOIN     afiliados af ON (af.clave_de_beneficiario = vpb.clave_de_beneficiario) \n"+
            "WHERE vpb.estado_de_la_prestacion_id IN (1,2,3,7)\n"+
            "AND vpb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd')\n"+
            "AND NOT EXISTS (SELECT * FROM periodos_de_actividad pa WHERE\n"+
            "                   vpb.fecha_de_la_prestacion >= pa.fecha_de_inicio AND (pa.fecha_de_finalizacion is null \n"+
            "                         OR\n"+
            "                        pa.fecha_de_finalizacion > vpb.fecha_de_la_prestacion )\n"+
            "                       )\n"+
            "AND vpb.efector_id in (#{efectores})\n"+
            "AND  vpb.prestacion_id in (#{prestaciones_ids} ) \n"
      })

    cq.each do |r|
        upd = CustomQuery.ejecutar({
            sql:  "UPDATE #{r[:esquema]}.prestaciones_brindadas \n"+
                  "SET estado_de_la_prestacion_liquidada_id = 14, \n"+
                  "    observaciones_de_liquidacion = CASE WHEN #{r[:esquema]}.prestaciones_brindadas.observaciones_de_liquidacion IS NULL THEN 'La prestación brindada al beneficiario no posee periodo de actividad al periodo de liquidación #{liquidacion.periodo.periodo}' \n"+
                  "                                        ELSE #{r[:esquema]}.prestaciones_brindadas.observaciones_de_liquidacion ||  (E' \\n La prestación brindada al beneficiario no posee periodo de actividad al periodo de liquidación #{liquidacion.periodo.periodo}') ,\n"+
                  "                                   END \n"+
                  "FROM vista_global_de_prestaciones_brindadas vpb\n"+
                  " INNER JOIN     afiliados af ON (af.clave_de_beneficiario = vpb.clave_de_beneficiario) \n"+
                  "WHERE vpb.estado_de_la_prestacion_id IN (1,2,3,7)\n"+
                  "AND vpb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd')\n"+
                  "AND NOT EXISTS (SELECT * FROM periodos_de_actividad pa WHERE\n"+
                  "                    af.afiliado_id = pa.afiliado_id\n"+
                  "                   AND vpb.fecha_de_la_prestacion >= pa.fecha_de_inicio AND (pa.fecha_de_finalizacion is null \n"+
                  "                         OR\n"+
                  "                        pa.fecha_de_finalizacion > vpb.fecha_de_la_prestacion )\n"+
                  "                       )\n"+
                  "AND vpb.esquema = '#{r[:esquema]}' \n"+
                  "AND vpb.efector_id in (#{efectores})\n"+
                  "AND  vpb.prestacion_id in (#{prestaciones_ids} ) \n"+
                  "AND #{r[:esquema]}.prestaciones_brindadas.id = vpb.id "
          })
    end
  end


  #
  # Marca todas las prestaciones de una liquidación como "Registrada"
  # @param liquidacion [LiquidacionSumar] Liquidacion en la cual se encuentran las prestaciones
  #
  def self.marcar_prestaciones_facturadas!(liquidacion)

    raise 'El argumento debe ser de tipo LiquidacionSumar' unless liquidacion.is_a?(LiquidacionSumar)

    estado_aceptada_id    = liquidacion.parametro_liquidacion_sumar.prestacion_aceptada.id
    estado_exceptuada_id  = liquidacion.parametro_liquidacion_sumar.prestacion_exceptuada.id
    estados_aceptados_ids = [estado_aceptada_id, estado_exceptuada_id].join(", ")

    begin
      ActiveRecord::Base.transaction do

        cq = CustomQuery.buscar({
         sql:  "SELECT DISTINCT esquema\n"+
               "FROM prestaciones_liquidadas\n"+
               "WHERE liquidacion_id = #{liquidacion.id}"
         })

        cq.each do |r|

          logger.warn "LOG INFO - LIQUIDACION_SUMAR: Marcando prestaciones para el esquema #{r[:esquema]} - Liquidacion #{liquidacion.id} "

          upd = CustomQuery.ejecutar({
              sql:  "UPDATE #{r[:esquema]}.prestaciones_brindadas \n "+
                    "SET estado_de_la_prestacion_id = #{estado_aceptada_id}, \n "+
                    "    estado_de_la_prestacion_liquidada_id = #{estado_aceptada_id} \n "+
                    "FROM prestaciones_liquidadas p \n "+
                    "    JOIN liquidaciones_sumar_cuasifacturas lsc ON (lsc.liquidacion_sumar_id = p.liquidacion_id and lsc.efector_id = p.efector_id ) \n "+
                    "WHERE p.liquidacion_id = #{liquidacion.id} \n "+
                    "AND   p.estado_de_la_prestacion_liquidada_id in ( #{estados_aceptados_ids} )\n "+
                    "AND   #{r[:esquema]}.prestaciones_brindadas.id = p.prestacion_brindada_id \n"+
                    "AND   p.esquema = '#{r[:esquema]}'"
            })
        end #end each
      end #end transaction
    rescue Exception => e
      raise "Ocurrio un problema: #{e.message}"
    end #end begin/rescue

  end #end method

  #
  # Revisa todas las prestaciones brindadas buscando prestaciones duplicadas en
  # base a que posean el mismo beneficiario, en la misma fecha, se haya realizado en
  # el mismo efector y sea la misma prestación
  #
  # @return [type] [description]
  def self.anular_prestaciones_duplicadas

    duplicados = CustomQuery.buscar({
      sql:  "SELECT  vpb.efector_id, vpb.clave_de_beneficiario, vpb.prestacion_id, vpb.fecha_de_la_prestacion, \n"+
            "               count(*)\n"+
            "from vista_global_de_prestaciones_brindadas vpb \n"+
            "where estado_de_la_prestacion_id in (2,3,7)\n"+
            "and clave_de_beneficiario is not null\n"+
            "group by  vpb.efector_id, vpb.clave_de_beneficiario, vpb.prestacion_id, vpb.fecha_de_la_prestacion\n"+
            "having count(*) > 1"
      })

    duplicados.each do |tupla|
      casos = CustomQuery.buscar({
        sql:  "select *\n"+
              "from vista_global_de_prestaciones_brindadas vpb\n"+
              "where clave_de_beneficiario = '#{tupla[:clave_de_beneficiario]}'\n"+
              "and efector_id = #{tupla[:efector_id]}\n"+
              "and fecha_de_la_prestacion = '#{tupla[:fecha_de_la_prestacion]}'\n"+
              "and prestacion_id = #{tupla[:prestacion_id]}\n"+
              "order by created_at, id"
        })

      # Si hay alguna en estado 3, tomo esa
      aprobado = casos.find {|c| c[:estado_de_la_prestacion_id] == '3'}
      if aprobado.blank?
        # Si hay alguna en estado 7 (refacturado) y ninguna en 3, tomo esa
        aprobado = casos.find {|c| c[:estado_de_la_prestacion_id] == '7'}
        if aprobado.blank?
          # Si no hay ninguna en 3, ni 7 son todas 2 (advertidas), tomo la primera
          aprobado = casos.find {|c| c[:estado_de_la_prestacion_id] == '2'}
        end
      end

      casos.each do |c|
        next if c == aprobado
        CustomQuery.ejecutar({
          sql: "UPDATE #{c[:esquema]}.prestaciones_brindadas\n"+
               "SET estado_de_la_prestacion_id = 11\n"+
               "WHERE id = #{c[:id]}\n"
        })
      end #end update

    end #end each duplicados
  end # end anular_prestaciones_duplicadas

  # CONSTANTES Y CALLBACKS PARA PROCESAMIENTO DE DATOS EXTERNOS

  # Define los atributos en el orden que deben aparecer en el archivo de texto (CSV) que se va a procesar y las expresiones regulares que
  # se utilizan para verificar rápidamente si el formato del valor tiene una sintaxis correcta
  ESTRUCTURA_DEL_ARCHIVO_DE_DATOS = {
    :efector => {
      :etiqueta => "Efector",
      :patron_de_validacion => /[[:alpha:]][0-9]{5}/, # Una letra, seguida de 5 dígitos del 0 al 9
      :obtener => lambda {|cadena| Efector.find_by_cuie(cadena)}
    },
    :fecha_de_la_prestacion => {
      :etiqueta => "Fecha de la prestación",
      :patron_de_validacion => /20[0-9][0-9]-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])|(0?[1-9]|[1-2][0-9]|3[0-1])\/(0?[1-9]|1[0-2])\/20[0-9][0-9]/,
      :obtener => lambda {|cadena| begin Date.strptime(cadena, "%Y-%m-%d") rescue begin Date.strptime(cadena, "%d/%m/%Y") rescue nil end end}
    },
    :clave_de_beneficiario => {
      :etiqueta => "Clave de beneficiario",
      :patron_de_validacion => /09[0-9]{14}|^$/, # Clave única de beneficiario de 16 dígitos que comienza con '09', o en blanco
      :obtener => lambda {|cadena| cadena.strip}
    },
    :apellido => {
      :etiqueta => "Apellido",
      :patron_de_validacion => /[[:word:]]+/, # Una o más palabras
      :obtener => lambda {|cadena| cadena.strip}
    },
    :nombre => {
      :etiqueta => "Nombre",
      :patron_de_validacion => /[[:word:]]+/, # Una o más palabras
      :obtener => lambda {|cadena| cadena.strip}
    },
    :clase_de_documento => {
      :etiqueta => "Clase de documento",
      :patron_de_validacion => Regexp.new(ClaseDeDocumento.all.collect{|c| c.id.to_s + "|" + c.codigo.to_s}.join("|"), :ignore_case), # ID o código existente
      :obtener => lambda {|cadena| begin ClaseDeDocumento.find(cadena.to_i) rescue ClaseDeDocumento.find_by_codigo(cadena) end}
    },
    :tipo_de_documento => {
      :etiqueta => "Tipo de documento",
      :patron_de_validacion => Regexp.new(TipoDeDocumento.all.collect{|c| c.id.to_s + "|" + c.codigo.to_s}.join("|"), :ignore_case), # ID o código existente
      :obtener => lambda {|cadena| begin TipoDeDocumento.find(cadena.strip.to_i) rescue TipoDeDocumento.find_by_codigo(cadena.strip) end}
    },
    :numero_de_documento => {
      :etiqueta => "Número de documento",
      :patron_de_validacion => /[[:word:]]+/, # Una o más palabras
      :obtener => lambda {|cadena| cadena.strip}
    },
    :historia_clinica => {
      :etiqueta => "Historia clínica / Registro",
      :patron_de_validacion => /[[:word:]]+/, # Una o más palabras
      :obtener => lambda {|cadena| cadena.strip}
    },
    :codigo_de_prestacion => {
      :etiqueta => "Código de prestación",
      :patron_de_validacion => /[[:alpha:]]{2}[[:blank:]]*[[:alpha:]][0-9]{3}[[:blank:]]*([0-9]{3}|[[:alpha:]][0-9]{2}(\.[0-9])?)/,
      :obtener => lambda {|cadena| cadena.gsub(/[[:blank:]]/, "")}
    },
    :dato_reportable_1_id => {
      :etiqueta => "Dato reportable 1 (ID)",
      :patron_de_validacion => /[1-9][0-9]*|^$/, # ID (entero), o en blanco
      :obtener => lambda {|cadena| begin DatoReportable.find(cadena.strip.to_i rescue nil end}
    },
    :dato_reportable_1_valor => {
      :etiqueta => "Dato reportable 1 (valor)",
      :patron_de_validacion => /[[:word:]]*/, # Cero o más cadenas
      :obtener => lambda {|cadena| cadena}
    },
    :dato_reportable_2_id => {
      :etiqueta => "Dato reportable 2 (ID)",
      :patron_de_validacion => /[1-9][0-9]*|^$/, # ID (entero), o en blanco
      :obtener => lambda {|cadena| cadena.to_i}
    },
    :dato_reportable_2_valor => {
      :etiqueta => "Dato reportable 2 (valor)",
      :patron_de_validacion => /[[:word:]]*/, # Cero o más cadenas
      :obtener => lambda {|cadena| cadena}
    },
    :dato_reportable_3_id => {
      :etiqueta => "Dato reportable 3 (ID)",
      :patron_de_validacion => /[1-9][0-9]*|^$/, # ID (entero), o en blanco
      :obtener => lambda {|cadena| cadena.to_i}
    },
    :dato_reportable_3_valor => {
      :etiqueta => "Dato reportable 3 (valor)",
      :patron_de_validacion => /[[:word:]]*/, # Cero o más cadenas
      :obtener => lambda {|cadena| cadena}
    },
    :dato_reportable_4_id => {
      :etiqueta => "Dato reportable 4 (ID)",
      :patron_de_validacion => /[1-9][0-9]*|^$/, # ID (entero), o en blanco
      :obtener => lambda {|cadena| cadena.to_i}
    },
    :dato_reportable_4_valor => {
      :etiqueta => "Dato reportable 4 (valor)",
      :patron_de_validacion => /[[:word:]]*/, # Cero o más cadenas
      :obtener => lambda {|cadena| cadena}
    },
    :observaciones => {
      :etiqueta => "Observaciones",
      :patron_de_validacion => /[[:word:]]*/, # Cero o más palabras
      :obtener => lambda {|cadena| cadena.strip}
    }
  }

  # Procesos de datos externos
  def self.procesar_datos_externos(nombre_de_tabla)

    # PRUEBA de serialización:
    # pb2 = PrestacionBrindada.new(ActiveSupport::JSON.decode(pb.to_json(:except => [:id, :created_at, :updated_at, :creator_id, :updater_id, :estado_de_la_prestacion_liquidada_id, :observaciones_de_liquidacion], :methods => :datos_reportables_asociados_attributes)))

    # Obtenemos los datos de la tabla de preprocesamiento (únicamente las líneas con formato válido)
    resultado = ActiveRecord::Base.connection.exec_query <<-SQL
        SELECT *
          FROM "procesos".#{nombre_de_tabla}
          WHERE formato_valido;
      SQL

    resultado.rows.each do |fila|
      errores = []
      prestacion_brindada = self.new
      atributos = parsear_linea(fila[resultado.columns.index("linea")])

      # Establecer la fecha de la prestación, o registrar un error si no se pudo convertir la cadena en una fecha válida
      prestacion_brindada.fecha_de_la_prestacion = atributos[:fecha_de_la_prestacion][:valor]
      if !prestacion_brindada.fecha_de_la_prestacion.present?
        errores << "La fecha de la prestación informada no es válida ('#{atributos[:fecha_de_la_prestacion][:informada]}')"
      end

      # Evaluamos los datos reportables informados
      dato_reportable_1 = atributos[:dato_reportable_1_id]
      dato_reportable_1_valor = atributos[:dato_reportable_1_valor]
      if !dato_reportable_1[:informado].blank?
        if !dato_reportable_1[:valor].present?
          errores << "Advertencia: el identificador del primer dato reportable no existe " + \
            "('#{dato_reportable_1[:informado]}'), se ignorará el valor asociado"
        else
          if dato_reportable_1_valor[:valor].blank?
            errores << "Advertencia: no se asignó el valor del primer dato reportable ('#{dato_reportable_1_valor[:informado]}')"
          end
        end
      end
      dato_reportable_2 = atributos[:dato_reportable_2_id]
      dato_reportable_2_valor = atributos[:dato_reportable_2_valor]
      if !dato_reportable_2[:informado].blank?
        if !dato_reportable_2[:valor].present?
          errores << "Advertencia: el identificador del segundo dato reportable no existe " + \
            "('#{dato_reportable_2[:informado]}'), se ignorará el valor asociado"
        else
          if dato_reportable_2_valor[:valor].blank?
            errores << "Advertencia: no se asignó el valor del segundo dato reportable ('#{dato_reportable_2_valor[:informado]}')"
          end
        end
      end
      dato_reportable_3 = atributos[:dato_reportable_3_id]
      dato_reportable_3_valor = atributos[:dato_reportable_3_valor]
      if !dato_reportable_3[:informado].blank?
        if !dato_reportable_3[:valor].present?
          errores << "Advertencia: el identificador del tercer dato reportable no existe " + \
            "('#{dato_reportable_3[:informado]}'), se ignorará el valor asociado"
        else
          if dato_reportable_3_valor[:valor].blank?
            errores << "Advertencia: no se asignó el valor del primer dato reportable ('#{dato_reportable_3_valor[:informado]}')"
          end
        end
      end
      dato_reportable_4 = atributos[:dato_reportable_4_id]
      dato_reportable_4_valor = atributos[:dato_reportable_4_valor]
      if !dato_reportable_4[:informado].blank?
        if !dato_reportable_4[:valor].present?
          errores << "Advertencia: el identificador del cuarto dato reportable no existe " + \
            "('#{dato_reportable_4[:informado]}'), se ignorará el valor asociado"
        else
          if dato_reportable_4_valor[:valor].blank?
            errores << "Advertencia: no se asignó el valor del cuarto dato reportable ('#{dato_reportable_4_valor[:informado]}')"
          end
        end
      end

      # Intentar encontrar el beneficiario al que se le brindó la prestación
      if atributos[:clave_de_beneficiario][:valor].present?
        # Si se pasa una clave de beneficiario, solo intentamos encontrarlo por ese criterio
        beneficiarios = Afiliado.where(:clave_de_beneficiario => atributos[:clave_de_beneficiario][:valor])
        if beneficiarios.size == 0
          errores << "La clave de beneficiario '#{atributos[:clave_de_beneficiario][:valor]}' no se encontró en el padrón"
        end
      else
        # Si no se pasó una clave, buscamos por clase, tipo y número de documento
        beneficiarios = Afiliado.busqueda_por_documento(
            atributos[:numero_de_documeno][:valor],
            atributos[:clase_de_documento][:valor] || ClaseDeDocumento.find_by_codigo("P"),
            nil
          )
        if beneficiarios.size == 0
          errores << "No se encontró al beneficiario " + \
            "'#{atributos[:apellido][:valor]}, #{:atributos[:nombre][:valor]}'" + \
            ", con la clase, tipo y número de documento indicados (clase: #{atributos[:clase_de_documento][:informado]}, " + \
            "tipo: #{atributos[:tipo_de_documento][:informado]}, " + \
            "número: #{atributos[:numero_de_documeno][:valor]}) en el padrón"
        end
      end

      # Obtener la prestación y el diagnóstico asociados con el código informado, o indicar el error si no se informó el código
      prestaciones = []
      if !atributos[:codigo_de_prestacion][:valor].present?
        errores << "No se informó el código de prestación"
      else
        codigo_de_prestacion = atributos[:codigo_de_prestacion][:valor][0..5]
        prestacion = Prestacion.find_by_codigo(codigo_de_prestacion)
        if !prestacion.present?
          errores << "El código de prestación no existe ('#{codigo_de_prestacion}')"
        end
        codigo_de_diagnostico = atributos[:codigo_de_prestacion][:valor][6..-1]
        diagnostico = Diagnostico.find_by_codigo(codigo_de_diagnostico)
        if !diagnostico.present?
          errores << "El código de diagnóstico no existe (cadena evaluada: '#{codigo_de_diagnostico}')"
        else
          prestacion_brindada.diagnostico_id = diagnostico.id
        end
        if prestacion.present? && diagnostico.present?
          # Obtener todas las prestaciones que tengan el código informado y admitan el diagnóstico informado
          prestaciones = Prestacion.joins(:diagnosticos).where(
              "\"prestaciones\".\"codigo\" = ? AND \"diagnosticos\".\"id\" = ?",
              codigo_de_prestacion,
              diagnostico.id
            )
          # Registrar el error si no se encuentra una prestación para esa combinación de código y diagnóstico
          if prestaciones.size == 0
            errores << "No se encontró una prestación con código '#{codigo_de_prestacion}' " + \
              "y diagnóstico '#{diagnostico.nombre} (#{codigo_de_diagnostico})'"
          end
        end
      end # if !atributos[:codigo_de_prestacion][:valor].present?

      # Inicializamos la variable que va a contener las distintas soluciones posibles, junto con su puntuación en forma ordenada
      soluciones = []

      # Construimos todas las soluciones combinando los beneficiarios y prestaciones posibles, y asignamos una puntuación
      # a cada solución
      if beneficiarios.size > 0 && prestaciones.size > 0 && prestacion_brindada.fecha_de_la_prestacion.present?

        # Iteramos todos los posibles registros de beneficiarios
        beneficiarios.each do |beneficiario|

          # Inicializamos la variable que nos da la puntuación para este beneficiario
          punt_benef = 0
          errores_benef = []

          # Creamos otro objeto para guardar la info de la prestación brindada con los datos del beneficiario
          pb_benef = prestacion_brindada.dup
          pb_benef.clave_de_beneficiario = beneficiario.clave_de_beneficiario

          # Registrar el error si tiene datos imprescindibles incompletos
          if !(beneficiario.sexo.present? && beneficiario.fecha_de_nacimiento.present?)
            errores_benef << "No se puede evaluar la prestación porque al registro del beneficiario " + \
              "le faltan datos imprescindibles (sexo o fecha de nacimiento)"
          else
            # Obtener el grupo poblacional al que pertenecía el beneficiario para la fecha de la prestación
            grupo_poblacional = beneficiario.grupo_poblacional_al_dia(pb_benef.fecha_de_la_prestacion)
            if !grupo_poblacional.present?
              errores_benef = "El beneficiario no integra la población objetivo del Programa Sumar (sexo: " + \
                "'#{beneficiario.sexo.nombre}', edad: " + \
                "'#{beneficiario.edad_en_anios(prestacion_brindada.fecha_de_la_prestacion)} años')"
            else
              # Añadimos un punto al beneficiario si tiene datos completos y pertenece a los grupos poblacionales del Programa
              punt_benef += 1
            end

            # Añadimos tres puntos si se registró la prestación con documento ajeno y este beneficiario tenía menos de un año
            # a la fecha de la prestación.
            if atributos[:clase_de_documento][:valor].present? && \
               atributos[:clase_de_documento][:valor].id == ClaseDeDocumento.id_del_codigo!("A") && \
               (beneficiario.fecha_de_nacimiento + 1.year) >= pb_benef.fecha_de_la_prestacion
              punt_benef += 3
            end
          end

          # Añadir un punto si el beneficiario está activo
          punt_benef += 1 if beneficiario.activo?(pb_benef.fecha_de_la_prestacion)

          # Iteramos todos los posibles registros de prestaciones
          prestaciones.each do |prestacion|

            # Inicializamos la variable que nos da la puntuación para esta combinación de beneficiario y prestación
            punt_benef_prest = punt_benef
            errores_benef_prest = []

            # Volvemos a duplicar el objeto para evaluar la combinación de este beneficiario con esta prestación
            pb_benef_prest = pb_benef.dup
            pb_benef_prest.prestacion_id = prestacion.id

            # Verificar si la prestación está habilitada para el sexo del beneficiario
            if beneficiario.sexo_id.present? && !(beneficiario.sexo.prestaciones_autorizadas.collect{|p| p.id}.member?(prestacion.id))
              pb_benef_prest.agregar_error(
                "La prestación no está habilitada para el sexo del beneficiario (#{beneficiario.sexo.nombre.downcase})"
              )
            else
              punt_benef_prest += 1
            end

            # Verificar si la prestación está habilitada para el grupo poblacional del beneficiario
            if grupo_poblacional.present? && !(grupo_poblacional.prestaciones_autorizadas.collect{|p| p.id}.member?(prestacion.id))
              pb_benef_prest.agregar_error(
                "La prestación no está habilitada para el grupo poblacional del beneficiario (#{grupo_poblacional.nombre.downcase})"
              )
            else
              punt_benef_prest += 1
            end

            # Verificar si la prestación está habilitada para este efector
            if !(@efector.prestaciones_autorizadas_al_dia(pb_benef_prest.fecha_de_la_prestacion).collect{|p| p.prestacion_id}.member?(prestacion.id))
              pb_benef_prest.agregar_error(
                "La prestación no está habilitada para el efector a la fecha de la prestación"
              )
            else
              punt_benef_prest += 1
            end

            # Si la prestación está habilitada, creamos un objeto PrestacionBrindada asignando la combinación actual de
            # beneficiario y prestación para poder evaluar esta solución
            if (
              beneficiario.sexo_id.present? &&
              grupo_poblacional.present? &&
              (@efector.prestaciones_autorizadas_al_dia(pb_benef_prest.fecha_de_la_prestacion).collect{|p| p.prestacion_id}.member?(prestacion.id)) &&
              (beneficiario.sexo.prestaciones_autorizadas.collect{|p| p.id}.member?(prestacion.id)) &&
              (grupo_poblacional.prestaciones_autorizadas.collect{|p| p.id}.member?(prestacion.id))
            )
              pb = PrestacionBrindada.new({
                :estado_de_la_prestacion_id => 3,
                :clave_de_beneficiario => pb_benef_prest.clave_de_beneficiario,
                :historia_clinica => pb_benef_prest.historia_clinica,
                :fecha_de_la_prestacion => pb_benef_prest.fecha_de_la_prestacion,
                :efector_id => @efector.id,
                :prestacion_id => prestacion.id,
                :es_catastrofica => prestacion.es_catastrofica,
                :diagnostico_id => diagnostico.id
              })
              dras = []
              pb.prestacion.datos_reportables_requeridos.each do |drr|
                if drr.dato_reportable_id == pb_benef_prest.dato_reportable_1_id
                  dra_valor = pb_benef_prest.dato_reportable_1_valor
                elsif drr.dato_reportable_id == pb_benef_prest.dato_reportable_2_id
                  dra_valor = pb_benef_prest.dato_reportable_2_valor
                elsif drr.dato_reportable_id == pb_benef_prest.dato_reportable_3_id
                  dra_valor = pb_benef_prest.dato_reportable_3_valor
                elsif drr.dato_reportable_id == pb_benef_prest.dato_reportable_4_id
                  dra_valor = pb_benef_prest.dato_reportable_4_valor
                else
                  dra_valor = nil
                end
                if dra_valor.present?
                  dra = DatoReportableAsociado.new({:dato_reportable_requerido_id => drr.id})
                  case drr.dato_reportable.tipo_ruby
                    when "string"
                      dra.valor_string = dra_valor
                    when "date"
                      dra.valor_date = a_fecha(dra_valor)
                    when "big_decimal"
                      dra.valor_big_decimal = dra_valor.to_f
                    when "integer"
                      if drr.dato_reportable.enumerable
                        dra.valor_integer = clase_a_id(drr.dato_reportable.clase_para_enumeracion, dra_valor)
                      else
                        dra.valor_integer = dra_valor.to_i
                      end
                  end
                  dras << dra
                end
              end
              pb.datos_reportables_asociados = dras

              # Verificamos si la prestación brindada sería válida y añadimos puntos en forma acorde
              if pb.valid?
                punt_benef_prest += 1
                pb.actualizar_metodos_de_validacion_fallados
                if pb.metodos_de_validacion.size == 0
                  punt_benef_prest += 1
                end
              else
                pb_benef_prest.agregar_error(pb.errors.full_messages.join(" - "))
              end
            end

            # Guardar esta solución entre las posibles, ubicándola en forma ordenada de acuerdo con el puntaje
            esta_solucion = [pb_benef_prest, punt_benef_prest]

            posicion = 0
            soluciones.each_with_index do |solucion, i|
              if solucion[1] < punt_benef_prest
                posicion = i
                break
              else
                posicion = i+1
              end
            end

            soluciones.insert(posicion, esta_solucion)
          end
        end

        # Ahora diferenciamos dos casos, según la prestación se haya registrado con documento ajeno o con documento propio
        if hash_a_id(@hash_clases, prestacion_brindada.clase_de_documento_informado) == ClaseDeDocumento.id_del_codigo!("A")
          # Cuando se ha registrado con documento ajeno, solo mantenemos las soluciones que tienen la mayor puntuación
          mayor_puntuacion = soluciones[0][1]
          soluciones.keep_if{|s| s[1] == mayor_puntuacion}

          if soluciones.size > 1
            # Si quedó más de una solución con la puntuación más alta, intentar seleccionar la que tenga el nombre más
            # parecido
            mejor_solucion = nil
            mejor_nivel = 0
            soluciones.each do |solucion|
              pb = solucion[0]
              nivel = nivel_de_similitud(pb.apellido_informado, pb.nombre_informado, pb.apellido, pb.nombre)
              if nivel > mejor_nivel
                mejor_solucion = pb
                mejor_nivel = nivel
              end
            end
            prestacion_brindada = mejor_solucion
          else
            # Si quedó una única solución posible, esa es la nuestra
            prestacion_brindada = soluciones.first[0]
          end
        else
          # Cuando se ha registrado la prestación con un número de documento propio, seleccionamos la solución de mejor
          # puntuación cuyo nivel de similitud en los nombres supere cierto valor umbral, para no asignar la prestación
          # a un beneficiario incorrecto cuando se la ha registrado con un DNI incorrecto.
          prestacion_seleccionada = nil
          soluciones.each do |solucion|
            pb = solucion[0]
            nivel = self.nivel_de_similitud(pb.apellido_informado, pb.nombre_informado, pb.apellido, pb.nombre)
            if nivel >= 6 # valor de umbral
              # Consideramos que encontramos un buen candidato
              prestacion_seleccionada = pb
              break
            end
          end

          # Seleccionar la mejor solución, o registrar el error si no coincidieron los nombres en ninguna de las soluciones
          if prestacion_seleccionada.present?
            prestacion_brindada = prestacion_seleccionada
          else
            prestacion_brindada = soluciones.first[0]
            prestacion_brindada.agregar_error(
              "El nombre del beneficiario no coincide (informado: '#{prestacion_brindada.apellido_informado}, " + \
              "#{prestacion_brindada.nombre_informado}', registrado en el padrón: '" + \
              "#{prestacion_brindada.apellido}, #{prestacion_brindada.nombre}')."
            )
          end
        end
      end

      # En este punto tenemos individualizada la prestación que se quiere registrar. Puede persistirse si no tiene errores
      # registrados.
      if prestacion_brindada.errores.blank?
        # Todo bien, la prestación se guarda y podrá persistirse como PrestacionBrindada
        prestacion_brindada.persistido = true
      else
        # La prestación que quedó seleccionada tiene errores por los que no se puede persistir
        prestacion_brindada.persistido = false
      end

      # Guardar la prestación y continuar con la próxima línea
      prestacion_brindada.save

    end # resultado.rows.each

  end # def self.procesar_datos_externos

  def prestaciones_liquidadas
    esquema_actual = ActiveRecord::Base.connection.exec_query("SELECT current_schema();").rows[0][0]

    # Devolvemos las prestaciones liquidadas asociadas con esta prestación brindada, o un
    # ActiveRecord::Relation sin datos si el esquema actual es una UAD que no realiza facturación
    uad = UnidadDeAltaDeDatos.find_by_codigo((esquema_actual.match(/uad_([0-9]{3})/) || [])[1])
    if uad.present? && uad.facturacion
      PrestacionLiquidada.where(:unidad_de_alta_de_datos_id => uad.id, :prestacion_brindada_id => self.id)
    else
      PrestacionLiquidada.where("'f'::boolean")
    end
  end #end ~ def prestaciones_liquidadas

end#end class
