class DetalleDeDebitoPrestacional < ActiveRecord::Base
  belongs_to :prestacion_liquidada
  belongs_to :motivo_de_rechazo
  belongs_to :informe_debito_prestacional
  belongs_to :afiliado

  attr_accessible :prestacion_liquidada_id, :motivo_de_rechazo_id, :afiliado_id
  attr_accessible :informado_sirge, :observaciones, :procesado_para_debito

  validates :prestacion_liquidada_id, presence: true 
  validates :motivo_de_rechazo_id, presence: true 
  validates :informe_debito_prestacional_id, presence: true 
  # validates :tipo_de_debito_prestacional_id, presence: true
end
