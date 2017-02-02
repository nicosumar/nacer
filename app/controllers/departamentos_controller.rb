# -*- encoding : utf-8 -*-
class DepartamentosController < ApplicationController

  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :buscar_provincia
  
  def index
    @departamentos = Departamento.paginate(:page => params[:page], :per_page => 20, :order => :nombre)
  end
  def show 
  	@departamento = Departamento.find_by_id(params[:id])
  	@distritos = @departamento.distritos.paginate(:page => params[:page], :per_page => 10, :order => :nombre)
  end

  def edit
  	@departamento = Departamento.find(params[:id])
  end

  def update
  	@departamento = Departamento.find_by_id(params[:id])
  	if @departamento.update_attributes(params[:departamento])
  		redirect_to(:action => "show", :id => @departamento.id)
  	else
  		render("edit")
  	end
  end

  def new
 	  #@departamento = Departamento.new(:provincia_id => @provincia.id )
    if @provincia # Si tengo la provincia, viene navengando 
      @departamento = Departamento.new(:provincia_id => @provincia.id ) 
    else # Sino, viene del index de departamentos y mando los datos para llenar el select 
      @departamento = Departamento.new()
      @provincias = Provincia.all
      @paises = Pais.all
    end
  end
  
  def create
  	@departamento = Departamento.new(params[:departamento])
  	if @departamento.save
  		redirect_to(:action => "show", :id => @departamento.id)
  	else
  		render(:action => "new", :departamento_id => @departamento.id)
  	end
  end

  private

  def buscar_provincia
  	if params[:provincia_id]
 		@provincia = Provincia.find_by_id(params[:provincia_id])
 	elsif params[:id]
 		dpto = Departamento.find_by_id(params[:id])
 		@provincia = Provincia.find_by_id(dpto.provincia_id)
 	end
  end

  def verificar_lectura
    if cannot? :read, Departamento
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

end
