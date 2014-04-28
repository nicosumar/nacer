# -*- encoding : utf-8 -*-
class InformeDebitoPrestacional < ActiveRecord::Base
  belongs_to :concepto_de_facturacion
  belongs_to :efector
  belongs_to :tipo_de_debito_prestacional
  belongs_to :estado_del_proceso
  has_many   :detalles_de_debitos_prestacionales

  attr_accessible :informado_sirge, :procesado_para_debito, :fecha_de_inicio, :fecha_de_finalizacion, :fecha_de_proceso
  attr_accessible :concepto_de_facturacion_id, :efector_id, :tipo_de_debito_prestacional_id, :estado_del_proceso_id
   
  validates :concepto_de_facturacion, presence: true
  validates :efector, presence: true
  validates :tipo_de_debito_prestacional, presence: true
  validates :estado_del_proceso, presence: true

  # Actualiza el estado del informe a "En Curso". Ademas guarda la fecha en la que se inicio
  def iniciar
    if self.estado_del_proceso == EstadoDelProceso.find(1) #Estado "No iniciado"
      self.estado_del_proceso = EstadoDelProceso.find(2) #Estado En curso
      self.fecha_de_inicio = Date.today
      self.save
    else
      return false
    end
  end

  def finalizar
    if self.estado_del_proceso == EstadoDelProceso.find(2) #Estado En curso
      self.estado_del_proceso = EstadoDelProceso.find(3) #Estado Finalizado
      self.fecha_de_finalizacion = Date.today
      self.save
    else
      return false
    end
  end

  def cerrar

    if self.estado_del_proceso == EstadoDelProceso.find(3) #Estado En_id curso self.ef
      
      ActiveRecord::Base.transaction do

        NotaDeDebito.nueva_desde_informe(self)

        # Cambio el estado del informe
        self.estado_del_proceso = EstadoDelProceso.find(4) #Estado Finalizado y cerrado 
        self.fecha_de_finalizacion = Date.today
        self.save

      end
    else
      return false
    end
  end

end
