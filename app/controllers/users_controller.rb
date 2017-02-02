# -*- encoding : utf-8 -*-
class UsersController < Devise::RegistrationsController
  before_filter :authenticate_user!, :except => [:new, :create]
  before_filter :admin_required, :only => [:admin_edit, :admin_update, :destroy]

  # GET /users
  def index
    # Verificar los permisos del usuario
    if cannot? :read, User
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    @new_users = User.no_eliminado.where(:authorized => false).order("id DESC")
    @users = User.no_eliminado.where(:authorized => true).includes([:unidades_de_alta_de_datos, :user_groups]).order("current_sign_in_at DESC NULLS LAST")
  end

  # GET /users/sign_up
  def new
    # Mantener el comportamiento de Devise
    super
  end

  # POST /users
  def create
    # Mantenemos el comportamiento de Devise
    super
  end

  # GET /users/edit
  def edit
    # Inicializar objetos necesarios para generar el formulario si hubiera algún error
    @sexos = Sexo.find(:all).collect{ |s| [s.nombre, s.id] }
    @sexo_id = current_user.sexo_id

    # Mantenemos el comportamiento de Devise
    super
  end

  # PUT /users
  def update
    # Inicializar objetos necesarios para generar el formulario si hubiera algún error
    @sexos = Sexo.find(:all).collect{ |s| [s.nombre, s.id] }
    @sexo_id = current_user.sexo_id

    # Mantenemos el comportamiento de Devise
    super
  end

  # GET /users/:id/edit
  def admin_edit
    @user = User.find(params[:id], :include => [:user_groups, :sexo])
    @user_groups = UserGroup.find(:all).collect{ |ug| [ug.user_group_description, ug.id] }
    @user_group_ids = @user.user_groups.collect{ |ug| ug.id }
    @unidades_de_alta_de_datos = UnidadDeAltaDeDatos.find(:all).collect{ |uad| [uad.nombre, uad.id] }
    @unidad_de_alta_de_datos_ids = @user.unidades_de_alta_de_datos.collect{ |uad| uad.id }
  end

  # PUT /users/:id
  def admin_update
    # Obtener el usuario
    user = User.find(params[:id], :include => [:user_groups, :unidades_de_alta_de_datos])

    # Verificar si se autorizó al usuario a iniciar sesión y registrar la hora y el administrador que autoriza
    if !user.authorized? && params[:user][:authorized] == "1"
      user.authorized = true
      user.authorized_at = DateTime.now
      user.authorized_by = current_user.id
      user.save
    elsif user.authorized? && params[:user][:authorized] == "0"
      user.authorized = false
      user.authorized_at = nil
      user.authorized_by = nil
      user.save
    end
      
    # Verificar si se solicitó la eliminación de la cuenta (soft delete)
    if !user.cuenta_eliminada? && params[:user][:cuenta_eliminada] == "1"
      user.cuenta_eliminada = true
      user.authorized = false
      user.authorized_at = nil
      user.authorized_by = nil
      user.save
    elsif user.cuenta_eliminada? && params[:user][:cuenta_eliminada] == "0"
      user.cuenta_eliminada = false
      user.save
    end
      
    # Actualizar los valores de los atributos para validar el registro antes de guardarlo
    user.user_groups = UserGroup.find((params[:user][:user_group_ids]).reject(&:blank?) || [])
    user.unidades_de_alta_de_datos = UnidadDeAltaDeDatos.find((params[:user][:unidad_de_alta_de_datos_ids]).reject(&:blank?) || [])

    redirect_to users_path,
      :flash => {
        :tipo => :ok,
        :titulo => 'Las autorizaciones de la cuenta de usuario se actualizaron correctamente.'
      }
  end

  # DELETE /users/:id
  def destroy
    # Obtener el usuario
    user = User.find(params[:id])

    if user.authorized || user.last_sign_in_at
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No se puede llevar a cabo esta acción",
          :mensaje => "No se pueden eliminar usuarios autorizados o que registren algún acceso previo al sistema."
        }
      )
      return
    else
      # Eliminar la cuenta del usuario
      user.destroy
      redirect_to(users_path, :flash => {:tipo => :ok, :titulo => "La cuenta de usuario fue eliminada" })
    end

  end

end
