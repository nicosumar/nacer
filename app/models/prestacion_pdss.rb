# -*- encoding : utf-8 -*-
class PrestacionPdss < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :nombre, :linea_de_cuidado_id, :orden, :grupo_pdss_id
  attr_accessible :tipo_de_prestacion_id, :modulo_id

  # Asociaciones
  belongs_to :grupo_pdss
  belongs_to :linea_de_cuidado
  belongs_to :modulo
  belongs_to :tipo_de_prestacion
  has_and_belongs_to_many :prestaciones
  has_and_belongs_to_many :areas_de_prestacion

  before_save :set_default_attributes

  def nombre_corto
    self.grupo_pdss.seccion_pdss.nombre + " / " + self.grupo_pdss.nombre
  end

  def self.last_orden_by_grupo_pdss_id grupo_pdss_id
    begin 

      #antes acá solo estaba esto: PrestacionPdss.where(grupo_pdss_id: grupo_pdss_id).order("orden DESC").first.orden

      #ahora lo que hago es recorrer todas las prestaciones del grupo, para saber si no tengo ya
      #a esta prestacion_pdss ahi adentro. De tal forma de obtener su numerito y asignarle el mismo (y no, erroneamente, uno incrementado)
      
      prestaciones_pdss = PrestacionPdss.where(grupo_pdss_id: grupo_pdss_id).order("orden DESC")

      prestaciones_pdss.each do |pre|

        if pre == self

          return pre.orden - 1

        end

      end

      last_orden = prestaciones_pdss.first.orden

    rescue => e
      last_orden = 0
    end
    return last_orden
  end

  private
    def set_default_attributes
      self.orden = (PrestacionPdss.last_orden_by_grupo_pdss_id(self.grupo_pdss.id) + 1) if self.orden.blank? and self.grupo_pdss.present?
    end

end
