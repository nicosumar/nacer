# -*- encoding : utf-8 -*-
class Rendicion < ActiveRecord::Base
  attr_accessible :efector_id, :estado_de_rendicion_id, :observaciones, :periodo_de_rendicion_id, :estado_de_rendicion, :rendiciones_detalles_attributes

  belongs_to :efector
  belongs_to :estado_de_rendicion
  belongs_to :periodo_de_rendicion
  belongs_to :referente
  has_many   :rendiciones_detalles#, class_name: 'RendicionDetalle'
  accepts_nested_attributes_for :rendiciones_detalles, :reject_if => :all_blank, :allow_destroy => true

  validates :efector, presence: true
  validates :estado_de_rendicion, presence: true
  #validates :periodo_de_rendicion, presence: true
  validate  :verificar_presentacion

  def verificar_presentacion
    rendicion_aux = Rendicion.where('efector_id =? AND periodo_de_rendicion_id=?' , self.efector_id, self.periodo_de_rendicion_id)
    fecha_actual = Time.now.strftime("%Y-%m-%d")
    periodo_actual = PeriodoDeRendicion.where('? <= fecha_hasta AND ? >= fecha_desde', fecha_actual, fecha_actual)
    if rendicion_aux.nil?
      return true
    else
      if rendicion_aux[0].periodo_de_rendicion_id == periodo_actual[0].id and rendicion_aux[0].periodo_de_rendicion_id != 3
        self.errors.add :periodo_de_rendicion_id, "La rendición ya fue presentada para este periodo"
        return false
      else
        return true
      end
    end
  end
  #def verificar_presentacion
   # rendicion_aux = Rendicion.where('efector_id =? AND periodo_de_rendicion_id=?' , self.efector_id, self.periodo_de_rendicion_id)
    #if rendicion_aux.nil?
     # return true
    #else
    #  self.errors.add :periodo_de_rendicion_id, "La rendición ya fue presentada para este periodo"
    #  return false
    #end
  #end
end
