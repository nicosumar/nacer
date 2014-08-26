# -*- encoding : utf-8 -*-
class PasswordsController < Devise::PasswordsController

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
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

      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      respond_with resource
    end
  end

end
