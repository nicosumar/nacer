class CentroDeInscripcion < ActiveRecord::Base

  # Asociaciones
  has_and_belongs_to_many :unidades_de_alta_de_datos

  #
  # proximo_valor
  # Devuelve el siguiente número de orden en la secuencia asociada al centro de inscripción en esta UAD, creando la secuencia
  # antes si no existiera.
  def proximo_valor
    begin
      ActiveRecord.Base::connection.execute(
        "SELECT nextval('#{UnidadDeAltaDeDatos.actual.schema}.ci_#{codigo}_novedades_seq');"
      ).getvalue(0,0).to_i
    rescue ActiveRecord::StatementInvalid
      ActiveRecord.Base::connection.execute "
        CREATE SEQUENCE \"#{UnidadDeAltaDeDatos.actual.schema}.ci_#{codigo}_novedades_seq\";
      "
      ActiveRecord.Base::connection.execute(
        "SELECT nextval('#{UnidadDeAltaDeDatos.actual.schema}.ci_#{codigo}_novedades_seq');"
      ).getvalue(0,0).to_i
    end
  end

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

  # Devuelve el valor del campo 'nombre', pero truncado a 80 caracteres.
  def nombre_corto
    if nombre.length > 80 then
      nombre.first(77) + "..."
    else
      nombre
    end
  end

end
