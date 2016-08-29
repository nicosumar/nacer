# -*- encoding : utf-8 -*-
class ObjetoDeLaPrestacion < ActiveRecord::Base
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :define_si_es_catastrofica, :es_catastrofica, :nombre, :tipo_de_prestacion_id

  # El codigo no puede cambiarse después de definido
  attr_readonly :codigo

  # Asociaciones
  belongs_to :tipo_de_prestacion

  # Validaciones
  validates_presence_of :codigo, :nombre, :tipo_de_prestacion_id

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    objeto_de_la_prestacion = self.find_by_codigo(codigo.strip.upcase)
    if objeto_de_la_prestacion
      return objeto_de_la_prestacion.id
    else
      return nil
    end
  end
  def self.id_del_codigo!(codigo)
    codigo_id = self.id_del_codigo(codigo)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end

  def full_codigo_y_nombre
    self.codigo_para_la_prestacion + " - " + self.nombre
  end

  def codigo_para_la_prestacion
    self.tipo_de_prestacion.codigo + self.codigo
  end

end
