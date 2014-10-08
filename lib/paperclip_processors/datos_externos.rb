# -*- encoding : utf-8 -*-

module Paperclip

  class DatosExternos < Processor

    attr_accessor :nombre_de_tabla

    def initialize(archivo, opciones = {}, adjunto = nil)
      super

      @archivo = archivo

      tipo_de_proceso = opciones.delete(:tipo_de_proceso)

      if tipo_de_proceso.nil? || !tipo_de_proceso.is_a?(TipoDeProceso)
        raise Paperclip::Error, "Paperclip::DatosExternos (postprocesador): No se definió el tipo de proceso."
      end
      @modelo = tipo_de_proceso.modelo_de_datos

      if adjunto.nil? || !adjunto.instance.is_a?(ProcesoDeDatosExternos)
        raise Paperclip::Error, "Paperclip::DatosExternos (postprocesador): La instancia asociada al adjunto no es de la clase ProcesoDeDatosExternos."
      end
      @proceso = adjunto.instance
    end

    def make
      # Crear la tabla asociada al proceso, eliminando una tabla previa si se cambió el archivo de datos asociado al proceso
      nombre_de_tabla = "proceso_de_datos_externos_" + @proceso.archivo_de_datos_fingerprint
      if !@proceso.tabla_de_preprocesamiento.blank? && @proceso.tabla_de_preprocesamiento != nombre_de_tabla
        @proceso.eliminar_tabla_de_preprocesamiento
      end
      @modelo.crear_tabla_de_preprocesamiento(nombre_de_tabla)
      @proceso.tabla_de_preprocesamiento = nombre_de_tabla
      @proceso.save(:validate => false)

      origen = @archivo.open("r")

      # Obtenemos los atributos y patrones de validación de acuerdo al modelo de datos asociado al tipo de proceso
      atributos = @modelo::ATRIBUTOS
      patrones = @modelo::PATRONES_DE_VALIDACION

      origen.each_with_index do |l, i|
        # Separamos la linea del archivo en los campos que la constituyen
        campos = l.chomp.split("\t").collect{|c| c.to_s.strip.gsub(/  /, " ").gsub("NULL", "").mb_chars.upcase.to_s}

        # Realizamos la validación del formato de la línea de acuerdo con los atributos y patrones de validación
        linea_valida = true
        errores = []
        atributos.each_with_index do |a, j|
          if !campos[j].to_s.match(patrones[j])
            linea_valida = false
            errores << "El valor del campo '#{a}' no tiene un formato válido ('#{campos[j].to_s}')"
          end
        end

        # Guardamos la línea en la tabla de preprocesamiento
        @modelo.guardar_linea_a_procesar(@proceso.tabla_de_preprocesamiento, i+1, campos, linea_valida, errores)
      end

      archivo.close
    end # def make

  end # Class DatosExternos

end # Module Paperclip
