# -*- encoding : utf-8 -*-
class UserSessionsController < Devise::SessionsController
  before_filter :authenticate_user!, :only => :seleccionar_uad

  # GET /users/sign_in
  def new
    # Mantener el comportamiento de Devise
    super
  end

  # POST /users/sign_in
  def create
    # Autenticación
    resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    # Buscar la/s UAD/s a la/s que pertenece el usuario
    if current_user.unidades_de_alta_de_datos.size == 0
      # El usuario fue creado, pero no ha sido asignado a ninguna UAD todavía
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      redirect_to(root_url,
        :flash => {:tipo => :error, :titulo => "No puede iniciar una sesión.",
          :mensaje => "Sus credenciales son correctas, pero aún no fue asignado a ninguna UAD activa del sistema.\n" +
                      "Póngase en contacto con los administradores del sistema para solucionar este inconveniente."
        }
      )
      return
    end

    # Seleccionar la UAD predeterminada del usuario
    uad_predeterminada = current_user.unidades_de_alta_de_datos_users.where(:predeterminada => true).first.unidad_de_alta_de_datos

    # Guardar la UAD seleccionada en la sesión
    session[:codigo_uad_actual] = uad_predeterminada.codigo

    redirect_to_stored({:tipo => :ok, :titulo => "Ha iniciado correctamente la sesión."})
  end

  # Permite al usuario seleccionar la UAD con la que va a trabajar
  def seleccionar_uad
    # Verificar que el usuario realmente posea más de una UAD habilitada
    if current_user.unidades_de_alta_de_datos.size < 2 && !current_user.in_group?(:administradores)
      redirect_to(root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado",
          :mensaje => "La petición no es válida. Se ha notificado a los administradores del sistema acerca de este incidente."
        }
      )
    end

    if params[:unidad_de_alta_de_datos_id]
      # Verificar que el ID de la UAD pasada en el parámetro pertenezca a una de las que posee habilitadas el usuario
      if !(current_user.in_group?(:administradores) ||
           current_user.unidades_de_alta_de_datos.collect{ |uad| uad.id }.member?(params[:unidad_de_alta_de_datos_id].to_i))
        redirect_to(root_url,
          :flash => {:tipo => :error, :titulo => "No está autorizado",
            :mensaje => "La petición no es válida. Se ha notificado a los administradores del sistema acerca de este incidente."
          }
        )
        return
      end

      # Intentar establecer la UAD seleccionada en el formulario
      session[:codigo_uad_actual] = UnidadDeAltaDeDatos.find(params[:unidad_de_alta_de_datos_id]).codigo

      redirect_to(root_url, :flash => {:tipo => :ok, :titulo => "Se seleccionó correctamente la unidad de alta de datos."})
      return
    else
      # Seleccionar la UAD predeterminada del usuario
      uad_predeterminada = current_user.unidades_de_alta_de_datos_users.where(:predeterminada => true).first.unidad_de_alta_de_datos

      # Obtener las UADs a las que pertenece el usuario
      if current_user.in_group? :administradores
        @unidades_de_alta_de_datos = UnidadDeAltaDeDatos.find(:all).collect{ |i| [i.nombre, i.id] }
      else
        @unidades_de_alta_de_datos = current_user.unidades_de_alta_de_datos.collect{ |i| [i.nombre, i.id] }
      end
      @unidad_de_alta_de_datos_id = uad_predeterminada.id
    end

  end

  # DELETE /users/sign_out
  def destroy
    super
  end

end
