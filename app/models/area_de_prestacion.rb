# -*- encoding : utf-8 -*-
class AreaDePrestacion < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Seguridad en asignciones masivas
  attr_accessible :codigo, :nombre

  # Asociaciones
  has_and_belongs_to_many :prestaciones_pdss

  # Validaciones
  #validates_presence_of :nombre

  def nombre_corto
    if nombre.length > 80 then
      nombre.first(77) + "..."
    else
      nombre
    end
  end

  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    area_de_prestacion = self.find_by_codigo(codigo.strip.upcase)
    return area_de_prestacion.id if area_de_prestacion
  end

  def self.id_del_codigo!(codigo)
    codigo_id = self.id_del_codigo(codigo)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end

end
