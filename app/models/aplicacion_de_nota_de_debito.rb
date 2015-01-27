class AplicacionDeNotaDeDebito < ActiveRecord::Base
  belongs_to :nota_de_debito
  attr_accessible :monto, :pago_sumar, :fecha_de_aplicacion
  attr_accessible :nota_de_debito_id

  validate :verificar_integridad_de_montos, on: :create
  after_save actualizar_reservado_de_nota_de_debito

  def verificar_integridad_de_montos
    nd = self.nota_de_debito
    # Si:
    #         remanente (monto disponible para aplicacion) -
    #      -  reservado (monto ya reservado por otros procesos de pago)
    #      -  monto actual a reservar
    #      es >= al monto original -> no paso ninguna macana
    unless (nd.remanente - nd.reservado - self.monto) >= nd.monto
      errors.add(:monto, "supera el remanente disponible para la nota de debito")      
    end
  end
  
  def actualizar_reservado_de_nota_de_debito
    reservado = (nota_de_debito.reservado + monto )
    nota_de_debito.update_attributes(:reservado => reservado)
  end

end
