# -*- encoding: utf-8
#
require "highline/import"
require "unicode_utils/upcase"

class EntrenarSeparadorDeNombresYSexos
  #include HighLine

  attr_accessor :archivo_a_procesar, :apellidos, :masculinos, :femeninos

  def initialize(a_procesar = nil)
    @archivo_a_procesar = File.open(a_procesar, "r") if a_procesar

    @apellidos = cargar_datos("lib/tasks/apellidos.txt")
    @masculinos = cargar_datos("lib/tasks/masculinos.txt")
    @femeninos = cargar_datos("lib/tasks/femeninos.txt")
  end

  def cargar_datos(ruta)
    resultado = {}

    begin
      origen = File.open(ruta, "r")
      origen.each do |linea|
        texto, cantidad = linea.chomp.split("\t")
        if texto.match(/ /)
          texto.gsub(/ +/, " ").split(" ").each do |t|
            if t.length > 1
              if resultado.has_key?(t)
                resultado[t] = resultado[t] + cantidad.to_i
              else
                resultado.merge! t => cantidad.to_i
              end
            end
          end
        else
          if texto.length > 1
            if resultado.has_key?(texto)
              resultado[texto] = resultado[texto] + cantidad.to_i
            else
              resultado.merge! texto => cantidad.to_i
            end
          end
        end
      end
      origen.close
    rescue
    end

    return resultado
  end

  def procesar_archivo
    archivo_a_procesar.each do |linea|
      puts "Procesando línea: #{linea}\n"
      tokens = UnicodeUtils.upcase(linea.chomp.gsub(/[,\.]/, "").gsub(/  /, " ")).split(" ")

      tokens.each do |t|
        puts "Procesando token: #{t}\n"

        choose do |menu|
          menu.prompt = "Clasifique el token "

          menu.choice(:apellido) {agregar_token(@apellidos, t)}
          menu.choice(:nombre_femenino) {agregar_token(@femeninos, t)}
          menu.choice(:nombre_masculino) {agregar_token(@masculinos, t)}
          menu.choice(:ignorar) {}
          menu.choice(:guardar_y_salir) {guardar_todo; return}
          menu.choice(:salir_sin_guardar) {return}
        end
      end
    end

    guardar_todo
    archivo_a_procesar.close
    return true
  end

  def agregar_token(hash, token)
    if hash.has_key?(token)
      hash[token] = hash[token] + 1
    else
      hash.merge! token => 1
    end
  end

  def guardar_todo
    guardar_datos(@apellidos, "lib/tasks/apellidos.txt")
    guardar_datos(@masculinos, "lib/tasks/masculinos.txt")
    guardar_datos(@femeninos, "lib/tasks/femeninos.txt")
  end

  def guardar_datos(hash, ruta)
    begin
      destino = File.open(ruta, "w")

      hash.each do |k, v|
        destino.puts "#{k}\t#{v.to_i}\n"
      end
      destino.close
    rescue
    end
  end

end

entrenador = EntrenarSeparadorDeNombresYSexos.new("/home/sbosio/rails/nacer/vendor/data/Nombres.txt")
entrenador.procesar_archivo
