class UserSessionsController < Devise::SessionsController

  # GET /users/sign_in
  def new
    # Mantener el comportamiento de Devise
    super
  end

  # POST /users/sign_in
  def create
    # Autenticación de Devise
    resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    # Buscar la/s UAD/s a la/s que pertenece el usuario
    case
      when current_user.unidades_de_alta_de_datos.size == 0
        # El usuario fue creado, pero no ha sido asignado a ninguna UAD todavía
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        redirect_to(root_url,
          :flash => {
            :tipo => :error,
            :titulo => "No puede iniciar una sesión.",
            :mensaje => "Sus credenciales son correctas, pero aún no fue asignado a ninguna UAD activa del sistema. Póngase en contacto con los administradores del sistema para solucionar este inconveniente."
          }
        )
        return
      when current_user.unidades_de_alta_de_datos.size == 1
        # El usuario sólo tiene asignada una única UAD, por lo cual se selecciona automáticamente
        if !establecer_uad(current_user.unidades_de_alta_de_datos.first)
          Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
          redirect_to(root_url,
            :flash => {
              :tipo => :error,
              :titulo => "Se produjo un error al iniciar la sesión",
              :mensaje  => "Sus credenciales son correctas, pero se produjo un error desconocido al intentar asignar su UAD. Póngase en contacto con los administradores del sistema para solucionar este inconveniente."
            }
          )
        end
        redirect_to_stored({:tipo => :ok, :titulo => "Ha iniciado correctamente la sesión."})
      when current_user.unidades_de_alta_de_datos.size > 1
        # Presentar la página para selección de la UAD con la que va a trabajar el usuario
        redirect_to seleccionar_uad_url
        return
    end
  end

  # Permite al usuario seleccionar la UAD con la que va a trabajar
  def seleccionar_uad
    if !current_user
      redirect_to(root_url,
        :flash => {
          :tipo => :advertencia,
          :titulo => "No está autorizado",
          :mensaje => "Debe iniciar la sesión antes de intentar acceder a esta página."
        }
      )
      return
    end

    @user_session = UserSession.find

    # Verificar que el usuario realmente posea más de una UAD habilitada
    if !current_user || current_user.unidades_de_alta_de_datos.size < 2
      @user_session.destroy
      redirect_to(root_url,
        :flash => {
          :tipo => :error,
          :titulo => "No está autorizado",
          :mensaje => "La petición no es válida. Su sesión fue cerrada, y se ha notificado a los administradores del sistema."
        }
      )
    end

    if params[:unidad_de_alta_de_datos_id]
      # Verificar que el ID de la UAD pasada en el parámetro pertenezca a una de las que posee habilitadas el usuario
      if !(current_user.unidades_de_alta_de_datos.collect{ |uad| uad.id }.member?(params[:unidad_de_alta_de_datos_id].to_i))
        @user_session.destroy
        redirect_to(root_url,
          :flash => {
            :tipo => :error,
            :titulo => "No está autorizado",
            :mensaje => "La petición no es válida. Su sesión fue cerrada, y se ha notificado a los administradores del sistema."
          }
        )
        return
      end

      # Intentar establecer la UAD seleccionada en el formulario
      if !establecer_uad(UnidadDeAltaDeDatos.find(params[:unidad_de_alta_de_datos_id].to_i))
        @user_session.destroy
        redirect_to(root_url,
          :flash => {
            :tipo => :error,
            :titulo => "Se produjo un error al iniciar la sesión",
            :mensaje  => "Sus credenciales son correctas, pero se produjo un error desconocido al intentar asignar su UAD. Póngase en contacto con los administradores del sistema para solucionar este inconveniente."
          }
        )
        return
      end

      redirect_to_stored({:tipo => :ok, :titulo => "Ha iniciado correctamente la sesión."})
      return
    else
      # Seleccionar la UAD predeterminada del usuario
      uad_predeterminada = UnidadDeAltaDeDatos.find(
        UnidadDeAltaDeDatosUser.where(
          :user_id => current_user.id,
          :predeterminada => true
        ).first.unidad_de_alta_de_datos_id
      )
      establecer_uad(uad_predeterminada)

      # Obtener las UADs a las que pertenece el usuario
      @unidades_de_alta_de_datos = current_user.unidades_de_alta_de_datos.collect{ |i| [i.nombre, i.id] }
      @unidad_de_alta_de_datos_id = uad_predeterminada.id
    end

  end

  # DELETE /users/sign_out
  def destroy
    super
  end

end
