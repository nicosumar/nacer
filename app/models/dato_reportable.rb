# -*- encoding : utf-8 -*-
class DatoReportable < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :clase_para_enumeracion, :codigo, :codigo_de_grupo, :enumerable, :integra_grupo, :nombre, :nombre_de_grupo
  attr_accessible :opciones_de_formateo, :orden_de_grupo, :sirge_id, :tipo_postgres, :tipo_ruby

  # Asociaciones
  has_many :prestaciones, :through => :datos_reportables_requeridos
  has_many :datos_reportables_requeridos

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    return nil if codigo.blank?
    find_by_codigo(codigo).id
  end

end
