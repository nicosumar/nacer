# -*- encoding : utf-8 -*-
class DatoReportableRequerido < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :dato_reportable_id, :fecha_de_inicio, :fecha_de_finalizacion, :minimo, :maximo, :necesario, :obligatorio, :prestacion_id

  # Asociaciones
  belongs_to :dato_reportable
  belongs_to :prestacion

  def codigo_de_grupo
    dato_reportable.codigo_de_grupo
  end

end
