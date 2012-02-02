class ReferentesController < ApplicationController
  before_filter :user_required

  def new
    if cannot? :create, Referente then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    # Para crear referentes, debe accederse desde la página del efector correspondiente
    if not defined?(params[:efector_id])
      redirect_to efectores_url, :notice => "Para agregar un referente, primero seleccione el efector correspondiente."
      return
    end

    # Obtener el efector al que corresponde este referente
    if Efector.exists?(params[:efector_id])
      @referente = Referente.new
      @efector = Efector.find(params[:efector_id])
      @contactos = Contacto.find(:all, :order => "apellidos, nombres, mostrado").collect{ |c| [c.apellidos ? c.apellidos + ", " + c.nombres : c.mostrado, c.id] }
    else
      redirect_to efectores_url, :notice => "Para agregar un referente, primero seleccione el efector correspondiente."
    end
  end

  def edit
    if can? :update, @referente then
      @referente = Referente.find(params[:id], :include => :efector)
      @efector = @referente.efector
      @contactos = Contacto.find(:all, :order => "apellidos, nombres, mostrado").collect{ |c| [c.apellidos ? c.apellidos + ", " + c.nombres : c.mostrado, c.id] }
      @contacto_id = @referente.contacto_id
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def create
    if can? :create, Referente then
      @referente = Referente.new(params[:referente])
      @efector = Efector.find(params[:referente][:efector_id])
      @referente_actual = Referente.actual_del_efector(@efector.id)
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    # Grabar los datos del referente
    if @referente.valid?
      if @referente_actual && @referente.fecha_de_inicio >= @referente_actual.fecha_de_inicio
        @referente_actual.update_attributes({:fecha_de_finalizacion => @referente.fecha_de_inicio})
      end
      if @referente.save
        redirect_to efector_path(@efector), :notice => 'El referente se agregó correctamente.'
        return
      end
    end

    # Si la grabación falla volver a mostrar el formulario con los errores
    @contactos = Contacto.find(:all, :order => "apellidos, nombres, mostrado").collect{ |c| [c.apellidos ? c.apellidos + ", " + c.nombres : c.mostrado, c.id] }
    @contacto_id = params[:referente][:contacto_id]
    render :action => "new"
  end

  def update
    @referente = Referente.find(params[:id])
    if cannot? :update, @referente then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end
    if @referente.update_attributes(params[:referente])
      redirect_to efector_path(@referente.efector), :notice => 'Los datos del referente se actualizaron correctamente.'
      return
    end

    # Si falla la grabación, volver a presentar el formulario con los errores
    @efector = Efector.find(@referente.efector_id)
    @contactos = Contacto.find(:all, :order => "apellidos, nombres, mostrado").collect{ |c| [c.apellidos ? c.apellidos + ", " + c.nombres : c.mostrado, c.id] }
    @contacto_id = params[:referente][:contacto_id]
    render :action => "edit"
  end

end
