class LiquidacionSumarAnexoMedico < ActiveRecord::Base
  belongs_to :estado_del_proceso
  has_one :liquidacion_informe

  attr_accessible :fecha_de_finalizacion, :fecha_de_inicio
end
