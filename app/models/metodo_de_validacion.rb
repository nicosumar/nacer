class MetodoDeValidacion < ActiveRecord::Base
  attr_accessible :genera_error, :mensaje, :metodo, :nombre

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    return nil if codigo.blank?
    find_by_codigo(codigo).id
  end

end
