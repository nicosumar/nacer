# -*- encoding : utf-8 -*-
class PrestacionPdss < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :apartado_pdss_id, :codigo, :grupo_pdss_id, :nombre, :nosologia_id, :orden, :rural, :subgrupo_pdss_id
  attr_accessible :tipo_de_prestacion_id

  # Asociaciones
  belongs_to :grupo_pdss
  belongs_to :subgrupo_pdss
  belongs_to :apartado_pdss
  belongs_to :nosologia
  belongs_to :tipo_de_prestacion
  has_and_belongs_to_many :prestaciones

end
