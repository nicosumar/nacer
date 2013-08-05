# -*- encoding : utf-8 -*-
class DocumentacionRespaldatoria < ActiveRecord::Base

  # Seguridad de asignaciones masivas
  attr_accessible :descripcion, :nombre, :codigo

  # Asociaciones
  has_and_belongs_to_many :prestaciones

end
