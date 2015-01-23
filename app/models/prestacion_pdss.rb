# -*- encoding : utf-8 -*-
class PrestacionPdss < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :nombre, :linea_de_cuidado_id, :orden, :grupo_pdss_id
  attr_accessible :tipo_de_prestacion_id, :modulo_id

  # Asociaciones
  belongs_to :seccion_pdss, :through => :grupo_pdss
  belongs_to :grupo_pdss
  belongs_to :linea_de_cuidado
  belongs_to :modulo
  belongs_to :tipo_de_prestacion
  has_and_belongs_to_many :prestaciones

end
