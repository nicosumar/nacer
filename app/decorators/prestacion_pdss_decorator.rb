class PrestacionPdssDecorator < Draper::Decorator
  delegate_all

  def nombre_de_la_seccion
    if object.grupo_pdss.present? and object.grupo_pdss.seccion_pdss.present?
      object.grupo_pdss.seccion_pdss.nombre
    else
      "Sin especificar"
    end
  end

end

