# -*- encoding : utf-8 -*-
class AgrupacionDeBeneficiarios < ActiveRecord::Base
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :nombre, :codigo, :condicion_ruby, :descripcion_de_la_condicion

  # Validaciones
  validates_presence_of :nombre, :codigo, :condicion_ruby
  validates_uniqueness_of :codigo

  # Asociaciones
  has_many :prestaciones

  # Devuelve el id asociado con el codigo pasado
  def self.id_del_codigo(codigo)
    return nil if codigo.blank?

    # Buscar el codigo en la tabla y devolver su ID (si existe)
    agrupacion = self.find_by_codigo(codigo.strip.upcase)
    return agrupacion.id if agrupacion
  end

end
