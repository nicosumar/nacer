class CantidadDePrestacionesPorPeriodoDecorator  < Draper::Decorator
  delegate_all

  def nombre_del_intervalo
    traducir_tiempo intervalo
  end

  def nombre_del_periodo
    traducir_tiempo periodo
  end

  def resumen
    "Cantidad máxima: #{object.cantidad_maxima}, período: #{nombre_del_periodo} e intervalo: #{nombre_del_intervalo}"
  end

  private 

    def traducir_tiempo tiempo
      tiempo.present? ? tiempo.split('.').first + " " + I18n.t(tiempo.split('.').last) : "Sin especificar"
    end

end

