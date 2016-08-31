# -*- encoding : utf-8 -*-
class DatoReportable < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :clase_para_enumeracion, :codigo, :codigo_de_grupo, :enumerable, :integra_grupo, :nombre, :nombre_de_grupo
  attr_accessible :opciones_de_formateo, :orden_de_grupo, :sirge_id, :tipo_postgres, :tipo_ruby

  # Asociaciones
  has_many :prestaciones, :through => :datos_reportables_requeridos
  has_many :datos_reportables_requeridos

  def codigo_y_nombre
    return self.codigo + " - " + self.nombre
  end

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    dato_reportable = self.find_by_codigo(codigo)

    if dato_reportable
      return dato_reportable.id
    else
      return nil
    end
  end
  def self.id_del_codigo!(codigo)
    codigo_id = self.id_del_codigo(codigo)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end

end
