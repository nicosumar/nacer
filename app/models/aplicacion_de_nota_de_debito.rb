class AplicacionDeNotaDeDebito < ActiveRecord::Base
  belongs_to :nota_de_debito
  belongs_to :estado_de_aplicacion_de_debito
  belongs_to :pago_sumar
  attr_accessible :monto, :pago_sumar, :fecha_de_aplicacion
  attr_accessible :nota_de_debito_id, :estado_de_aplicacion_de_debito_id

  validate :verificar_integridad_de_montos, on: :create
  # after_create :actualizar_reservado_de_nota_de_debito
  

  after_initialize :init

  def init
    # o el valor de la base, o q busque el estado 2
    self.fecha_de_aplicacion ||= Date.today
  end

  def verificar_integridad_de_montos
    nd = self.nota_de_debito
    self.monto = nd.remanente - nd.reservado
    # Si:
    #         remanente (monto disponible para aplicacion) -
    #      +  reservado (monto ya reservado por otros procesos de pago)
    #      +  monto actual a reservar
    #      es menor o igual al monto original -> no paso ninguna macana
    if (nd.remanente + nd.reservado + self.monto) > nd.monto
      errors.add(:monto, "supera el remanente disponible para la nota de debito")
      return false
    end
    true
  end
  
  def actualizar_reservado_de_nota_de_debito
    reservado = (nota_de_debito.reservado + monto )
    nota_de_debito.update_attributes(reservado: reservado)
  end

  # 
  # Anula la aplicacion reservada marcandola como anulada
  # 
  # @return [Boolean] true si pudo anularla, false, si se complicó
  def anular_reserva
    ActiveRecord::Base.transaction do 
      estado_anulacion = EstadoDeAplicacionDeDebito.where(codigo: "N").first
      # anulo la aplicacion
      self.update_attributes(estado_de_aplicacion_de_debito_id: estado_anulacion.id)  
      #restituyo el reservado de la ND
      self.nota_de_debito.update_attributes(reservado: self.nota_de_debito.reservado - self.monto)
    end # end transaction
    true
  end # end anular_reserva

end
