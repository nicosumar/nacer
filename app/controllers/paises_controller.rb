# -*- encoding : utf-8 -*-
class PaisesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura

  def index
    # Obtener el listado de Paises
    @paises = Pais.paginate(:page => params[:page], :per_page => 20, :order => :nombre)
  end

  def show
  	@pais = Pais.find(params[:id])
  	@provincias = @pais.provincias.paginate(:page => params[:page], :per_page => 10, :order => :nombre)
  end

  def edit
  	@pais = Pais.find(params[:id])
  end

  def update
  	@pais = Pais.find(params[:id])
  	if @pais.update_attributes(params[:pais])
  		redirect_to(:action => "show", :id => @pais.id)
  	else
  		render("edit")
  	end
  end

  def new
  	@pais = Pais.new
  end

  def create
  	@pais = Pais.new(params[:pais])
  	if @pais.save
  		redirect_to(:action => 'show', :id => @pais.id )
  	else
  		render(:action => "new")
  	end
  end

  private

  def verificar_lectura
    if cannot? :read, Pais
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

end

