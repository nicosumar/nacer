# -*- encoding : utf-8 -*-
class PeriodoDeEmbarazo < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :afiliado_id, :centro_de_inscripcion_id, :fecha_de_diagnostico_del_embarazo, :fecha_de_finalizacion
  attr_accessible :fecha_de_inicio, :fecha_de_la_ultima_menstruacion, :fecha_efectiva_de_parto, :fecha_probable_de_parto
  attr_accessible :semanas_de_embarazo, :unidad_de_alta_de_datos_id

  # Asociaciones
  belongs_to :afiliado

end
