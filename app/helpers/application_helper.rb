# -*- encoding : utf-8 -*-
module ApplicationHelper

  # Devuelve una cadena indicando la edad en años, meses ó días dadas una fecha de nacimiento, y
  # otra fecha para el cálculo, si no se especifica esta última se supone que es al día de hoy
  def edad_entre(fecha_de_nacimiento, fecha_de_calculo = Date.today)

    # Imposible calcular la edad con una fecha de cálculo anterior a la de nacimiento
    return nil if (!fecha_de_nacimiento || fecha_de_calculo < fecha_de_nacimiento)

    # Calculamos la diferencia entre los años de ambas fechas
    diferencia_en_años = (fecha_de_calculo.year - fecha_de_nacimiento.year)

    # Calculamos la diferencia entre los meses de ambas fechas
    diferencia_en_meses = (fecha_de_calculo.month - fecha_de_nacimiento.month)

    # Calculamos la diferencia en días
    diferencia_en_dias = (fecha_de_calculo.day) - (fecha_de_nacimiento.day)
    if diferencia_en_dias < 0
      diferencia_en_meses -= 1
      diferencia_en_dias = (fecha_de_calculo - fecha_de_nacimiento).to_i
    end

    if diferencia_en_meses < 0
      # Ajustamos la cantidad de meses y años, si la cantidad de meses es negativa
      diferencia_en_años -= 1
      diferencia_en_meses += 12
    end

    # Si la diferencia entre fechas es de un año o más, devolver la edad en años
    return "#{diferencia_en_años} años" if diferencia_en_años > 1
    return "un año" if diferencia_en_años == 1

    # Si la diferencia entre fechas es de un mes o más, devolver la edad en meses
    return "#{diferencia_en_meses} meses" if diferencia_en_meses > 1
    return "un mes" if diferencia_en_meses == 1

    # La diferencia entre fechas es menor a un mes, devolver la edad en días cumplidos
    return "#{diferencia_en_dias} días" if diferencia_en_dias > 1
    return "un día" if diferencia_en_dias == 1
    return "menos de un día" if diferencia_en_dias == 0
  end

end
