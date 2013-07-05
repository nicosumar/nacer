# -*- encoding : utf-8 -*-
module ApplicationHelper

  A_LETRAS = ["", "un", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "10", "11"]

  # Devuelve una cadena indicando la edad en años, meses ó días dadas una fecha de nacimiento, y
  # otra fecha para el cálculo, si no se especifica esta última se supone que es al día de hoy
  def edad_entre(fecha_de_nacimiento, fecha_de_calculo = Date.today)

    # Imposible calcular la edad con una fecha de cálculo anterior a la de nacimiento
    return nil if (!fecha_de_nacimiento || fecha_de_calculo < fecha_de_nacimiento)

    # Calculamos la diferencia entre los años de ambas fechas
    diferencia_en_anios = (fecha_de_calculo.year - fecha_de_nacimiento.year)

    # Calculamos la diferencia entre los meses de ambas fechas
    diferencia_en_meses = (fecha_de_calculo.month - fecha_de_nacimiento.month)

    # Calculamos la diferencia en días
    diferencia_en_dias = (fecha_de_calculo.day) - (fecha_de_nacimiento.day)
    if diferencia_en_dias < 0
      diferencia_en_meses -= 1
      diferencia_en_dias = diferencia_en_dias.abs
    end

    if diferencia_en_meses < 0
      # Ajustamos la cantidad de meses y años, si la cantidad de meses es negativa
      diferencia_en_anios -= 1
      diferencia_en_meses += 12
    end

    # Si la diferencia entre fechas es de seis años o más, devolver la edad en años
    return "#{diferencia_en_anios} años" if diferencia_en_anios > 5

    # Armar la cadena que representa la cantidad de años
    if diferencia_en_anios > 1
      anios = "#{A_LETRAS[diferencia_en_anios]} años"
    elsif diferencia_en_anios == 1
      anios = "un año"
    end

    # Armar la cadena que representa la cantidad de meses
    if diferencia_en_meses > 1
      meses = "#{A_LETRAS[diferencia_en_meses]} meses"
    elsif diferencia_en_meses == 1
      meses = "un mes"
    end

    # Devolver la edad en años y meses, si es mayor de un año
    return (anios + (meses ? (" y " + meses) : "")) if diferencia_en_anios > 0

    # Armar la cadena que representa la cantidad de días
    if diferencia_en_dias > 9
      dias = diferencia_en_dias.to_s + " días"
    elsif diferencia_en_dias > 1
      dias = "#{A_LETRAS[diferencia_en_dias]} días"
    elsif diferencia_en_dias == 1
      dias = "un día"
    end

    # Devolver la edad en meses y días, si es mayor de un mes
    return (meses + (dias ? (" y " + dias) : "")) if diferencia_en_meses > 0

    if diferencia_en_dias > 9
      return "#{diferencia_en_dias} días"
    elsif diferencia_en_dias > 1
      return "#{A_LETRAS[diferencia_en_dias]} días"
    elsif diferencia_en_dias == 1
      return "un día"
    end

    # Menos de un día de edad
    return "menos de un día" if diferencia_en_dias == 0

    # WTF?
    return "una fecha de nacimiento futura"

  end

  def novedad_o_afiliado(clave_de_beneficiario)

    begin
      novedad = NovedadDelAfiliado.where(:clave_de_beneficiario => clave_de_beneficiario).order('updated_at DESC').first
    rescue
    end

    return (novedad.apellido.to_s + ", " + novedad.nombre.to_s) if novedad

    afiliado = Afiliado.find_by_clave_de_beneficiario(clave_de_beneficiario)

    return (afiliado.apellido.to_s + ", " + afiliado.nombre.to_s) if afiliado

    return ''

  end

end
