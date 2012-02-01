class ConveniosDeAdministracionController < ApplicationController
  before_filter :user_required

  def index
    if can? :read, ConvenioDeAdministracion
      @convenios_de_administracion = ConvenioDeAdministracion.paginate(:page => params[:page], :per_page => 10, :include => [:efector, :administrador], :order => "numero")
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def show
    @convenio_de_administracion = ConvenioDeAdministracion.find(params[:id], :include => [:efector, :administrador])
    if cannot? :read, @convenio_de_administracion
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def new
    if can? :create, ConvenioDeAdministracion then
      @convenio_de_administracion = ConvenioDeAdministracion.new
      @efectores = Efector.que_no_son_administrados.collect{ |e| [e.nombre_corto, e.id] }
      @efector_id = nil
      @administradores = Efector.administradores_y_no_administrados.collect{ |a| [a.nombre_corto, a.id] }
      @administrador_id = nil
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def edit
    @convenio_de_administracion = ConvenioDeAdministracion.find(params[:id], :include => [:efector, :administrador])
    if can? :update, @convenio_de_administracion
      @efectores = [[@convenio_de_administracion.efector.nombre_corto, @convenio_de_administracion.efector.id]]
      @efector_id = @convenio_de_administracion.efector_id
      @administradores = [[@convenio_de_administracion.administrador.nombre_corto, @convenio_de_administracion.administrador.id]]
      @administrador_id = @convenio_de_administracion.administrador_id
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def create
    if can? :create, ConvenioDeAdministracion
      @convenio_de_administracion = ConvenioDeAdministracion.new(params[:convenio_de_administracion])
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if @convenio_de_administracion.save
      redirect_to convenios_de_administracion_url, :notice => 'El convenio de administración se creó exitosamente.'
    else
      @efectores = Efector.que_no_son_administrados.collect{ |e| [e.nombre_corto, e.id] }
      @efector_id = @convenio_de_administracion.efector_id
      @administradores = Efector.administradores_y_no_administrados.collect{ |a| [a.nombre_corto, a.id] }
      @administrador_id = @convenio_de_administracion.administrador_id
      render :action => "new"
    end
  end

  def update
    @convenio_de_administracion = ConvenioDeAdministracion.find(params[:id], :include => [:efector, :administrador])
    if cannot? :update, @convenio_de_administracion then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    # Remover los parámetros de los campos que no pueden modificarse, para mayor seguridad
    params[:convenio_de_administracion].delete :numero
    params[:convenio_de_administracion].delete :efector_id
    params[:convenio_de_administracion].delete :administrador_id

    if @convenio_de_administracion.update_attributes(params[:convenio_de_administracion])
      redirect_to @convenio_de_administracion, :notice => 'Los datos del convenio de administración se actualizaron correctamente.'
    else
      @efectores = [[@convenio_de_administracion.efector.nombre_corto, @convenio_de_administracion.efector.id]]
      @efector_id = @convenio_de_administracion.efector_id
      @administradores = [[@convenio_de_administracion.administrador.nombre_corto, @convenio_de_administracion.administrador.id]]
      @administrador_id = @convenio_de_administracion.administrador_id
      render :action => "edit"
    end
  end

#  def destroy
#    @convenio_de_administracion = ConvenioDeAdministracion.find(params[:id])
#    @convenio_de_administracion.destroy
#  end

end
