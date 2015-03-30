# -*- encoding : utf-8 -*-
class NotaDeDebito < ActiveRecord::Base
  belongs_to :efector
  belongs_to :concepto_de_facturacion
  belongs_to :tipo_de_nota_debito
  has_many   :aplicaciones_de_notas_de_debito
  
  attr_accessible :monto, :numero, :observaciones, :remanente, :reservado
  attr_accessible :efector_id, :concepto_de_facturacion_id, :tipo_de_nota_debito_id 

  validates :monto, presence: true
  validates :observaciones, presence: true

  # 
  # Devuelve el monto disponible para ser aplicado en un proceso de pago
  # 
  # @return [BigDecimal] Monto disponible
  def disponible_para_aplicacion
    self.remanente - self.reservado
  end

  # 
  #  Genera aplicaciones reservadas vinculadas proceso de pago
  # @param pago_sumar [PagoSumar] [proceso de pago al que se vincula la aplicacion]
  # @param pago_sumar [BigDecimal] [Monto maximo a reservar para la aplicacion.]
  # 
  # @return [Boolean] [True: si pudo crear y reserva la aplicacion. False: caso contrario]
  def reservar_para_pago(pago_sumar, maximo_monto_de_reserva = self.disponible_para_aplicacion)
    unless pago_sumar.is_a? PagoSumar
      errors.add(:base, "El argumento debe ser un pago sumar")
      return false
    end

    # Verifico que la nd tenga disponible el monto solicitado
    errors.add(:monto, "La nota de débito no posee monto disponible para aplicación" ) unless self.disponible_para_aplicacion > 0
    errors.add(:base, "La reserva de monto debe ser mayor a cero") if maximo_monto_de_reserva == 0

    #  Verifico que el proceso de pago refiera al administrador/autoadministrado
    # del efector administrado/autoadministrado de la nota de debito
    efectores = []
    if pago_sumar.efector.es_administrador? 
      efectores << pago_sumar.efector.id
      efectores << pago_sumar.efector.efectores_administrados.map { |e| e.id }
      efector_ok = efectores.flatten(1).include?(self.efector_id)
    elsif pago_sumar.efector.es_autoadministrado?
      efector_ok = (pago_sumar.efector_id == self.efector_id)
    end
    errors.add(:efector_id, "El efector de pago no se corresponde para esta nota de débito") unless efector_ok
    
    # Verifico que no exista una aplicacion reservada o aplicada para este proceso de pago
    errors.add(:base, "Ya existe una aplicacion reservada para este proceso de pago.") unless self.aplicaciones_de_notas_de_debito.where(pago_sumar_id: pago_sumar.id, estado_de_aplicacion_de_debito_id: [1,2]).blank?
    
    return false if errors.present?

    monto_a_reservar = 
      if maximo_monto_de_reserva <= self.disponible_para_aplicacion
        maximo_monto_de_reserva
      elsif maximo_monto_de_reserva > self.disponible_para_aplicacion 
        self.disponible_para_aplicacion 
      end
                            

    transaction do
      begin
        # Si existe una aplicacion anulada, la vuelvo a crear y que tome el nuevo (posible) valor del disponible
        self.aplicaciones_de_notas_de_debito.build(monto: monto_a_reservar)
        self.reservado += monto_a_reservar
        self.save
      rescue Exception => e
        errors.add(:base, "Ocurrio un error en la transaccion. Detalles: #{e.me}")
      end
    end # end transaction
  end

  # 
  # Marca como anuladas las prestaciones cuyo estado es "Reservado"
  # @param pago_sumar [PagoSumar] Proceso de pago vinculado a las aplicaciones
  # 
  # @return [AplicacionDeNotaDeDebito] [Devuelve un array con las aplicaciones anuladas]
  def anular_aplicaciones_reservadas(pago_sumar)
    return false unless pago_sumar.is_a? PagoSumar
    
    estado_reservado = EstadoDeAplicacionDeDebito.where(codigo: "R").first
    aplicaciones_anuladas = []

    # Anulo cada una de las aplicaciones vinculadas a este proceso de pago y guardo las aplicaciones q fueron anuladas
    transaction do
      self.aplicaciones_de_notas_de_debito.
           where(pago_sumar_id: pago_sumar.id).
           where(estado_de_aplicacion_de_debito_id: estado_reservado.id ).
           each { |aplicacion|  aplicaciones_anuladas.push(aplicacion) if aplicacion.anular_reserva}  
    #rescue
    #  errors.add(:aplicaciones_de_notas_de_debito, "No se pudieron anular algunas aplicaciones. La anulacion no se ha llevado acabo")
    #  return 0
    end
    aplicaciones_anuladas
  end

  # 
  # Genera una nota de debito desde un informe de debito prestacional
  # @param arg_InformeDeDebito InformeDebitoPrestacional 
  # 
  # @return [NotaDeDebito] [Nota de debito creada]
  def self.nueva_desde_informe(arg_InformeDeDebito)

    if arg_InformeDeDebito.class != InformeDebitoPrestacional
      return false
    end

    NotaDeDebito.create([
          { 
            efector_id: arg_InformeDeDebito.efector.id ,
            concepto_de_facturacion_id: arg_InformeDeDebito.concepto_de_facturacion.id,
            tipo_de_nota_debito_id: 1, #Debito prestacional
            observaciones: "Generado a partir del informe de debito N° #{arg_InformeDeDebito.id}" ,
            monto: (InformeDebitoPrestacional.joins(detalles_de_debitos_prestacionales: :prestacion_liquidada ).where(id: arg_InformeDeDebito.id).sum(:monto) ).to_f
          }
        ])
  end

  # 
  # Devuelve las notas de debito que poseen un monto disponible para aplicación
  # 
  # @return [ActiveRecord::Relation] Relacion de las notas de debito q tienen disponible para aplicacion
  def self.disponibles_para_aplicacion
    joins(:aplicaciones_de_notas_de_debito).
    where("aplicaciones_de_notas_de_debito.estado_de_aplicacion_de_debito_id != 3").
    where("notas_de_debito.remanente - notas_de_debito.reservado > 0")
  end

  # 
  #  Devuelve las notas de debito disponibles para un efector. 
  # Si el efector es administrador, incluye las ND disponibles para sus administrados
  # @param efector [Efector] Efector por el cual realizar el filtro
  # @param incluir_administrados = false [Boolean] [Indica si incluye o no las nd de sus administrados]
  # 
  # @return [ActiveRecord::Relation] [description]
  def self.por_efector(efector, incluir_administrados = false)
    return false unless efector.is_a?(Efector)
    efectores = []
    
    if incluir_administrados and efector.es_administrador? 
      efectores = efector.efectores_administrados.map { |e| e.id }
      efectores << efector.id
    else
      efectores << efector.id
    end
    return where(efector_id: efectores)
  end # end por_efector


end
