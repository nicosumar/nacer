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

  def nombre_corto
    self.grupo_pdss.seccion_pdss.nombre + " / " + self.grupo_pdss.nombre
  end

  def self.last_orden_by_grupo_pdss_id grupo_pdss_id
    begin 
      last_orden = PrestacionPdss.where(grupo_pdss_id: grupo_pdss_id).order("orden DESC").first.orden
    rescue => e
      last_orden = 0
    end
    return last_orden
  end

end
