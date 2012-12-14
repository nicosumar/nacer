# -*- encoding : utf-8 -*-
class NovedadDelAfiliado < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Advertencias generadas por las validaciones
  attr_accessor :advertencias

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :apellido, :nombre, :clase_de_documento_id, :tipo_de_documento_id, :numero_de_documento
  attr_accessible :numero_de_celular, :e_mail, :sexo_id, :fecha_de_nacimiento, :es_menor
  attr_accessible :pais_de_nacimiento_id, :se_declara_indigena, :lengua_originaria_id, :tribu_originaria_id
  attr_accessible :alfabetizacion_del_beneficiario_id, :alfab_beneficiario_años_ultimo_nivel
  attr_accessible :domicilio_calle, :domicilio_numero, :domicilio_piso, :domicilio_depto, :domicilio_manzana
  attr_accessible :domicilio_entre_calle_1, :domicilio_entre_calle_2, :telefono, :otro_telefono
  attr_accessible :domicilio_departamento_id, :domicilio_distrito_id, :domicilio_barrio_o_paraje
  attr_accessible :domicilio_codigo_postal, :observaciones, :lugar_de_atencion_habitual_id
  attr_accessible :apellido_de_la_madre, :nombre_de_la_madre, :tipo_de_documento_de_la_madre_id
  attr_accessible :numero_de_documento_de_la_madre, :alfabetizacion_de_la_madre_id, :alfab_madre_años_ultimo_nivel
  attr_accessible :apellido_del_padre, :nombre_del_padre, :tipo_de_documento_del_padre_id
  attr_accessible :numero_de_documento_del_padre, :alfabetizacion_del_padre_id, :alfab_padre_años_ultimo_nivel
  attr_accessible :apellido_del_tutor, :nombre_del_tutor, :tipo_de_documento_del_tutor_id
  attr_accessible :numero_de_documento_del_tutor, :alfabetizacion_del_tutor_id, :alfab_tutor_años_ultimo_nivel
  attr_accessible :esta_embarazada, :fecha_de_la_ultima_menstruacion, :fecha_de_diagnostico_del_embarazo
  attr_accessible :semanas_de_embarazo, :fecha_probable_de_parto, :fecha_efectiva_de_parto, :score_de_riesgo
  attr_accessible :discapacidad_id, :fecha_de_la_novedad, :centro_de_inscripcion_id, :nombre_del_agente_inscriptor
  attr_accessible :observaciones_generales

  # La clave de beneficiario sólo puede registrarse al grabar la novedad
  attr_readonly :clave_de_beneficiario

  # Asociaciones
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

  # Validaciones
  validate :generar_advertencias
  validate :verificar_fechas
  validate :verificar_documentos_de_identidad
  validates_presence_of :tipo_de_novedad_id, :clave_de_beneficiario
  validates_presence_of :fecha_de_la_novedad, :centro_de_inscripcion_id
  validates_numericality_of :semanas_de_embarazo, :only_integer => true, :allow_blank => true, :greater_than => 3, :less_than => 43

  # Objeto para guardar las advertencias
  @advertencias

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
    self.attributes = atributos_del_afiliado

    # Copiar los atributos que no se pueden asignar masivamente
    self.clave_de_beneficiario = afiliado.clave_de_beneficiario
    self.es_menor = afiliado.menor?(afiliado.fecha_de_la_ultima_novedad || afiliado.fecha_de_inscripcion)
    self.esta_embarazada = afiliado.embarazada?(afiliado.fecha_de_la_ultima_novedad ||
      afiliado.fecha_de_diagnostico_del_embarazo || afiliado.fecha_de_inscripcion)
    return true
  end

  # verificar_fechas
  # Verifica que todos los campos de fecha contengan valores lógicos
  def verificar_fechas
    error_de_fecha = false

    # Fecha de la novedad
    if fecha_de_la_novedad

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
      if fecha_de_la_novedad < (Date.today - 2.months)
        errors.add(:fecha_de_la_novedad, 'no puede exceder en dos meses la fecha de hoy')
        error_de_fecha = true
      end

    end # fecha_de_la_novedad

    # Fecha de nacimiento
    if fecha_de_nacimiento

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

    end # fecha_de_nacimiento

    # Fecha de la última menstruación
    if esta_embarazada && fecha_de_la_ultima_menstruacion

      # Fecha de diagnóstico del embarazo
      if fecha_de_diagnostico_del_embarazo && fecha_de_la_ultima_menstruacion > fecha_de_diagnostico_del_embarazo
        errors.add(:fecha_de_la_ultima_menstruacion, 'no puede ser posterior a la fecha de diagnóstico del embarazo')
        errors.add(:fecha_de_diagnostico_del_embarazo, 'no puede ser anterior a la fecha de la última menstruación')
        error_de_fecha = true
      end

      # Fecha probable de parto
      if fecha_probable_de_parto && fecha_de_la_ultima_menstruacion > fecha_probable_de_parto
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
    if esta_embarazada && fecha_de_diagnostico_del_embarazo

      # Fecha probable de parto
      if fecha_probable_de_parto && fecha_de_diagnostico_del_embarazo > fecha_probable_de_parto
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

  # verificar_documentos_de_identidad
  # Realiza la verificación de los números de documentos para evitar la carga de errores y duplicados.
  def verificar_documentos_de_identidad

    error_dni = false

    # VERIFICACION DE INTERVALOS VÁLIDOS

    # Documento del beneficiario
    if tipo_de_documento_id == TipoDeDocumento.id_del_codigo("DNI") && !numero_de_documento.blank?
      nro_dni = numero_de_documento.strip.to_i
      if nro_dni < 50000 || nro_dni > 99999999
        errors.add(
          :numero_de_documento,
          'no se encuentra en el intervalo esperado (no ingrese separadores como puntos o espacios en el número de DNI).'
        )
        error_dni = true
      end
    end

    # Documento de la madre
    if tipo_de_documento_de_la_madre_id == TipoDeDocumento.id_del_codigo("DNI") && !numero_de_documento_de_la_madre.blank?
      nro_dni = numero_de_documento_de_la_madre.strip.to_i
      if nro_dni < 50000 || nro_dni > 99999999
        errors.add(
          :numero_de_documento_de_la_madre,
          'no se encuentra en el intervalo esperado (no ingrese separadores como puntos o espacios en el número de DNI).'
        )
        error_dni = true
      end
    end

    # Documento del padre
    if tipo_de_documento_del_padre_id == TipoDeDocumento.id_del_codigo("DNI") && !numero_de_documento_del_padre.blank?
      nro_dni = numero_de_documento_del_padre.strip.to_i
      if nro_dni < 50000 || nro_dni > 99999999
        errors.add(
          :numero_de_documento_del_padre,
          'no se encuentra en el intervalo esperado (no ingrese separadores como puntos o espacios en el número de DNI).'
        )
        error_dni = true
      end
    end

    # Documento del tutor
    if tipo_de_documento_del_tutor_id == TipoDeDocumento.id_del_codigo("DNI") && !numero_de_documento_del_tutor.blank?
      nro_dni = numero_de_documento_del_tutor.strip.to_i
      if nro_dni < 50000 || nro_dni > 99999999
        errors.add(
          :numero_de_documento_del_tutor,
          'no se encuentra en el intervalo esperado (no ingrese separadores como puntos o espacios en el número de DNI).'
        )
        error_dni = true
      end
    end

    # DUPLICADOS
    if clase_de_documento_id == ClaseDeDocumento.id_del_codigo("P")
      # Sólo verificamos cuando el documento es propio
      afiliados_con_este_documento = Afiliado.where(
        :clase_de_documento_id => 1,
        :tipo_de_documento_id => tipo_de_documento,
        :numero_de_documento => numero_de_documento)

      if afiliados_con_este_documento.size > 0
        # Verificamos si existe otra clave de beneficiario asociada a este documento propio
        # que no esté marcado ya como duplicado
        afiliados_con_este_documento.each do |afiliado|
          if (afiliado.clave_de_beneficiario != clave_de_beneficiario &&
              !([14,81,82,83,203].member? afiliado.motivo_de_la_baja_id)) # TODO: 
            errors.add(
              :numero_de_documento,
              (
                "ya ha sido asignado a otro beneficiario: " +
                afiliado.apellido + ", " + afiliado.nombre + " (" + afiliado.clave_de_beneficiario + ")."
              )
            )
            error_dni = true
          end
        end
      end
    end

    return !error_dni

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
    if es_menor &&
      (apellido_de_la_madre.blank? || nombre_de_la_madre.blank? ||
      !tipo_de_documento_de_la_madre_id || numero_de_documento_de_la_madre.blank?) &&
      (apellido_del_padre.blank? || nombre_del_padre.blank? ||
      !tipo_de_documento_del_padre_id || numero_de_documento_del_padre.blank?) &&
      (apellido_del_tutor.blank? || nombre_del_tutor.blank? ||
      !tipo_de_documento_del_tutor_id || numero_de_documento_del_tutor.blank?)
      @advertencias << "El beneficiario es menor de edad y no se completó la información de alguno de los adultos responsables (apellido, nombre, tipo y número de documento)."
    end
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
    edad = self.edad_en_años(fecha_de_la_novedad || Date.today)

    return 1 if edad < 1
    return 2 if edad < 6
    return 3 if sexo_id == Sexo.id_del_codigo("F") && esta_embarazada
    return 5 if edad < 20
    return 6 if sexo_id == Sexo.id_del_codigo("F") && edad < 64

    return nil
  end
  
  # edad_en_años
  # Devuelve la edad en años cumplidos para la fecha de cálculo indicada, o para el día de hoy, si no se
  # indica una fecha.
  def edad_en_años (fecha_de_calculo = Date.today)

    # Calculamos la diferencia entre los años de ambas fechas
    diferencia_en_años = (fecha_de_calculo.year - fecha_de_nacimiento.year)

    # Calculamos la diferencia entre los meses de ambas fechas
    diferencia_en_meses = (fecha_de_calculo.month - fecha_de_nacimiento.month)

    # Calculamos la diferencia en días y ajustamos la diferencia en meses en forma acorde
    diferencia_en_dias = (fecha_de_calculo.day) - (fecha_de_nacimiento.day)
    if diferencia_en_dias < 0 then diferencia_en_meses -= 1 end

    # Ajustamos la diferencia en años en forma acorde
    if diferencia_en_meses < 0 then diferencia_en_años -= 1 end

    # Devolver la cantidad de años
    return diferencia_en_años

  end

end
