class AddendasController < ApplicationController
  before_filter :user_required

  def index
    if can? :read, Addenda then
      @addendas = Addenda.paginate(:page => params[:page], :per_page => 10, :include => {:convenio_de_gestion => :efector}, :order => "fecha_de_suscripcion")
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def show
    @addenda = Addenda.find(params[:id], :include => [{:convenio_de_gestion => :efector}, {:prestaciones_autorizadas_alta => :prestacion}, {:prestaciones_autorizadas_baja => :prestacion}])
    if cannot? :read, @addenda then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def new
    if cannot? :create, Addenda then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    # Para crear addendas, debe accederse desde la página del convenio modificado
    if not defined?(params[:convenio_de_gestion_id])
      redirect_to convenios_de_gestion_url, :notice => "Para crear una addenda, primero seleccione el convenio que se modificará."
      return
    end

    # Obtener el convenio de gestion que modificará esta addenda
    if ConvenioDeGestion.exists?(params[:convenio_de_gestion_id])
      @addenda = Addenda.new
      @convenio_de_gestion = ConvenioDeGestion.find(params[:convenio_de_gestion_id])
      @prestaciones_alta = Prestacion.no_autorizadas(@convenio_de_gestion.efector.id).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }
      @prestaciones_baja = PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).collect{ |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id] }
      @prestacion_autorizada_alta_ids = []
      @prestacion_autorizada_baja_ids = []
    else
      redirect_to convenios_de_gestion_url, :notice => "Para crear una addenda, primero seleccione el convenio que se modificará."
    end
  end

  def edit
    if can? :update, @addenda then
      @addenda = Addenda.find(params[:id], :include => [{:convenio_de_gestion => :efector}, {:prestaciones_autorizadas_alta => :prestacion}, {:prestaciones_autorizadas_baja => :prestacion}])
      @convenio_de_gestion = @addenda.convenio_de_gestion
      @prestaciones_alta = Prestacion.no_autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }
      @prestaciones_baja = PrestacionAutorizada.autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{ |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id] }
      @prestacion_autorizada_alta_ids = @addenda.prestaciones_autorizadas_alta.collect{ |p| p.prestacion_id }
      @prestacion_autorizada_baja_ids = @addenda.prestaciones_autorizadas_baja.collect{ |p| p.id }
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def create
    if can? :create, Addenda then
      # Guardar las prestaciones seleccionadas para dar de alta y de baja
      @prestacion_autorizada_alta_ids = params[:addenda][:prestacion_autorizada_alta_ids]
      @prestacion_autorizada_baja_ids = params[:addenda][:prestacion_autorizada_baja_ids]
      params[:addenda].delete :prestacion_autorizada_alta_ids
      params[:addenda].delete :prestacion_autorizada_baja_ids
      @addenda = Addenda.new(params[:addenda])
      @convenio_de_gestion = ConvenioDeGestion.find(params[:addenda][:convenio_de_gestion_id])
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    # Agregar los datos de la tabla asociada, si los parámetros del convenio pasaron todas las validaciones
    if @addenda.valid? then
      if @prestacion_autorizada_alta_ids then
        @addenda.prestaciones_autorizadas_alta.build(@prestacion_autorizada_alta_ids.collect{ |p| { :efector_id => @convenio_de_gestion.efector.id, :prestacion_id => p, :fecha_de_inicio => @addenda.fecha_de_inicio } })
      end
      if @addenda.save
        if @prestacion_autorizada_baja_ids then
          @prestacion_autorizada_baja_ids.each do |p|
            prestacion_autorizada = PrestacionAutorizada.find(p)
            prestacion_autorizada.update_attributes({:fecha_de_finalizacion => @addenda.fecha_de_inicio})
            @addenda.prestaciones_autorizadas_baja << prestacion_autorizada
          end
        end
        redirect_to convenio_de_gestion_path(@convenio_de_gestion), :notice => 'La addenda se creó exitosamente.'
        return
      end
    end

    # Si la grabación falla volver a mostrar el formulario con los errores
    @prestaciones_alta = Prestacion.no_autorizadas(@convenio_de_gestion.efector.id).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }
    @prestaciones_baja = PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).collect{ |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id] }
    render :action => "new"
  end

  def update
    @addenda = Addenda.find(params[:id])
    if can? :update, @addenda then
      # Guardar las prestaciones seleccionadas para luego rellenar la tabla asociada si se graba correctamente
      @prestacion_autorizada_alta_ids = params[:addenda][:prestacion_autorizada_alta_ids]
      @prestacion_autorizada_baja_ids = params[:addenda][:prestacion_autorizada_baja_ids]
      params[:addenda].delete :prestacion_autorizada_alta_ids
      params[:addenda].delete :prestacion_autorizada_alta_ids
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    # Remover los parámetros de los campos que no pueden modificarse, para mayor seguridad
    params[:addenda].delete :convenio_de_gestion_id

    # Actualizar los valores de los atributos para validar el registro antes de guardarlo
    @addenda.attributes = params[:addenda]
    @convenio_de_gestion = @addenda.convenio_de_gestion 
    if @addenda.valid?
      # Modificar los registros dependientes
      # TODO: cambiar este método ya que destruye previamente la información existente, por otro que
      # tenga en cuenta los existentes en vez de destruirlos y luego crearlos nuevamente. Ver de qué
      # manera puede realizarse en forma atómica con la llamada a 'save' del objeto padre.
      @addenda.prestaciones_autorizadas_alta.destroy_all
      if @prestacion_autorizada_alta_ids then
        @addenda.prestaciones_autorizadas_alta.build(@prestacion_autorizada_alta_ids.collect{ |p| { :efector_id => @convenio_de_gestion.efector.id, :prestacion_id => p, :fecha_de_inicio => @addenda.fecha_de_inicio } })
      end
      if @addenda.save
        @addenda.prestaciones_autorizadas_baja.each do |p|
          prestacion_autorizada = PrestacionAutorizada.find(p)
          prestacion_autorizada.update_attributes({ :fecha_de_finalizacion => nil, :autorizante_de_la_baja_type => nil, :autorizante_de_la_baja_id => nil })
        end
        if @prestacion_autorizada_baja_ids then
          @prestacion_autorizada_baja_ids.each do |p|
            prestacion_autorizada = PrestacionAutorizada.find(p)
            prestacion_autorizada.update_attributes({:autorizante_de_la_baja_type => "Addenda", :autorizante_de_la_baja_id => @addenda.id, :fecha_de_finalizacion => @addenda.fecha_de_inicio})
          end
        end
        redirect_to addenda_path(@addenda), :notice => 'Los datos de la addenda se actualizaron correctamente.'
        return
      end
    else
      @prestaciones_alta = Prestacion.no_autorizadas_al_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }
      @prestaciones_baja = PrestacionAutorizada.autorizadas_al_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{ |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id] }
      render :action => "edit"
    end
  end

#  def destroy
#  end

end
