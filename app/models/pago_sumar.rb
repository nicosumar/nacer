# -*- encoding : utf-8 -*-
class PagoSumar < ActiveRecord::Base
  belongs_to :efector
  belongs_to :concepto_de_facturacion
  belongs_to :cuenta_bancaria_origen, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_origen_id'
  belongs_to :cuenta_bancaria_destino, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_destino_id'
  belongs_to :estado_del_proceso
  has_many   :expedientes_sumar
  has_many   :aplicaciones_de_notas_de_debito

  # Atributos a ser inicializados/completados deforma automatica
  attr_accessible :fecha_de_proceso, :fecha_informado_sirge, :informado_sirge, :monto
  # Fecha de proceso: Fecha en la que se inicio el proceso
  
  # Atributos a ser completados por el usuario
  attr_accessible :cuenta_bancaria_origen_id, :cuenta_bancaria_destino_id, :efector_id, :concepto_de_facturacion_id
  
  @nota_de_debito_ids = []
  attr_accessor notas_de_debito
  attr_accessible :nota_de_debito_ids, :expediente_sumar_ids
  
  # Atributos solo actualizable luego de ser creado
  attr_accessible :notificado, :fecha_de_notificacion

  accepts_nested_attributes_for :expedientes_sumar
  attr_accessible :expedientes_sumar_attributes

  accepts_nested_attributes_for :aplicaciones_de_notas_de_debito
  attr_accessible :aplicaciones_de_notas_de_debito_attributes  

  after_initialize :init
  before_create :calcular_monto_a_pagar

  # before_validation :validar_nd_y_expedientes
  #validate :nota_de_debito_ids, :nota_de_debitosYExpedientes
  validate :notas_de_debito_pertenecen_a_efectores_en_los_expedientes, if: expediente_sumar_ids.present?

  before_save :

  # 
  # Metodo llamado por validate.
  # 
  #  Verifica los efectores poseedores de notas de debito que afectan este proceso de pago
  # se correspondan con los efectores incluidos en los expedientes de pago incluidos en este proceso.
  #  La verificación toma en cuenta el estado de los conveios con los efectores al momento del proceso de pago
  # 
  def notas_de_debito_pertenecen_a_efectores_en_los_expedientes
    #si hay ND
    if nota_de_debito_ids.present?
      
      nd_no_relacionadas = []
      nd_relacionadas = []
      
      expedientes_sumar.each do |exp|
        efectores = []
        fecha_de_creacion_del_expediente = exp.created_at.to_date
        
        # Obtengo los efectores para la fecha en que se liquido ( === fecha de creacion del expediente)
        if self.efector.es_administrador?(fecha_de_creacion_del_expediente)
          efectores << pago_sumar.efector
          efectores << pago_sumar.efector.efectores_administrados(fecha_de_creacion_del_expediente).map { |e| e }
        else
          efectores << self.efector
        end

        # Busco sobre las notas de debito aun no relacioadas
        (self.notas_de_debito - nd_relacionadas).each do |nd|
          # Verifico que la ND pertenece a alguno de los efectores
          if efectores.map { |e| e.id }.include? nd.efector_id
            # La nota de debito ta OK, Pertenece a algun efector de los expedientes
            # Ademas, si estaba relacionada a nd_no_relacionadas y aparece -> la borro de la lista
            nd_relacionadas << nd 
            nd_no_relacionadas.delete nd
          else
            # si la ND no pertenece a estos efectores la marco
            nd_no_relacionadas << nd 
          end
        end # end each nota de debito

      end #end each expediente

      if nd_no_relacionadas.size > 1
        errors.add(:nota_de_debito_ids, "Las notas de debito numeros: #{nd_no_relacionadas.join(',')} no estan asociadas a los efectores incluidos en los expedientes #{expedientes_sumar.map { |e| e.numero }.joins(', ')}")
        false
      end
    end
  end
  
  def init
    # o el valor de la base, o q busque el estado 2
    self.estado_del_proceso ||= EstadoDelProceso.find(2) # "En Curso"
    self.fecha_de_proceso ||= Date.today

    estados_aceptados = EstadoDeAplicacionDeDebito.where("estados_de_aplicaciones_de_debitos.id != 3 ").
                                                   map { |e| e.id }
    
    @nota_de_debito_ids = self.aplicaciones_de_notas_de_debito.
                               where(estado_de_aplicacion_de_debito_id: estados_aceptados).
                               map { |e| e.nota_de_debito_id } 
  end

  def calcular_monto_a_pagar
    total_aprobado = 0.0
    total_de_debitos = 0.0
    
    self.expedientes_sumar.each do |exp|
      total_aprobado += exp.monto_aprobado
    end

    total_de_debitos = self.aplicaciones_de_notas_de_debito.sum(:monto)
    self.monto = total_aprobado - total_de_debitos

  end

  # 
  # Vincula las notas de debito indicadas al este proceso de pago.
  #  El metodo reserva aplicaciones sobre la nota de debito para su pago y solicita 
  # tantas aplicaciones de notas de debito como ocurrencias del efector exitan en cada expediente. 
  # @param value_ids [type] [description]
  # 
  # @return [type] [description]
  def asociar_notas_de_debito(value_ids)
    unless value_ids.is_a? Array
      errors.add(:aplicaciones_de_notas_de_debito, "Las notas de debito indicadas no son correctas")
      return nil 
    end

    value_ids.each do |id|
      unless id.is_a? Fixnum
        errors.add(:aplicaciones_de_notas_de_debito, "Uno de los ids de notas de debito no es valido - ID: #{id}")
        return nil 
      end
    end

    nd_incluidas  = value_ids & self.nota_de_debito_ids # interseccion de arrays
    nd_nuevas     = value_ids - nd_incluidas # las enviadas menos las que ya estaban
    nd_eliminadas =  self.nota_de_debito_ids - nd_incluidas

    transaction do
      begin
        # Busco para cada nota de debito el efector que corresponde con los incluidos en este proceso de pago
        if self.efector.es_administrador? 
          efectores = []
          efectores << pago_sumar.efector
          efectores << pago_sumar.efector.efectores_administrados.map { |e| e }
          efectores.
        NotaDeDebito.find(value_ids).each do |nd|
          
        end

      rescue Exception => e
        
      end
    end
    
  end


  # 
  #  Crea nuevas aplicaciones de debito para una nota de debito vinculada a este proceso de pago
  #  Marca como anuladas las aplicaciones de notas de debitos que ya estaban vinculadas y no se 
  # volvieron a asignar
  # 
  # @param value_ids [Array] [Array con los ids de notas de debito a vincular]
  # 
  # @return [type] [description]
  def nota_de_debito_ids=(value_ids)

    unless value_ids.is_a? Array
      errors.add(:base, "No se puede encontrar la nota de debito sin el ID. Contacte con el departamento de sistemas.")
    end

    value_ids.each do |id|
      unless id.is_a? Fixnum
        errors.add(:base, "Uno de los ids de notas de debito no es valido - ID: #{id}")
      end
    end
    
    begin
      nds = NotaDeDebito.find (value_ids)
    rescue Exception => e
      errors.add(:base, "Uno de los ids de notas de debito no es valido ")
    end
    self.notas_de_debito = nds
    @nota_de_debito_ids = value_ids


=begin
    nd_incluidas  = value_ids & self.nota_de_debito_ids # interseccion de arrays
    nd_nuevas     = value_ids - nd_incluidas # las enviadas menos las que ya estaban
    nd_eliminadas =  self.nota_de_debito_ids - nd_incluidas

    transaction do 
      begin

        self.expediente_sumar_ids=()
        NotaDeDebito.find(nd_nuevas).each do |nd|

          nd.reservar_para_pago(pago_sumar, monto?ASD?FASDf)
        end
        
      rescue Exception => e
        errors.add(:base, "Ocurrio un error al asignar las notas de debito. Detalle: #{e.message}")
      end
      #vinculo las que no estaban anteriormente
      
      
      #desvinculo las nd que ya estaban reservadas y se editaron (no se envian en el array)
      

      
      # Agrego las notas de debito que no existian anteriormente
      nd_nuevas.each do | n_id|
        self.aplicaciones_de_notas_de_debito.build(nota_de_debito_id: n_id)
      end

      # Anulo las aplicaciones reservadas que se quitaron del array anterior
      notas_anuladas = NotaDeDebito.find nd_eliminadas
      notas_anuladas.each do |na|
        na.anular_aplicaciones_reservadas(self)
      end
      self.save
    end # end transaction
=end
  end

  # 
  #  Devuelve los ids de las notas de debito cuyas aplicaciones (reservadas o aplicadas)
  # estan vinculadas a este proceso de pago
  # 
  # @return [Fixnum] Ids de las notas vinculadas
  def nota_de_debito_ids
    @nota_de_debito_ids
  end


  def expediente_sumar_ids=(value_ids)
    unless value_ids.is_a? Array
      return nil 
      raise ArgumentError
    end

    value_ids.reject! { |x| !(x.is_a? Fixnum)}
   
    # Borro los seleccionados y agrego nuevamente
    ActiveRecord::Base.transaction do 
      self.expedientes_sumar.clear
      # Verifico que el expediente corresponda al efector de pago
      e = ExpedienteSumar.find(value_ids)
      self.expedientes_sumar << e if e.efector_id == self.efector_id
    end
    self.expediente_sumar_ids
  end

  def numero_de_proceso
    "%07d" % self.id    
  end
end