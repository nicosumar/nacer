# -*- encoding : utf-8 -*-
class PrestacionBrindada < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # CAMBIADO POR UNA ASOCIACIÓN AL MODELO DE MÉTODOS DE VALIDACIÓN (LOS MÉTODOS DE VALIDACIÓN FALLADOS SE PERSISTEN A LA BB.DD.)
  # Advertencias generadas por las validaciones
  #attr_accessor :advertencias, :datos_reportables_incompletos

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :cantidad_de_unidades, :clave_de_beneficiario, :cuasi_factura_id, :diagnostico_id, :efector_id
  attr_accessible :es_catastrofica, :estado_de_la_prestacion_id, :fecha_de_la_prestacion, :fecha_del_debito, :mensaje_de_la_baja
  attr_accessible :monto_facturado, :monto_liquidado, :nomenclador_id, :observaciones, :prestacion_id
  attr_accessible :datos_reportables_asociados_attributes, :historia_clinica

  # Los atributos siguientes solo pueden establecerse durante la creación
  attr_readonly :clave_de_beneficiario, :efector_id, :fecha_de_la_prestacion, :prestacion_id

  # Asociaciones
  belongs_to :cuasi_factura
  belongs_to :diagnostico
  belongs_to :efector
  belongs_to :estado_de_la_prestacion
  belongs_to :nomenclador
  belongs_to :prestacion
  has_many :datos_reportables_asociados, :inverse_of => :prestacion_brindada, :order => :id
  has_and_belongs_to_many :metodos_de_validacion_fallados, :class_name => "MetodoDeValidacion"

  # Atributos anidados
  accepts_nested_attributes_for :datos_reportables_asociados

  # Validaciones
  validates_presence_of :efector_id, :estado_de_la_prestacion_id, :fecha_de_la_prestacion, :prestacion_id
  validates_presence_of :diagnostico_id, :if => :requiere_diagnostico?
  validates_presence_of :historia_clinica, :if => :requiere_historia_clinica?
  validates_presence_of :clave_de_beneficiario, :unless => :prestacion_comunitaria?
  # TODO: Ver cómo hacer para que no tome en cuenta las prestaciones anuladas
  validates_uniqueness_of(:prestacion_id,
                          :scope => [:efector_id, :fecha_de_la_prestacion, :clave_de_beneficiario],
                          :message => "crearía una prestación duplicada. Ya se registró una prestación con estos mismos datos.")
  validate :pasa_validaciones_especificas?
  validate :validar_asociacion

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
  # Métodos de validación adicionales asociados al modelo de la clase MetodoDeValidacion
  def beneficiaria_embarazada?
    beneficiaria =
    NovedadDelAfiliado.where(
      :clave_de_beneficiario => clave_de_beneficiario,
      :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
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
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P", "I"]),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not @beneficiaria
      @beneficiaria = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
    end

    return false unless @beneficiaria.embarazo_actual && @beneficiaria.semanas_de_embarazo

    return (@beneficiaria.semanas_de_embarazo < 20)
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

    return (beneficiario.edad_en_dias(fecha_de_la_prestacion) || 0) < 3
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

    return (beneficiario.edad_en_anios(fecha_de_la_prestacion) || 2) < 1
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

    return (beneficiario.edad_en_anios(fecha_de_la_prestacion) || 23) > 24
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

  # Verifica si hay datos reportables asociados obligatorios que estén incompletos
  def datos_reportables_asociados_completos?
    datos_reportables_asociados.all?{ |dra| !dra.hay_advertencias? }
  end

  # Verifica si a la fecha de registro, la prestación se encontraba vigente
  def prestacion_vigente?
    return true unless persisted?
    return fecha_de_la_prestacion >= (created_at.to_date - 120.days)
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
    return true unless persisted? && prestacion

    if prestacion
      metodos_fallados = []
      prestacion.metodos_de_validacion.where(:genera_error => false).each do |mv|
        if !eval('self.' + mv.metodo)
          metodos_fallados << mv
        end
      end
      self.metodos_de_validacion_fallados = metodos_fallados
    end

    return (metodos_fallados.size > 0 ? true : false)
  end

  # Indica si la prestación brindada falló algún método de validación
  def con_advertencias?
    metodos_de_validacion_fallados.size > 0
  end

  # CAMBIOS: Muevo las validaciones generales a métodos de validación específicos
  # y desactivo la generación de advertencias, las que pasan a persistirse en la base de datos. TODO: cleanup
#  def hay_advertencias?
#
#    # Eliminar las advertencias anteriores (si hubiera alguna)
#    @advertencias = {}
#    @datos_reportables_incompletos = false
#
#    # No verificamos advertencias si hay errores presentes
#    if errors.count > 0 || (datos_reportables_asociados && datos_reportables_asociados.any?{ |dra| dra.errors.count > 0 })
#      return false
#    end
#
#    alguna_advertencia = false
#
#    # Verificar que la fecha de la prestación tenga menos de 4 meses de la fecha de hoy
#    if fecha_de_la_prestacion < (Date.today - 120.days)
#      if @advertencias.has_key? :base
#        @advertencias[:base] << "La prestación brindada tiene más de 120 días de antigüedad con respecto a la fecha de registro"
#      else
#        @advertencias.merge! :base => ["La prestación brindada tiene más de 120 días de antigüedad con respecto a la fecha de registro"]
#      end
#      alguna_advertencia = true
#    end
#
#    # Verificar el estado de actividad del beneficiario
#    beneficiario = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
#    if beneficiario && !beneficiario.activo?(fecha_de_la_prestacion)
#      if @advertencias.has_key? :base
#        @advertencias[:base] << (
#          (beneficiario.sexo.codigo == "F" ? "La beneficiaria " : "El beneficiario ") +
#          "no se encontraba " + (beneficiario.sexo.codigo == "F" ? "activa " : "activo ") + "para la fecha de la prestación"
#        )
#      else
#        @advertencias.merge! :base => [(
#          (beneficiario.sexo.codigo == "F" ? "La beneficiaria " : "El beneficiario ") +
#          "no se encontraba " + (beneficiario.sexo.codigo == "F" ? "activa " : "activo ") + "para la fecha de la prestación"
#        )]
#      end
#      alguna_advertencia = true
#    end
#
#    if prestacion
#      prestacion.metodos_de_validacion.where(:genera_error => false).each do |mv|
#        if !eval('self.' + mv.metodo)
#          if @advertencias.has_key? :base
#            @advertencias[:base] << mv.mensaje
#          else
#            @advertencias.merge! :base => [mv.mensaje]
#          end
#          alguna_advertencia = true
#        end
#      end
#
#      # Verificar si hay advertencias relacionadas con los datos reportables asociados
#      if datos_reportables_asociados.any?{ |dra| dra.hay_advertencias? }
#        alguna_advertencia = true
#      end
#    end
#
#    return alguna_advertencia
#  end

  def prestacion_comunitaria?
    return true unless prestacion
    prestacion.comunitaria
  end

end
