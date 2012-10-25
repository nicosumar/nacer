class CentroDeInscripcion < ActiveRecord::Base

  # Asociaciones
  has_and_belongs_to_many :unidades_de_alta_de_datos

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si es un código nuevo existente, los códigos
    # anteriores no se mapean porque existía una mala interpretación de los conceptos de UAD y CI),
    # además que un sistema anterior corrompió los códigos de CI (que en verdad eran UADs).
    centro_de_inscripcion = self.find_by_codigo(codigo.strip)
    if centro_de_inscripcion
      return centro_de_inscripcion.id
    else
      return nil
    end
  end

end
