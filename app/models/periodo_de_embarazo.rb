# -*- encoding : utf-8 -*-
class PeriodoDeEmbarazo < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :afiliado_id, :fecha_de_diagnostico_del_embarazo, :fecha_de_finalizacion, :fecha_de_inicio
  attr_accessible :fecha_de_la_ultima_menstruacion, :fecha_probable_de_parto, :semanas_de_embarazo

  # Asociaciones
  belongs_to :afiliado

end
