class ContactosController < ApplicationController
  before_filter :user_required

  def index
    # Verificar los permisos del usuario
    if cannot? :read, Contacto
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    @contactos = Contacto.paginate(
      :page => params[:page], :per_page => 20,
      :order => [:apellidos, :nombres, :mostrado]
    )
  end

  def show
    # Verificar los permisos del usuario
    if cannot? :read, Contacto
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el contacto solicitado
    begin
      @contacto = Contacto.find(params[:id], :include => :sexo)
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "El contacto solicitado no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
    end
  end

  def new
    # Verificar los permisos del usuario
    if cannot? :create, Contacto
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
    @contacto = Contacto.new
    @sexos = Sexo.find(:all).collect{ |s| [s.nombre, s.id] }
    @sexo_id = nil
  end

  def edit
    # Verificar los permisos del usuario
    if cannot? :update, Contacto
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
      @contacto = Contacto.find(params[:id], :include => :sexo)
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
    @sexos = Sexo.find(:all).collect{ |s| [s.nombre, s.id] }
    @sexo_id = @contacto.sexo_id
  end

  def create
    # Verificar los permisos del usuario
    if cannot? :create, Contacto
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:contacto]
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Crear el nuevo objeto
    @contacto = Contacto.new

    # Verificar que el sexo indicado se corresponda con alguna de las opciones válidas del formulario
    @sexos = Sexo.find(:all).collect{ |s| [s.nombre, s.id] }
    @sexo_id = (params[:contacto][:sexo_id].blank? ? nil : params[:contacto][:sexo_id].to_i)
    if @sexo_id && !(@sexos.collect{|s| s[1]}.member?(@sexo_id))
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
    @contacto.creator_id = current_user.id
    @contacto.updater_id = current_user.id

    # Establecer el valor del resto de los atributos
    @contacto.attributes = params[:contacto]

    # Grabar el nuevo contacto en la base de datos
    if @contacto.save
      redirect_to(
        contacto_path(@contacto),
        :flash => {:tipo => :ok, :titulo => 'El contacto se creó correctamente.'}
      )
      return
    end

    # Si la grabación falla volver a mostrar el formulario con los errores
    render :action => "new"
  end

  def update
    # Verificar los permisos del usuario
    if cannot? :update, Contacto
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:contacto]
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener el contacto que se actualizará
    begin
      @contacto = Contacto.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que el sexo indicado se corresponda con alguna de las opciones válidas del formulario
    @sexos = Sexo.find(:all).collect{ |s| [s.nombre, s.id] }
    @sexo_id = (params[:contacto][:sexo_id].blank? ? nil : params[:contacto][:sexo_id].to_i)
    if @sexo_id && !(@sexos.collect{|s| s[1]}.member?(@sexo_id))
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
    @contacto.updater_id = current_user.id

    # Actualizar los valores de los atributos no protegidos por asignación masiva
    @contacto.attributes = params[:contacto]

    # Grabar la actualización en la base de datos
    if @contacto.save
      redirect_to(
        contacto_path(@contacto),
        :flash => {:tipo => :ok, :titulo => 'La información del contacto se modificó correctamente.'}
      )
      return
    end

    # Si la grabación falla volver a mostrar el formulario con los errores
    render :action => "edit"
  end

#def destroy
#end

end
