class PrestacionDecorator < Draper::Decorator
  delegate_all

  def nombre_del_concepto_de_la_prestacion
    object.concepto_de_facturacion.present? ? object.concepto_de_facturacion.concepto : "Sin especificar"
  end

end

