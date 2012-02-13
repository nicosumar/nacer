class Afiliado < ActiveRecord::Base
  set_primary_key "afiliado_id"

  belongs_to :categoria_de_afiliado
  has_many :periodos_de_actividad

  validates_presence_of :clave_de_beneficiario, :apellido, :nombre, :tipo_de_documento
  validates_presence_of :clase_de_documento, :numero_de_documento, :categoria_de_afiliado_id
  validates_numericality_of :numero_de_documento, :integer => true
  validates_uniqueness_of :clave_de_beneficiario

  def self.attr_hash_desde_texto(texto, separador = "\t")
    campos = texto.split(separador)
    if campos.size != 86
      raise ArgumentError, "El texto no contiene la cantidad correcta de campos (86), ¿quizás equivocó el separador?"
      return nil
    end
    attr_hash = {
      :afiliado_id => self.valor(campos[0], :entero),
      :clave_de_beneficiario => self.valor(campos[1], :texto),
      :apellido => self.valor(campos[2], :texto),
      :nombre => self.valor(campos[3], :texto),
      :tipo_de_documento => self.valor(campos[4], :texto),
      :clase_de_documento => self.valor(campos[5], :texto),
      :numero_de_documento => self.valor(campos[6], :texto),
      :sexo => self.valor(campos[7], :texto),
      :provincia => self.valor(campos[8], :texto),
      :localidad => self.valor(campos[9], :texto),
      :categoria_de_afiliado_id => self.valor(campos[10], :entero),
      :fecha_de_nacimiento => self.valor(campos[11], :fecha),
      :se_declara_indigena => self.valor(campos[12], :texto),
      :lengua_originaria_id => self.valor(campos[13], :entero),
      :tribu_originaria_id => self.valor(campos[14], :entero),
      :tipo_de_documento_de_la_madre => self.valor(campos[15], :texto),
      :numero_de_documento_de_la_madre => self.valor(campos[16], :texto),
      :apellido_de_la_madre => self.valor(campos[17], :texto),
      :nombre_de_la_madre => self.valor(campos[18], :texto),
      :tipo_de_documento_del_padre => self.valor(campos[19], :texto),
      :numero_de_documento_del_padre => self.valor(campos[20], :texto),
      :apellido_del_padre => self.valor(campos[21], :texto),
      :nombre_del_padre => self.valor(campos[22], :texto),
      :tipo_de_documento_del_tutor => self.valor(campos[23], :texto),
      :numero_de_documento_del_tutor => self.valor(campos[24], :texto),
      :apellido_del_tutor => self.valor(campos[25], :texto),
      :nombre_del_tutor => self.valor(campos[26], :texto),
      :tipo_de_relacion_id => self.valor(campos[27], :texto),
      :fecha_de_inscripcion => self.valor(campos[28], :fecha),
      :fecha_de_alta_efectiva => self.valor(campos[29], :fecha),
      :fecha_de_diagnostico_del_embarazo => self.valor(campos[30], :fecha),
      :semanas_de_embarazo => self.valor(campos[31], :entero),
      :fecha_probable_de_parto => self.valor(campos[32], :fecha),
      :fecha_efectiva_de_parto => self.valor(campos[33], :fecha),
      :activo => self.valor(campos[34], :texto),
      :accion_pendiente_de_confirmar => self.valor(campos[35], :texto),
      :domicilio_calle => self.valor(campos[36], :texto),
      :domicilio_numero => self.valor(campos[37], :texto),
      :domicilio_manzana => self.valor(campos[38], :texto),
      :domicilio_piso => self.valor(campos[39], :texto),
      :domicilio_depto => self.valor(campos[40], :texto),
      :domicilio_entre_calle_1 => self.valor(campos[41], :texto),
      :domicilio_entre_calle_2 => self.valor(campos[42], :texto),
      :domicilio_barrio_o_paraje => self.valor(campos[43], :texto),
      :domicilio_municipio => self.valor(campos[44], :texto),
      :domicilio_departamento_o_partido => self.valor(campos[45], :texto),
      :domicilio_localidad => self.valor(campos[46], :texto),
      :domicilio_provincia => self.valor(campos[47], :texto),
      :domicilio_codigo_postal => self.valor(campos[48], :texto),
      :telefono => self.valor(campos[49], :texto),
      :lugar_de_atencion_habitual => self.valor(campos[50], :texto),
      :fecha_de_envio_de_los_datos => self.valor(campos[51], :fecha),
      :fecha_de_alta => self.valor(campos[52], :fecha),
      :pendiente_de_enviar => self.valor(campos[53], :entero),
      :codigo_provincia_uad => self.valor(campos[54], :texto),
      :codigo_uad => self.valor(campos[55], :texto),
      :codigo_ci_uad => self.valor(campos[56], :texto),
      :motivo_de_la_baja => self.valor(campos[57], :entero),
      :mensaje_de_la_baja => self.valor(campos[58], :texto),
      :proceso_de_baja_automatica_id => self.valor(campos[59], :entero),
      :pendiente_de_enviar_a_nacion => self.valor(campos[60], :entero),
      :fecha_y_hora_de_carga => self.valor(campos[61], :fecha_hora),
      :usuario_que_carga => self.valor(campos[62], :texto),
      :menor_convive_con_tutor => self.valor(campos[63], :texto),
      :fecha_de_baja_efectiva => self.valor(campos[64], :fecha),
      :fecha_de_alta_uec => self.valor(campos[65], :fecha),
      :auditoria => self.valor(campos[66], :texto),
      :cuie_del_efector_asignado => self.valor(campos[67], :texto),
      :cuie_del_lugar_de_atencion_habitual => self.valor(campos[68], :texto),
      :clave_del_benef_que_provoca_baja => self.valor(campos[69], :texto),
      :usuario_de_creacion => self.valor(campos[70], :texto),
      :fecha_de_creacion => self.valor(campos[71], :fecha),
      :persona_id => self.valor(campos[72], :entero),
      :confirmacion_del_numero_de_documento => self.valor(campos[73], :texto),
      :score_de_riesgo => self.valor(campos[74], :entero),
      :alfabetizacion => self.valor(campos[75], :texto),
      :alfabetizacion_anios_ultimo_nivel => self.valor(campos[76], :entero),
      :alfabetizacion_de_la_madre => self.valor(campos[77], :texto),
      :alfab_madre_anios_ultimo_nivel => self.valor(campos[78], :entero),
      :alfabetizacion_del_padre => self.valor(campos[79], :texto),
      :alfab_padre_anios_ultimo_nivel => self.valor(campos[80], :entero),
      :alfabetizacion_del_tutor => self.valor(campos[81], :texto),
      :alfab_tutor_anios_ultimo_nivel => self.valor(campos[82], :entero),
      :activo_r => self.valor(campos[83], :texto),
      :motivo_baja_r => self.valor(campos[84], :entero),
      :mensaje_baja_r => self.valor(campos[85], :texto)
    }
  end

  def self.valor(texto, tipo)

    texto.strip!
    return nil if texto == "NULL" || texto == ""

    begin
      case
        when tipo == :texto
          return texto
        when tipo == :entero
          return texto.to_i
        when tipo == :fecha
          año, mes, dia = texto.split(" ")[0].split("-")
          return nil if año == "1899"
          return Date.new(año.to_i, mes.to_i, dia.to_i)
        when tipo == :fecha_hora
          año, mes, dia = texto.split(" ")[0].split("-")
          horas, minutos, segundos = texto.split(" ")[1].split(":")
          return nil if año == "1899"
          return DateTime.new(año.to_i, mes.to_i, dia.to_i, horas.to_i, minutos.to_i, segundos.to_i)
        else
          return nil
      end
    rescue
      return nil
    end

  end

end
