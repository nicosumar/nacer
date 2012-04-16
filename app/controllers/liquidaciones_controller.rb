class LiquidacionesController < ApplicationController
  before_filter :user_required

  def index
    if can? :read, Liquidacion then
      @liquidaciones = Liquidacion.paginate(:page => params[:page], :per_page => 10, :include => [:efector, {:cuasi_facturas => :efector}],
        :order => "updated_at DESC")
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def show
    @liquidacion = Liquidacion.find(params[:id], :include => [:efector, {:cuasi_facturas => :efector}])
    if cannot? :read, @liquidacion then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def new
    if can? :create, Liquidacion then
      @liquidacion = Liquidacion.new
      @efectores = Efector.administradores_y_autoadministrados.collect{ |e| [e.nombre_corto, e.id] }
      @efector_id = nil
      @meses_de_prestaciones = [["Enero", 1], ["Febrero", 2], ["Marzo", 3], ["Abril", 4], ["Mayo", 5], ["Junio", 6], ["Julio", 7], ["Agosto", 8],
        ["Septiembre", 9], ["Octubre", 10], ["Noviembre", 11], ["Diciembre", 12]]
      @mes_de_prestaciones = Date.today.month - 1
      @años_de_prestaciones = ((Date.today.year - 5)..(Date.today.year)).collect {|a| [a.to_s, a]}
      @año_de_prestaciones = Date.today.year
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def edit
    @liquidacion = Liquidacion.find(params[:id], :include => [:efector, {:cuasi_facturas => :efector}])
    if can? :update, @liquidacion then
      @efectores = [[@liquidacion.efector.nombre_corto, @liquidacion.efector_id]]
      @efector_id = @liquidacion.efector_id
      @meses_de_prestaciones = [["Enero", 1], ["Febrero", 2], ["Marzo", 3], ["Abril", 4], ["Mayo", 5], ["Junio", 6], ["Julio", 7], ["Agosto", 8],
        ["Septiembre", 9], ["Octubre", 10], ["Noviembre", 11], ["Diciembre", 12]]
      @mes_de_prestaciones = @liquidacion.mes_de_prestaciones
      @años_de_prestaciones = ((Date.today.year - 5)..(Date.today.year)).collect {|a| [a.to_s, a]}
      @año_de_prestaciones = @liquidacion.año_de_prestaciones
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def create
    if can? :create, Liquidacion then
      # Establecer el valor de los atributos protegidos
      @liquidacion = Liquidacion.new
      @liquidacion.efector_id = params[:liquidacion][:efector_id]
      @liquidacion.mes_de_prestaciones = params[:liquidacion][:mes_de_prestaciones]
      @liquidacion.año_de_prestaciones = params[:liquidacion][:año_de_prestaciones]

      # Establecer el valor del resto de los atributos por asignación masiva
      @liquidacion.attributes = params[:liquidacion]
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if @liquidacion.save
      redirect_to liquidacion_path(@liquidacion), :notice => 'La liquidación se creó exitosamente.'
      return
    end

    # Si la grabación falla volver a mostrar el formulario con los errores
    @efectores = Efector.administradores_y_autoadministrados.collect{ |e| [e.nombre_corto, e.id] }
    @efector_id = @liquidacion.efector_id
    @meses_de_prestaciones = [["Enero", 1], ["Febrero", 2], ["Marzo", 3], ["Abril", 4], ["Mayo", 5], ["Junio", 6], ["Julio", 7], ["Agosto", 8],
      ["Septiembre", 9], ["Octubre", 10], ["Noviembre", 11], ["Diciembre", 12]]
    @mes_de_prestaciones = @liquidacion.mes_de_prestaciones
    @años_de_prestaciones = ((Date.today.year - 5)..(Date.today.year)).collect {|a| [a.to_s, a]}
    @año_de_prestaciones = @liquidacion.año_de_prestaciones
    render :action => "new"
  end

  def update
    @liquidacion = Liquidacion.find(params[:id])
    if cannot? :update, @liquidacion then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if @liquidacion.update_attributes(params[:liquidacion])
      redirect_to liquidacion_path(@liquidacion), :notice => 'Los datos de la liquidación se actualizaron correctamente.'
      return
    end

    # Si la grabación falla, mostrar el formulario con los errores
    @efectores = [[@liquidacion.efector.nombre_corto, @liquidacion.efector_id]]
    @meses_de_prestaciones = [["Enero", 1], ["Febrero", 2], ["Marzo", 3], ["Abril", 4], ["Mayo", 5], ["Junio", 6], ["Julio", 7], ["Agosto", 8],
      ["Septiembre", 9], ["Octubre", 10], ["Noviembre", 11], ["Diciembre", 12]]
    @mes_de_prestaciones = @liquidacion.mes_de_prestaciones
    @años_de_prestaciones = ((Date.today.year - 5)..(Date.today.year)).collect {|a| [a.to_s, a]}
    @año_de_prestaciones = @liquidacion.año_de_prestaciones
    render :action => "edit"
  end

#  def destroy
#  end

end
