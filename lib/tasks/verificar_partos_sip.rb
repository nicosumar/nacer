# -*- encoding : utf-8 -*-

class VerificarPartosSip

  def self.procesar
    archivo = File.open("lib/tasks/datos/verificacion_partos_#{Date.today.iso8601}.csv", "w")
    archivo.puts("Efector\tPeriodo de liquidación\tNúmero de cuasifactura\tFecha de la prestación\tClave de beneficiario\tDocumento\tNombre\tCódigo de prestación\tMensajes del proceso")

    ActiveRecord::Base.transaction do
      ActiveRecord::Base.logger.silence do
        partos_a_verificar = AnexoMedicoPrestacion.partos_para_verificar_carga_sip

        partos_a_verificar.each do |parto|
          pl = parto.prestacion_liquidada
          af = Afiliado.find_by_clave_de_beneficiario(pl.clave_de_beneficiario)
          numero_de_documento_beneficiaria = self.normalizar_documento(af.numero_de_documento)

          if !pl.efector.categorizado_cone
            parto.update_attributes(:estado_de_la_prestacion_id => 7, :motivo_de_rechazo_id => 22)
            archivo.puts("#{pl.efector.nombre}\t#{pl.periodo.periodo}\t#{pl.liquidaciones_sumar_cuasifacturas.numero_cuasifactura}\t#{pl.fecha_de_la_prestacion.strftime('%d/%m/%Y')}\t#{pl.clave_de_beneficiario}\t#{(pl.afiliado.tipo_de_documento.present? ? pl.afiliado.tipo_de_documento.codigo + " " : "") + pl.afiliado.numero_de_documento.to_s}\t#{pl.afiliado.apellido.to_s + ", " + pl.afiliado.nombre.to_s}\t#{pl.prestacion_incluida.prestacion_codigo + pl.diagnostico.codigo}\tPrestación devuelta para ser refacturada: El efector no tiene categorización CONE")
          else
            partos_sip = PartoSip.where("
                numero_de_documento LIKE '%#{numero_de_documento_beneficiaria}%'
                AND fecha_de_terminacion = '#{pl.fecha_de_la_prestacion.iso8601}'
                AND right(id01, 1) IN ('0', '1')
                AND efector_id = #{pl.efector_id}
              ")

            if partos_sip.size == 0
              # No se encontró el registro en la base del SIP
              parto.update_attributes(:estado_de_la_prestacion_id => 7, :motivo_de_rechazo_id => 23)
              archivo.puts("#{pl.efector.nombre}\t#{pl.periodo.periodo}\t#{pl.liquidaciones_sumar_cuasifacturas.numero_cuasifactura}\t#{pl.fecha_de_la_prestacion.strftime('%d/%m/%Y')}\t#{pl.clave_de_beneficiario}\t#{(pl.afiliado.tipo_de_documento.present? ? pl.afiliado.tipo_de_documento.codigo + " " : "") + pl.afiliado.numero_de_documento.to_s}\t#{pl.afiliado.apellido.to_s + ", " + pl.afiliado.nombre.to_s}\t#{pl.prestacion_incluida.prestacion_codigo + pl.diagnostico.codigo}\tPrestación devuelta para ser refacturada: No se encontró la HCPB asociada con el parto para este número de documento y fecha de prestación")
            else
              # Se encontraron uno o más registros, verificar que todos los datos del primer registro estén completos, o marcar los errores
              motivos_de_rechazo = ''

              # Verificar que coincida aproximadamente el nombre
              if self.nivel_de_similitud(self.normalizar_nombre(af.apellido), self.normalizar_nombre(af.nombre), self.normalizar_nombre(partos_sip.first.apellido), self.normalizar_nombre(partos_sip.first.nombre)) < 6
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "Los nombres registrados no coinciden (SIP: '#{partos_sip.first.apellido}, #{partos_sip.first.nombre}' / Sumar: '#{af.apellido}, #{af.nombre}')"
              end

              # Verificar que se haya informado la edad materna
              if !partos_sip.first.edad_materna.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró la edad materna en la carga de la HCPB"
              end

              # Verificar que se haya informado la cantidad de gestas previas
              if !partos_sip.first.gestas_previas.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró la edad materna en la carga de la HCPB"
              end

              # Verificar que se haya informado si el embarazo fue planeado
              if !partos_sip.first.embarazo_planeado.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró si el embarazo fue planeado en la carga de la HCPB"
              end

              # Verificar que se haya informado el fracaso de MAC
              if !partos_sip.first.fracaso_de_mac.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró el fracaso de método anticonceptivo en la carga de la HCPB"
              end

              # Verificar que se haya informado el resultado de la prueba de Chagas
              if !partos_sip.first.chagas.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró el resultado de la prueba de Chagas en la carga de la HCPB"
              end

              # Verificar que se haya informado el resultado de alguna de las pruebas no treponémicas para sífilis
              if !partos_sip.first.sifilis_antes_20_semanas.present? && !partos_sip.first.sifilis_despues_20_semanas.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró el resultado de ninguna prueba no treponémica para sífilis en la carga de la HCPB"
              end

              # Verificar que se haya informado la cantidad de consultas prenatales
              if !partos_sip.first.consultas_prenatales.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró la cantidad de consultas prenatales en la carga de la HCPB"
              end

              # Verificar que se haya informado si se utilizaron corticoides antenatales
              if !partos_sip.first.corticoides_antenatales.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró si se utilizaron corticoides antenatales en la carga de la HCPB"
              end

              # Verificar que se haya informado la edad gestacional al parto / cesárea
              if !partos_sip.first.edad_gestacional_al_parto.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró la edad gestacional al parto en la carga de la HCPB"
              end

              # Verificar que se haya informado si el RN nació vivo o muerto
              if !partos_sip.first.nacimiento.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró si el RN nació vivo o muerto en la carga de la HCPB"
              end

              # Verificar que se haya informado la forma de terminación
              if !partos_sip.first.terminacion.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró la forma de terminación en la carga de la HCPB"
              end

              # Verificar que se haya informado el uso de ocitócicos en el prealumbramiento
              if !partos_sip.first.ocitocicos_prealumbramiento.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró el uso de ocitócicos en el prealumbramiento en la carga de la HCPB"
              end

              # Verificar que se haya informado el peso al nacer
              if !partos_sip.first.peso_al_nacer.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró el peso al nacer del recién nacido en la carga de la HCPB"
              end

              # Verificar que se haya informado cómo egresó el recién nacido
              if !partos_sip.first.egreso_del_rn.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró cómo egresó el recién nacido en la carga de la HCPB"
              end

              # Verificar que se haya informado si se realizó consejería en anticoncepción
              if !partos_sip.first.anticoncepcion_consejeria.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró si se realizó consejería en anticoncepción en la carga de la HCPB"
              elsif partos_sip.first.anticoncepcion_consejeria == "B" && !partos_sip.first.anticoncepcion_mac.present? # Si se realizó consejería, verificar que se haya informado el MAC seleccionado
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se registró el método anticonceptivo elegido durante la consejería en la carga de la HCPB"
              end

              # Verificar que se haya informado el estado de la vacunación ATT
              if !partos_sip.first.att_actual.present? && !partos_sip.first.att_1a_dosis.present? && !partos_sip.first.att_2a_dosis.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se indicó el estado de la vacunación antitetánica en la carga de la HCPB"
              end

              # Verificar que se haya informado el nivel educativo de la madre
              if !partos_sip.first.nivel_educativo.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se indicó el nivel de instrucción de la madre en la carga de la HCPB"
              end

              # Verificar que se haya informado el score de Apgar
              if !partos_sip.first.apgar_1.present? && !partos_sip.first.apgar_5.present?
                motivos_de_rechazo += (motivos_de_rechazo.size > 0 ? "; " : "") + "No se indicó el score de Apgar en la carga de la HCPB"
              end

              # Verificar si hubo algún motivo de rechazo y marcar el registro en el anexo médico
              if motivos_de_rechazo.size > 0
                parto.update_attributes(:estado_de_la_prestacion_id => 7, :motivo_de_rechazo_id => 24)
                archivo.puts("#{pl.efector.nombre}\t#{pl.periodo.periodo}\t#{pl.liquidaciones_sumar_cuasifacturas.numero_cuasifactura}\t#{pl.fecha_de_la_prestacion.strftime('%d/%m/%Y')}\t#{pl.clave_de_beneficiario}\t#{(pl.afiliado.tipo_de_documento.present? ? pl.afiliado.tipo_de_documento.codigo + " " : "") + pl.afiliado.numero_de_documento.to_s}\t#{pl.afiliado.apellido.to_s + ", " + pl.afiliado.nombre.to_s}\t#{pl.prestacion_incluida.prestacion_codigo + pl.diagnostico.codigo}\tPrestación devuelta para ser refacturada: #{motivos_de_rechazo}")
              else
                parto.update_attributes(:estado_de_la_prestacion_id => 5, :motivo_de_rechazo_id => nil)
                archivo.puts("#{pl.efector.nombre}\t#{pl.periodo.periodo}\t#{pl.liquidaciones_sumar_cuasifacturas.numero_cuasifactura}\t#{pl.fecha_de_la_prestacion.strftime('%d/%m/%Y')}\t#{pl.clave_de_beneficiario}\t#{(pl.afiliado.tipo_de_documento.present? ? pl.afiliado.tipo_de_documento.codigo + " " : "") + pl.afiliado.numero_de_documento.to_s}\t#{pl.afiliado.apellido.to_s + ", " + pl.afiliado.nombre.to_s}\t#{pl.prestacion_incluida.prestacion_codigo + pl.diagnostico.codigo}\tPrestación aceptada para ser liquidada")
              end
            end
          end
        end
      end
    end

    archivo.close
  end

  def self.normalizar_documento(numero)
    return nil unless numero
    numero.mb_chars.upcase.to_s.gsub(/[^[[:digit:]]]/, "")
  end

  # Normaliza un nombre (o apellido) a mayúsculas, eliminando caracteres extraños y acentos
  def self.normalizar_nombre(nombre)
    return nil unless nombre
    normalizado = nombre.mb_chars.upcase.to_s
    normalizado.gsub!(/[\,\.\'\`\^\~\-\"\/\\\!\$\%\&\(\)\=\+\*\-\_\;\:\<\>\|\@\#\[\]\{\}]/, "")
    if normalizado.match(/[ÁÉÍÓÚÄËÏÖÜÀÈÌÒÂÊÎÔÛ014]/)
      normalizado.gsub!(/[ÁÄÀÂ4]/, "A")
      normalizado.gsub!(/[ÉËÈÊ]/, "E")
      normalizado.gsub!(/[ÍÏÌÎ1]/, "I")
      normalizado.gsub!(/[ÓÖÒÔ0]/, "O")
      normalizado.gsub!(/[ÚÜÙÛ]/, "U")
      normalizado.gsub!("Ç", "C")
      normalizado.gsub!(/  /, " ")
    end
    return normalizado
  end

  # Devuelve el nivel de similitud entre el nombre y apellido 1 y el 2
  def self.nivel_de_similitud(apellido1, nombre1, apellido2, nombre2)

    # Normalizamos todas las cadenas antes de la comparación
    apellido_1 = (self.normalizar_nombre(apellido1) || "")
    nombre_1 = (self.normalizar_nombre(nombre1) || "")
    apellido_2 = (self.normalizar_nombre(apellido2) || "")
    nombre_2 = (self.normalizar_nombre(nombre2) || "")

    # Verificar apellidos
    case
      when apellido_1.split(" ").any?{|a1| apellido_2.split(" ").any?{|a2| a1 == a2 }}
        # Coincide algún apellido
        nivel = 4
      else
        # No coincide ningún apellido, procedemos a verificar si algún apellido registrado tiene una distancia
        # de Levenshtein menor o igual que 3 con alguno de los informados
        if apellido_1.split(" ").any?{|a1| apellido_2.split(" ").any?{|a2| Text::Levenshtein.distance(a1, a2) <= 3 }}
          nivel = 2
        else
          nivel = 1
        end
    end

    # Verificar nombres
    case
      when nombre_1.split(" ").all?{|n1| nombre_2.split(" ").any?{|n2| n1 == n2 }}
        # Coinciden todos los nombres (sin importar el orden)
        nivel *= 7
      when nombre_1.split(" ").any?{|n1| nombre_2.split(" ").any?{|n2| n1 == n2 }}
        # Coinciden uno o más nombres, pero no todos
        nivel *= 5
      else
        # No coincide ningún nombre, procedemos a verificar si algún nombre registrado tiene una distancia de Levenshtein
        # menor o igual que 3 con el otro
        if nombre_1.split(" ").any?{|n1| nombre_2.split(" ").any?{|n2| Text::Levenshtein.distance(n1, n2) <= 3 }}
          nivel *= 3
        else
          nivel *= 1
        end
    end

    return nivel
  end
end
