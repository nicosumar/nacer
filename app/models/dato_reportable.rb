# -*- encoding : utf-8 -*-
class DatoReportable < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :clase_para_enumeracion, :codigo, :enumerable, :integra_grupo, :nombre, :nombre_de_grupo, :sirge_id
  attr_accessible :tipo_postgres, :tipo_ruby

  # Asociaciones
  has_many :prestaciones, :through => :datos_reportables_requeridos
  has_many :datos_reportables_requeridos


end
