class NovedadDelAfiliado < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :apellido, :nombre, :clase_de_documento_id, :tipo_de_documento_id, :numero_de_documento
  attr_accessible :numero_de_celular, :e_mail, :categoria_de_afiliado_id, :sexo_id, :fecha_de_nacimiento, :es_menor
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
  attr_accessible :esta_embarazada, :fecha_de_la_ultima_menstruacion, :fecha_de_diagnostico_del_embarazo, :semanas_de_embarazo
  attr_accessible :fecha_probable_de_parto, :fecha_efectiva_de_parto, :score_de_riesgo, :discapacidad_id
  attr_accessible :fecha_de_la_novedad, :centro_de_inscripcion_id, :nombre_del_agente_inscriptor, :observaciones_generales

  # La clave de beneficiario sólo puede registrarse al grabar la novedad
  attr_readonly :clave_de_beneficiario

  # Asociaciones
  belongs_to :clase_de_documento
  belongs_to :tipo_de_documento
  #belongs_to :categoria_de_afiliado_id     #-- OBSOLETO
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

  # Validaciones
  validates_presence_of :tipo_de_novedad_id, :estado_de_la_novedad_id, :clave_de_beneficiario
  validates_presence_of :fecha_de_la_novedad, :centro_de_inscripcion_id
  validate :verificar_fechas
  validate :verificar_intervalo_dni
  validate :generar_advertencias

  # copiar_atributos_del_afiliado
  # Copia los valores de los atributos del afiliado a esta novedad
  def copiar_atributos_del_afiliado(afiliado)
    return false if (!afiliado || !afiliado.kind_of?(Afiliado))

    # Copiar todos los atributos que se pueden asignar masivamente
    atributos_del_afiliado = afiliado.attributes
    atributos_del_afiliado.delete "afiliado_id"
    atributos_del_afiliado.delete "clave_de_beneficiario"
    atributos_del_afiliado.delete "activo"
    atributos_del_afiliado.delete "mensaje_de_la_baja"
    atributos_del_afiliado.delete "motivo_de_la_baja_id"
    atributos_del_afiliado.delete "unidad_de_alta_de_datos_id"
    atributos_del_afiliado.delete "fecha_de_inscripcion"
    atributos_del_afiliado.delete "fecha_de_carga"
    atributos_del_afiliado.delete "usuario_que_carga"
    atributos_del_afiliado.delete "fecha_de_la_ultima_novedad"
    self.attributes = atributos_del_afiliado

    # Definir los atributos que no se pueden asignar masivamente
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

  # verificar_intervalo_dni
  # Verifica que si alguno de los campos de tipo de documento está establecido en DNI,
  # el valor del campo de número respectivo contenga un número y esté en el intervalo esperable.
  def verificar_intervalo_dni

    error_dni = false

    # Documento del beneficiario
    if tipo_de_documento_id == 1 && !numero_de_documento.strip.empty?
      nro_dni = numero_de_documento.strip.to_i
      if nro_dni < 50000 || nro_dni > 99999999
        errors.add(:numero_de_documento, 'no se encuentra en el intervalo esperado (recuerde no ingresar separadores como puntos o espacios al ingresar el número de DNI).')
        error_dni = true
      end
    end

    # Documento de la madre
    if tipo_de_documento_de_la_madre_id == 1 && !numero_de_documento_de_la_madre.strip.empty?
      nro_dni = numero_de_documento_de_la_madre.strip.to_i
      if nro_dni < 50000 || nro_dni > 99999999
        errors.add(:numero_de_documento_de_la_madre, 'no se encuentra en el intervalo esperado (recuerde no ingresar separadores como puntos o espacios al ingresar el número de DNI).')
        error_dni = true
      end
    end

    # Documento del padre
    if tipo_de_documento_del_padre_id == 1 && !numero_de_documento_del_padre.strip.empty?
      nro_dni = numero_de_documento_del_padre.strip.to_i
      if nro_dni < 50000 || nro_dni > 99999999
        errors.add(:numero_de_documento_del_padre, 'no se encuentra en el intervalo esperado (recuerde no ingresar separadores como puntos o espacios al ingresar el número de DNI).')
        error_dni = true
      end
    end

    # Documento del tutor
    if tipo_de_documento_del_tutor_id == 1 && !numero_de_documento_del_padre.strip.empty?
      nro_dni = numero_de_documento_del_tutor.strip.to_i
      if nro_dni < 50000 || nro_dni > 99999999
        errors.add(:numero_de_documento_del_tutor, 'no se encuentra en el intervalo esperado (recuerde no ingresar separadores como puntos o espacios al ingresar el número de DNI).')
        error_dni = true
      end
    end

    return !error_dni

  end

  # Verifica que los datos estén completos para el tipo de novedad ingresado
  def generar_advertencias
    # No verificamos advertencias si hay errores presentes
    return true if errors.count > 0

    @advertencias = []

    # Advertencias de campos vacíos que generan un registro incompleto:
    if apellido.empty?
      @advertencias << "No se ingresó el apellido del beneficiario."
    end
    if nombre.empty?
      @advertencias << "No se ingresó el nombre del beneficiario."
    end
    if !clase_de_documento_id
      @advertencias << "No se seleccionó la clase de documento del beneficiario."
    end
    if !tipo_de_documento_id
      @advertencias << "No se seleccionó el tipo de documento del beneficiario."
    end
    if numero_de_documento.empty?
      @advertencias << "No se ingresó el número de documento."
    end
    if !sexo_id
      @advertencias << "No se seleccionó el sexo del beneficiario."
    end
    if !fecha_de_nacimiento
      @advertencias << "No se ingresó la fecha de nacimiento del beneficiario."
    end
    if domicilio_calle.empty? && domicilio_manzana.empty?
      @advertencias << "No se ingresó calle ni manzana en el domicilio."
    end
    if !(domicilio_calle.empty? && domicilio_manzana.empty?) && domicilio_numero.empty?
      @advertencias << "No se ingresó el número de puerta o casa en el domicilio."
    end
    if !(domicilio_calle.empty? && domicilio_manzana.empty?) && domicilio_numero.empty?
      @advertencias << "No se ingresó el número de puerta o casa en el domicilio."
    end
    if !domicilio_departamento_id
      @advertencias << "No se seleccionó el departamento de residencia del beneficiario."
    end
    if !lugar_de_atencion_habitual_id
      @advertencias << "No se seleccionó el lugar de atención habitual del beneficiario."
    end
    if es_menor &&
      (apellido_de_la_madre.empty? || nombre_de_la_madre.empty? ||
      !tipo_de_documento_de_la_madre_id || numero_de_documento_de_la_madre.empty?) &&
      (apellido_del_padre.empty? || nombre_del_padre.empty? ||
      !tipo_de_documento_del_padre_id || numero_de_documento_del_padre.empty?) &&
      (apellido_del_tutor.empty? || nombre_del_tutor.empty? ||
      !tipo_de_documento_del_tutor_id || numero_de_documento_del_tutor.empty?)
      @advertencias << "El beneficiario es menor de edad y no se completó la información de alguno de los adultos responsables (apellido, nombre, tipo y número de documento)."
    end
    if esta_embarazada && !fecha_probable_de_parto
      @advertencias << "La beneficiaria está embarazada y no se indicó la fecha probable de parto."
    end

    return true
  end
end
