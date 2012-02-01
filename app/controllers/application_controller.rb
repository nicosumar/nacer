class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :user_required, :admin_required, :current_user

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def user_required
    unless current_user
      store_location
      redirect_to root_url, :notice => "Debe iniciar la sesión antes de intentar acceder a esta página."
      return false
    end
  end

  def admin_required
    if !current_user
      store_location
      redirect_to root_url, :notice => "Debe iniciar una sesión de administrador antes de intentar acceder a esta página."
      return false
    else
      return true if current_user.in_group? :administradores
      redirect_to root_url, :notice => "Sólo los administradores pueden acceder a esta página."
      return false
    end
  end

  def store_location
    puts request.inspect
    session[:return_to] = request.url
  end

  def redirect_to_stored(notice)
    redirect_to (session[:return_to] || root_url), :notice => notice
    session[:return_to] = nil
  end

end
