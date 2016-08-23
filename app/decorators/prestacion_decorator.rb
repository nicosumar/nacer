class PrestacionDecorator < Draper::Decorator
  delegate_all

  def nombre_del_objeto_de_la_prestacion
    object.objeto_de_la_prestacion.present? ? object.objeto_de_la_prestacion.nombre : "Sin especificar"
  end

  def nombre_del_concepto_de_la_prestacion
    object.concepto_de_facturacion.present? ? object.concepto_de_facturacion.concepto : "Sin especificar"
  end

  def nombre_del_tipo_de_tratamiento
    object.tipo_de_tratamiento.present? ? object.tipo_de_tratamiento.nombre : "Sin especificar"
  end

  def nombre_de_los_sexos
    object.sexos.present? ? object.sexos.pluck(:nombre).to_sentence : "Sin especificar"
  end

  def nombre_de_los_grupos_poblacionales
    object.grupos_poblacionales.present? ? object.grupos_poblacionales.pluck(:nombre).to_sentence : "Sin especificar"
  end

  def nombre_de_las_documentaciones_respaldatorias
    object.documentaciones_respaldatorias.present? ? object.documentaciones_respaldatorias.pluck(:nombre).to_sentence : "Sin especificar"
  end

end

