# -*- encoding : utf-8 -*-
class VistaGlobalDeNovedadDelAfiliado < ActiveRecord::Base

  # Todos los atributos son solo para lectura porque es un modelo "falso" que referencia una vista y no una tabla
  # Lo pongo por seguridad
  attr_readonly :apellido, :nombre, :clase_de_documento_id, :tipo_de_documento_id, :numero_de_documento
  attr_readonly :numero_de_celular, :e_mail, :sexo_id, :fecha_de_nacimiento, :es_menor
  attr_readonly :pais_de_nacimiento_id, :se_declara_indigena, :lengua_originaria_id, :tribu_originaria_id
  attr_readonly :alfabetizacion_del_beneficiario_id, :alfab_beneficiario_anios_ultimo_nivel
  attr_readonly :domicilio_calle, :domicilio_numero, :domicilio_piso, :domicilio_depto, :domicilio_manzana
  attr_readonly :domicilio_entre_calle_1, :domicilio_entre_calle_2, :telefono, :otro_telefono
  attr_readonly :domicilio_departamento_id, :domicilio_distrito_id, :domicilio_barrio_o_paraje
  attr_readonly :domicilio_codigo_postal, :observaciones, :lugar_de_atencion_habitual_id
  attr_readonly :apellido_de_la_madre, :nombre_de_la_madre, :tipo_de_documento_de_la_madre_id
  attr_readonly :numero_de_documento_de_la_madre, :alfabetizacion_de_la_madre_id, :alfab_madre_anios_ultimo_nivel
  attr_readonly :apellido_del_padre, :nombre_del_padre, :tipo_de_documento_del_padre_id
  attr_readonly :numero_de_documento_del_padre, :alfabetizacion_del_padre_id, :alfab_padre_anios_ultimo_nivel
  attr_readonly :apellido_del_tutor, :nombre_del_tutor, :tipo_de_documento_del_tutor_id
  attr_readonly :numero_de_documento_del_tutor, :alfabetizacion_del_tutor_id, :alfab_tutor_anios_ultimo_nivel
  attr_readonly :esta_embarazada, :fecha_de_la_ultima_menstruacion, :fecha_de_diagnostico_del_embarazo
  attr_readonly :semanas_de_embarazo, :fecha_probable_de_parto, :fecha_efectiva_de_parto, :score_de_riesgo
  attr_readonly :discapacidad_id, :fecha_de_la_novedad, :centro_de_inscripcion_id, :nombre_del_agente_inscriptor
  attr_readonly :observaciones_generales, :mes_y_anio_de_proceso, :mensaje_de_la_baja
  attr_readonly :clave_de_beneficiario

  # Asociaciones
  belongs_to :tipo_de_novedad
  belongs_to :estado_de_la_novedad
  belongs_to :clase_de_documento
  belongs_to :tipo_de_documento
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

  def es_una_baja?
    tipo_de_novedad_id == TipoDeNovedad.id_del_codigo("B")
  end

  def embarazada?
    esta_embarazada && !fecha_efectiva_de_parto
  end

  def puerpera?
    esta_embarazada && fecha_efectiva_de_parto
  end

  def pendiente?
    estado_de_la_novedad && estado_de_la_novedad.pendiente
  end

  def categorizar
    edad = self.edad_en_anios(fecha_de_la_novedad || Date.today)

    return 1 if edad >= 10 && sexo_id == Sexo.id_del_codigo("F") && esta_embarazada
    return 3 if edad < 1
    return 4 if edad < 6
    return 5 if edad < 20
    return 6 if sexo_id == Sexo.id_del_codigo("F") && edad < 64

    return nil
  end

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

  def edad_en_dias (fecha_de_calculo = Date.today)

    # Calculamos la diferencia en días entre ambas fechas
    if fecha_de_nacimiento
      return (fecha_de_calculo - fecha_de_nacimiento).to_i
    else
      return nil
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
