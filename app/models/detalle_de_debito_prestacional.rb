class DetalleDeDebitoPrestacional < ActiveRecord::Base
  belongs_to :prestacion_liquidada
  belongs_to :motivo_de_rechazo
  belongs_to :informe_debito_prestacional

  attr_accessible :prestacion_liquidada, :motivo_de_rechazo
  attr_accessible :fecha_de_debito, :informado_sirge, :observaciones, :procesado_para_debito
end
