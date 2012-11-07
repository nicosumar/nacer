class InicioController < ApplicationController

  def index
    redirect_to(new_user_session_path, :flash => flash) unless user_signed_in?
  end

end
