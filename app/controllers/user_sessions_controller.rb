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
          @user_session.destroy
          redirect_to root_url, :notice => 'No puede iniciar la sesión ya que no ha sido asignado a ninguna UAD activa del sistema.'
          return
        when current_user.unidades_de_alta_de_datos.size == 1
          # El usuario sólo tiene asignada una única UAD, por lo cual se selecciona automáticamente
          if !establecer_uad(current_user.unidades_de_alta_de_datos.first)
            @user_session.destroy
            redirect_to root_url,
              :notice => "Se produjo un error al intentar iniciar la sesión, ya hemos sido notificados y resolveremos el problema a la brevedad."
          end
          redirect_to_stored 'Ha iniciado correctamente la sesión.'
        when current_user.unidades_de_alta_de_datos.size > 1
          # Presentar la página para selección de la UAD con la que va a trabajar el usuario
          redirect_to seleccionar_uad_url
          return
      end
    else
      render :action => "new"
    end
  end

  # Permite al usuario seleccionar la UAD con la que va a trabajar
  def seleccionar_uad
    if !current_user
      redirect_to root_url, :notice => "Debe iniciar la sesión antes de intentar acceder a esta página."
      return
    end

    @user_session = UserSession.find

    # Verificar que el usuario realmente posea más de una UAD habilitada
    if !current_user || current_user.unidades_de_alta_de_datos.size < 2
      @user_session.destroy
      redirect_to root_url,
        :notice => "No está autorizado para acceder a esta página. El incidente será reportado al administrador del sistema."
      return
    end

    if params[:unidad_de_alta_de_datos_id]
      # Verificar que el ID de la UAD pasada en el parámetro pertenezca a una de las que posee habilitadas el usuario
      if !(current_user.unidades_de_alta_de_datos.collect{ |uad| uad.id }.member?(params[:unidad_de_alta_de_datos_id].to_i))
        @user_session.destroy
        redirect_to root_url,
          :notice => "No está autorizado para acceder a esta página. El incidente será reportado al administrador del sistema."
        return
      end

      # Intentar establecer la UAD seleccionada en el formulario
      if !establecer_uad(UnidadDeAltaDeDatos.find(params[:unidad_de_alta_de_datos_id].to_i))
        @user_session.destroy
        redirect_to root_url,
          :notice => "Se produjo un error al intentar iniciar la sesión, ya hemos sido notificados y resolveremos el problema a la brevedad."
        return
      end
      redirect_to_stored 'Ha iniciado correctamente la sesión.'
      return
    else
      # Obtener las UADs a las que pertenece el usuario
      @unidades_de_alta_de_datos = current_user.unidades_de_alta_de_datos.collect{ |i| [i.nombre, i.id] }
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    redirect_to root_url, :notice => 'Ha cerrado correctamente la sesión.'
  end
end
