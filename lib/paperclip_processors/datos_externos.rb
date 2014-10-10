# -*- encoding : utf-8 -*-

module Paperclip

  class DatosExternos < Processor

    def initialize(archivo, opciones = {}, adjunto = nil)
      super

      @archivo = archivo

      tipo_de_proceso = opciones.delete(:tipo_de_proceso)

      if tipo_de_proceso.nil? || !tipo_de_proceso.is_a?(TipoDeProceso)
        raise Paperclip::Error, "No se definió el tipo de proceso."
      end
      @modelo = eval(tipo_de_proceso.modelo_de_datos)

      if adjunto.nil? || !adjunto.instance.is_a?(ProcesoDeDatosExternos)
        raise Paperclip::Error, "La instancia asociada al adjunto no es de la clase ProcesoDeDatosExternos."
      end
      @proceso = adjunto.instance
    end

    def make
      # Abrimos el archivo de texto que se cargó para lectura, convirtiendo la codificación de caracteres a UTF8 si es necesario
      codificacion_determinada = determinar_codificacion
      @proceso.archivo_de_datos_encoding = codificacion_determinada
      origen = File.open(
          File.expand_path(@archivo.path),
          :mode => File::RDONLY,
          :external_encoding => codificacion_determinada.present? ? codificacion_determinada : "utf-8",
          :internal_encoding => "utf-8",
          :textmode => true
        )

      # Hacemos todo dentro de una transacción para dejar la base en un estado coherente
      ActiveRecord::Base.transaction do
        # Crear la tabla asociada al proceso, eliminando una tabla previa si se cambió el archivo de datos asociado al proceso
        nombre_de_tabla = "proceso_de_datos_externos_" + @proceso.archivo_de_datos_fingerprint
        if !@proceso.tabla_de_preprocesamiento.blank?
          @proceso.eliminar_tabla_de_preprocesamiento
        end
        @proceso.tabla_de_preprocesamiento = nombre_de_tabla
        @proceso.crear_tabla_de_preprocesamiento

        # Obtenemos las etiquetas y patrones de validación definidos por el modelo de datos asociado al tipo de proceso
        etiquetas = @modelo::ESTRUCTURA_DEL_ARCHIVO_DE_DATOS.collect {|k, v| v[:etiqueta]}
        patrones = @modelo::ESTRUCTURA_DEL_ARCHIVO_DE_DATOS.collect {|k, v| v[:patron_de_validacion]}

        origen.each_with_index do |l, i|
          # Separamos la linea del archivo en los valores que la constituyen
          valores = l.chomp.split("\t").collect{|c| c.to_s.strip.gsub(/  /, " ").gsub("NULL", "").mb_chars.upcase.to_s}

          # Realizamos la validación del formato de la línea de acuerdo con los atributos y patrones de validación
          linea_valida = true
          errores = []
          etiquetas.each_with_index do |e, j|
            if !valores[j].to_s.match(patrones[j])
              linea_valida = false
              errores << "El valor del campo '#{e}' no tiene un formato válido ('#{valores[j].to_s}')"
            end
          end

          # Guardamos la línea en la tabla de preprocesamiento
          ActiveRecord::Base.connection.execute <<-SQL
            INSERT INTO "procesos"."#{@proceso.tabla_de_preprocesamiento}" (
                numero_de_linea,
                formato_valido,
                errores_de_formato,
                linea
              )
              VALUES (
                '#{i+1}',
                '#{linea_valida ? "t" : "f"}'::boolean,
                #{ActiveRecord::Base.sanitize(errores.size > 0 ? errores.join("; ") : "NULL")},
                #{ActiveRecord::Base.sanitize(l.chomp)}
              );
          SQL
        end #origen.each
      end # ActiveRecord::Base.transaction

      origen # Devolvemos el archivo original para que Paperclip lo almacene
    end # def make

    def determinar_codificacion
      return nil unless @archivo.present?

      tipo = begin
        Paperclip.run("file", "-b -i :file", :file => File.expand_path(@archivo.path))
      rescue Cocaine::CommandLineError => e
        Paperclip.log("Error while determining content type: #{e}")
        nil
      end

      codificacion = /charset=([[[:alpha:]],[[:digit:]],-]+).*$/.match(tipo)
      if codificacion.present?
        return codificacion[1]
      else
        return nil
      end
    end

  end # Class DatosExternos

end # Module Paperclip
