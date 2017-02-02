# -*- encoding : utf-8 -*-
class DistritosController < ApplicationController

  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :buscar_departamento

  def index
    @distritos =  Distrito.paginate(:page => params[:page], :per_page => 20, :order => :nombre)
  end

  def show
	@distrito = Distrito.find_by_id(params[:id])
  end

  def create
  	@distrito = Distrito.new(params[:distrito])
  	if @distrito.save
  		redirect_to(:action => "show", :id => @distrito.id)
  	else
  		render(:action => "new", :distrito_id => @distrito.id)
  	end
  end

  def new
  	#@distrito = Distrito.new(:departamento_id => @dpto.id)
    if @dpto # Si tengo el departamento, viene navengando 
      @distrito = Distrito.new(:departamento_id => @dpto.id ) 
    else # Sino, viene del index de departamentos y mando los datos para llenar el select 
      @distrito = Distrito.new()
      @departamentos = Departamento.all
    end
  end

  def edit
  	@distrito = Distrito.find(params[:id])
  end

  def update
  	@distrito = Distrito.find_by_id(params[:id])
  	if @distrito.update_attributes(params[:distrito])
  		redirect_to(:action => "show", :id => @distrito.id)
  	else
  		render("edit")
  	end
  end

  private 

  def buscar_departamento
  	if params[:departamento_id]
 		@dpto = Departamento.find_by_id(params[:departamento_id])
 	elsif params[:id]
 		dist = Distrito.find_by_id(params[:id])
 		@dpto = Departamento.find_by_id(dist.departamento_id)
 	end
  end

  def verificar_lectura
    if cannot? :read, Distrito
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end


end
