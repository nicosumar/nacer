# -*- encoding : utf-8 -*-
class TipoDePrestacion < ActiveRecord::Base
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre

  # El código no puede modificarse una vez establecido
  attr_readonly :codigo

  # Asociaciones
  has_many :objetos_de_las_prestaciones

  # Validaciones
  validates_presence_of :codigo, :nombre

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    tipo_de_prestacion = self.find_by_codigo(codigo.strip.upcase)
    if tipo_de_prestacion
      return tipo_de_prestacion.id
    else
      return nil
    end
  end
  def self.id_del_codigo!(codigo)
    codigo_id = self.id_del_codigo(codigo)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end

  def codigo_y_nombre
    self.codigo + " - " + self.nombre
  end

end
