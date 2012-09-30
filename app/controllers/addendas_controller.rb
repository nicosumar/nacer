class AddendasController < ApplicationController
  before_filter :user_required

  def index
    # Verificar los permisos del usuario
    if cannot? :read, Addenda
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    @addendas = Addenda.paginate(
      :page => params[:page], :per_page => 20,
      :include => {:convenio_de_gestion => :efector},
      :order => "updated_at DESC"
    )
  end

  def show
    # Verificar los permisos del usuario
    if cannot? :read, Addenda
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda solicitada
    begin
      @addenda = Addenda.find(
        params[:id],
        :include => [
          {:convenio_de_gestion => :efector},
          {:prestaciones_autorizadas_alta => :prestacion},
          {:prestaciones_autorizadas_baja => :prestacion}
        ]
      )
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La adenda solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
    end
  end

  def new
    # Verificar los permisos del usuario
    if cannot? :create, Addenda
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Para crear addendas, debe accederse desde la página del convenio modificado
    if !params[:convenio_de_gestion_id]
      redirect_to(
        convenios_de_gestion_url,
        :flash => {
          :tipo => :advertencia, :titulo => "No se ha seleccionado un convenio de gestión",
          :mensaje => [
            "Para poder crear la nueva adenda, debe hacerlo accediendo antes a la página " +
              "del convenio de gestión que va a modificarse.",
            "Seleccione el convenio de gestión del listado, o realice una búsqueda para " +
              "encontrarlo."
          ]
        }
      )
      return
    end

    # Crear variables requeridas para generar el formulario
    @addenda = Addenda.new

    # Obtener el convenio de gestión asociado
    begin
      @convenio_de_gestion = ConvenioDeGestion.find(params[:convenio_de_gestion_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    @prestaciones_alta = Prestacion.no_autorizadas(@convenio_de_gestion.efector.id).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
    }
    @prestaciones_baja = PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).collect{
      |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
    }
    @prestacion_autorizada_alta_ids = []
    @prestacion_autorizada_baja_ids = []
  end

  def edit
    # Verificar los permisos del usuario
    if cannot? :update, Addenda
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear las variables requeridas para generar el formulario
    begin
      @addenda = Addenda.find(
        params[:id],
        :include => [
          {:convenio_de_gestion => :efector},
          {:prestaciones_autorizadas_alta => :prestacion},
          {:prestaciones_autorizadas_baja => :prestacion}
        ]
      )
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    @convenio_de_gestion = @addenda.convenio_de_gestion
    @prestaciones_alta = Prestacion.no_autorizadas_antes_del_dia(
      @convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    @prestaciones_baja = PrestacionAutorizada.autorizadas_antes_del_dia(
      @convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{
        |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
      }
    @prestacion_autorizada_alta_ids =
      @addenda.prestaciones_autorizadas_alta.collect{
        |p| p.prestacion_id
      }
    @prestacion_autorizada_baja_ids =
      @addenda.prestaciones_autorizadas_baja.collect{
        |p| p.id
      }
  end

  def create
    # Verificar los permisos del usuario
    if cannot? :create, Addenda
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:addenda] || !params[:addenda][:convenio_de_gestion_id]
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Guardar las prestaciones seleccionadas para dar de alta y de baja
    @prestacion_autorizada_alta_ids = params[:addenda][:prestacion_autorizada_alta_ids] || []
    @prestacion_autorizada_baja_ids = params[:addenda][:prestacion_autorizada_baja_ids] || []
    params[:addenda].delete :prestacion_autorizada_alta_ids
    params[:addenda].delete :prestacion_autorizada_baja_ids

    # Crear el nuevo objeto
    @addenda = Addenda.new

    # Obtener el convenio de gestión asociado
    begin
      @convenio_de_gestion = ConvenioDeGestion.find(params[:addenda][:convenio_de_gestion_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Verificar que las prestaciones autorizadas a dar de alta o de baja coincidan con las opciones válidas del formulario
    @prestaciones_alta =
      Prestacion.no_autorizadas(@convenio_de_gestion.efector.id).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    @prestaciones_baja =
      PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).collect{
        |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
      }
    if (@prestacion_autorizada_alta_ids.any?{|p_id| !((@prestaciones_alta.collect{|p| p[1]}).member?(p_id.to_i))} ||
        @prestacion_autorizada_baja_ids.any?{|p_id| !((@prestaciones_baja.collect{|p| p[1]}).member?(p_id.to_i))})
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Establecer el valor de los atributos protegidos
    @addenda.convenio_de_gestion_id = @convenio_de_gestion.id
    @addenda.fecha_de_inicio = parametro_fecha(params[:addenda], :fecha_de_inicio)
    @addenda.creator_id = current_user.id
    @addenda.updater_id = current_user.id

    # Establecer los valores del resto de los atributos
    @addenda.attributes = params[:addenda]

    # Agregar los datos de la tabla asociada, si los parámetros de la addenda pasaron todas las validaciones
    if @addenda.save
      @prestacion_autorizada_alta_ids.each do |prestacion_id|
        prestacion_autorizada_alta = PrestacionAutorizada.new
        prestacion_autorizada_alta.attributes = {
          :efector_id => @convenio_de_gestion.efector_id,
          :prestacion_id => prestacion_id,
          :fecha_de_inicio => @addenda.fecha_de_inicio
        }
        @addenda.prestaciones_autorizadas_alta << prestacion_autorizada_alta
      end
      @prestacion_autorizada_baja_ids.each do |prestacion_autorizada_id|
        prestacion_autorizada_baja = PrestacionAutorizada.find(prestacion_autorizada_id)
        prestacion_autorizada_baja.attributes = {
          :fecha_de_finalizacion => @addenda.fecha_de_inicio
        }
        @addenda.prestaciones_autorizadas_baja << prestacion_autorizada_baja
      end
      redirect_to(
        addenda_path(@addenda),
        :flash => {:tipo => :ok, :titulo => 'La adenda se creó exitosamente.'}
      )
      return
    end

    # Si la grabación falla volver a mostrar el formulario con los errores
    render :action => "new"
  end

  def update
    # Verificar los permisos del usuario
    if cannot? :update, Addenda
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:addenda]
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Guardar las prestaciones seleccionadas para dar de alta y de baja
    @prestacion_autorizada_alta_ids = params[:addenda][:prestacion_autorizada_alta_ids] || []
    @prestacion_autorizada_baja_ids = params[:addenda][:prestacion_autorizada_baja_ids] || []
    params[:addenda].delete :prestacion_autorizada_alta_ids
    params[:addenda].delete :prestacion_autorizada_baja_ids

    # Obtener la addenda que se actualizará y su convenio de gestión
    begin
      @addenda = Addenda.find(params[:id], :include => [{:convenio_de_gestion => :efector},
        {:prestaciones_autorizadas_alta => :prestacion}, {:prestaciones_autorizadas_baja => :prestacion}])
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    @convenio_de_gestion = @addenda.convenio_de_gestion

    # Verificar que las prestaciones autorizadas a dar de alta o de baja coincidan con las opciones válidas del formulario
    @prestaciones_alta =
      Prestacion.no_autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    @prestaciones_baja =
      PrestacionAutorizada.autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{
        |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
      }
    if (@prestacion_autorizada_alta_ids.any?{|p_id| !((@prestaciones_alta.collect{|p| p[1]}).member?(p_id.to_i))} ||
        @prestacion_autorizada_baja_ids.any?{|p_id| !((@prestaciones_baja.collect{|p| p[1]}).member?(p_id.to_i))})
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Establecer los valores de los atributos protegidos
    @addenda.updater_id = current_user.id

    # Actualizar los valores de los atributos no protegidos por asignación masiva
    @addenda.attributes = params[:addenda]

    if @addenda.save
      # Modificar los registros dependientes en la tabla asociada si los parámetros pasaron todas las validaciones
      # TODO: cambiar este método ya que destruye previamente la información existente
      @addenda.prestaciones_autorizadas_alta.destroy_all
      @prestacion_autorizada_alta_ids.each do |prestacion_id|
        prestacion_autorizada_alta = PrestacionAutorizada.new
        prestacion_autorizada_alta.attributes = 
          {
            :efector_id => @convenio_de_gestion.efector_id,
            :prestacion_id => prestacion_id,
            :fecha_de_inicio => @addenda.fecha_de_inicio
          }
        @addenda.prestaciones_autorizadas_alta << prestacion_autorizada_alta
      end
      @addenda.prestaciones_autorizadas_baja.each do |p|
        prestacion_autorizada = PrestacionAutorizada.find(p)
        prestacion_autorizada.attributes = 
          {
            :fecha_de_finalizacion => nil,
            :autorizante_de_la_baja_type => nil,
            :autorizante_de_la_baja_id => nil
          }
        prestacion_autorizada.save
      end
      @prestacion_autorizada_baja_ids.each do |prestacion_autorizada_id|
        prestacion_autorizada_baja = PrestacionAutorizada.find(prestacion_autorizada_id)
        prestacion_autorizada_baja.attributes = {:fecha_de_finalizacion => @addenda.fecha_de_inicio}
        @addenda.prestaciones_autorizadas_baja << prestacion_autorizada_baja
      end
      redirect_to(addenda_path(@addenda),
        :flash => {
          :tipo => :ok,
          :titulo => 'La información de la adenda se actualizó correctamente.'
        }
      )
      return
    end

    # Si la grabación falla volver a mostrar el formulario con los errores
    render :action => "edit"
  end

#  def destroy
#  end

end
