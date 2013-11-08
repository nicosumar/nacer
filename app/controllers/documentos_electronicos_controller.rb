class DocumentosElectronicosController < ApplicationController

	before_filter :authenticate_user!
  
  def cuasifacturas

  end

  def consolidados
  	
  end

  def index
  	
  	# Valores para los dropdown
  	if params[:efectores_id].blank?
  		@efectores_id = -1
  	end


  	@efectores = Efector.find(:all).collect {|i| [i.nombre, i.id]}
  	@efectores << ['Todos', -1]
  	@concepto_de_facturacion = ConceptoDeFacturacion.find(:all).collect {|i| [i.concepto, i.id]}
  	@periodos = Periodo.includes(:concepto_de_facturacion).find(:all).collect {|i| ["#{i.periodo} - #{i.concepto_de_facturacion.nombre}", i.id]}
  	@periodos << ['Todos', -1]



  end
end
