# -*- encoding : utf-8 -*-
require 'usa_multi_tenant'
class NovedadDelAfiliado < ActiveRecord::Base
  extend UsaMultiTenant

  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Advertencias generadas por las validaciones
  attr_accessor :advertencias

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :apellido, :nombre, :clase_de_documento_id, :tipo_de_documento_id, :numero_de_documento
  attr_accessible :numero_de_celular, :e_mail, :sexo_id, :fecha_de_nacimiento, :es_menor
  attr_accessible :pais_de_nacimiento_id, :se_declara_indigena, :lengua_originaria_id, :tribu_originaria_id
  attr_accessible :alfabetizacion_del_beneficiario_id, :alfab_beneficiario_anios_ultimo_nivel
  attr_accessible :domicilio_calle, :domicilio_numero, :domicilio_piso, :domicilio_depto, :domicilio_manzana
  attr_accessible :domicilio_entre_calle_1, :domicilio_entre_calle_2, :telefono, :otro_telefono
  attr_accessible :domicilio_departamento_id, :domicilio_distrito_id, :domicilio_barrio_o_paraje
  attr_accessible :domicilio_codigo_postal, :observaciones, :lugar_de_atencion_habitual_id
  attr_accessible :apellido_de_la_madre, :nombre_de_la_madre, :tipo_de_documento_de_la_madre_id
  attr_accessible :numero_de_documento_de_la_madre, :alfabetizacion_de_la_madre_id, :alfab_madre_anios_ultimo_nivel
  attr_accessible :apellido_del_padre, :nombre_del_padre, :tipo_de_documento_del_padre_id
  attr_accessible :numero_de_documento_del_padre, :alfabetizacion_del_padre_id, :alfab_padre_anios_ultimo_nivel
  attr_accessible :apellido_del_tutor, :nombre_del_tutor, :tipo_de_documento_del_tutor_id
  attr_accessible :numero_de_documento_del_tutor, :alfabetizacion_del_tutor_id, :alfab_tutor_anios_ultimo_nivel
  attr_accessible :esta_embarazada, :fecha_de_la_ultima_menstruacion, :fecha_de_diagnostico_del_embarazo
  attr_accessible :semanas_de_embarazo, :fecha_probable_de_parto, :fecha_efectiva_de_parto, :score_de_riesgo
  attr_accessible :discapacidad_id, :fecha_de_la_novedad, :centro_de_inscripcion_id, :nombre_del_agente_inscriptor
  attr_accessible :observaciones_generales, :mes_y_anio_de_proceso, :mensaje_de_la_baja, :motivo_baja_beneficiario_id

  # La clave de beneficiario sólo puede registrarse al grabar la novedad
  attr_readonly :clave_de_beneficiario

  # Asociaciones
  belongs_to :motivo_baja_beneficiario
  belongs_to :tipo_de_novedad
  belongs_to :estado_de_la_novedad
  belongs_to :clase_de_documento
  belongs_to :tipo_de_documento
  #belongs_to :categoria_de_afiliado     #-- OBSOLETO
  belongs_to :sexo
  belongs_to :pais_de_nacimiento, :class_name => "Pais"
  belongs_to :lengua_originaria
  belongs_to :tribu_originaria
  belongs_to :alfabetizacion_del_beneficiario, :class_name => "NivelDeInstruccion"
  belongs_to :domicilio_departamento, :class_name => "Departamento"
  belongs_to :domicilio_distrito, :class_name => "Distrito"
  belongs_to :lugar_de_atencion_habitual, :class_name => "Efector"
  belongs_to :tipo_de_documento_de_la_madre, :class_name => "TipoDeDocumento"
  belongs_to :alfabetizacion_de_la_madre, :class_name => "NivelDeInstruccion"
  belongs_to :tipo_de_documento_del_padre, :class_name => "TipoDeDocumento"
  belongs_to :alfabetizacion_del_padre, :class_name => "NivelDeInstruccion"
  belongs_to :tipo_de_documento_del_tutor, :class_name => "TipoDeDocumento"
  belongs_to :alfabetizacion_del_tutor, :class_name => "NivelDeInstruccion"
  belongs_to :discapacidad
  belongs_to :centro_de_inscripcion
  belongs_to :creator, :class_name => "User"
  belongs_to :updater, :class_name => "User"

  # Validaciones
  validate :fechas_correctas, :unless => :es_una_baja?
  validate :es_menor_de_edad, :unless => :es_una_baja?
  validate :documentos_correctos, :unless => :es_una_baja?
  validate :datos_de_embarazo, :unless => :es_una_baja?
  validate :sin_duplicados
  validates_presence_of :tipo_de_novedad_id
  validates_presence_of :fecha_de_la_novedad, :centro_de_inscripcion_id
  validates_presence_of :observaciones_generales, :if => :es_una_baja?
  validates_presence_of :fecha_de_diagnostico_del_embarazo, :if => :embarazada?
  validates_presence_of :semanas_de_embarazo, :if => :embarazada?
  validates_numericality_of :semanas_de_embarazo, :only_integer => true, :allow_blank => true, :greater_than => 3, :less_than => 43

  # Objeto para guardar las advertencias
  @advertencias = []

  # copiar_atributos_del_afiliado
  # Copia los valores de los atributos del afiliado a esta novedad
  #
  def copiar_atributos_del_afiliado(afiliado)
    # Verificar que se pasó un afiliado válido
    return false if (!afiliado || !afiliado.kind_of?(Afiliado))

    # Obtener los atributos del afiliado, eliminar los que no se pueden asignar masivamente y los que
    # no forman parte de las novedades, y copiar los valores de los atributos restantes en esta novedad
    atributos_del_afiliado = afiliado.attributes
    atributos_del_afiliado.delete "afiliado_id"
    atributos_del_afiliado.delete "clave_de_beneficiario"
    atributos_del_afiliado.delete "categoria_de_afiliado_id"
    atributos_del_afiliado.delete "activo"
    atributos_del_afiliado.delete "mensaje_de_la_baja"
    atributos_del_afiliado.delete "motivo_de_la_baja_id"
    atributos_del_afiliado.delete "unidad_de_alta_de_datos_id"
    atributos_del_afiliado.delete "fecha_de_inscripcion"
    atributos_del_afiliado.delete "fecha_de_carga"
    atributos_del_afiliado.delete "usuario_que_carga"
    atributos_del_afiliado.delete "fecha_de_la_ultima_novedad"
    atributos_del_afiliado.delete "cobertura_efectiva_basica"
    atributos_del_afiliado.delete "efector_ceb_id"
    atributos_del_afiliado.delete "fecha_de_la_ultima_prestacion"
    atributos_del_afiliado.delete "prestacion_ceb_id"
    atributos_del_afiliado.delete "grupo_poblacional_id"
    atributos_del_afiliado.delete "devenga_capita"
    atributos_del_afiliado.delete "devenga_cantidad_de_capitas"
    self.esta_embarazada = atributos_del_afiliado.delete "embarazo_actual"
    self.attributes = atributos_del_afiliado

    # Copiar los atributos que no se pueden asignar masivamente
    self.clave_de_beneficiario = afiliado.clave_de_beneficiario
    self.es_menor = afiliado.menor?(afiliado.fecha_de_la_ultima_novedad || afiliado.fecha_de_inscripcion)
    return true
  end

  #
  # es_una_baja?
  # Indica si la novedad es una solicitud de baja
  def es_una_baja?
    tipo_de_novedad_id == TipoDeNovedad.id_del_codigo("B")
  end

  def embarazada?
    esta_embarazada && !fecha_efectiva_de_parto
  end

  def puerpera?
    esta_embarazada && fecha_efectiva_de_parto
  end

  # fechas_correctas
  # Verifica que todos los campos de fecha contengan valores lógicos
  def fechas_correctas
    error_de_fecha = false

    # Fecha de la novedad
    if fecha_de_la_novedad.present?

      # Fecha de nacimiento
      if fecha_de_nacimiento && fecha_de_la_novedad < fecha_de_nacimiento
        errors.add(:fecha_de_la_novedad, 'no puede ser anterior a la fecha de nacimiento')
        errors.add(:fecha_de_nacimiento, 'no puede ser posterior a la fecha de inscripción/modificación')
        error_de_fecha = true
      end

      # Fecha de la última menstruación
      if esta_embarazada && fecha_de_la_ultima_menstruacion && fecha_de_la_novedad < fecha_de_la_ultima_menstruacion
        errors.add(:fecha_de_la_novedad, 'no puede ser anterior a la fecha de la última menstruación')
        errors.add(:fecha_de_la_ultima_menstruacion, 'no puede ser posterior a la fecha de inscripción/modificación')
        error_de_fecha = true
      end

      # Fecha de diagnóstico del embarazo
      if esta_embarazada && fecha_de_diagnostico_del_embarazo && fecha_de_la_novedad < fecha_de_diagnostico_del_embarazo
        errors.add(:fecha_de_la_novedad, 'no puede ser anterior a la fecha de diagnóstico del embarazo')
        errors.add(:fecha_de_diagnostico_del_embarazo, 'no puede ser posterior a la fecha de inscripción/modificación')
        error_de_fecha = true
      end

      #      # Fecha probable de parto
      #      if esta_embarazada && fecha_probable_de_parto && fecha_de_la_novedad > fecha_probable_de_parto
      #        errors.add(:fecha_de_la_novedad, 'no puede ser posterior a la fecha probable de parto')
      #        errors.add(:fecha_probable_de_parto, 'no puede ser anterior a la fecha de inscripción/modificación')
      #        error_de_fecha = true
      #      end

      # Fecha de hoy
      if fecha_de_la_novedad > Date.today
        errors.add(:fecha_de_la_novedad, 'no puede ser una fecha futura')
        error_de_fecha = true
      end

      # Fecha de hoy
      if fecha_de_la_novedad < (Date.today - 4.months)
        errors.add(:fecha_de_la_novedad, 'no puede exceder en cuatro meses la fecha de hoy')
        error_de_fecha = true
      end

    end # fecha_de_la_novedad

    # Fecha de nacimiento
    if fecha_de_nacimiento.present?

      # Fecha de la última menstruación
      if esta_embarazada && fecha_de_la_ultima_menstruacion && fecha_de_nacimiento > fecha_de_la_ultima_menstruacion
        errors.add(:fecha_de_nacimiento, 'no puede ser posterior a la fecha de la última menstruación')
        errors.add(:fecha_de_la_ultima_menstruacion, 'no puede ser anterior a la fecha de nacimiento')
        error_de_fecha = true
      end

      # Fecha de diagnóstico del embarazo
      if esta_embarazada && fecha_de_diagnostico_del_embarazo && fecha_de_nacimiento > fecha_de_diagnostico_del_embarazo
        errors.add(:fecha_de_nacimiento, 'no puede ser posterior a la fecha de diagnóstico del embarazo')
        errors.add(:fecha_de_diagnostico_del_embarazo, 'no puede ser anterior a la fecha de nacimiento')
        error_de_fecha = true
      end

      # Fecha probable de parto
      if esta_embarazada && fecha_probable_de_parto && fecha_de_nacimiento > fecha_probable_de_parto
        errors.add(:fecha_de_nacimiento, 'no puede ser posterior a la fecha probable de parto')
        errors.add(:fecha_probable_de_parto, 'no puede ser anterior a la fecha de nacimiento')
        error_de_fecha = true
      end

      # Fecha de hoy
      if fecha_de_nacimiento > Date.today
        errors.add(:fecha_de_nacimiento, 'no puede ser una fecha futura')
        error_de_fecha = true
      end

      # Fecha de inscripción original cuando es una modificación
      if tipo_de_novedad_id == TipoDeNovedad.id_del_codigo("M")
        afiliado = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)
        if afiliado.present? && afiliado.fecha_de_inscripcion.present? && afiliado.fecha_de_inscripcion < fecha_de_nacimiento
          errors.add(
            :fecha_de_nacimiento,
            "no puede ser posterior a la fecha de inscripción original (#{afiliado.fecha_de_inscripcion.strftime('%d/%m/%Y')})"
          )
          error_de_fecha = true
        end
      end

    end # fecha_de_nacimiento

    # Fecha de la última menstruación
    if esta_embarazada && fecha_de_la_ultima_menstruacion.present?

      # Fecha de diagnóstico del embarazo
      if fecha_de_diagnostico_del_embarazo && fecha_de_la_ultima_menstruacion > fecha_de_diagnostico_del_embarazo
        errors.add(:fecha_de_la_ultima_menstruacion, 'no puede ser posterior a la fecha de diagnóstico del embarazo')
        errors.add(:fecha_de_diagnostico_del_embarazo, 'no puede ser anterior a la fecha de la última menstruación')
        error_de_fecha = true
      end

      # Fecha probable de parto
      if fecha_probable_de_parto.present? && fecha_de_la_ultima_menstruacion > fecha_probable_de_parto
        errors.add(:fecha_de_la_ultima_menstruacion, 'no puede ser posterior a la fecha probable de parto')
        errors.add(:fecha_probable_de_parto, 'no puede ser anterior a la fecha de la última menstruación')
        error_de_fecha = true
      end

      # Fecha de hoy
      if fecha_de_la_ultima_menstruacion > Date.today
        errors.add(:fecha_de_la_ultima_menstruacion, 'no puede ser una fecha futura')
        error_de_fecha = true
      end

    end # fecha_de_la_ultima_menstruacion

    # Fecha de diagnóstico del embarazo
    if esta_embarazada && fecha_de_diagnostico_del_embarazo.present?

      # Fecha probable de parto
      if fecha_probable_de_parto.present? && fecha_de_diagnostico_del_embarazo > fecha_probable_de_parto
        errors.add(:fecha_de_diagnostico_del_embarazo, 'no puede ser posterior a la fecha probable de parto')
        errors.add(:fecha_probable_de_parto, 'no puede ser anterior a la fecha de diagnóstico_del_embarazo')
        error_de_fecha = true
      end

      # Fecha de hoy
      if fecha_de_diagnostico_del_embarazo > Date.today
        errors.add(:fecha_de_diagnostico_del_embarazo, 'no puede ser una fecha futura')
        error_de_fecha = true
      end

    end # fecha_de_diagnostico_del_embarazo

    return !error_de_fecha

  end

  def datos_de_embarazo
    return true

    # TODO: Escribir validaciones para las fechas y semanas de gestación
  end

  # Verifica que se haya marcado el campo de menor de edad si a la fecha de la novedad aún no cumple la edad límite
  def es_menor_de_edad
    if !es_menor && fecha_de_la_novedad && fecha_de_nacimiento &&
        (fecha_de_nacimiento + Parametro.valor_del_parametro(:edad_limite_para_exigir_adulto_responsable).years) > fecha_de_la_novedad
      errors.add(
        :es_menor,
        'debe estar marcado si aún no ha cumplido los ' +
          Parametro.valor_del_parametro(:edad_limite_para_exigir_adulto_responsable).to_s + ' años'
      )
      return false
    end

    return true
  end

  # Verifica que los datos estén completos para el tipo de novedad ingresado
  def generar_advertencias
    # Eliminar las advertencias anteriores (si hubiera alguna)
    @advertencias = []

    # No verificamos advertencias si hay errores presentes
    return true if errors.count > 0

    # Advertencias de campos vacíos que generan un registro incompleto:
    if apellido.blank?
      @advertencias << "No se ingresó el apellido del beneficiario."
    end
    if nombre.blank?
      @advertencias << "No se ingresó el nombre del beneficiario."
    end
    if !clase_de_documento_id
      @advertencias << "No se seleccionó la clase de documento del beneficiario."
    end
    if !tipo_de_documento_id
      @advertencias << "No se seleccionó el tipo de documento del beneficiario."
    end
    if numero_de_documento.blank?
      @advertencias << "No se ingresó el número de documento."
    end
    if !sexo_id
      @advertencias << "No se seleccionó el sexo del beneficiario."
    end
    if !fecha_de_nacimiento
      @advertencias << "No se ingresó la fecha de nacimiento del beneficiario."
    end
    if domicilio_calle.blank? && domicilio_manzana.blank?
      @advertencias << "No se ingresó el nombre de la calle ni de la manzana en el domicilio."
    end
    if !(domicilio_calle.blank? && domicilio_manzana.blank?) && domicilio_numero.blank?
      @advertencias << "No se ingresó el número de puerta o casa en el domicilio."
    end
    if !domicilio_departamento_id
      @advertencias << "No se seleccionó el departamento de residencia del beneficiario."
    end
    if !lugar_de_atencion_habitual_id
      @advertencias << "No se seleccionó el lugar de atención habitual del beneficiario."
    end
    #COMENTADO PORQUE NO SE REQUIERE VALIDACION DE EDAD 
    #if es_menor &&
    # (apellido_de_la_madre.blank? || nombre_de_la_madre.blank? ||
    #!tipo_de_documento_de_la_madre_id || numero_de_documento_de_la_madre.blank?) &&
    # (apellido_del_padre.blank? || nombre_del_padre.blank? ||
    # !tipo_de_documento_del_padre_id || numero_de_documento_del_padre.blank?) &&
    # (apellido_del_tutor.blank? || nombre_del_tutor.blank? ||
    # !tipo_de_documento_del_tutor_id || numero_de_documento_del_tutor.blank?)
    # @advertencias << "El beneficiario es menor de edad y no se completó la información de alguno de los adultos" +
    #  " responsables (apellido, nombre, tipo y número de documento)."
    # end

    if esta_embarazada && !fecha_probable_de_parto
      @advertencias << "La beneficiaria está embarazada y no se indicó la fecha probable de parto."
    end

    return true
  end

  # pendiente?
  # Indica si la novedad está pendiente (aún no ha sido informada, ni anulada).
  def pendiente?
    estado_de_la_novedad && estado_de_la_novedad.pendiente
  end

  # categorizar
  # Devuelve la categoría de beneficiario (ahora es obsoleto, pero se mantiene aún por
  # compatibilidad).
  def categorizar
    if fecha_de_nacimiento.present?
      edad = self.edad_en_anios(fecha_de_la_novedad || Date.today)
      return 1 if edad >= 10 && sexo_id == Sexo.id_del_codigo("F") && esta_embarazada
      return 3 if edad < 1
      return 4 if edad < 6
      return 5 if edad < 20
      return 6 if edad < 64
    end

    return nil
  end

  # edad_en_anios
  # Devuelve la edad en años cumplidos para la fecha de cálculo indicada, o para el día de hoy, si no se
  # indica una fecha.
  def edad_en_anios (fecha_de_calculo = Date.today)

    # Calculamos la diferencia entre los años de ambas fechas
    if fecha_de_nacimiento
      diferencia_en_anios = (fecha_de_calculo.year - fecha_de_nacimiento.year)
    else
      return nil
    end

    # Calculamos la diferencia entre los meses de ambas fechas
    diferencia_en_meses = (fecha_de_calculo.month - fecha_de_nacimiento.month)

    # Calculamos la diferencia en días y ajustamos la diferencia en meses en forma acorde
    diferencia_en_dias = (fecha_de_calculo.day) - (fecha_de_nacimiento.day)
    if diferencia_en_dias < 0 then diferencia_en_meses -= 1 end

    # Ajustamos la diferencia en años en forma acorde
    if diferencia_en_meses < 0 then diferencia_en_anios -= 1 end

    # Devolver la cantidad de años
    return diferencia_en_anios

  end

  # edad_en_meses
  # Devuelve la edad en meses cumplidos para la fecha de cálculo indicada, o para el día de hoy, si no se
  # indica una fecha.
  def edad_en_meses(fecha_de_calculo = Date.today)

    # Calculamos la diferencia entre los años de ambas fechas
    if fecha_de_nacimiento
      diferencia_en_anios = (fecha_de_calculo.year - fecha_de_nacimiento.year)
    else
      return nil
    end

    # Calculamos la diferencia entre los meses de ambas fechas
    diferencia_en_meses = (fecha_de_calculo.month - fecha_de_nacimiento.month)

    # Calculamos la diferencia en días y ajustamos la diferencia en meses en forma acorde
    diferencia_en_dias = (fecha_de_calculo.day) - (fecha_de_nacimiento.day)
    if diferencia_en_dias < 0 then diferencia_en_meses -= 1 end

    # Ajustamos la diferencia en años en forma acorde
    if diferencia_en_meses < 0
      diferencia_en_anios -= 1
      diferencia_en_meses += 12
    end

    # Devolver la cantidad de meses cumplidos
    return (diferencia_en_anios * 12 + diferencia_en_meses)

  end

  # edad_en_dias
  # Devuelve la edad en días cumplidos para la fecha de cálculo indicada, o para el día de hoy, si no se
  # indica una fecha.
  def edad_en_dias (fecha_de_calculo = Date.today)

    # Calculamos la diferencia en días entre ambas fechas
    if fecha_de_nacimiento
      return (fecha_de_calculo - fecha_de_nacimiento).to_i
    else
      return nil
    end

  end

  def verificacion_correcta?

    # Verificamos que se hayan completado los campos obligatorios del formulario
    campo_obligatorio_vacio = false
    if apellido.blank?
      errors.add(:apellido, 'no puede estar en blanco')
      campo_obligatorio_vacio = true
    end
    if nombre.blank?
      errors.add(:nombre, 'no puede estar en blanco')
      campo_obligatorio_vacio = true
    end
    if numero_de_documento.blank?
      errors.add(:numero_de_documento, 'no puede estar en blanco')
      campo_obligatorio_vacio = true
    end
    if !fecha_de_nacimiento
      errors.add(:fecha_de_nacimiento, 'no puede estar en blanco')
      campo_obligatorio_vacio = true
    end

    return false if (campo_obligatorio_vacio || !documentos_correctos || !sin_duplicados)

    return true
  end

  def documentos_correctos

    error_de_documento = false

    # Verificar que el valor del campo número de documento sea válido, si el tipo es DNI, LC o LE
    if ( tipo_de_documento_id && numero_de_documento &&
          TipoDeDocumento.where(:codigo => ["DNI", "LE", "LC"]).collect{ |t| t.id }.member?(tipo_de_documento_id) )
      numero_de_documento.gsub!(/[^[:digit:]]/, '')
      if !numero_de_documento.blank? && (numero_de_documento.to_i < 50000 || numero_de_documento.to_i > 99999999)
        errors.add(:numero_de_documento, 'no se encuentra en el intervalo esperado (50000-99999999).')
        error_de_documento = true
      end
    end

    # Verificar que el valor del campo número de documento de la madre sea válido, si el tipo es DNI, LC o LE
    if ( tipo_de_documento_de_la_madre_id && numero_de_documento_de_la_madre &&
          TipoDeDocumento.where(:codigo => ["DNI", "LE", "LC"]).collect{ |t| t.id }.member?(tipo_de_documento_de_la_madre_id) )
      numero_de_documento_de_la_madre.gsub!(/[^[:digit:]]/, '')
      if !numero_de_documento_de_la_madre.blank? && (numero_de_documento_de_la_madre.to_i < 50000 ||
            numero_de_documento_de_la_madre.to_i > 99999999)
        errors.add(:numero_de_documento_de_la_madre, 'no se encuentra en el intervalo esperado (50000-99999999).')
        error_de_documento = true
      end
    end

    # Verificar que el valor del campo número de documento del padre sea válido, si el tipo es DNI, LC o LE
    if ( tipo_de_documento_del_padre_id && numero_de_documento_del_padre &&
          TipoDeDocumento.where(:codigo => ["DNI", "LE", "LC"]).collect{ |t| t.id }.member?(tipo_de_documento_del_padre_id) )
      numero_de_documento_del_padre.gsub!(/[^[:digit:]]/, '')
      if !numero_de_documento_del_padre.blank? && (numero_de_documento_del_padre.to_i < 50000 ||
            numero_de_documento_del_padre.to_i > 99999999)
        errors.add(:numero_de_documento_del_padre, 'no se encuentra en el intervalo esperado (50000-99999999).')
        error_de_documento = true
      end
    end

    # Verificar que el valor del campo número de documento del padre sea válido, si el tipo es DNI, LC o LE
    if ( tipo_de_documento_del_tutor_id && numero_de_documento_del_tutor &&
          TipoDeDocumento.where(:codigo => ["DNI", "LE", "LC"]).collect{ |t| t.id }.member?(tipo_de_documento_del_tutor_id) )
      numero_de_documento_del_tutor.gsub!(/[^[:digit:]]/, '')
      if !numero_de_documento_del_tutor.blank? && (numero_de_documento_del_tutor.to_i < 50000 ||
            numero_de_documento_del_tutor.to_i > 99999999)
        errors.add(:numero_de_documento_del_tutor, 'no se encuentra en el intervalo esperado (50000-99999999).')
        error_de_documento = true
      end
    end

    # Verificar que tenga menos de un año si la clase de documento seleccionada es "Ajeno" y que coincida con alguno de los documentos de los adultos responsables
    if clase_de_documento_id == ClaseDeDocumento.id_del_codigo("A")
      if fecha_de_nacimiento && fecha_de_la_novedad && edad_en_anios(fecha_de_la_novedad) > 0
        errors.add(:base,
          "No se puede crear una solicitud con documento ajeno si el niño o niña ya ha cumplido el año de vida"
        )
        error_de_documento = true
      end
      if ((!numero_de_documento_de_la_madre.blank? || !numero_de_documento_del_padre.blank? || !numero_de_documento_del_tutor.blank?) &&
            ![numero_de_documento_de_la_madre, numero_de_documento_del_padre, numero_de_documento_del_tutor].member?(numero_de_documento))
        errors.add(:base,
          "El número de documento ajeno no coincide con el número de documento de ningún adulto responsable"
        )
        error_de_documento = true
      end
    end

    return false if error_de_documento

    return true
  end

  def sin_duplicados

    # Verificaciones de números de documento propios para evitar duplicaciones por tipo y número de documento (motivo 81)
    if clase_de_documento_id == ClaseDeDocumento.id_del_codigo("P")
      # Verificar si existe en la tabla de afiliados otro beneficiario con el mismo tipo y número de documento propio
      # que no esté marcado ya como duplicado
      if tipo_de_novedad_id == TipoDeNovedad.id_del_codigo("A")
        afiliados =
          Afiliado.where(
          "clase_de_documento_id = ? AND tipo_de_documento_id = ? AND numero_de_documento = ?
            AND (motivo_de_la_baja_id IS NULL OR motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))",
          clase_de_documento_id, tipo_de_documento_id, numero_de_documento
        )
      elsif tipo_de_novedad_id == TipoDeNovedad.id_del_codigo("M")
        afiliados =
          Afiliado.where(
          "clase_de_documento_id = ? AND tipo_de_documento_id = ? AND numero_de_documento = ?
            AND (motivo_de_la_baja_id IS NULL OR motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
            AND clave_de_beneficiario != ?
            AND NOT EXISTS (
              SELECT *
                FROM novedades_de_los_afiliados na
                WHERE
                  na.clave_de_beneficiario = afiliados.clave_de_beneficiario
                  AND na.tipo_de_novedad_id = '#{TipoDeNovedad.id_del_codigo("B")}'
                  AND na.estado_de_la_novedad_id = '#{EstadoDeLaNovedad.id_del_codigo("R")}'
            )",
          clase_de_documento_id, tipo_de_documento_id, numero_de_documento, clave_de_beneficiario
        )
      end
      if (afiliados || []).size > 0
        errors.add(:base,
          "No se puede crear la solicitud porque ya existe " +
            (afiliados.first.sexo && afiliados.first.sexo.codigo == "F" ? "una beneficiaria" : "un beneficiario") +
            " con el mismo tipo y número de documento: " + afiliados.first.apellido.to_s + ", " + afiliados.first.nombre.to_s +
            ", " + (afiliados.first.tipo_de_documento ? afiliados.first.tipo_de_documento.codigo + " " : "") +
            afiliados.first.numero_de_documento.to_s + ", clave " + afiliados.first.clave_de_beneficiario.to_s +
            (afiliados.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
              afiliados.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
        )
        return false
      end

      # Verificar si existe en la tabla de novedades otro beneficiario con el mismo tipo y número de documento propio
      # que esté pendiente
      if persisted?
        novedades =
          NovedadDelAfiliado.where(
          "id != ? AND clase_de_documento_id = ? AND tipo_de_documento_id = ? AND numero_de_documento = ? AND
            estado_de_la_novedad_id IN (?) AND tipo_de_novedad_id IN (?)", id, clase_de_documento_id, tipo_de_documento_id,
          numero_de_documento, EstadoDeLaNovedad.where(:pendiente => true).collect{ |e| e.id },
          (es_una_baja? ? TipoDeNovedad.where("codigo != 'M'").collect{ |t| t.id } :
              TipoDeNovedad.where("codigo != 'B'").collect{ |t| t.id }
          )
        )
      else
        novedades =
          NovedadDelAfiliado.where(
          "clase_de_documento_id = ? AND tipo_de_documento_id = ? AND numero_de_documento = ? AND
            estado_de_la_novedad_id IN (?) AND tipo_de_novedad_id IN (?)", clase_de_documento_id, tipo_de_documento_id,
          numero_de_documento, EstadoDeLaNovedad.where(:pendiente => true).collect{ |e| e.id },
          (es_una_baja? ? TipoDeNovedad.where("codigo != 'M'").collect{ |t| t.id } :
              TipoDeNovedad.where("codigo != 'B'").collect{ |t| t.id }
          )
        )
      end
      if novedades.size > 0
        errors.add(:base,
          "No se puede crear la solicitud porque ya existe otra solicitud pendiente para el mismo tipo y número" +
            " de documento: " + novedades.first.apellido.to_s + ", " + novedades.first.nombre.to_s +
            ", " + (novedades.first.tipo_de_documento ? novedades.first.tipo_de_documento.codigo + " " : "") +
            novedades.first.numero_de_documento.to_s + ", clave " + novedades.first.clave_de_beneficiario.to_s +
            (novedades.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
              novedades.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
        )
        return false
      end
    end

    # Verificar si existe en la tabla de afiliados otro beneficiario con el mismo nombre, apellido y fecha de nacimiento
    # que no esté marcado ya como duplicado
    if tipo_de_novedad_id == TipoDeNovedad.id_del_codigo("A")
      afiliados =
        Afiliado.where(
        "apellido = ? AND nombre = ? AND fecha_de_nacimiento = ?
          AND (motivo_de_la_baja_id IS NULL OR motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))",
        apellido, nombre, fecha_de_nacimiento
      )
    elsif tipo_de_novedad_id == TipoDeNovedad.id_del_codigo("M")
      afiliados =
        Afiliado.where(
        "apellido = ? AND nombre = ? AND fecha_de_nacimiento = ?
          AND (motivo_de_la_baja_id IS NULL OR motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          AND clave_de_beneficiario != ?
          AND NOT EXISTS (
            SELECT *
              FROM novedades_de_los_afiliados na
              WHERE
                na.clave_de_beneficiario = afiliados.clave_de_beneficiario
                AND na.tipo_de_novedad_id = '#{TipoDeNovedad.id_del_codigo("B")}'
                AND na.estado_de_la_novedad_id = '#{EstadoDeLaNovedad.id_del_codigo("R")}'
          )",
        apellido, nombre, fecha_de_nacimiento, clave_de_beneficiario
      )
    end
    if (afiliados || []).size > 0
      errors.add(:base,
        "No se puede crear la solicitud porque ya existe " +
          (afiliados.first.sexo && afiliados.first.sexo.codigo == "F" ? "una beneficiaria" : "un beneficiario") +
          " con el mismo nombre, apellido y fecha de nacimiento: " + afiliados.first.apellido.to_s + ", " +
          afiliados.first.nombre.to_s + ", " +
          (afiliados.first.tipo_de_documento ? afiliados.first.tipo_de_documento.codigo + " " : "") +
          afiliados.first.numero_de_documento.to_s + ", clave " + afiliados.first.clave_de_beneficiario.to_s +
          (afiliados.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
            afiliados.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
      )
      return false
    end

    # Verificar si existe en la tabla de novedades otro beneficiario con el mismo nombre, apellido y fecha de nacimiento
    # que esté pendiente
    if persisted?
      novedades =
        NovedadDelAfiliado.where(
        "id != ? AND apellido = ? AND nombre = ? AND fecha_de_nacimiento = ? AND estado_de_la_novedad_id IN (?)
           AND tipo_de_novedad_id IN (?)", id, apellido, nombre, fecha_de_nacimiento.strftime("%Y-%m-%d"),
        EstadoDeLaNovedad.where(:pendiente => true).collect{ |e| e.id },
        (es_una_baja? ? TipoDeNovedad.where("codigo != 'M'").collect{ |t| t.id } : TipoDeNovedad.where("codigo != 'B'").collect{ |t| t.id })
      )
    else
      novedades =
        NovedadDelAfiliado.where(
        "apellido = ? AND nombre = ? AND fecha_de_nacimiento = ? AND estado_de_la_novedad_id IN (?)
           AND tipo_de_novedad_id IN (?)", apellido, nombre,
        fecha_de_nacimiento.strftime("%Y-%m-%d"), EstadoDeLaNovedad.where(:pendiente => true).collect{ |e| e.id },
        (es_una_baja? ? TipoDeNovedad.where("codigo != 'M'").collect{ |t| t.id } : TipoDeNovedad.where("codigo != 'B'").collect{ |t| t.id })
      )
    end
    if novedades.size > 0
      errors.add(:base,
        "No se puede crear la solicitud porque ya existe otra solicitud pendiente con el mismo nombre, apellido y" +
          " fecha de nacimiento: " + novedades.first.apellido.to_s + ", " + novedades.first.nombre.to_s +
          ", " + (novedades.first.tipo_de_documento ? novedades.first.tipo_de_documento.codigo + " " : "") +
          novedades.first.numero_de_documento.to_s + ", clave " + novedades.first.clave_de_beneficiario.to_s +
          (novedades.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
            novedades.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
      )
      return false
    end

    # Verificación de duplicados con el número de documento de la madre (código 83)
    if !numero_de_documento_de_la_madre.blank?
      # Verificar si existe en la tabla de afiliados otro beneficiario con el mismo nombre, fecha de nacimiento y número de
      # documento de la madre que no esté marcado ya como duplicado
      if tipo_de_novedad_id == TipoDeNovedad.id_del_codigo("A")
        afiliados =
          Afiliado.where(
          "nombre = ? AND fecha_de_nacimiento = ? AND numero_de_documento_de_la_madre = ?
            AND (motivo_de_la_baja_id IS NULL OR motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))",
          nombre, fecha_de_nacimiento, numero_de_documento_de_la_madre
        )
      elsif tipo_de_novedad_id == TipoDeNovedad.id_del_codigo("M")
        afiliados =
          Afiliado.where(
          "nombre = ? AND fecha_de_nacimiento = ? AND numero_de_documento_de_la_madre = ?
            AND (motivo_de_la_baja_id IS NULL OR motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
            AND clave_de_beneficiario != ?
            AND NOT EXISTS (
              SELECT *
                FROM novedades_de_los_afiliados na
                WHERE
                  na.clave_de_beneficiario = afiliados.clave_de_beneficiario
                  AND na.tipo_de_novedad_id = '#{TipoDeNovedad.id_del_codigo("B")}'
                  AND na.estado_de_la_novedad_id = '#{EstadoDeLaNovedad.id_del_codigo("R")}'
            )", nombre, fecha_de_nacimiento, numero_de_documento_de_la_madre, clave_de_beneficiario
        )
      end
      if (afiliados || []).size > 0
        errors.add(:base,
          "No se puede crear la solicitud porque ya existe " +
            (afiliados.first.sexo && afiliados.first.sexo.codigo == "F" ? "una beneficiaria" : "un beneficiario") +
            " con el mismo nombre, fecha de nacimiento y número de documento de la madre: " + afiliados.first.apellido.to_s +
            ", " + afiliados.first.nombre.to_s + ", " +
            (afiliados.first.tipo_de_documento ? afiliados.first.tipo_de_documento.codigo + " " : "") +
            afiliados.first.numero_de_documento.to_s + ", clave " + afiliados.first.clave_de_beneficiario.to_s +
            (afiliados.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
              afiliados.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
        )
        return false
      end

      # Verificar si existe en la tabla de novedades otro beneficiario con el mismo nombre, fecha de nacimiento y número de
      # documento de la madre que esté pendiente
      if persisted?
        novedades =
          NovedadDelAfiliado.where(
          "id != ? AND nombre = ? AND fecha_de_nacimiento = ? AND numero_de_documento_de_la_madre = ?
             AND estado_de_la_novedad_id IN (?) AND tipo_de_novedad_id IN (?)", id, nombre,
          fecha_de_nacimiento.strftime("%Y-%m-%d"), numero_de_documento_de_la_madre,
          EstadoDeLaNovedad.where(:pendiente => true).collect{ |e| e.id },
          (es_una_baja? ? TipoDeNovedad.where("codigo != 'M'").collect{ |t| t.id } : TipoDeNovedad.where("codigo != 'B'").collect{ |t| t.id })
        )
      else
        novedades =
          NovedadDelAfiliado.where(
          "nombre = ? AND fecha_de_nacimiento = ? AND numero_de_documento_de_la_madre = ? AND estado_de_la_novedad_id IN (?)
             AND tipo_de_novedad_id IN (?)", nombre, fecha_de_nacimiento.strftime("%Y-%m-%d"), numero_de_documento_de_la_madre,
          EstadoDeLaNovedad.where(:pendiente => true).collect{ |e| e.id },
          (es_una_baja? ? TipoDeNovedad.where("codigo != 'M'").collect{ |t| t.id } : TipoDeNovedad.where("codigo != 'B'").collect{ |t| t.id })
        )
      end
      if novedades.size > 0
        errors.add(:base,
          "No se puede crear la solicitud porque ya existe otra solicitud pendiente con el mismo nombre, fecha de" +
            " nacimiento y número de documento de la madre: " + novedades.first.apellido.to_s + ", " + novedades.first.nombre.to_s +
            ", " + (novedades.first.tipo_de_documento ? novedades.first.tipo_de_documento.codigo + " " : "") +
            novedades.first.numero_de_documento.to_s + ", clave " + novedades.first.clave_de_beneficiario.to_s +
            (novedades.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
              novedades.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
        )
        return false
      end
    end

    return true
  end

  #
  # self.generar_archivo_a
  # Genera el archivo de exportación de novedades de acuerdo con el formato requerido por el sistema de gestión de padrones
  # para el código de UAD, código de CI y fecha límite pasados como parámetros
  def self.generar_archivo_a(codigo_uad, codigo_ci, fecha_limite, directorio_de_destino)
    # TODO: agregar validaciones
    return nil unless codigo_uad && codigo_ci && fecha_limite && directorio_de_destino

    codigo_provincia = ('%02d' % Parametro.valor_del_parametro(:id_de_esta_provincia))

    # Ejecutar todo dentro de una transacción para así poder cancelar las modificaciones en la BD en caso de fallas
    archivo_a = nil
    begin
      #      ActiveRecord::Base.transaction do

      # Verificar si existe la secuencia antes de solicitar la generación del archivo A y crearla
      if ActiveRecord::Base::connection.exec_query("
          SELECT *
            FROM information_schema.sequences
            WHERE sequence_schema = 'uad_#{codigo_uad}' AND sequence_name = 'ci_#{codigo_ci}_archivo_a_seq';
          ").rows.size == 0
        ActiveRecord::Base::connection.execute("
            CREATE SEQUENCE uad_#{codigo_uad}.ci_#{codigo_ci}_archivo_a_seq;
          ")
      end

      # Obtener el siguiente número en la secuencia de generación de archivos A para este CI en esta UAD
      numero_secuencia =
        ActiveRecord::Base.connection.exec_query("
            SELECT
              (CASE
                WHEN is_called THEN last_value + 1
                ELSE last_value
              END) AS numero_secuencia FROM uad_#{codigo_uad}.ci_#{codigo_ci}_archivo_a_seq;
        ").rows[0][0].to_i

      # Crear el archivo de texto de salida
      archivo_a = File.new("#{directorio_de_destino}/A#{codigo_provincia.to_s + codigo_uad + codigo_ci + ('%05d' % numero_secuencia)}.txt", "w")
      archivo_a.set_encoding("CP1252", :crlf_newline => true)

      # Escribir el encabezado
      archivo_a.puts(
        "H\t" +
          Date.today.strftime("%Y-%m-%d") + "\t" +
          "admin\t" +
          codigo_provincia + "\t" +
          codigo_uad + "\t" +
          codigo_ci + "\t" +
          ('%05d' % numero_secuencia) + "\t" +
          Parametro.valor_del_parametro(:version_del_sistema_de_gestion)
      )

      # Obtener los registros de novedades
      novedades =
        ActiveRecord::Base.connection.exec_query "
            SELECT
              'D'::text AS \"TipoRegistro\",
              n1.clave_de_beneficiario AS \"ClaveBeneficiario\",
              REGEXP_REPLACE(LEFT(n1.apellido, 30), E'\\t', '', 'g') AS \"BenefApellido\",
              REGEXP_REPLACE(LEFT(n1.nombre, 30), E'\\t', '', 'g') AS \"BenefNombre\",
              t1.codigo AS \"BenefTipoDocumento\",
              c1.codigo AS \"BenefClaseDocumento\",
              REGEXP_REPLACE(LEFT(n1.numero_de_documento, 12), E'\\t', '', 'g') AS \"BenefNroDocumento\",
              s1.codigo AS \"BenefSexo\",
              n1.categoria_de_afiliado_id AS \"BenefIdCategoria\",
              n1.fecha_de_nacimiento AS \"BenefFechaNacimiento\",
              s2.codigo AS \"Indigena\",
              n1.lengua_originaria_id AS \"Id_Lengua\",
              n1.tribu_originaria_id AS \"Id_PuebloOriginario\",
              t2.codigo AS \"MadreTipoDoc\",
              REGEXP_REPLACE(LEFT(n1.numero_de_documento_de_la_madre, 12), E'\\t', '', 'g') AS \"MadreNroDoc\",
              REGEXP_REPLACE(LEFT(n1.apellido_de_la_madre, 30), E'\\t', '', 'g') AS \"MadreApellido\",
              REGEXP_REPLACE(LEFT(n1.nombre_de_la_madre, 30), E'\\t', '', 'g') AS \"MadreNombre\",
              t3.codigo AS \"PadreTipoDoc\",
              REGEXP_REPLACE(LEFT(n1.numero_de_documento_del_padre, 12), E'\\t', '', 'g') AS \"PadreNroDoc\",
              REGEXP_REPLACE(LEFT(n1.apellido_del_padre, 30), E'\\t', '', 'g') AS \"PadreApellido\",
              REGEXP_REPLACE(LEFT(n1.nombre_del_padre, 30), E'\\t', '', 'g') AS \"PadreNombre\",
              t4.codigo AS \"TutorTipoDoc\",
              REGEXP_REPLACE(LEFT(n1.numero_de_documento_del_tutor, 12), E'\\t', '', 'g') AS \"TutorNroDoc\",
              REGEXP_REPLACE(LEFT(n1.apellido_del_tutor, 30), E'\\t', '', 'g') AS \"TutorApellido\",
              REGEXP_REPLACE(LEFT(n1.nombre_del_tutor, 30), E'\\t', '', 'g') AS \"TutorNombre\",
              NULL::text AS \"TutorTipoRelacion\",
              (CASE
                WHEN tn.codigo = 'A' THEN
                  n1.fecha_de_la_novedad
                ELSE
                  af.fecha_de_inscripcion
              END) AS \"FechaDeInscripcion\",
              NULL::date AS \"FechaAltaEfectiva\",
              n1.fecha_de_diagnostico_del_embarazo AS \"FechaDiagnosticoEmbarazo\",
              n1.semanas_de_embarazo AS \"SemanasEmbarazo\",
              n1.fecha_probable_de_parto AS \"FechaProbableParto\",
              n1.fecha_efectiva_de_parto AS \"FechaEfectivaParto\",
              'S'::text AS \"Activo\",
              REGEXP_REPLACE(LEFT(n1.domicilio_calle, 40), E'\\t', '', 'g') AS \"DomicilioCalle\",
              REGEXP_REPLACE(LEFT(n1.domicilio_numero, 5), E'\\t', '', 'g') AS \"DomicilioNro\",
              REGEXP_REPLACE(LEFT(n1.domicilio_manzana, 5), E'\\t', '', 'g') AS \"DomicilioManzana\",
              REGEXP_REPLACE(LEFT(n1.domicilio_piso, 5), E'\\t', '', 'g') AS \"DomicilioPiso\",
              REGEXP_REPLACE(LEFT(n1.domicilio_depto, 5), E'\\t', '', 'g') AS \"DomicilioDepto\",
              REGEXP_REPLACE(LEFT(n1.domicilio_entre_calle_1, 40), E'\\t', '', 'g') AS \"DomEntreCalle1\",
              REGEXP_REPLACE(LEFT(n1.domicilio_entre_calle_2, 40), E'\\t', '', 'g') AS \"DomEntreCalle2\",
              REGEXP_REPLACE(LEFT(n1.domicilio_barrio_o_paraje, 40), E'\\t', '', 'g') AS \"DomBarrio\",
              UPPER(LEFT(d1.nombre, 40)) AS \"DomMunicipio\",
              UPPER(LEFT(d1.nombre, 40)) AS \"DomDepartamento\",
              UPPER(LEFT(d2.nombre, 40)) AS \"DomLocalidad\",
              REGEXP_REPLACE(LEFT(n1.domicilio_codigo_postal, 8), E'\\t', '', 'g') AS \"DomCodigoPostal\",
              '#{codigo_provincia}'::text AS \"DomIdProvincia\",
              REGEXP_REPLACE(n1.telefono, E'\\t', '', 'g') AS \"Telefono\",
              e1.cuie AS \"LugarAtencionHabitual\",
              e1.cuie AS \"CUIEfectorAsignado\",
              n1.id AS \"Id_Novedad\",
              tn.codigo AS \"TipoNovedad\",
              n1.fecha_de_la_novedad AS \"FechaNovedad\",
              '#{codigo_provincia}'::text AS \"CodigoProvinciaAltaDatos\",
              '#{codigo_uad}'::text AS \"CodigoUADAltaDatos\",
              ci.codigo AS \"CodigoCIAltaDatos\",
              n1.created_at::date AS \"FechaCarga\",
              LEFT(n1.creator_id::text, 10) AS \"UsuarioCarga\",
              NULL::text AS \"Checksum\",
              (CASE
                WHEN tn.codigo = 'M' THEN
                  '1111111111111111111111100011111111111111111111111111111111111100000000'::text
                ELSE
                  NULL::text
              END) AS \"ClaveBinaria\",
              n1.score_de_riesgo AS \"ScoreDeRiesgo\",
              n2.codigo AS \"BenefAlfabetizacion\",
              n1.alfab_beneficiario_anios_ultimo_nivel AS \"BenefAlfabetAniosUltimoNivel\",
              n3.codigo AS \"MadreAlfabetizacion\",
              n1.alfab_madre_anios_ultimo_nivel AS \"MadreAlfabetAniosUltimoNivel\",
              n4.codigo AS \"PadreAlfabetizacion\",
              n1.alfab_padre_anios_ultimo_nivel AS \"PadreAlfabetAniosUltimoNivel\",
              n5.codigo AS \"TutorAlfabetizacion\",
              n1.alfab_tutor_anios_ultimo_nivel AS \"TutorAlfabetAniosUltimoNivel\",
              n1.e_mail AS \"Email\",
              REGEXP_REPLACE(LEFT(n1.numero_de_celular, 20), E'\\t', '', 'g') AS \"NumeroCelular\",
              n1.fecha_de_la_ultima_menstruacion AS \"FUM\",
              REGEXP_REPLACE(
                (CASE
                  WHEN LENGTH(n1.observaciones) > 0 THEN
                    LEFT(
                      '--DOMICILIO: '::text ||
                      REGEXP_REPLACE(n1.observaciones, E'\\r\\n', '~', 'g') ||
                      ' --~'::text ||
                      REGEXP_REPLACE(COALESCE(n1.observaciones_generales, ''), E'\\r\\n', '~', 'g'), 200
                    )
                  ELSE
                    LEFT(REGEXP_REPLACE(COALESCE(n1.observaciones_generales, ''), E'\\r\\n', '~', 'g'), 200)
                END),
                E'\\t', '', 'g'
              ) AS \"ObservacionesGenerales\",
              d3.codigo AS \"Discapacidad\",
              UPPER(LEFT(p1.nombre, 40)) AS \"AfiPais\"
              FROM uad_#{codigo_uad}.novedades_de_los_afiliados AS n1
                LEFT JOIN tipos_de_documentos t1
                  ON (t1.id = n1.tipo_de_documento_id)
                LEFT JOIN clases_de_documentos c1
                  ON (c1.id = n1.clase_de_documento_id)
                LEFT JOIN sexos s1
                  ON (s1.id = n1.sexo_id)
                LEFT JOIN si_no s2
                  ON (s2.valor_bool = n1.se_declara_indigena)
                LEFT JOIN tipos_de_documentos t2
                  ON (t2.id = n1.tipo_de_documento_de_la_madre_id)
                LEFT JOIN tipos_de_documentos t3
                  ON (t3.id = n1.tipo_de_documento_del_padre_id)
                LEFT JOIN tipos_de_documentos t4
                  ON (t4.id = n1.tipo_de_documento_del_tutor_id)
                LEFT JOIN departamentos d1
                  ON (d1.id = n1.domicilio_departamento_id)
                LEFT JOIN distritos d2
                  ON (d2.id = n1.domicilio_distrito_id)
                LEFT JOIN efectores e1
                  ON (e1.id = n1.lugar_de_atencion_habitual_id)
                LEFT JOIN niveles_de_instruccion n2
                  ON (n2.id = n1.alfabetizacion_del_beneficiario_id)
                LEFT JOIN niveles_de_instruccion n3
                  ON (n3.id = n1.alfabetizacion_de_la_madre_id)
                LEFT JOIN niveles_de_instruccion n4
                  ON (n4.id = n1.alfabetizacion_del_padre_id)
                LEFT JOIN niveles_de_instruccion n5
                  ON (n5.id = n1.alfabetizacion_del_tutor_id)
                LEFT JOIN discapacidades d3
                  ON (d3.id = n1.discapacidad_id)
                LEFT JOIN paises p1
                  ON (p1.id = n1.pais_de_nacimiento_id)
                LEFT JOIN centros_de_inscripcion ci
                  ON (ci.id = n1.centro_de_inscripcion_id)
                LEFT JOIN tipos_de_novedades tn
                  ON (tn.id = n1.tipo_de_novedad_id)
                LEFT JOIN estados_de_las_novedades en
                  ON (en.id = n1.estado_de_la_novedad_id)
                LEFT JOIN afiliados af
                  ON (af.clave_de_beneficiario = n1.clave_de_beneficiario)
              WHERE
                ci.codigo = '#{codigo_ci}'
                AND en.codigo = 'R'
                AND tn.codigo != 'B'
                AND n1.fecha_de_la_novedad < '#{fecha_limite.strftime('%Y-%m-%d')}';
      "

      # Actualizar el estado de los registros exportados
      estado = EstadoDeLaNovedad.id_del_codigo("P")
      ActiveRecord::Base.connection.exec_query "
          UPDATE uad_#{codigo_uad}.novedades_de_los_afiliados
            SET
              estado_de_la_novedad_id = '#{estado}',
              mes_y_anio_de_proceso = '#{(fecha_limite - 1.month).strftime('%Y-%m-%d')}'
            WHERE
              estado_de_la_novedad_id = (SELECT id FROM estados_de_las_novedades WHERE codigo = 'R')
              AND centro_de_inscripcion_id = (SELECT id FROM centros_de_inscripcion WHERE codigo = '#{codigo_ci}')
              AND tipo_de_novedad_id != (SELECT id FROM tipos_de_novedades WHERE codigo = 'B')
              AND fecha_de_la_novedad < '#{fecha_limite.strftime('%Y-%m-%d')}';
      "

      # Exportar los registros al archivo
      novedades.rows.each do |novedad|
        # Agrego un bloque begin porque parece que algunos caracteres Unicode no pueden grabarse en CP1252 y falla el puts
        begin
          archivo_a.puts novedad.join("\t")
        rescue
          byebug
          novedad.DomicilioCalle =   novedad.DomicilioCalle.encode('CP1252', :invalid => :replace, :undef => :replace)
            
          #intento de recuperacion
          begin
            
          rescue
              
            
          end
          
          
          archivo_a.puts "D\t9999999999999999\tNo se puede grabar el registro\tHay caracteres UNICODE que no pueden convertirse"
        end
      end

      # Escribir el pie
      archivo_a.puts "T\t#{('%06d' % novedades.rows.size)}"

      # Cerrar el archivo
      archivo_a.close

      # Incrementar el número de secuencia si todo fue bien
      ActiveRecord::Base.connection.exec_query("
          SELECT nextval('uad_#{codigo_uad}.ci_#{codigo_ci}_archivo_a_seq'::regclass);
        ")
      #      end
    rescue
      return nil
    end

    return archivo_a ? archivo_a.path : nil

  end

  
  
  
  #La idea es generar todos los archivos A en uno solo.
  def self.generar_archivo_a_unico(uads, fecha_limite,directorio_de_destino)
    # TODO: agregar validaciones

    return nil unless uads && fecha_limite && directorio_de_destino
    
    
    codigo_provincia = ('%02d' % Parametro.valor_del_parametro(:id_de_esta_provincia))
    
    # Ejecutar todo dentro de una transacción para así poder cancelar las modificaciones en la BD en caso de fallas
    archivo_a = nil
    
    # Verificar si existe la secuencia antes de solicitar la generación del archivo A y crearla
    if ActiveRecord::Base::connection.exec_query("
    SELECT *
        FROM information_schema.sequences
        WHERE sequence_schema = 'public' AND sequence_name = 'archivo_a_seq';
        ").rows.size == 0
      ActiveRecord::Base::connection.execute("
        CREATE SEQUENCE public.archivo_a_seq;
        ")
    end
    
    # Obtener el siguiente número en la secuencia de generación de archivos A para este CI en esta UAD
    numero_secuencia =
      ActiveRecord::Base.connection.exec_query("
          SELECT
            (CASE
              WHEN is_called THEN last_value + 1
              ELSE last_value
              END) AS numero_secuencia FROM public.archivo_a_seq;
      ").rows[0][0].to_i
    
    
    
    
    
  
        
    
    
    begin
      
      # Crear el archivo de texto de salida
      archivo_a = File.new("#{directorio_de_destino}/A#{codigo_provincia.to_s + ('%05d' % numero_secuencia)}.txt", "w")
      archivo_a.set_encoding("CP1252", :crlf_newline => true)
    
      size = 0;
      
        # Escribir el encabezado
      archivo_a.puts(
        "H\t" +
          Date.today.strftime("%Y-%m-%d") + "\t" +
          "admin\t" +
          codigo_provincia + "\t" +
          ('%05d' % numero_secuencia) + "\t" +
          Parametro.valor_del_parametro(:version_del_sistema_de_gestion)
      )
      
      uads.each do |uad|
     
        uad.codigos_de_CIs_con_novedades(fecha_limite).each do |codigo_ci|
               
          # Obtener los registros de novedades
          novedades =
            ActiveRecord::Base.connection.exec_query "
            SELECT
              'D'::text AS \"TipoRegistro\",
              n1.clave_de_beneficiario AS \"ClaveBeneficiario\",
              REGEXP_REPLACE(LEFT(n1.apellido, 30), E'\\t', '', 'g') AS \"BenefApellido\",
              REGEXP_REPLACE(LEFT(n1.nombre, 30), E'\\t', '', 'g') AS \"BenefNombre\",
              t1.codigo AS \"BenefTipoDocumento\",
              c1.codigo AS \"BenefClaseDocumento\",
              REGEXP_REPLACE(LEFT(n1.numero_de_documento, 12), E'\\t', '', 'g') AS \"BenefNroDocumento\",
              s1.codigo AS \"BenefSexo\",
              n1.categoria_de_afiliado_id AS \"BenefIdCategoria\",
              n1.fecha_de_nacimiento AS \"BenefFechaNacimiento\",
              s2.codigo AS \"Indigena\",
              n1.lengua_originaria_id AS \"Id_Lengua\",
              n1.tribu_originaria_id AS \"Id_PuebloOriginario\",
              t2.codigo AS \"MadreTipoDoc\",
              REGEXP_REPLACE(LEFT(n1.numero_de_documento_de_la_madre, 12), E'\\t', '', 'g') AS \"MadreNroDoc\",
              REGEXP_REPLACE(LEFT(n1.apellido_de_la_madre, 30), E'\\t', '', 'g') AS \"MadreApellido\",
              REGEXP_REPLACE(LEFT(n1.nombre_de_la_madre, 30), E'\\t', '', 'g') AS \"MadreNombre\",
              t3.codigo AS \"PadreTipoDoc\",
              REGEXP_REPLACE(LEFT(n1.numero_de_documento_del_padre, 12), E'\\t', '', 'g') AS \"PadreNroDoc\",
              REGEXP_REPLACE(LEFT(n1.apellido_del_padre, 30), E'\\t', '', 'g') AS \"PadreApellido\",
              REGEXP_REPLACE(LEFT(n1.nombre_del_padre, 30), E'\\t', '', 'g') AS \"PadreNombre\",
              t4.codigo AS \"TutorTipoDoc\",
              REGEXP_REPLACE(LEFT(n1.numero_de_documento_del_tutor, 12), E'\\t', '', 'g') AS \"TutorNroDoc\",
              REGEXP_REPLACE(LEFT(n1.apellido_del_tutor, 30), E'\\t', '', 'g') AS \"TutorApellido\",
              REGEXP_REPLACE(LEFT(n1.nombre_del_tutor, 30), E'\\t', '', 'g') AS \"TutorNombre\",
              NULL::text AS \"TutorTipoRelacion\",
              (CASE
                WHEN tn.codigo = 'A' THEN
                  n1.fecha_de_la_novedad
                ELSE
                  af.fecha_de_inscripcion
              END) AS \"FechaDeInscripcion\",
              NULL::date AS \"FechaAltaEfectiva\",
              n1.fecha_de_diagnostico_del_embarazo AS \"FechaDiagnosticoEmbarazo\",
              n1.semanas_de_embarazo AS \"SemanasEmbarazo\",
              n1.fecha_probable_de_parto AS \"FechaProbableParto\",
              n1.fecha_efectiva_de_parto AS \"FechaEfectivaParto\",
              'S'::text AS \"Activo\",
              REGEXP_REPLACE(LEFT(n1.domicilio_calle, 40), E'\\t', '', 'g') AS \"DomicilioCalle\",
              REGEXP_REPLACE(LEFT(n1.domicilio_numero, 5), E'\\t', '', 'g') AS \"DomicilioNro\",
              REGEXP_REPLACE(LEFT(n1.domicilio_manzana, 5), E'\\t', '', 'g') AS \"DomicilioManzana\",
              REGEXP_REPLACE(LEFT(n1.domicilio_piso, 5), E'\\t', '', 'g') AS \"DomicilioPiso\",
              REGEXP_REPLACE(LEFT(n1.domicilio_depto, 5), E'\\t', '', 'g') AS \"DomicilioDepto\",
              REGEXP_REPLACE(LEFT(n1.domicilio_entre_calle_1, 40), E'\\t', '', 'g') AS \"DomEntreCalle1\",
              REGEXP_REPLACE(LEFT(n1.domicilio_entre_calle_2, 40), E'\\t', '', 'g') AS \"DomEntreCalle2\",
              REGEXP_REPLACE(LEFT(n1.domicilio_barrio_o_paraje, 40), E'\\t', '', 'g') AS \"DomBarrio\",
              UPPER(LEFT(d1.nombre, 40)) AS \"DomMunicipio\",
              UPPER(LEFT(d1.nombre, 40)) AS \"DomDepartamento\",
              UPPER(LEFT(d2.nombre, 40)) AS \"DomLocalidad\",
              REGEXP_REPLACE(LEFT(n1.domicilio_codigo_postal, 8), E'\\t', '', 'g') AS \"DomCodigoPostal\",
              '#{codigo_provincia}'::text AS \"DomIdProvincia\",
              REGEXP_REPLACE(n1.telefono, E'\\t', '', 'g') AS \"Telefono\",
              e1.cuie AS \"LugarAtencionHabitual\",
              e1.cuie AS \"CUIEfectorAsignado\",
              n1.id AS \"Id_Novedad\",
              tn.codigo AS \"TipoNovedad\",
              n1.fecha_de_la_novedad AS \"FechaNovedad\",
              '#{codigo_provincia}'::text AS \"CodigoProvinciaAltaDatos\",
              '#{uad.codigo}'::text AS \"CodigoUADAltaDatos\",
              ci.codigo AS \"CodigoCIAltaDatos\",
              n1.created_at::date AS \"FechaCarga\",
              LEFT(n1.creator_id::text, 10) AS \"UsuarioCarga\",
              NULL::text AS \"Checksum\",
              (CASE
                WHEN tn.codigo = 'M' THEN
                  '1111111111111111111111100011111111111111111111111111111111111100000000'::text
                ELSE
                  NULL::text
              END) AS \"ClaveBinaria\",
              n1.score_de_riesgo AS \"ScoreDeRiesgo\",
              n2.codigo AS \"BenefAlfabetizacion\",
              n1.alfab_beneficiario_anios_ultimo_nivel AS \"BenefAlfabetAniosUltimoNivel\",
              n3.codigo AS \"MadreAlfabetizacion\",
              n1.alfab_madre_anios_ultimo_nivel AS \"MadreAlfabetAniosUltimoNivel\",
              n4.codigo AS \"PadreAlfabetizacion\",
              n1.alfab_padre_anios_ultimo_nivel AS \"PadreAlfabetAniosUltimoNivel\",
              n5.codigo AS \"TutorAlfabetizacion\",
              n1.alfab_tutor_anios_ultimo_nivel AS \"TutorAlfabetAniosUltimoNivel\",
              n1.e_mail AS \"Email\",
              REGEXP_REPLACE(LEFT(n1.numero_de_celular, 20), E'\\t', '', 'g') AS \"NumeroCelular\",
              n1.fecha_de_la_ultima_menstruacion AS \"FUM\",
              REGEXP_REPLACE(
                (CASE
                  WHEN LENGTH(n1.observaciones) > 0 THEN
                    LEFT(
                      '--DOMICILIO: '::text ||
                      REGEXP_REPLACE(n1.observaciones, E'\\r\\n', '~', 'g') ||
                      ' --~'::text ||
                      REGEXP_REPLACE(COALESCE(n1.observaciones_generales, ''), E'\\r\\n', '~', 'g'), 200
                    )
                  ELSE
                    LEFT(REGEXP_REPLACE(COALESCE(n1.observaciones_generales, ''), E'\\r\\n', '~', 'g'), 200)
                END),
                E'\\t', '', 'g'
              ) AS \"ObservacionesGenerales\",
              d3.codigo AS \"Discapacidad\",
              UPPER(LEFT(p1.nombre, 40)) AS \"AfiPais\"
              FROM uad_#{uad.codigo}.novedades_de_los_afiliados AS n1
                LEFT JOIN tipos_de_documentos t1
                  ON (t1.id = n1.tipo_de_documento_id)
                LEFT JOIN clases_de_documentos c1
                  ON (c1.id = n1.clase_de_documento_id)
                LEFT JOIN sexos s1
                  ON (s1.id = n1.sexo_id)
                LEFT JOIN si_no s2
                  ON (s2.valor_bool = n1.se_declara_indigena)
                LEFT JOIN tipos_de_documentos t2
                  ON (t2.id = n1.tipo_de_documento_de_la_madre_id)
                LEFT JOIN tipos_de_documentos t3
                  ON (t3.id = n1.tipo_de_documento_del_padre_id)
                LEFT JOIN tipos_de_documentos t4
                  ON (t4.id = n1.tipo_de_documento_del_tutor_id)
                LEFT JOIN departamentos d1
                  ON (d1.id = n1.domicilio_departamento_id)
                LEFT JOIN distritos d2
                  ON (d2.id = n1.domicilio_distrito_id)
                LEFT JOIN efectores e1
                  ON (e1.id = n1.lugar_de_atencion_habitual_id)
                LEFT JOIN niveles_de_instruccion n2
                  ON (n2.id = n1.alfabetizacion_del_beneficiario_id)
                LEFT JOIN niveles_de_instruccion n3
                  ON (n3.id = n1.alfabetizacion_de_la_madre_id)
                LEFT JOIN niveles_de_instruccion n4
                  ON (n4.id = n1.alfabetizacion_del_padre_id)
                LEFT JOIN niveles_de_instruccion n5
                  ON (n5.id = n1.alfabetizacion_del_tutor_id)
                LEFT JOIN discapacidades d3
                  ON (d3.id = n1.discapacidad_id)
                LEFT JOIN paises p1
                  ON (p1.id = n1.pais_de_nacimiento_id)
                LEFT JOIN centros_de_inscripcion ci
                  ON (ci.id = n1.centro_de_inscripcion_id)
                LEFT JOIN tipos_de_novedades tn
                  ON (tn.id = n1.tipo_de_novedad_id)
                LEFT JOIN estados_de_las_novedades en
                  ON (en.id = n1.estado_de_la_novedad_id)
                LEFT JOIN afiliados af
                  ON (af.clave_de_beneficiario = n1.clave_de_beneficiario)
              WHERE
                ci.codigo = '#{codigo_ci}'
                AND en.codigo = 'R'
                AND tn.codigo != 'B'
                AND n1.fecha_de_la_novedad < '#{fecha_limite.strftime('%Y-%m-%d')}';
          "

          # Actualizar el estado de los registros exportados
          estado = EstadoDeLaNovedad.id_del_codigo("P")
          ActiveRecord::Base.connection.exec_query "
          UPDATE uad_#{uad.codigo}.novedades_de_los_afiliados
            SET
              estado_de_la_novedad_id = '#{estado}',     
              mes_y_anio_de_proceso = '#{(fecha_limite - 1.month).strftime('%Y-%m-%d')}'
            WHERE
              estado_de_la_novedad_id = (SELECT id FROM estados_de_las_novedades WHERE codigo = 'R')
              AND centro_de_inscripcion_id = (SELECT id FROM centros_de_inscripcion WHERE codigo = '#{codigo_ci}')
              AND tipo_de_novedad_id != (SELECT id FROM tipos_de_novedades WHERE codigo = 'B')
              AND fecha_de_la_novedad < '#{fecha_limite.strftime('%Y-%m-%d')}';
          "

          # Exportar los registros al archivo
          novedades.rows.each do |novedad|
            # Agrego un bloque begin porque parece que algunos caracteres Unicode no pueden grabarse en CP1252 y falla el puts
            begin
              archivo_a.puts novedad.join("\t")
            rescue
              
             
              #intento de recuperacion
              begin
                novedad.DomicilioCalle =   novedad.DomicilioCalle.encode('CP1252', :invalid => :replace, :undef => :replace)       
                archivo_a.puts novedad.join("\t")
              rescue
                
                archivo_a.puts "D\t9999999999999999\tNo se puede grabar el registro\tHay un error desconocido"
              end
          
          
              archivo_a.puts "D\t9999999999999999\tNo se puede grabar el registro\tHay caracteres UNICODE que no pueden convertirse"
            end
          end
          
           size = size + novedades.rows.size 
        end 
         
      end
    
      # Cerrar el archivo
      # Incrementar el número de secuencia si todo fue bien  
      ActiveRecord::Base.connection.exec_query("
          SELECT nextval('public.archivo_a_seq'::regclass);
        ")  
      
      # Escribir el pie
 
      archivo_a.puts "T\t#{('%06d' % size)}"  
       
 
    
      archivo_a.close
    
      return archivo_a ? archivo_a.path : nil
      
      
    rescue
     
      return nil
    end
        
    

  end

  
  
  #
  # self.con_estado
  # Devuelve los registros filtrados de acuerdo con el ID de estado pasado como parámetro
  def self.con_estado(id_de_estado)
    where(:estado_de_la_novedad_id => id_de_estado)
  end

  def grupo_poblacional_al_dia(fecha_de_la_prestacion = Date.today)

    if edad_en_anios(fecha_de_la_prestacion) < 6
      return GrupoPoblacional.find_by_codigo("A")
    elsif (6..9) === edad_en_anios(fecha_de_la_prestacion)
      return GrupoPoblacional.find_by_codigo("B")
    elsif (10..19) === edad_en_anios(fecha_de_la_prestacion)
      return GrupoPoblacional.find_by_codigo("C")
    elsif sexo.codigo == "F" && (20..64) === edad_en_anios(fecha_de_la_prestacion)
      return GrupoPoblacional.find_by_codigo("D")
    elsif sexo.codigo == "M" && (20..64) === edad_en_anios(fecha_de_la_prestacion)
      return GrupoPoblacional.find_by_codigo("E")
    end

  end

  def estaba_embarazada?(fecha = Date.today)
    # Verificar si coincide la fecha con los datos del embarazo registrados actualmente en esta novedad
    if (esta_embarazada && fecha_probable_de_parto)
      return true if (fecha >= (fecha_probable_de_parto - 40.weeks) && fecha < (fecha_probable_de_parto + 6.weeks))
    end

    # En el caso de modificaciones de datos, verificar si existe algún periodo de embarazo registrado que coincida con la fecha
    if tipo_de_novedad.codigo == "M"
      Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario).periodos_de_embarazo.each do |pe|
        return true if (fecha >= (pe.fecha_probable_de_parto - 40.weeks) && fecha < (pe.fecha_probable_de_parto + 6.weeks))
      end
    end
    return false
  end

  def embarazo_actual
    esta_embarazada
  end

end
