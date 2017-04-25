# -*- encoding: utf-8
#
class ExtraerReporteDePrestaciones
		
	attr_accessor :periodo_id

  def initialize(periodo_id = nil)
		@periodo_id = periodo_id
  end

    def procesar_archivo_sirge
		periodo = Periodo.find(@periodo_id)
		filename = 'lib/tasks/datos/'+"Paquete_Basico_Periodo_SIRGE_" + periodo.periodo + ".txt"
    destino = File.open(filename, "w")
		prestaciones = periodo.padron_de_prestaciones_sirge
	  separador = ";"
		columnas = prestaciones.columns
    prestaciones.each do |prestacion|
			campos = []
			columnas.each do |campo|
				campos << prestacion[campo]
			end
			row = campos.join(separador)
      destino.puts row
    end

    destino.close
  end

    def procesar_archivo_ace
		periodo = Periodo.find(@periodo_id)
		filename = 'lib/tasks/datos/'+"Paquete_Basico_Periodo_ACE_" + periodo.periodo + ".txt"
    destino = File.open(filename, "w")
		prestaciones = periodo.padron_de_prestaciones_ace
	  separador = ";"
		columnas = prestaciones.columns
    prestaciones.each do |prestacion|
			campos = []
			columnas.each do |campo|
				campos << prestacion[campo]
			end
			row = campos.join(separador)
      destino.puts row
    end

    destino.close
  end

end
