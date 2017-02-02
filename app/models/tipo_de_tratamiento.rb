# -*- encoding : utf-8 -*-
class TipoDeTratamiento < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre

  # Asociaciones
  has_many :prestaciones, :inverse_of => :tipo_de_tratamiento

  # Validaciones
  validates :nombre, presence: true
  validates :codigo, presence: true

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if codigo.blank?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    tipo = self.find_by_codigo(codigo.strip.upcase)
    if tipo.present?
      return tipo.id
    else
      return nil
    end
  end

  # Devuelve el id asociado con el código pasado, pero dispara una excepción si no lo encuentra
  def self.id_del_codigo!(codigo)
    codigo_id = self.id_del_codigo(codigo)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end

end
