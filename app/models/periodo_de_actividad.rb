# -*- encoding : utf-8 -*-
class PeriodoDeActividad < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :afiliado_id, :fecha_de_inicio, :fecha_de_finalizacion, :motivo_de_la_baja_id, :mensaje_de_la_baja

end
