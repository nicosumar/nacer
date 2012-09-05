class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      # Buscar la/s UAD/s a la/s que pertenece el usuario
      case
        when current_user.unidades_de_alta_de_datos.size == 0
          # El usuario fue creado, pero no ha sido asignado a ninguna UAD todavía
          self.destroy
          redirect_to root_url, :notice => 'No puede iniciar la sesión ya que no ha sido asignado a ninguna UAD del sistema.'
          return
        when current_user.unidades_de_alta_de_datos.size == 1
          # El usuario sólo tiene asignada una única UAD, por lo cual se selecciona automáticamente
          establecer_uad(current_user.unidades_de_alta_de_datos.first)
          redirect_to_stored 'Ha iniciado correctamente la sesión.'
        when current_user.unidades_de_alta_de_datos.size > 1
          # Presentar la página para selección de la UAD con la que va a trabajar el usuario
          render :action => "seleccionar_uad"
        else
      end
    else
      render :action => "new"
    end
  end

  # Permite al usuario seleccionar la UAD con la que va a trabajar
  def seleccionar_uad
    # Verificar 
    if current_user.unidades_de_alta_de_datos.size < 2
      redirect_to root_url,
        :notice => "No está autorizado para acceder a esta página. El incidente será reportado al administrador del sistema."
      return
    end

    # Obtener las UADs a las que pertenece el usuario
    @unidades = current_user.unidades_de_alta_de_datos.collect{ |i| [i.nombre, i.id] }
    @unidad_de_alta_de_datos_id = nil
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    redirect_to root_url, :notice => 'Ha cerrado correctamente la sesión.'
  end
end
