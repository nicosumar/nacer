# -*- encoding: utf-8
#
class SeparadorDeNombresYSexos
  attr_accessor :apellidos, :masculinos, :femeninos, :separador, :archivo_a_procesar, :separador, :columna

  def initialize(ruta = nil, sep = "\t", col = 0)
    @apellidos = cargar_datos("lib/tasks/apellidos.txt")
    @masculinos = cargar_datos("lib/tasks/masculinos.txt")
    @femeninos = cargar_datos("lib/tasks/femeninos.txt")
    @archivo_a_procesar = ruta
    @separador = sep
    @columna = col
  end

  def cargar_datos(ruta)
    resultado = {}

    begin
      origen = File.open(ruta, "r")
      origen.each do |linea|
        texto, cantidad = linea.chomp.split("\t", -1)
        if texto.match(/ /)
          texto.gsub(/ +/, " ").split(" ", -1).each do |t|
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

  def decidir(nombre)
    separar_nombres(nombre).merge! determinar_sexo(nombre)
  end

  def determinar_sexo(nombre)
    nombres = self.separar_nombres(nombre)[:nombres]
    return {:sexo => :indetermindo, :prob_sexo => 0.0} unless nombres

    p_masculino = p_femenino = 1.0
    nombres.gsub(".", "").split(" ", -1).each do |n|
      if n.length > 1
        total = @masculinos[n].to_f + @femeninos[n].to_f
        if total > 0.0
          p_femenino *= (@femeninos[n].to_f/total)
          p_masculino *= (@masculinos[n].to_f/total)
        end
      end
    end

    return {:sexo => :indeterminado, :prob_sexo => p_femenino} if p_femenino == p_masculino
    return (p_masculino > p_femenino ? {:sexo => :masculino, :prob_sexo => p_masculino} : {:sexo => :femenino, :prob_sexo => p_femenino})
  end

  def separar_nombres(nombre)
    tokens = nombre.chomp.strip.gsub(",", "").gsub(/  /, " ").mb_chars.upcase.to_s.split(" ", -1)

    mejor_p = 0.0
    mejor_solucion = {}
    (0..(tokens.size)).each do |i|
      solucion = {:apellidos => tokens[0,tokens.size-i].join(" "), :nombres => tokens[tokens.size-i,i].join(" ")}
      p = p_nombre(solucion[:nombres]) * p_apellido(solucion[:apellidos])
      if p > mejor_p
        mejor_p = p
        mejor_solucion = solucion
      end
      solucion = {:nombres => tokens[0,tokens.size-i].join(" "), :apellidos => tokens[tokens.size-i,i].join(" ")}
      p = p_nombre(solucion[:nombres]) * p_apellido(solucion[:apellidos])
      if p > mejor_p
        mejor_p = p
        mejor_solucion = solucion
      end
    end

    return mejor_solucion.merge! :prob_nombre => mejor_p
  end

  def p_nombre(texto)
    return 1.0 if texto.blank?

    p_masc = p_fem = 1.0
    texto.gsub(".", "").split(" ", -1).each do |n|
      if n.length > 1
        n_total = apellidos[n].to_f + masculinos[n].to_f + femeninos[n].to_f
        if n_total == 0.0
          p_masc *= 0.5
          p_fem *= 0.5
        elsif n_total > 0.0
          p_masc *= (masculinos[n].to_f/n_total)
          p_fem *= (femeninos[n].to_f/n_total)
        end
      end
    end
    return (p_masc > p_fem ? p_masc : p_fem)
  end

  def p_apellido(texto)
    return 1.0 if texto.blank?

    p = 1.0
    texto.gsub(".", "").split(" ", -1).each do |n|
      if n.length > 1
        n_total = apellidos[n].to_f + masculinos[n].to_f + femeninos[n].to_f
        if n_total > 0.0
          p *= (apellidos[n].to_f/n_total)
        end
      end
    end
    return p
  end

  def procesar_archivo
    return true unless archivo_a_procesar

    origen = File.open(archivo_a_procesar, "r")
    destino = File.open(archivo_a_procesar + ".new", "w")

    origen.each do |linea|
      campos = linea.chomp.split(separador, -1)

      if columna.is_a? Array
        decision = decidir(campos.slice(columna[0], columna[1]-columna[0]))
      else
        decision = decidir(campos[columna])
      end

      destino.puts campos.join(separador) + separador + decision[:apellidos].to_s + separador + decision[:nombres].to_s + separador + decision[:prob_nombre].to_s + (
        case decision[:sexo]
          when :femenino
            separador + "F"
          when :masculino
            separador + "M"
          else
            separador
        end
      ) + separador + decision[:prob_sexo].to_s
    end

    origen.close
    destino.close
  end

end
