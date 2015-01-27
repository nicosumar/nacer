class AplicacionDeNotaDeDebito < ActiveRecord::Base
  belongs_to :nota_de_debito
  attr_accessible :monto, :pago_sumar, :fecha_de_aplicacion

  after_create actualizar_nota_de_debito


  private

  def actualizar_nota_de_debito
    nd = self.nota_de_debito
    # Si:
    #         remanente (monto disponible para aplicacion) -
    #      -  reservado (monto ya reservado por otros procesos de pago)
    #      -  monto actual a reservar
    #      es >= al monto original -> no paso ninguna macana
    if (nd.remanente - nd.reservado - self.monto) >= nd.monto
      # sumo a la reserva el nuevo monto a reservar
      nd.reservado += self.monto
      self.fecha_de_aplicacion = Day.today
      
    else
      false
    end
    
  end
end
