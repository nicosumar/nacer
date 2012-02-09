class ContactosController < ApplicationController
  before_filter :user_required

  def index
    if can? :read, Contacto
      @contactos = Contacto.paginate(:page => params[:page], :per_page => 10, :order => [:apellidos, :nombres, :mostrado])
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def show
    @contacto = Contacto.find(params[:id], :include => :sexo)

    if cannot? :read, @contacto
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def new
    if can? :create, Contacto then
      @contacto = Contacto.new
      @sexos = Sexo.find(:all).collect{ |s| [s.descripcion, s.id] }
      @sexo_id = nil
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def edit
    @contacto = Contacto.find(params[:id])
    if can? :update, @contacto
      @sexos = Sexo.find(:all).collect{ |s| [s.descripcion, s.id] }
      @sexo_id = @contacto.sexo_id
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def create
    if can? :create, Contacto then
      @contacto = Contacto.new(params[:contacto])
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if @contacto.save
      redirect_to contactos_url, :notice => 'El contacto se creó exitosamente.'
    else
      # Si la grabación falla volver a mostrar el formulario con los errores
      @sexos = Sexo.find(:all).collect{ |s| [s.descripcion, s.id] }
      @sexo_id = params[:contacto][:sexo_id]
      render :action => "new"
    end
  end

  def update
    @contacto = Contacto.find(params[:id])
    if can? :update, @contacto
      if @contacto.update_attributes(params[:contacto])
        redirect_to contacto_path(@contacto)
      else
        # Si la grabación falla volver a mostrar el formulario con los errores
        @sexos = Sexo.find(:all).collect{ |s| [s.descripcion, s.id] }
        @sexo_id = params[:contacto][:sexo_id]
        render :action => "edit"
      end
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

end
