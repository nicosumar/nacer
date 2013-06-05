# -*- encoding : utf-8 -*-
class ProvinciasController < ApplicationController

  before_filter :authenticate_user!
	before_filter :verificar_lectura
  before_filter :buscar_pais

	def index
    @provincias = Provincia.paginate(:page => params[:page], :per_page => 20, :order => :nombre)
  end

  def show
		@provincia = Provincia.find(params[:id])
	  @departamentos = @provincia.departamentos.paginate(:page => params[:page], :per_page => 10, :order => :nombre)
  end

	def edit
		@provincia = Provincia.find(params[:id])
 	end

 	def update
 		@provincia = Provincia.find(params[:id])
  	if @provincia.update_attributes(params[:provincia])
  		redirect_to(:action => "show", :id => @provincia.id, :pais_id => @provincia.pais_id)
  	else
  		render("edit")
  	end
 	end

 	def new
    if @pais # Si tengo el pais, viene navengando desde provincia
 		  @provincia = Provincia.new(:pais_id => @pais.id ) 
    else # Sino, viene del index de provincias y mando los datos para llenar el select 
      @provincia = Provincia.new()
      @paises = Pais.all
    end
 	end

 	def create
 		@provincia = Provincia.new(params[:provincia])
  	if @provincia.save
  		redirect_to(:action => "show", :id => @provincia.id)
  	else
  		render(:action => "new", :pais_id => @pais.id)
  	end
  end

  private

 	def buscar_pais
 		if params[:pais_id]
 			@pais = Pais.find_by_id(params[:pais_id])
    elsif params[:id]
      prov = Provincia.find_by_id(params[:id])
      @pais = Pais.find_by_id(prov.pais_id)
 		end
 	end

  def verificar_lectura
    if cannot? :read, Provincia
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end



end
