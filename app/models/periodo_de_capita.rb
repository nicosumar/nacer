# -*- encoding : utf-8 -*-
class PeriodoDeCapita < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :afiliado_id, :capitas_al_inicio, :fecha_de_finalizacion, :fecha_de_inicio

end
