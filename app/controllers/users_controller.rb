class UsersController < ApplicationController
  before_filter :user_required, :only => [:edit, :update]
  before_filter :admin_required, :only => [:index, :new, :create, :destroy]

  def index
    @users = User.find(:all, :include => :user_groups)
  end

  def new
    @user = User.new
    @sexos = Sexo.find(:all).collect{ |s| [s.descripcion, s.id] }
    @sexo_id = nil
    @user_groups = UserGroup.find(:all).collect{ |ug| [ug.user_group_description, ug.id] }
    @user_group_ids = []
    @unidade_de_alta_de_datos = 
      UnidadDeAltaDeDatos.find(:all).collect{ |uad| [uad.nombre, uad.id] }
    @unidades_de_alta_de_datos_ids = []
  end

  def edit
    if current_user.in_group? :administradores then
      # Permitir la edición de cualquier usuario sólo a los administradores
      @user = User.find(params[:id], :include => :user_groups)
      # Los administradores pueden definir la pertenencia a los grupos de usuarios
      @user_groups = UserGroup.find(:all).collect{ |ug| [ug.user_group_description, ug.id] }
      @user_group_ids = @user.user_groups.collect{ |ug| [ug.id] }
      @nidades_de_alta_de_datos =
        UnidadDeAltaDeDatos.find(:all).collect{ |uad| [uad.nombre, uad.id] }
      @unidades_de_alta_de_datos_ids = @user.unidades_de_alta_de_datos.collect{ |uad| [uad.id] }
    elsif not (params[:id].to_s == current_user.id.to_s)
      # Rechazar un intento fraguado de editar la información de otros usuarios
      redirect_to root_url,
        :notice => "No está autorizado para modificar la información de otros usuarios. Este incidente será reportado al administrador del sistema."
    else
      # El usuario sólo puede modificar su propia información
      @user = current_user
    end
    @sexos = Sexo.find(:all).collect{ |s| [s.descripcion, s.id] }
    @sexo_id = @user.sexo_id
  end

  def create
    # Guardar los grupos de pertenencia seleccionados
    @user_group_ids = params[:user][:user_group_ids] || []
    @unidades_de_alta_de_datos_ids = params[:user][:unidades_de_alta_de_datos_ids] || []
    params[:user].delete :user_group_ids
    params[:user].delete :unidades_de_alta_de_datos_ids
    @user = User.new(params[:user])
    if @user.save
      @user_group_ids.each do |i|
        @user.user_groups << UserGroup.find(i)
      end
      @unidades_de_alta_de_datos_ids.each do |i|
        @user.unidades_de_alta_de_datos << UnidadDeAltaDeDatos.find(i)
      end
      redirect_to users_url, :notice => 'El usuario se creó satisfactoriamente.'
      return
    end

    # Si la grabación falla, volver al formulario para corregir los errores.
    @user_groups = UserGroup.find(:all).collect{ |ug| [ug.user_group_description, ug.id] }
    @unidades_de_alta_de_datos =
      UnidadDeAltaDeDatos.find(:all).collect{ |uad| [uad.nombre, uad.id] }
    @sexos = Sexo.find(:all).collect{ |s| [s.descripcion, s.id] }
    render :action => "new"
  end

  def update
    # Guardar los grupos de pertenencia seleccionados
    @user_group_ids = params[:user][:user_group_ids] || []
    @unidades_de_alta_de_datos_ids = params[:user][:unidades_de_alta_de_datos_ids] || []
    params[:user].delete :user_group_ids
    params[:user].delete :unidades_de_alta_de_datos_ids
    if current_user.in_group? :administradores then
      # Permitir la edición de cualquier usuario sólo a los administradores
      @user = User.find(params[:id], :include => :user_groups)
    elsif not (params[:id].to_s == current_user.id.to_s)
      # Rechazar un intento fraguado de editar la información de otros usuarios
      redirect_to root_url, 
        :notice => "No está autorizado para modificar la información de otros usuarios. Este incidente será reportado al administrador del sistema."
      return
    else
      # El usuario sólo puede modificar su propia información
      @user = current_user
      # Eliminar de los parámetros los valores que no pueden modificarse (por si la petición ha sido fraguada)
      params[:user].delete :login
      params[:user].delete :crypted_password
      params[:user].delete :password_salt
      params[:user].delete :persistence_token
      params[:user].delete :current_login_at
      params[:user].delete :last_login_at
      params[:user].delete :current_login_ip
      params[:user].delete :last_login_ip
    end

    # Actualizar los valores de los atributos para validar el registro antes de guardarlo
    if @user.update_attributes(params[:user]) 
      if current_user.in_group? :administradores then
        @user.user_groups.destroy_all
        @user.unidades_de_alta_de_datos.destroy_all
        @user_group_ids.each do |i|
          @user.user_groups << UserGroup.find(i)
        end
        @unidades_de_alta_de_datos_ids.each do |i|
          @user.unidades_de_alta_de_datos << UnidadDeAltaDeDatos.find(i)
        end
        redirect_to users_url, :notice => 'La información del usuario se actualizó correctamente.'
        return
      end
      redirect_to root_url, :notice => 'La información de su cuenta se actualizó correctamente.'
      return
    end

    # Si la grabación falla, volver al formulario para corregir los errores.
    @user_groups = UserGroup.find(:all).collect{ |ug| [ug.user_group_description, ug.id] }
    @unidades_de_alta_de_datos =
      UnidadDeAltaDeDatos.find(:all).collect{ |uad| [uad.nombre, uad.id] }
    @sexos = Sexo.find(:all).collect{ |s| [s.descripcion, s.id] }
    @sexo_id = params[:user][:sexo_id]
    render :action => "edit"
  end

end
