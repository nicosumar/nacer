class PartoSip < ActiveRecord::Base
  belongs_to :efector
  attr_accessible :anticoncepcion_consejeria, :anticoncepcion_mac, :apellido, :apgar_1, :apgar_5, :att_1a_dosis, :att_2a_dosis, :att_actual
  attr_accessible :chagas, :consultas_prenatales, :corticoides_antenatales, :edad_gestacional_al_parto, :edad_materna, :efector_id, :egreso_del_rn
  attr_accessible :embarazo_planeado, :fecha_de_terminacion, :fracaso_de_mac, :gestas_previas, :id01, :nacimiento, :nivel_educativo, :nombre
  attr_accessible :numero_de_documento, :ocitocicos_prealumbramiento, :peso_al_nacer, :sifilis_antes_20_semanas, :sifilis_despues_20_semanas, :terminacion

  def self.cargar_desde_archivo(nombre_archivo)
    # Crear un hash que asocie CUIEs con IDs de efectores para parsear más rápido el archivo
    @@hash_efectores = {}
    Efector.where(:integrante => true).each do |e|
      @@hash_efectores.merge! e.cuie => e.id
    end

    archivo = File.open(nombre_archivo, "r")

    ActiveRecord::Base.transaction do
      ActiveRecord::Base.logger.silence do
        self.delete_all
        archivo.each do |linea|
          self.create!(self.parsear_linea(linea))
        end
      end
    end

    archivo.close
  end

  def self.parsear_linea(linea)
    return nil unless linea

    campos = linea.gsub(/[\r\n]/, "").split("\t")

    return {
      :efector_id => self.hash_a_id(@@hash_efectores, self.a_texto(campos[0])),
      :id01 => self.a_texto(campos[1]),
      :nombre => self.a_texto(campos[2]),
      :apellido => self.a_texto(campos[3]),
      :numero_de_documento => self.a_numero_de_documento(campos[4]),
      :fecha_de_terminacion => self.a_fecha(campos[5]),
      :edad_materna => self.a_entero(campos[6]),
      :gestas_previas => self.a_entero(campos[7]),
      :embarazo_planeado => self.a_texto(campos[8]),
      :fracaso_de_mac => self.a_texto(campos[9]),
      :chagas => self.a_texto(campos[10]),
      :sifilis_antes_20_semanas => self.a_texto(campos[11]),
      :sifilis_despues_20_semanas => self.a_texto(campos[12]),
      :consultas_prenatales => self.a_entero(campos[13]),
      :corticoides_antenatales => self.a_texto(campos[14]),
      :edad_gestacional_al_parto => self.a_entero(campos[15]),
      :nacimiento => self.a_texto(campos[16]),
      :terminacion => self.a_texto(campos[17]),
      :ocitocicos_prealumbramiento => self.a_texto(campos[18]),
      :peso_al_nacer => self.a_entero(campos[19]),
      :egreso_del_rn => self.a_texto(campos[20]),
      :anticoncepcion_consejeria => self.a_texto(campos[21]),
      :anticoncepcion_mac => self.a_texto(campos[22]),
      :att_actual => self.a_texto(campos[23]),
      :att_1a_dosis => self.a_entero(campos[24]),
      :att_2a_dosis => self.a_entero(campos[25]),
      :nivel_educativo => self.a_texto(campos[26]),
      :apgar_1 => self.a_texto(campos[27]),
      :apgar_5 => self.a_texto(campos[28])
    }
  end

  def self.hash_a_id(hash, cadena)
    texto = cadena.to_s.strip.gsub("NULL", "").upcase
    return nil if texto.blank?
    return texto.to_i if (texto.to_i > 0 && hash.values.member?(texto.to_i))
    return hash[texto]
  end

  def self.a_texto(cadena)
    texto = cadena.to_s.strip.gsub(/  /, " ").gsub("NULL", "").mb_chars.upcase.to_s
    return (texto.blank? ? nil : texto)
  end

  def self.a_numero_de_documento(cadena)
    return cadena.to_s.strip.gsub(/[ ,\.-]/, "").upcase
  end

  def self.a_entero(cadena)
    texto = cadena.to_s.strip.gsub(/[ ,\.-]/, "")
    return (texto.blank? ? nil : texto.to_i)
  end

  def self.a_fecha(cadena)
    texto = cadena.to_s.strip.gsub("NULL", "")
    return nil if texto.blank?
    begin
      anio, mes, dia = texto.split("-")
      fecha = Date.new(anio.to_i, mes.to_i, dia.to_i)
    rescue
      begin
        dia, mes, anio = texto.split("/")
        fecha = Date.new(anio.to_i, mes.to_i, dia.to_i)
      rescue
        begin
          dia, mes, anio = texto.split(".")
          fecha = Date.new(anio.to_i, mes.to_i, dia.to_i)
        rescue
          fecha = nil
        end
      end
    end
    return fecha
  end

end
