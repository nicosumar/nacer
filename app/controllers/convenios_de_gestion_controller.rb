class ConveniosDeGestionController < ApplicationController
  before_filter :user_required

  def index
    if can? :read, ConvenioDeGestion
      @convenios_de_gestion = ConvenioDeGestion.paginate(
        :page => params[:page], :per_page => 20,
        :include => :efector, :order => "updated_at DESC"
      )
    else
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
    end
  end

  def show
    @convenio_de_gestion = ConvenioDeGestion.find(params[:id], :include => [:efector, {:prestaciones_autorizadas => :prestacion}, {:addendas => [{:prestaciones_autorizadas_alta => :prestacion}, {:prestaciones_autorizadas_baja => :prestacion}]}])
    if cannot? :read, @convenio_de_gestion then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def new
    if can? :create, ConvenioDeGestion then
      @convenio_de_gestion = ConvenioDeGestion.new
      @efectores = Efector.que_no_tengan_convenio.collect{ |e| [e.nombre_corto, e.id] }
      @efector_id = nil
      @prestaciones = Prestacion.find(:all, :order => :codigo).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }
      @prestaciones_autorizadas_ids = []
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def edit
    @convenio_de_gestion = ConvenioDeGestion.find(params[:id], :include => [:efector, :prestaciones_autorizadas, :addendas])
    if can? :update, @convenio_de_gestion then
      @efectores = [[@convenio_de_gestion.efector.nombre_corto, @convenio_de_gestion.efector.id]]
      @efector_id = @convenio_de_gestion.efector_id
      @prestaciones = Prestacion.find(:all, :order => :codigo).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }
      @prestacion_autorizada_ids = @convenio_de_gestion.prestaciones_autorizadas.collect{ |p| p.prestacion_id }
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def create
    if can? :create, ConvenioDeGestion then
      # Guardar las prestaciones seleccionadas para luego rellenar la tabla asociada si se graba correctamente
      @prestacion_autorizada_ids = params[:convenio_de_gestion][:prestacion_autorizada_ids]
      params[:convenio_de_gestion].delete :prestacion_autorizada_ids
      @convenio_de_gestion = ConvenioDeGestion.new(params[:convenio_de_gestion])
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    # Agregar los datos de la tabla asociada, si los parámetros del convenio pasaron todas las validaciones
    if @convenio_de_gestion.valid? then
      if @prestacion_autorizada_ids then
        @convenio_de_gestion.prestaciones_autorizadas.build(@prestacion_autorizada_ids.collect{ |p| { :efector_id => @convenio_de_gestion.efector.id, :prestacion_id => p, :fecha_de_inicio => @convenio_de_gestion.fecha_de_inicio } })
      end
      if @convenio_de_gestion.save
        redirect_to convenios_de_gestion_url, :notice => 'El convenio de gestión se creó exitosamente.'
        return
      end
    end

    # Si la grabación falla volver a mostrar el formulario con los errores
    @efectores = Efector.que_no_tengan_convenio.collect{ |e| [e.nombre_corto, e.id] }
    @efector_id = @convenio_de_gestion.efector_id
    @prestaciones = Prestacion.find(:all, :order => :codigo).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }
    render :action => "new"
  end

  def update
    @convenio_de_gestion = ConvenioDeGestion.find(params[:id])
    if can? :update, @convenio_de_gestion then
      # Guardar las prestaciones seleccionadas para luego rellenar la tabla asociada si se graba correctamente
      @prestacion_autorizada_ids = params[:convenio_de_gestion][:prestacion_autorizada_ids]
      params[:convenio_de_gestion].delete :prestacion_autorizada_ids
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    # Remover los parámetros de los campos que no pueden modificarse, para mayor seguridad
    params[:convenio_de_gestion].delete :numero
    params[:convenio_de_gestion].delete :efector_id

    # Actualizar los valores de los atributos para validar el registro antes de guardarlo
    @convenio_de_gestion.attributes = params[:convenio_de_gestion]
    if @convenio_de_gestion.valid?
      # Modificar los registros dependientes
      # TODO: cambiar este método ya que destruye previamente la información existente, por otro que
      # tenga en cuenta los existentes en vez de destruirlos y luego crearlos nuevamente. Ver de qué
      # manera puede realizarse en forma atómica con la llamada a 'save' del objeto padre.
      @convenio_de_gestion.prestaciones_autorizadas.destroy_all
      @convenio_de_gestion.prestaciones_autorizadas.build(@prestacion_autorizada_ids.collect{ |p| { :efector_id => @convenio_de_gestion.efector.id, :prestacion_id => p, :fecha_de_inicio => @convenio_de_gestion.fecha_de_inicio } })
    end

    if @convenio_de_gestion.save then
      redirect_to @convenio_de_gestion, :notice => 'Los datos del convenio de gestión se actualizaron correctamente.'
    else
      @efectores = Efector.que_no_tengan_convenio.collect{ |e| [e.nombre_corto, e.id] }
      @efector_id = @convenio_de_gestion.efector_id
      @prestaciones = Prestacion.find(:all, :order => :codigo).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }
      render :action => "edit"
    end
  end

#  def destroy
#    @convenio_de_gestion = ConvenioDeGestion.find(params[:id])
#    if can? :destroy, @convenio_de_gestion then
#      @convenio_de_gestion.destroy
#    else
#      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
#      return
#    end
#
#    redirect_to convenios_de_gestion_url
#  end

end
