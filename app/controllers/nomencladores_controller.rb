class NomencladoresController < ApplicationController
  before_filter :authenticate_user!

  def index
    if can? :read, Nomenclador then
      @nomencladores = Nomenclador.paginate(:page => params[:page], :per_page => 20, :order => "fecha_de_inicio")
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def show
    @nomenclador = Nomenclador.find(params[:id], :include => [ { :asignaciones_de_precios => { :prestacion => :unidad_de_medida } } ])
    if cannot? :read, @nomenclador
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def new
    if can? :create, Nomenclador then
      @nomenclador = Nomenclador.new
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def edit
    @nomenclador = Nomenclador.find(params[:id])
    if cannot? :update, @nomenclador
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def create
    if cannot? :create, Nomenclador
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    @nomenclador = Nomenclador.new(params[:nomenclador])

    if @nomenclador.save
      redirect_to nomenclador_path(@nomenclador), :notice => 'El nomenclador se creó exitosamente.'
      return
    else
      render :action => "new"
    end
  end

  def update
    @nomenclador = Nomenclador.find(params[:id])
    if cannot? :update, @nomenclador
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if @nomenclador.update_attributes(params[:nomenclador])
      redirect_to nomenclador_path(@nomenclador), :notice => 'La información del nomenclador se actualizó correctamente.'
    else
      render :action => "edit"
    end
  end

#  def destroy
#  end

end
