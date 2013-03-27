# -*- encoding : utf-8 -*-
class ObjetoDeLaPrestacion < ActiveRecord::Base
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :define_si_es_catastrofica, :es_catastrofica, :nombre, :tipo_de_prestacion_id

  # El codigo no puede cambiarse después de definido
  attr_readonly :codigo

  # Asociaciones
  belongs_to :tipo_de_prestacion

  # Validaciones
  validate_presence_of :codigo, :nombre, :tipo_de_prestacion_id

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    return nil if codigo.blank?

    # Buscar el codigo en la tabla y devolver su ID (si existe)
    objeto = self.find_by_codigo(codigo.strip.upcase)
    return objeto.id if objeto
  end

end
