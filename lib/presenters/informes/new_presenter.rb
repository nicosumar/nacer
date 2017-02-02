class Informes::NewPresenter
  extend ActiveSupport::Memoizable
	
  def initialize(informe)
  	if informe.new_record?
  		@informe = Informe.new
  		@informe.esquemas.build
  	else
  		@informe = informe
  	end
  end

  #devuelve los metodos existentes en el controller informes.
  def metodos_en_controller
  	(InformesController.action_methods - ApplicationController.action_methods - ["new","index", "edit", "create"]).to_a
  end
  
  # TODO: devuelve los formatos en los que el informe puede ser renderizado
  #       agregar modelo para esto.
  #
  # @return array
  def formatos
  	['html']
  end

  # Devuelve los esquemas en los cuales pueden realizarse consultas agrega un parametro para todos
  #
  # @return array
  def esquemas
  	esquemas = UnidadDeAltaDeDatos.all
    esquemas << UnidadDeAltaDeDatos.new(nombre: 'Todos', id:'todos')
  end

  # Devuelve los esquemas en los que el informe puede ser ejecutado
  #
  # @return array
  def esquemas_informes
  	@informe.esquemas
  end

  memoize :esquemas, :formatos, :metodos_en_controller, :esquemas_informes

end