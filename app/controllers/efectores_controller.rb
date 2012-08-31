class EfectoresController < ApplicationController
  before_filter :user_required

  def index
    if can? :read, Efector
      @efectores = Efector.paginate(:page => params[:page], :per_page => 20, :include => [:convenio_de_gestion, :convenio_de_administracion], :order => :cuie)
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def show
    @efector = Efector.find(params[:id], :include => [:distrito, :departamento, :convenio_de_gestion, :convenio_de_administracion, :prestaciones_autorizadas, {:referentes => :contacto}])
    if @efector.prestaciones_autorizadas.any?
      @prestaciones_autorizadas = PrestacionAutorizada.find(PrestacionAutorizada.autorizadas_antes_del_dia(@efector.id, (Time.now.to_date + 1)).collect{ |p| p.id }, :include => :prestacion)
    else
      @prestaciones_autorizadas = []
    end

    if cannot? :read, @efector then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def new
    if can? :create, Efector then
      @efector = Efector.new
      @departamentos = Departamento.de_esta_provincia.collect{ |d| [d.nombre_corto, d.id] }
      @departamento_id = nil
      @distritos = []
      @distrito_id = nil
      @grupos_de_efectores = GrupoDeEfectores.find(:all).collect{ |g| [g.nombre_corto, g.id] }
      @grupo_de_efectores_id = nil
      @areas_de_prestacion = AreaDePrestacion.find(:all).collect{ |a| [a.nombre_corto, a.id] }
      @area_de_prestacion_id = nil
      @dependencias_administrativas = DependenciaAdministrativa.find(:all).collect{ |d| [d.nombre_corto, d.id] }
      @dependencia_administrativa_id = nil
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def edit
    @efector = Efector.find(params[:id], :include => [{:convenio_de_gestion => :prestaciones_autorizadas}, {:referentes => :contacto}, :departamento, :distrito, :grupo_de_efectores, :area_de_prestacion, :dependencia_administrativa, {:convenio_de_administracion => :administrador}, {:asignaciones_de_nomenclador => :nomenclador}])
    if can? :update, @efector
      @departamentos = Departamento.de_esta_provincia.collect{ |d| [d.nombre_corto, d.id] }
      @departamento_id = @efector.departamento_id
      @distritos = Distrito.where(:departamento_id => @departamento_id).collect{ |d| [d.nombre_corto, d.id] }
      @distrito_id = @efector.distrito_id
      @grupos_de_efectores = GrupoDeEfectores.find(:all).collect{ |g| [g.nombre_corto, g.id] }
      @grupo_de_efectores_id = @efector.grupo_de_efectores_id
      @areas_de_prestacion = AreaDePrestacion.find(:all).collect{ |a| [a.nombre_corto, a.id] }
      @area_de_prestacion_id = @efector.area_de_prestacion_id
      @dependencias_administrativas = DependenciaAdministrativa.find(:all).collect{ |d| [d.nombre_corto, d.id] }
      @dependencia_administrativa_id = @efector.dependencia_administrativa_id
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def create
    if can? :create, Efector then
      @efector = Efector.new(params[:efector])
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if @efector.save
      redirect_to efectores_url, :notice => 'El convenio de gestión se creó exitosamente.'
    else
      # Si la grabación falla volver a mostrar el formulario con los errores
      @departamentos = Departamento.de_esta_provincia.collect{ |d| [d.nombre_corto, d.id] }
      @departamento_id = @efector.departamento_id
      @distritos = Distrito.where(:departamento_id => @departamento_id).collect{ |d| [d.nombre_corto, d.id] }
      @distrito_id = @efector.distrito_id
      @grupos_de_efectores = GrupoDeEfectores.find(:all).collect{ |g| [g.nombre_corto, g.id] }
      @grupo_de_efectores_id = @efector.grupo_de_efectores_id
      @areas_de_prestacion = AreaDePrestacion.find(:all).collect{ |a| [a.nombre_corto, a.id] }
      @area_de_prestacion_id = @efector.area_de_prestacion_id
      @dependencias_administrativas = DependenciaAdministrativa.find(:all).collect{ |d| [d.nombre_corto, d.id] }
      @dependencia_administrativa_id = @efector.dependencia_administrativa_id
      render :action => "new"
    end
  end

  def update
    @efector = Efector.find(params[:id])
    if can? :update, @efector
      if @efector.update_attributes(params[:efector])
        redirect_to efector_path(@efector)
      else
        # Si la grabación falla volver a mostrar el formulario con los errores
        @departamentos = Departamento.de_esta_provincia.collect{ |d| [d.nombre_corto, d.id] }
        @departamento_id = @efector.departamento_id
        @distritos = Distrito.where(:departamento_id => @departamento_id)
        @distrito_id = @efector.distrito_id
        @grupos_de_efectores = GrupoDeEfectores.find(:all).collect{ |g| [g.nombre_corto, g.id] }
        @grupo_de_efectores_id = @efector.grupo_de_efectores_id
        @areas_de_prestacion = AreaDePrestacion.find(:all).collect{ |a| [a.nombre_corto, a.id] }
        @area_de_prestacion_id = @efector.area_de_prestacion_id
        @dependencias_administrativas = DependenciaAdministrativa.find(:all).collect{ |d| [d.nombre_corto, d.id] }
        @dependencia_administrativa_id = @efector.dependencia_administrativa_id
        render :action => "edit"
      end
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

#  def destroy
#    @efector = Efector.find(params[:id])
#    @efector.destroy
#
#    respond_to do |format|
#      format.html { redirect_to efectores_url }
#      format.json { head :ok }
#    end
#  end

end
