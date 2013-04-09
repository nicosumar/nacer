# -*- encoding : utf-8 -*-
class GrupoPoblacional < ActiveRecord::Base
  attr_accessible :codigo, :nombre

  # Asociaciones
  has_and_belongs_to_many :prestaciones_autorizadas, :class_name => "Prestacion"

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    grupo = self.find_by_codigo(codigo.strip.upcase)

    if grupo
      return grupo.id
    else
      logger.warn "ADVERTENCIA: No se encontró el grupo poblacional '#{codigo.strip.upcase}'."
      return nil
    end
  end

end
