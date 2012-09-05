class CentroDeInscripcion < ActiveRecord::Base

  # Asociaciones
  has_and_belongs_to_many :unidades_de_alta_de_datos

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    centro_de_inscripcion = self.find_by_codigo(codigo.strip)

    if centro_de_inscripcion
      return centro_de_inscripcion.id
    else
      # Parche horrible para mapear los viejos códigos de CIs a los nuevos códigos.
      case
        when ["00001", "00101", "00102", "00103", "00104", "00105", "00106",
              "00107", "00109", "00110", "00115", "00200", "00201", "00202",
              "00203", "00204", "00205", "00206", "11111", "11112", "11113",
              "11115", "11116", "11117", "11118", "11119", "11121", "11122",
              "11124", "11129", "11132", "11146"].member?(codigo.strip)
          # Códigos de CIs pertenecientes a personal de la UGSP - CI id: 1
          return 1
        when ["00300", "00403"].member?(codigo.strip)
          # Códigos de CIs pertenecientes a personal del Hospital Luis C. Lagomaggiore - CI id: 2
          return 2
        when codigo.strip == "00301"
          # Códigos de CIs pertenecientes a personal de la Municipalidad de la Capital - CI id: 3
          return 3
        when codigo.strip == "00402"
          # Código de CI perteneciente a personal del Hospital Alfredo Perrupato - CI id: 4
          return 4
        when ["00404", "00406", "11126", "11127"].member?(codigo.strip)
          # Códigos de CIs pertenecientes a personal del Hospital Diego Paroissien - CI id: 5
          return 5
        when codigo.strip == "00405"
          # Código de CI perteneciente a personal de la Coordinación de San Carlos  - CI id: 6
          return 6
        when ["00408", "00411"].member?(codigo.strip)
          # Códigos de CIs pertenecientes a personal de la Coordinación de San Rafael - CI id: 7
          return 7
        when codigo.strip == "11128"
          # Código de CI perteneciente a personal del Hospital Domingo Sícoli - CI id: 8
          return 8
        when codigo.strip == "11144"
          # Código de CI perteneciente a personal de la Coordinación de Lavalle - CI id: 9
          return 9
        when codigo.strip == "11145"
          # Código de CI perteneciente a personal de la Municipalidad de San Rafael - CI id: 10
          return 10
        when codigo.strip == "11147"
          # Código de CI perteneciente a personal del Hospital Schestakow - CI id: 11
          return 11
        when codigo.strip == "00409"
          # Código de CI perteneciente a personal del Microhospital de Puente de Hierro - CI id: 12
          return 12
        else
          logger.warn "ADVERTENCIA: No se encontró el centro de inscripción '#{codigo.strip}'."
          return nil
      end
    end
  end

end
