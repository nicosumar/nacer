# -*- encoding : utf-8 -*-
class PeriodoDeCobertura < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :afiliado_id, :fecha_de_finalizacion, :fecha_de_inicio

end
